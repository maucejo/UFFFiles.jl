global binary_write::Bool

"""
    readuff(filename::String) -> Vector{UFFDataset}

Reads a UFF (Universal File Format) file and parses its contents into a vector of UFFDataset objects.

**Input**
- `filename::String`: The path to the UFF file to be read.

**Output**
- `data::Vector{UFFDataset}`: A vector containing the parsed UFF datasets.
"""
function readuff(filename::String)

    # Initialize an array to hold parsed datasets
    data = Vector{UFFDataset}(undef, 0)
    # https://discourse.julialang.org/t/readline-and-end-of-file/64384/4
    open(filename, "r") do io
        while !eof(io)
            line = readline(io)

            # Look for dataset delimiter
            if line == "    -1"
                # Determine dataset type from the following line & mark the position
                mark(io)
                line = readline(io)

                dtype = length(line) > 6 ? strip(line[1:7]) : strip(line[1:6])
                if any(dtype .== supported_datasets())
                    # Parse the block based on its dataset type
                    # https://stackoverflow.com/questions/34016768/julia-invoke-a-function-by-a-given-string/34023458#34023458
                    parse_function = getfield(UFFFiles, Symbol("parse_dataset", dtype))

                    datatmp = parse_function(io)
                    data = push!(data, datatmp)
                else
                     @warn "Unsupported dataset type: $dtype - skipping this dataset"
                     while readline(io) != "    -1"  # Remove the -1 from the end of this dataset
                     end
                end
            end
        end
    end

    return data
end

# FileIO integration
fileio_load(file::File{FileIO.format"UFF"}) = readuff(file.filename)

"""
    writeuff(filename::String, data::Vector{UFFDataset})

Writes a vector of UFFDataset objects to a UFF file.

**Input**
- `filename::String`: The path to the UFF file to be written.
- `datasets::Vector{UFFDataset}`: A vector containing the UFF datasets to be
written.
"""
function writeuff(filename::String, datasets)
    open(filename, "w") do io
        for dataset in datasets
            write_dataset(io, dataset)
        end
    end
end

# FileIO integration
fileio_save(file::File{format"UFF"}, data) = writeuff(file.filename, data)