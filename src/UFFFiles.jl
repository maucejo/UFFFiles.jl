module UFFFiles
    using Dates, Printf, Scanf

    # Base UFFDataset abstract type
    abstract type UFFDataset end

    # Exported Types
    # Types for UFF datasets -- see https://www.ceas3.uc.edu/sdrluff/all_files.php
    export Dataset15, Dataset18, Dataset55, Dataset58, Dataset82,
           Dataset151, Dataset164, Dataset1858, Dataset2411, Dataset2412, Dataset2414

    # Exported functions - Main functions
    export readuff, writeuff

    # Helper functions
    export connectivity_matrix, convert_to_si!, dataset_type, collect_to_mat,
           srdc_doc, supported_datasets, supported_file_extensions

    # Include files
    include("uff_utils.jl")

    # Include datasets read/write functions
    include("datasets/dataset15.jl")
    include("datasets/dataset18.jl")
    include("datasets/dataset55.jl")
    include("datasets/dataset58common.jl")
    include("datasets/dataset58.jl")
    include("datasets/dataset58b.jl")
    include("datasets/dataset82.jl")
    include("datasets/dataset151.jl")
    include("datasets/dataset164.jl")
    include("datasets/dataset1858.jl")
    include("datasets/dataset2411.jl")
    include("datasets/dataset2412.jl")
    include("datasets/dataset2414.jl")
    include("datasets/doc_datasets.jl")
    include("read_write_uff.jl")

    # Include helper functions
    include("uff_helpers.jl")
    include("unit_conversion.jl")
end
