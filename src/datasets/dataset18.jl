"""
    Dataset18

A struct containing UFF Dataset 18 (Coordinate systems) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `cs_num::Int`: Coordinate system number
- `cs_type::Int`: Coordinate system type
- `ref_cs_num::Int`: Reference coordinate system number
- `color::Int`: Color
- `method_def::Int`: Method of definition
- `cs_name::String`: Coordinate system name
- `cs_origin::Vector{Float64}`: Origin of new system specified in reference system
- `cs_x::Vector{Float64}`: Point on +x axis of the new system specified in reference system
- `cs_xz::Vector{Float64}`: Point on +xz plane of the new system specified in reference system
"""
@show_data struct Dataset18 <: UFFDataset
    # Fields specific to Dataset18
    type::Symbol                        # Data set type
    name::String                        # Data set name
    cs_num::Vector{Int}                 # Record 1 - field 1
    cs_type::Vector{Int}                # Record 1 - field 2
    ref_cs_num::Vector{Int}             # Record 1 - field 3
    color::Vector{Int}                  # Record 1 - field 4
    method_def::Vector{Int}             # Record 1 - field 5
    cs_name::Vector{String}             # Record 2 - field 1
    cs_origin::Vector{Vector{Float64}}  # Record 3 - fields 1 to 3
    cs_x::Vector{Vector{Float64}}       # Record 3 - fields 4 to 6
    cs_xz::Vector{Vector{Float64}}      # Record 3 - fields 7 to 9

    Dataset18(
        cs_num = Int[],
        cs_type = Int[],
        ref_cs_num = Int[],
        color = Int[],
        method_def = Int[],
        cs_name = String[],
        cs_origin = Vector{Vector{Float64}}[],
        cs_x = Vector{Vector{Float64}}[],
        cs_xz = Vector{Vector{Float64}}[]
    ) = new(:Dataset18, "Coordinate systems", cs_num, cs_type, ref_cs_num, color, method_def, cs_name, cs_origin, cs_x, cs_xz)
end

"""
Universal Dataset Number: 18

**Name:   Coordinate Systems**

            Record 1: FORMAT(5I10)
                 Field 1       -- coordinate system number
                 Field 2       -- coordinate system type
                 Field 3       -- reference coordinate system number
                 Field 4       -- color
                 Field 5       -- method of definition
                               = 1 - origin, +x axis, +xz plane

            Record 2: FORMAT(20A2)
                 Field 1       -- coordinate system name

            Record 3: FORMAT(1P6E13.5)
                 Total of 9 coordinate system definition parameters.
                 Fields 1-3    -- origin of new system specified in
                                  reference system
                 Fields 4-6    -- point on +x axis of the new system
                                  specified in reference system
                 Fields 7-9    -- point on +xz plane of the new system
                                  specified in reference system

Records 1 thru 3 are repeated for each coordinate system in the model.
"""
function parse_dataset18(io)
    cs_num = Int[]
    cs_type = Int[]
    ref_cs_num = Int[]
    color = Int[]
    method_def = Int[]
    cs_name = String[]
    cs_origin = Vector{Float64}[]
    cs_x = Vector{Float64}[]
    cs_xz = Vector{Float64}[]

    while  (line = readline(io))[1:6] != "    -1"
        # Record 1 - FORMAT(5I10)
        csn, cst, ref_csn, col, md = @scanf(line, "%10d%10d%10d%10d%10d", Int, Int, Int, Int, Int)[2:end]
        # csn, cst, ref_csn, col, md = parse.(Int, split(line))
        push!(cs_num, csn)
        push!(cs_type, cst)
        push!(ref_cs_num, ref_csn)
        push!(color, col)
        push!(method_def, md)

        # Record 2 - FORMAT(20A2)
        push!(cs_name, strip(readline(io)))

        # Record 3 - FORMAT(1P6E13.5)
        # Fields 1-6
        cs_orig1, cs_orig2, cs_orig3, cs_x1, cs_x2, cs_x3 = @scanf(readline(io), "%13e%13e%13e%13e%13e%13e", Float64, Float64, Float64, Float64, Float64, Float64)[2:end]

        # Fields 7-9
        cs_xz1, cs_xz2, cs_xz3 = @scanf(readline(io), "%13e%13e%13e", Float64, Float64, Float64)[2:end]

        push!(cs_origin, [cs_orig1, cs_orig2, cs_orig3])
        push!(cs_x, [cs_x1, cs_x2, cs_x3])
        push!(cs_xz, [cs_xz1, cs_xz2, cs_xz3])

        # Move to the next coordinate system
    end

    return Dataset18(
        cs_num,
        cs_type,
        ref_cs_num,
        color,
        method_def,
        cs_name,
        cs_origin,
        cs_x,
        cs_xz
    )
end

"""
    write_dataset(dataset::Dataset18) -> Vector{String}

Write a UFF Dataset 18 (Coordinate Systems) to a vector of strings.

**Input**
- `dataset::Dataset18`: The dataset structure containing coordinate system information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset18)
    # Header
    println(io, "    -1")
    println(io, "    18")

    # Ensure we can iterate consistently over coordinate systems
    ncs = length(dataset.cs_num)

    for i in 1:ncs
        # Record 1: FORMAT(5I10) - 5 integers with width 10
        println(io,
            @sprintf("%10i%10i%10i%10i%10i",
                dataset.cs_num[i],
                dataset.cs_type[i],
                dataset.ref_cs_num[i],
                dataset.color[i],
                dataset.method_def[i]
            ),
        )

        # Record 2: FORMAT(20A2) - coordinate system name (40 characters)
        println(io, dataset.cs_name[i])

        # Record 3: FORMAT(1P6E13.5) - 9 coordinate system definition parameters
        # Split into 2 lines: first line has 6 values, second line has 3 values
        println(io,
            @sprintf("%13.5e%13.5e%13.5e%13.5e%13.5e%13.5e",
                dataset.cs_origin[i][1],
                dataset.cs_origin[i][2],
                dataset.cs_origin[i][3],
                dataset.cs_x[i][1],
                dataset.cs_x[i][2],
                dataset.cs_x[i][3]
            ),
        )
        println(io,
            @sprintf("%13.5e%13.5e%13.5e",
                dataset.cs_xz[i][1],
                dataset.cs_xz[i][2],
                dataset.cs_xz[i][3]
            ),
        )
    end

    # Footer
    println(io, "    -1")
end