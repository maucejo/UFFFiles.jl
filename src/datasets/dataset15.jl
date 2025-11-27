"""
    Dataset15

A struct containing UFF Dataset 15 (Nodes) data .

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `node_ID::Vector{Int}`: Node label
- `def_cs_num::Vector{Int}`: Definition coordinate system number
- `disp_cs_num::Vector{Int}`: Displacement coordinate system number
- `color::Vector{Int}`: Color
- `coords::Vector{Vector{Float64}}`: 3D coordinates of node in the definition system
"""
@show_data struct Dataset15 <: UFFDataset
    # Fields specific to Dataset15
    type::Symbol                     # Data set type
    name::String                     # Data set name
    node_ID::Vector{Int}             # Record 1 - field 1
    def_cs_num::Vector{Int}          # Record 1 - field 2
    disp_cs_num::Vector{Int}         # Record 1 - field 3
    color::Vector{Int}               # Record 1 - field 4
    node_coords::Matrix{Float64}     # Record 1 - fields 5 to 7

    Dataset15(
        node_ID = Int[],
        def_cs_num = Int[],
        disp_cs_num = Int[],
        color = Int[],
        node_coords = Matrix{Float64}(undef, 0, 0)
    ) = new(:Dataset15, "Nodes", node_ID, def_cs_num, disp_cs_num, color, node_coords)
end

"""
Universal Dataset Number: 15

**Name:   Nodes**

             Record 1: FORMAT(4I10,1P3E13.5)
                       Field 1   -  node label
                       Field 2   -  definition coordinate system number
                       Field 3   -  displacement coordinate system number
                       Field 4   -  color
                       Field 5-7 -  3 - Dimensional coordinates of node
                                    in the definition system

             NOTE:  Repeat record for each node
"""
function parse_dataset15(io)

    node_ID = Int[]
    def_cs_num = Int[]
    disp_cs_num = Int[]
    color = Int[]
    node_coords = Vector{Float64}[]

    while  (r1 = rstrip(readline(io))) != "    -1"
        nid, dcs, disp_cs, col, x, y, z = @scanf(r1, "%10d%10d%10d%10d%13e%13e%13e", Int, Int, Int, Int, Float64, Float64, Float64)[2:end]

        push!(node_ID, nid)
        push!(def_cs_num, dcs)
        push!(disp_cs_num, disp_cs)
        push!(color, col)
        push!(node_coords, [x, y, z])
    end

    return Dataset15(
        node_ID,
        def_cs_num,
        disp_cs_num,
        color,
        reduce(hcat, node_coords)'
    )
end

"""
    write_dataset(dataset::Dataset15) -> Vector{String}

Write a UFF Dataset 15 (Nodes) to a vector of strings.

**Input**
- `dataset::Dataset15`: The dataset structure containing node information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset15)

    # Write header
    println(io, "    -1")
    println(io, "    15")

    # Write node data
    for i in eachindex(dataset.node_ID)
        # Format: 4I10 for integers, 1P3E13.5 for coordinates
        line = @sprintf("%10d%10d%10d%10d%13.5E%13.5E%13.5E",
            dataset.node_ID[i],
            dataset.def_cs_num[i],
            dataset.disp_cs_num[i],
            dataset.color[i],
            dataset.node_coords[i, 1],
            dataset.node_coords[i, 2],
            dataset.node_coords[i, 3]
        )
        println(io, line)
    end

    # Write footer
    println(io, "    -1")
end