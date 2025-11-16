"""
    Dataset2411

A struct containing UFF Dataset 2411 (Nodes - Double precision) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `nodes_ID::Vector{Int}`: Node IDs
- `coord_system::Vector{Int}`: Coordinate system IDs
- `disp_coord_system::Vector{Int}`: Displacement coordinate system IDs
- `color::Vector{Int}`: Color codes
- `node_coords::Matrix{Float64}`: Node coordinates
"""
@show_data struct Dataset2411 <: UFFDataset
    # Fields specific to Dataset2411
    type::Symbol                    # Data set type
    name::String                    # Data set name
    nodes_ID::Vector{Int}           # Record 1 - field 1
    coord_system::Vector{Int}       # Record 1 - field 2
    disp_coord_system::Vector{Int}  # Record 1 - field 3
    color::Vector{Int}              # Record 1 - field 4
    node_coords::Matrix{Float64}    # Record 2 - fields 1 to 3

    Dataset2411(
        nodes_ID = Int[],
        coord_system = Int[],
        disp_coord_system = Int[],
        color = Int[],
        node_coords = Matrix{Float64}(undef, 0, 0)
    ) = new(:Dataset2411, "Nodes - Double precision",nodes_ID, coord_system, disp_coord_system, color, node_coords)
end

"""
Universal Dataset Number: 2411

**Name:   Nodes - Double Precision**

    Record 1: FORMAT(4I10)
                 Field 1       -- node label
                 Field 2       -- export coordinate system number
                 Field 3       -- displacement coordinate system number
                 Field 4       -- color

    Record 2: FORMAT(1P3D25.16)
                 Fields 1-3    -- node coordinates in the part coordinate
                                  system

    Records 1 and 2 are repeated for each node in the model.
"""
function parse_dataset2411(block)
    # Initialize empty arrays to hold the parsed data
    nnodes = (length(block) - 1) ÷ 2
    nodes_ID = zeros(Int, nnodes)
    coord_system = similar(nodes_ID)
    disp_coord_system = similar(nodes_ID)
    color = similar(nodes_ID)
    node_coords = zeros(nnodes, 3)

    record1 = block[2:2:end]
    record2 = block[3:2:end]

    for (i, (r1, r2)) in enumerate(zip(record1, record2))
        nodes_ID[i], coord_system[i], disp_coord_system[i], color[i] = parse.(Int, split(r1))
        node_coords[i, :] = parse.(Float64, split(r2))
    end

    return Dataset2411(
        nodes_ID,
        coord_system,
        disp_coord_system,
        color,
        node_coords
    )
end

"""
    write_dataset(dataset::Dataset2411) -> Vector{String}

Write a UFF Dataset 2411 (Nodes - Double Precision) to a vector of strings.

**Input**
- `dataset::Dataset2411`: The dataset structure containing node information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(dataset::Dataset2411)
    # Follow the docstring format for UFF 2411 (Nodes - Double Precision)
    # Record 1: 4I10 (node label, export CS, displacement CS, color)
    # Record 2: 1P3D25.16 (x, y, z coordinates)
    lines = String[]

    # Header
    push!(lines, "    -1")
    push!(lines, "  2411")

    # Ensure we can iterate consistently over nodes
    nnodes = length(dataset.nodes_ID)

    for i in 1:nnodes
        # Record 1: integers in width 10
        push!(
            lines,
            @sprintf("%10d%10d%10d%10d",
                dataset.nodes_ID[i],
                dataset.coord_system[i],
                dataset.disp_coord_system[i],
                dataset.color[i]
            ),
        )

        # Record 2: three double-precision values, width 25 with 16 decimals
        # Using E-format is acceptable; parser splits by whitespace.
        push!(
            lines,
            @sprintf("%25.16E%25.16E%25.16E",
                dataset.node_coords[i, 1],
                dataset.node_coords[i, 2],
                dataset.node_coords[i, 3]
            ),
        )
    end

    # Footer
    push!(lines, "    -1")

    return lines
end