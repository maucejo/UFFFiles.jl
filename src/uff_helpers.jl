"""
    dataset_type(data::UFFDataset)

Returns the dataset type presents in a UFFDataset object.

**Input**
- `data::UFFDataset`: The UFFDataset object to extract types from.

**Output**
- `Symbol`: A vector containing the dataset types.
"""
function dataset_type(data::UFFDataset)
    # Function to get the types of UFF datasets in a vector
    return data.type
end

"""
    supported_datasets()

Returns a vector of supported UFF dataset types.
"""
function supported_datasets()
    # Returns a vector of supported UFF dataset types
    return ["15", "18", "55", "58", "58b", "82", "151", "164", "1858", "2411", "2412", "2414"]
end


function supported_file_extensions()
    # Returns a vector of supported UFF file extensions
    return ["unv", "uff", "uf", "bunv", "ufb", "buf"]
end

"""
    connectivity_matrix(dataset::Dataset2412)

Returns the connectivity matrix for a Dataset2412 object, where each row corresponds to an element and each column corresponds to a node. Missing values are filled with `-1`.

**Input**
- `dataset::Dataset2412`: The Dataset2412 object to extract connectivity from.

**Output**
- `Matrix{Int}`: A matrix representing the connectivity of elements to nodes.
"""
function connectivity_matrix(dataset::Dataset2412)
    # Create a mapping from element ID to its index in the dataset
    if dataset != Dataset2412
        throw(ArgumentError("connectivity_matrix function only supports Dataset2412 type."))
    end

    connectivity = dataset.connectivity
    max_nodes = maximum(length.(connectivity))

    mat = fill(-1, length(connectivity), max_nodes)
    for (i, conn) in enumerate(connectivity)
        mat[i, 1:length(conn)] .= conn
    end

    return mat
end

"""
    dataset55_to_mat(dataset::Vector{Dataset55})

Converts a vector of Dataset55 objects into a matrix of data values and a vector of corresponding x-values based on the analysis type.

**Input**
- `dataset::Vector{Dataset55}`: A vector of Dataset55 objects to be converted

**Outputs**
- `mat::VecOrMat{dtype}`: A matrix where each column corresponds to a dataset's data values.
- `x::Vector{xtype}`: Vector of x-values corresponding to each dataset based on its analysis type.

**Note**
- `dtype` and `xtype` depend on the dataset's `dtype` and `analysis_type` respectively.
- It is assumed that all datasets in the input vector have the same number of data points and analysis type.
"""
function dataset55_to_mat(dataset)
    # Convert Dataset55 to Matrix
    ndatasets = length(dataset)
    ndata_per_dataset = length(dataset[1].data)

    analysis_type = dataset[1].analysis_type
    if analysis_type == 3
        xtype = ComplexF64
    else
        xtype = Float64
    end

    dtype = if dataset[1].dtype == 5
        ComplexF64
    else
        Float64
    end

    x = Vector{xtype}(undef, ndatasets)
    mat = Matrix{dtype}(undef, ndata_per_dataset, ndatasets)
    for (i, ds) in enumerate(dataset)
        mat[:, i] .= ds.data[:]

        if analysis_type == 0 || analysis_type == 1
            x[i] = ds.r8.field1
        elseif analysis_type == 2 || analysis_type == 5
            x[i] = ds.r8.freq
        elseif analysis_type == 3
            x[i] = complex(ds.r8.real_eigval, ds.r8.imag_eigval)
        elseif analysis_type == 4
            x[i] = ds.r8.time
        elseif analysis_type == 6
            x[i] = ds.r8.eigval
        else
            throw(ArgumentError("Unsupported analysis type: $analysis_type"))
        end
    end

    return ndatasets == 1 ? vec(mat) : mat, x
end

"""
    dataset58_to_mat(dataset::Vector{Dataset58})

Converts a vector of Dataset58 objects into a matrix of data values and a vector of corresponding x-values based on the dataset parameters.

**Input**
- `dataset::Vector{Dataset58}`: A vector of Dataset58 objects to be converted

**Outputs**
- `mat::VecOrMat{dtype}`: A matrix where each row corresponds to a dataset's data values.
- `x::Vector{xtype}`: A vector of x-values corresponding to each dataset based on its parameters.

**Note**
- `dtype` and `xtype` depend on the dataset's `ord_dtype`.
- It is assumed that all datasets in the input vector have the same number of data points and data type.
"""
function dataset58_to_mat(dataset)
    # Convert Dataset58 to Matrix
    ndatasets = length(dataset)
    nx = length(dataset[1].data)

    xtype, dtype = if dataset[1].ord_dtype == 2
            Float32, Float32
    elseif ord_dtype == 4
            Float64, Float64
    elseif ord_dtype == 5
            Float32, ComplexF32
    elseif ord_dtype == 6
            Float64, ComplexF64
    end

    xmin = xtype(dataset[1].abs_min)
    dx = xtype(dataset[1].abs_increment)
    if xmin == xtype(0.)
        xmax = (nx - 1)*dx
    else
        xmax = nx*dx
    end
    x = xmin:dx:xmax

    mat = Matrix{dtype}(undef, ndatasets, nx)
    for (i, ds) in enumerate(dataset)
        mat[i, :] .= ds.data
    end

    return ndatasets == 1 ? vec(mat) : mat, x
end