"""
    readuff(filename::String) -> Vector{UFFDataset}

Reads a UFF (Universal File Format) file and parses its contents into a vector of UFFDataset objects.

**Input**
- `filename::String`: The path to the UFF file to be read.

**Output**
- `data::Vector{UFFDataset}`: A vector containing the parsed UFF datasets.
"""
function readuff(filename::String)

    # Extract blocks from the UFF file
    blocks = extract_blocks(filename)
    nblocks = length(blocks)

    # Initialize an array to hold parsed datasets
    data = Vector{UFFDataset}(undef, nblocks)

    for (i, block) in enumerate(blocks)
        # Determine dataset type from the first line of the block
        dtype = strip(block[1])
        # Parse the block based on its dataset type
        data[i] = parse_datasets(dtype, block)
    end

    return data
end

"""
    writeuff(filename::String, data::Vector{UFFDataset})

Writes a vector of UFFDataset objects to a UFF file.

**Input**
- `filename::String`: The path to the UFF file to be written.
- `data::Vector{UFFDataset}`: A vector containing the UFF datasets to be
written.
"""
function writeuff(filename::String, data)
    open(filename, "w") do io
        for dataset in data
            lines = write_datasets(dataset)

            # Write the formatted lines to the file
            for line in lines
                println(io, line)
            end
        end
    end
end

## Functions for reading and writing UFF datasets
"""
    parse_datasets(dtype::String, block::Vector{String}) -> UFFDataset

Parses a block of UFF data based on the dataset type.

**Input**
- `dtype::String`: The dataset type identifier (e.g., "15", "18", etc.).
- `block::Vector{String}`: The block of data as a vector of strings.

**Output**
- `dataset::UFFDataset`: The parsed dataset as an instance of the corresponding UFFDataset subtype.
"""
function parse_datasets(dtype, block)
    if dtype == "15"
        # Parse Dataset15
        return parse_dataset15(block)
    elseif dtype == "18"
        # Parse Dataset18
        return parse_dataset18(block)
    elseif dtype == "55"
        # Parse Dataset55
        return parse_dataset55(block)
    elseif dtype == "58"
        # Parse Dataset58
        return parse_dataset58(block)
    elseif dtype == "82"
        # Parse Dataset82
        return parse_dataset82(block)
    elseif dtype == "151"
        # Parse Dataset151
        return parse_dataset151(block)
    elseif dtype == "164"
        # Parse Dataset164
        return parse_dataset164(block)
    elseif dtype == "2411"
        # Parse Dataset2411
        return parse_dataset2411(block)
    elseif dtype == "2412"
        # Parse Dataset2412
        return parse_dataset2412(block)
    elseif dtype == "2414"
        # Parse Dataset2414
        return parse_dataset2414(block)
    else
        throw("Unsupported dataset type: $dtype")
    end
end

"""
    write_dataset(dataset::UFFDataset) -> Vector{String}

Writes a UFF dataset to a vector of formatted strings based on its type.

**Input**
- `dataset::UFFDataset`: The dataset to be written.

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content.
"""
function write_datasets(dataset::UFFDataset)
    if dataset isa Dataset15
        return write_dataset15(dataset)
    elseif dataset isa Dataset18
        return write_dataset18(dataset)
    elseif dataset isa Dataset55
        return write_dataset55(dataset)
    elseif dataset isa Dataset58
        return write_dataset58(dataset)
    elseif dataset isa Dataset82
        return write_dataset82(dataset)
    elseif dataset isa Dataset151
        return write_dataset151(dataset)
    elseif dataset isa Dataset164
        return write_dataset164(dataset)
    elseif dataset isa Dataset2411
        return write_dataset2411(dataset)
    elseif dataset isa Dataset2412
        return write_dataset2412(dataset)
    elseif dataset isa Dataset2414
        return write_dataset2414(dataset)
    else
        throw("Unsupported dataset type: $(typeof(dataset))")
    end
end