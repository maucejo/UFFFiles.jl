"""
    extract_blocks(filepath::String) -> Vector{Vector{String}}

Extracts blocks of data from a UFF file located at `filepath`. Each block is delimited by lines containing `-1`.

**Input**
- `filepath::String`: Path to the UFF file.

**Output**
- `blocks::Vector{Vector{String}}`: A vector containing blocks of data, where each block is represented as a vector of strings.
"""
function extract_blocks(filepath::String)
    blocks = Vector{String}[]
    current_block = String[]
    in_block = false

    open(filepath, "r") do file
        for line in eachline(file)
            trimmed_line = strip(line)

            if trimmed_line == "-1"
            # if strip(line) == "-1"
                if !in_block
                    # Start of a new block
                    in_block = true
                else
                    # End of current block
                    if !isempty(current_block)
                        push!(blocks, copy(current_block))
                    end
                    empty!(current_block)
                    in_block = false
                end
            elseif in_block
                # Inside a block
                push!(current_block, trimmed_line)
                # push!(current_block, line)
            end
        end
    end

    return blocks
end

"""
    extend_line(line::String) -> String

Extends a line to 80 characters by adding spaces if it is shorter than 80 characters and trim to 80 if req'd.

**Input**
- `line::String`: The line to be extended.

**Output**
- `extended_line::String`: The line extended to 80 characters.
"""
function extend_line(line)
    # Function to extend a line to 80 characters by adding spaces
    nl = length(line)
    if nl < 80
        line *= " "^(80 - nl)
    end

    line = length(line) > 80 ? line[1:80] : line

    return line
end

"""
    issupported(block::Vector{String}) -> Bool

Checks if the dataset type in the given block is supported.

**Input**
- `block::Vector{String}`: A vector of strings representing a block of data.

**Output**
- `Bool`: `true` if the dataset type is supported, `false` otherwise.
"""
function issupported(block::Vector{String})
    dtype = parse(Int, strip(block[1]))
    supported = supported_datasets()

    return dtype in supported
end


## Macro
"""
    @show_struct struct StructName
        field1::Type1
        field2::Type2
        ...
    end

    Or for NamedTuples:
    @show_struct NamedTuple{(:field1, :field2, ...), Tuple{Type1, Type2, ...}}

Macro that automatically generates an enhanced display method for a structure or a NamedTuple type.

This macro applies to a structure definition or a NamedTuple type and overloads the `Base.show`
function to provide formatted output that includes the type name and, for each field,
its name, type, and value.

**Display Format**
- For simple types (Number, String, Symbol): displays the value directly
- For arrays (AbstractArray):
  - If elements are simple types and the array contains 10 elements or less:
    displays all elements
  - If elements are simple types and the array contains more than 10 elements:
    displays the first 5 elements followed by "..."
  - Always includes an array summary (dimensions and type)
- For other types: displays the type and standard representation

**Example**
```julia
@show_data struct MyStruct
    x::Int
    y::String
end

@show_data NamedTuple{(:x, :y), Tuple{Int, String}}

s = MyStruct(1, "hello")
t = (x = 1, y = "hello")
"""
macro show_data(expr)
    # Check if we have a struct definition or a type expression
    if expr.head == :struct
        # Handle struct definition as before
        struct_def = expr.args[2]

        # Extract the base type name without parameters
        base_name = nothing
        if isa(struct_def, Symbol)
            # Simple case: struct Name
            base_name = struct_def
        elseif isa(struct_def, Expr)
            if struct_def.head == :<:
                # Case: struct Name <: Parent or struct Name{T} <: Parent
                subtype_expr = struct_def.args[1]
                if isa(subtype_expr, Symbol)
                    base_name = subtype_expr
                elseif isa(subtype_expr, Expr) && subtype_expr.head == :curly
                    # Handle parametric type: struct Name{T}
                    base_name = subtype_expr.args[1]
                end
            elseif struct_def.head == :curly
                # Case: struct Name{T}
                base_name = struct_def.args[1]
            end
        end

        if base_name === nothing
            error("Unsupported struct definition format")
        end

        # Create the show method for the struct
        show_def = create_show_method(base_name)

        # Combine the structure definition and the show method
        return quote
            $(esc(:($Base.@__doc__ $expr)))
            $show_def
        end
    else
        # Handle type expression (for NamedTuple)
        base_type = expr
        show_def = create_show_method(base_type)

        return show_def
    end
end

# Helper function to create the show method
function create_show_method(type_expr)
    quote
        function Base.show(io::IO, obj::T) where {T <: $(esc(type_expr))}
            println(io, "  $(typeof(obj))")

            for field in fieldnames(typeof(obj))
                value = getfield(obj, field)
                value_type = typeof(value)

                if value_type <: Number || value_type <: Symbol
                    println(io, "  "^(2) * "$field: $value_type $value")
                elseif value_type <: AbstractString
                    # Display strings with quotes
                    println(io, "  "^(2) * "$field: $value_type \"$value\"")
                elseif value_type <: NamedTuple
                    # Display NamedTuple with its fields
                    nt_fields = keys(value)
                    n_fields = length(nt_fields)

                    if n_fields == 0
                        println(io, "  "^(2) * "$field: NamedTuple ()")
                    elseif n_fields <= 4
                        # Display all fields
                        println(io, "  "^(2) * "$field: NamedTuple")
                        for (k, v) in pairs(value)
                            v_str = if v isa AbstractString
                                "\"$v\""
                            else
                                "$v"
                            end
                            println(io, "  "^(3) * "$k: $(typeof(v)) $v_str")
                        end
                    else
                        # Display first 4 fields and truncate
                        println(io, "  "^(2) * "$field: NamedTuple")
                        for (i, (k, v)) in enumerate(pairs(value))
                            if i <= 4
                                v_str = if v isa AbstractString
                                    "\"$v\""
                                else
                                    "$v"
                                end
                                println(io, "  "^(3) * "$k: $(typeof(v)) $v_str")
                            else
                                println(io, "  "^(3) * "... ($(n_fields - 5) more fields)")
                                break
                            end
                        end
                    end
                elseif value_type <: AbstractArray
                    val_str = "..."
                    if !isempty(value) && (eltype(value) <: Number || eltype(value) <: AbstractString || eltype(value) <: Symbol)
                        if length(value) <= 10
                            val_str = "$value"
                        else
                            val_str = string(value[1:5]) * "..."
                        end
                    end
                    println(io, "  "^(2) * "$field: $(summary(value)) $val_str")
                elseif isstructtype(value_type)
                    # For structures, display only the type, not the value
                    println(io, "  "^(2) * "$field: $value_type")
                else
                    println(io, "  "^(2) * "$field: $value_type $value")
                end
            end
        end
    end
end