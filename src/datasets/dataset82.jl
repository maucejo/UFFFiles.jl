"""
    Dataset82

A struct containing UFF Dataset 82 (Tracelines) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `line_number::Int`: Trace line number
- `num_nodes::Int`: Number of nodes defining trace line
- `color::Int`: Color
- `id_line::String`: Identification line
- `line_nodes::Vector{Int}`: Nodes defining trace line
"""
@show_data struct Dataset82 <: UFFDataset
    # Fields specific to Dataset82
    type::Symbol                     # Data set type
    name::String                     # Data set name
    line_number::Int                 # Record 1 - field 1
    num_nodes::Int                   # Record 1 - field 2
    color::Int                       # Record 1 - field 3
    id_line::String                  # Record 2 - field 1
    line_nodes::Vector{Int}          # Record 3 - field 1

    Dataset82(
        line_number = Int[],
        num_nodes = Int[],
        color = Int[],
        id_line = String[],
        line_nodes = Vector{Int}[]
    ) = new(:Dataset82, "Tracelines", line_number, num_nodes, color, id_line, line_nodes)
end

"""
Universal Dataset Number: 82

**Name:   Tracelines**

             Record 1: FORMAT(3I10)
                       Field 1 -    trace line number
                       Field 2 -    number of nodes defining trace line
                                    (maximum of 250)
                       Field 3 -    color

             Record 2: FORMAT(80A1)
                       Field 1 -    Identification line

             Record 3: FORMAT(8I10)
                       Field 1 -    nodes defining trace line
                               =    > 0 draw line to node
                               =    0 move to node (a move to the first
                                    node is implied)
             Notes: 1) MODAL-PLUS node numbers must not exceed 8000.
                    2) Identification line may not be blank.
                    3) Systan only uses the first 60 characters of the
                       identification text.
                    4) MODAL-PLUS does not support trace lines longer than
                       125 nodes.
                    5) Supertab only uses the first 40 characters of the
                       identification line for a name.
                    6) Repeat Datasets for each Trace_Line
"""
function parse_dataset82(io)
    # Record 1 - FORMAT(3I10)
    r1 = readline(io)
    line_number, num_nodes, color = @scanf(r1, "%10i%10i%10i", Int, Int, Int)[2:end]

    # Record 2 - FORMAT(80A1)
    id_line = strip(readline(io))

    # Record 3 - FORMAT(8I10)
    line_nodes = Int[]
    while (line = readline(io))[1:6] != "    -1"
        append!(line_nodes, parse.(Int, split(line)))
    end

    return Dataset82(
        line_number,
        num_nodes,
        color,
        id_line,
        line_nodes
    )
end

"""
    write_dataset(dataset::Dataset82) -> Vector{String}

Write a UFF Dataset 82 (Tracelines) to a vector of strings.

**Input**
- `dataset::Dataset82`: The dataset structure containing trace line information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset82)

    # Write header
    println(io, "    -1")
    println(io, "    82")

    # Write Record 1: FORMAT(3I10)
    # Field 1: trace line number
    # Field 2: number of nodes
    # Field 3: color
    r1 = @sprintf("%10d%10d%10d",
        dataset.line_number,
        dataset.num_nodes,
        dataset.color
    )
    println(io, r1)

    # Write Record 2: FORMAT(80A1)
    # Identification line (max 80 characters)
    r2 = rpad(dataset.id_line[1:min(length(dataset.id_line), 80)], 0)
    println(io, r2)

    # Write Record 3: FORMAT(8I10)
    # Node numbers, 8 per line
    for i in 1:8:length(dataset.line_nodes)
        # Get up to 8 nodes for this line
        end_idx = min(i + 7, length(dataset.line_nodes))
        nodes_chunk = dataset.line_nodes[i:end_idx]

        # Format each node as I10 (10 characters, right-aligned)
        line_parts = [@sprintf("%10d", node) for node in nodes_chunk]
        println(io, join(line_parts, ""))
    end

    # Write footer
    println(io, "    -1")

    return nothing
end