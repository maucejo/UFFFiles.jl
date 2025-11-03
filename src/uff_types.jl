abstract type UFFDataset end

# Types for UFF datasets -- see https://www.ceas3.uc.edu/sdrluff/all_files.php
"""
    Dataset15

A struct containing UFF Dataset 15 metadata.

**Fields**
- `type::Symbol`: Data set type
- `node_ID::Vector{Int}`: Node label
- `def_cs_num::Vector{Int}`: Definition coordinate system number
- `disp_cs_num::Vector{Int}`: Displacement coordinate system number
- `color::Vector{Int}`: Color
- `coords::Vector{Vector{Float64}}`: 3D coordinates of node in the definition system
"""
@show_data struct Dataset15 <: UFFDataset
    # Fields specific to Dataset15
    type::Symbol                     # Data set type
    node_ID::Vector{Int}             # Record 1 - field 1
    def_cs_num::Vector{Int}          # Record 1 - field 2
    disp_cs_num::Vector{Int}         # Record 1 - field 3
    color::Vector{Int}               # Record 1 - field 4
    coords::Vector{Vector{Float64}}  # Record 1 - fields 5 to 7

    Dataset15(
        node_ID = Int[],
        def_cs_num = Int[],
        disp_cs_num = Int[],
        color = Int[],
        coords = Vector{Float64}[]
    ) = new(:Dataset15, node_ID, def_cs_num, disp_cs_num, color, coords)
end

"""
    Dataset18

A struct containing UFF Dataset 18 metadata.

**Fields**
- `type::Symbol`: Data set type
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
    type::Symbol     # Data set type
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
    ) = new(:Dataset18, cs_num, cs_type, ref_cs_num, color, method_def, cs_name, cs_origin, cs_x, cs_xz)
end

"""
    Dataset55

A struct containing UFF Dataset 55 metadata.

**Fields**
- `type::Symbol`: Data set type
- `id1::String`: ID line 1
- `id2::String`: ID line 2
- `id3::String`: ID line 3
- `id4::String`: ID line 4
- `id5::String`: ID line 5
- `model_type::Int`: Model type
- `analysis_type::Int`: Analysis type
- `data_charac::Int`: Data characterization
- `spec_dtype::Int`: Specific data type
- `dtype::Int`: Data type
- `ndv_per_node::Int`: Number of data values per node
- `r7::NamedTuple`: Analysis type specific
- `r8::NamedTuple`: Analysis type specific
- `node_number::Vector{Int}`: Node numbers
- `data::Matrix{Union{Float64, ComplexF64}}`: Data values
"""
@show_data struct Dataset55 <: UFFDataset
    # Fields specific to Dataset55
    type::Symbol       # Data set type

    #Record 1 to 5 fields
    id1::String        # Record 1 - field 1
    id2::String        # Record 2 - field 1
    id3::String        # Record 3 - field 1
    id4::String        # Record 4 - field 1
    id5::String        # Record 5 - field 1

    # Record 6 fields
    model_type::Int    # Record 6 - field 1
    analysis_type::Int # Record 6 - field 2
    data_charac::Int   # Record 6 - field 3
    spec_dtype::Int    # Record 6 - field 4
    dtype::Int         # Record 6 - field 5
    ndv_per_node::Int  # Record 6 - field 6

    # Record 7 fields (Analysis type specific)
    r7::NamedTuple      # Record 7 - field 1

    # Record 8 fields (Analysis type specific)
    r8::NamedTuple  # Record 8 - fields 1 to 4

    # Record 9 fields
    node_number::Vector{Int}      # Record 9 - field 1

    # Record 10 fields
    data::AbstractMatrix  # Record 10 - fields 1 to ndv_per_node

    function Dataset55(
        id1 = "",
        id2 = "",
        id3 = "",
        id4 = "",
        id5 = "",
        model_type = 0,
        analysis_type = 0,
        data_charac = 0,
        spec_dtype = 0,
        dtype = 0,
        ndv_per_node = 0,
        r7_raw = Int[],
        r8_raw = Float64[],
        node_number = Int[],
        data = Array{Union{Float64, ComplexF64}}(undef, 0, 0)
    )

        # Parse r7 and r8 based on analysis_type
        if !isempty(r7_raw) && !isempty(r8_raw)
            if analysis_type == 0 # Unknown
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], ID_number = r7_raw[3])
                r8 = (field1 = r8_raw[1],)

            elseif analysis_type == 1 # Static
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], load_case_num = r7_raw[3])
                r8 = (field1 = r8_raw[1],)

            elseif analysis_type == 2 # Normal Mode
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], load_case = r7_raw[3], mode_number = r7_raw[4])
                r8 = (freq = r8_raw[1], modal_mass = r8_raw[2], modal_visc_dr = r8_raw[3], modal_hyst_dr = r8_raw[4])

            elseif analysis_type == 3 # Complex Eigenvalue
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], load_case_num = r7_raw[3], mode_number = r7_raw[4])
                r8 = (real_eigval = r8_raw[1], imag_eigval = r8_raw[2], real_modalA = r8_raw[3], imag_modalA = r8_raw[4], real_modalB = r8_raw[5], imag_modalB = r8_raw[6])

            elseif analysis_type == 4 # Transient
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], load_case_num = r7_raw[3], time_step_num = r7_raw[4])
                r8 = (time = r8_raw[1],)

            elseif analysis_type == 5 # Frequency Response
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], load_case_num = r7_raw[3], freq_step_num = r7_raw[4])
                r8 = (freq = r8_raw[1],)

            elseif analysis_type == 6 # Buckling
                r7 = (field1 = r7_raw[1], field2 = r7_raw[2], load_case_num = r7_raw[3])
                r8 = (eigval = r8_raw[1],)
            end
        else
            r7 = ()
            r8 = ()
        end

        return new(:Dataset55, id1, id2, id3, id4, id5, model_type, analysis_type, data_charac, spec_dtype, dtype, ndv_per_node, r7, r8, node_number, data)
    end
end

"""
    Dataset58

A struct containing UFF Dataset 58 metadata.

**Fields**
- `type::Symbol`: Data set type
- `id1::String`: ID line 1
- `id2::String`: ID line 2
- `id3::String`: ID line 3
- `id4::String`: ID line 4
- `id5::String`: ID line 5
- `func_type::Int`: Function type
- `func_id::Int`: Function ID
- `ver_num::Int`: Version number
- `load_case::Int`: Load case
- `resp_name::String`: Response name
- `resp_node::Int`: Response node
- `resp_dir::Int`: Response direction
- `ref_name::String`: Reference name
- `ref_node::Int`: Reference node
- `ref_dir::Int`: Reference direction
- `ord_dtype::Int`: Ordinate data type
- `num_pts::Int`: Number of points
- `abs_spacing_type::Int`: Abscissa spacing type
- `abs_start::Float64`: Abscissa start
- `abs_increment::Float64`: Abscissa increment
- `zval::Float64`: Z-axis value
- `abs_spec_dtype::Int`: Abscissa specification data type
- `abs_len_unit_exp::Int`: Abscissa length unit exponent
- `abs_force_unit_exp::Int`: Abscissa force unit exponent
- `abs_temp_unit_exp::Int`: Abscissa temperature unit exponent
- `abs_axis_label::String`: Abscissa axis label
- `abs_axis_unit_label::String`: Abscissa axis unit label
- `ord_spec_dtype::Int`: Ordinate specification data type
- `ord_len_unit_exp::Int`: Ordinate length unit exponent
- `ord_force_unit_exp::Int`: Ordinate force unit exponent
- `ord_temp_unit_exp::Int`: Ordinate temperature unit exponent
- `ord_axis_label::String`: Ordinate axis label
- `ord_axis_unit_label::String`: Ordinate axis unit label
- `ord_denom_spec_dtype::Int`: Ordinate denominator specification data type
- `ord_denom_len_unit_exp::Int`: Ordinate denominator length unit exponent
- `ord_denom_force_unit_exp::Int`: Ordinate denominator force unit exponent
- `ord_denom_temp_unit_exp::Int`: Ordinate denominator temperature unit exponent
- `ord_denom_axis_label::String`: Ordinate denominator axis label
- `ord_denom_axis_unit_label::String`: Ordinate denominator axis unit label
- `z_spec_dtype::Int`: Z-axis specification data type
- `z_len_unit_exp::Int`: Z-axis length unit exponent
- `z_force_unit_exp::Int`: Z-axis force unit exponent
- `z_temp_unit_exp::Int`: Z-axis temperature unit exponent
- `z_axis_label::String`: Z-axis label
- `z_axis_unit_label::String`: Z-axis unit label
- `data::AbstractVector`: Data values
"""
@show_data struct Dataset58 <: UFFDataset
    # Fields specific to Dataset58
    type::Symbol    # Data set type
    id1::String     # Record 1 - field 1
    id2::String     # Record 2 - field 1
    id3::String     # Record 3 - field 1
    id4::String     # Record 4 - field 1
    id5::String     # Record 5 - field 1

    #Record 6 fields
    func_type::Int     # Record 6 - field 1
    func_id::Int       # Record 6 - field 2
    ver_num::Int       # Record 6 - field 3
    load_case::Int     # Record 6 - field 4
    resp_name::String  # Record 6 - field 5
    resp_node::Int     # Record 6 - field 6
    resp_dir::Int      # Record 6 - field 7
    ref_name::String   # Record 6 - field 8
    ref_node::Int      # Record 6 - field 9
    ref_dir::Int       # Record 6 - field 10

    # Record 7 fields
    ord_dtype::Int            # Record 7 - field 1
    num_pts::Int              # Record 7 - field 2
    abs_spacing_type::Int     # Record 7 - field 3
    abs_start ::Float64       # Record 7 - field 4
    abs_increment ::Float64   # Record 7 - field 5
    zval::Float64             # Record 7 - field 6

    # Record 8 fields
    abs_spec_dtype::Int          # Record 8 - field 1
    abs_len_unit_exp::Int        # Record 8 - field 2
    abs_force_unit_exp::Int      # Record 8 - field 3
    abs_temp_unit_exp::Int       # Record 8 - field 4
    abs_axis_label::String       # Record 8 - field 5
    abs_axis_unit_label::String  # Record 8 - field 6

    # Record 9 fields
    ord_spec_dtype::Int          # Record 9 - field 1
    ord_len_unit_exp::Int        # Record 9 - field 2
    ord_force_unit_exp::Int      # Record 9 - field 3
    ord_temp_unit_exp::Int       # Record 9 - field 4
    ord_axis_label::String       # Record 9 - field 5
    ord_axis_unit_label::String  # Record 9 - field 6

    # Record 10 fields
    ord_denom_spec_dtype::Int          # Record 10 - field 1
    ord_denom_len_unit_exp::Int        # Record 10 - field 2
    ord_denom_force_unit_exp::Int      # Record 10 - field 3
    ord_denom_temp_unit_exp::Int       # Record 10 - field 4
    ord_denom_axis_label::String       # Record 10 - field 5
    ord_denom_axis_unit_label::String  # Record 10 - field 6

    # Record 11 fields
    z_spec_dtype::Int          # Record 11 - field 1
    z_len_unit_exp::Int        # Record 11 - field 2
    z_force_unit_exp::Int      # Record 11 - field 3
    z_temp_unit_exp::Int       # Record 11 - field 4
    z_axis_label::String       # Record 11 - field 5
    z_axis_unit_label::String  # Record 11 - field 6

    # Record 12 fields
    data::AbstractVector

    Dataset58(
        id1 = "",
        id2 = "",
        id3 = "",
        id4 = "",
        id5 = "",
        func_type = 0,
        func_id = 0,
        ver_num = 0,
        load_case = 0,
        resp_name = "",
        resp_node = 0,
        resp_dir = 0,
        ref_name = "",
        ref_node = 0,
        ref_dir = 0,
        ord_dtype = 0,
        num_pts = 0,
        abs_spacing_type = 0,
        abs_start = 0.0,
        abs_increment = 0.0,
        zval = 0.0,
        abs_spec_dtype = 0,
        abs_len_unit_exp = 0,
        abs_force_unit_exp = 0,
        abs_temp_unit_exp = 0,
        abs_axis_label = "",
        abs_axis_unit_label = "",
        ord_spec_dtype = 0,
        ord_len_unit_exp = 0,
        ord_force_unit_exp = 0,
        ord_temp_unit_exp = 0,
        ord_axis_label = "",
        ord_axis_unit_label = "",
        ord_denom_spec_dtype = 0,
        ord_denom_len_unit_exp = 0,
        ord_denom_force_unit_exp = 0,
        ord_denom_temp_unit_exp = 0,
        ord_denom_axis_label = "",
        ord_denom_axis_unit_label = "",
        z_spec_dtype = 0,
        z_len_unit_exp = 0,
        z_force_unit_exp = 0,
        z_temp_unit_exp = 0,
        z_axis_label = "",
        z_axis_unit_label = "",
        data = [],
    ) = new(:Dataset58, id1, id2, id3, id4, id5, func_type, func_id, ver_num, load_case, resp_name, resp_node, resp_dir, ref_name, ref_node, ref_dir, ord_dtype, num_pts, abs_spacing_type, abs_start, abs_increment, zval, abs_spec_dtype, abs_len_unit_exp, abs_force_unit_exp, abs_temp_unit_exp, abs_axis_label, abs_axis_unit_label, ord_spec_dtype, ord_len_unit_exp, ord_force_unit_exp, ord_temp_unit_exp, ord_axis_label, ord_axis_unit_label, ord_denom_spec_dtype, ord_denom_len_unit_exp, ord_denom_force_unit_exp, ord_denom_temp_unit_exp, ord_denom_axis_label, ord_denom_axis_unit_label, z_spec_dtype, z_len_unit_exp, z_force_unit_exp, z_temp_unit_exp, z_axis_label, z_axis_unit_label, data)
end

"""
    Dataset82

A struct containing UFF Dataset 82 metadata.

**Fields**
- `type::Symbol`: Data set type
- `line_number::Int`: Trace line number
- `num_nodes::Int`: Number of nodes defining trace line
- `color::Int`: Color
- `id_line::String`: Identification line
- `line_nodes::Vector{Int}`: Nodes defining trace line
"""
@show_data struct Dataset82 <: UFFDataset
    # Fields specific to Dataset82
    type::Symbol                     # Data set type
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
    ) = new(:Dataset82, line_number, num_nodes, color, id_line, line_nodes)
end

"""
    Dataset151

A struct containing UFF Dataset 151 metadata.

**Fields**
- `type::Symbol`: Data set type
- `model_name::String`: model file name
- `description::String`: model file description
- `application::String`: Program which created the dataset
- `datetime_created::DateTime`: dataset creation date and time
- `version::String`: version from dataset
- `file_type::Int`: file type
- `datetime_last_saved::DateTime`: dataset last saved date and time
- `program::String`: program which created uff file
- `datetime_written::DateTime`: uff file written date and time
"""
@show_data struct Dataset151 <: UFFDataset
    # Fields specific to Dataset151
    type::Symbol                    # Data set type
    model_name::String              # Record 1 - field 1
    description::String             # Record 2 - field 1
    application::String             # Record 3 - field 1
    datetime_created::String        # Record 4 - fields 1 and 2
    version::String                 # Record 4 - fields 3 and 4
    file_type::Int                  # Record 4 - field 5
    datetime_last_saved::String     # Record 5 - fields 1 and 2
    program::String                 # Record 6 - field 1
    datetime_written::String        # Record 7 - fields 1 and 2

    Dataset151(
        model_name = "",
        description = "",
        application = "",
        datetime_created = "",
        version = "",
        file_type = 0,
        datetime_last_saved = "",
        program = "",
        datetime_written = ""
    ) = new(:Dataset151, model_name, description, application, datetime_created, version, file_type, datetime_last_saved, program, datetime_written)
end

"""
    Dataset164

A struct containing UFF Dataset 164 metadata.

**Fields**
- `type::Symbol`: Data set type
- `units::Int`: Units code
- `description::String`: Units description
- `temperature_mode::Int`: Temperature mode
- `conversion_factor::Vector{Float64}`: Units factors for converting to SI units
"""
@show_data struct Dataset164 <: UFFDataset
    # Fields specific to Dataset164
    type::Symbol                        # Data set type
    units::Int                          # Record 1 - field 1
    description::String                 # Record 1 - field 2
    temperature_mode::Int               # Record 1 - field 3
    conversion_factor::Vector{Float64}  # Record 2 - fields 1 to 4

    Dataset164(
        units = 1,
        description = "",
        temperature_mode = 0,
        conversion_factor = [1., 1., 1., 0.]
    ) = new(:Dataset164, units, description, temperature_mode, conversion_factor)
end

"""
    Dataset2411

A struct containing UFF Dataset 2411 metadata.

**Fields**
- `type::Symbol`: Data set type
- `nodes_ID::Vector{Int}`: Node IDs
- `coord_system::Vector{Int}`: Coordinate system IDs
- `disp_coord_system::Vector{Int}`: Displacement coordinate system IDs
- `color::Vector{Int}`: Color codes
- `node_coords::Matrix{Float64}`: Node coordinates
"""
@show_data struct Dataset2411 <: UFFDataset
    # Fields specific to Dataset2411
    type::Symbol                    # Data set type
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
        node_coords = Matrix{Float64}[]
    ) = new(:Dataset2411, nodes_ID, coord_system, disp_coord_system, color, node_coords)
end

"""
    Dataset2412

A struct containing UFF Dataset 2412 metadata.

**Fields**
- `type::Symbol`: Data set type
- `elements_ID::Vector{Int}`: Element label
- `fe_descriptor_id::Vector{Int}`: Finite element descriptor ID
- `phys_property::Vector{Int}`: Physical property table number
- `mat_property::Vector{Int}`: Material property table number
- `color::Vector{Int}`: Color
- `nodes_per_elt::Vector{Int}`: Number of nodes per element
- `connectivity::Vector{Vector{Int}}`: Element connectivity (node labels)
- `beam_info::Vector{Vector{Int}}`: Beam element information
"""
@show_data struct Dataset2412 <: UFFDataset
    # Fields specific to Dataset2412
    type::Symbol                        # Data set type
    elements_ID::Vector{Int}            # Record 1 - field 1
    fe_descriptor_id::Vector{Int}       # Record 1 - field 2
    phys_property::Vector{Int}          # Record 1 - field 3
    mat_property::Vector{Int}           # Record 1 - field 4
    color::Vector{Int}                  # Record 1 - field 5
    nodes_per_elt::Vector{Int}          # Record 1 - field 6
    connectivity::Vector{Vector{Int}}   # Record 2/3 - node labels
    beam_info::Vector{Vector{Int}}      # Record 2 - beam elements info

    Dataset2412(
        elements_ID = Int[],
        fe_descriptor_id = Int[],
        phys_property = Int[],
        mat_property = Int[],
        color = Int[],
        nodes_per_elt = Int[],
        connectivity = Vector{Vector{Int}}[],
        beam_info = Vector{Vector{Int}}[]
    ) = new(:Dataset2412, elements_ID, fe_descriptor_id, phys_property, mat_property, color, nodes_per_elt, connectivity, beam_info)
end

"""
    Dataset2414

A struct containing UFF Dataset 2414 metadata.

**Fields**
- `type::Symbol`: Data set type
- `analysis_dlabel::Int`: Analysyis data label
- `analysis_dname::String`: Analysis data name
- `dataset_location::Int`: Dataset location
- `id_line1::String`: ID line 1
- `id_line2::String`: ID line 2
- `id_line3::String`: ID line 3
- `id_line4::String`: ID line 4
- `id_line5::String`: ID line 5
- `model_type::Int`: Model type
- `analysis_type::Int`: Analysis type
- `data_characteristic::Int`: Data characteristic
- `result_type::Int`: Result type
- `dtype::Int`: Data type
- `num_data_values::Int`: Number of data values
- `int_analysis_type::NamedTuple`: Integer analysis type information
- `real_analysis_type::NamedTuple`: Real analysis type information
- `data_info::NamedTuple`: Data information
- `data_value::AbstractArray`: Data values
"""
@show_data struct Dataset2414 <: UFFDataset
    # Fields specific to Dataset2414
    type::Symbol             # Data set type
    analysis_dlabel::Int  # Record 1 - field 1
    analysis_dname::String   # Record 2 - field 1
    dataset_location::Int    # Record 3 - field 1

    id_line1::String  # Record 4 - field 1
    id_line2::String  # Record 5 - field 1
    id_line3::String  # Record 6 - field 1
    id_line4::String  # Record 7 - field 1
    id_line5::String  # Record 8 - field 1

    # Record 9 fields
    model_type::Int           # Record 9 - field 1
    analysis_type::Int        # Record 9 - field 2
    data_characteristic::Int  # Record 9 - field 3
    result_type::Int          # Record 9 - field 4
    dtype::Int                # Record 9 - field 5
    num_data_values::Int      # Record 9 - field 6

    int_analysis_type::NamedTuple   # Record 10-11 - field 1
    real_analysis_type::NamedTuple  # Record 12-13 - field 1

    data_info::NamedTuple  # Record 14 - fields depend on analysis type
    data_value::AbstractArray  # Record 15 - fields depend on analysis type

    function Dataset2414(
        analysis_dlabel = 0,
        analysis_dname = "",
        dataset_location = 1,
        id_line1 = "",
        id_line2 = "",
        id_line3 = "",
        id_line4 = "",
        id_line5 = "",
        model_type = 0,
        analysis_type = 0,
        data_characteristic = 0,
        result_type = 0,
        dtype = 0,
        num_data_values = 0,
        int_analysis_type_raw = Int[],
        real_analysis_type_raw = Float64[],
        data_info_raw = Vector{Int}[],
        data_value_raw = AbstractVector[]
    )
        if !isempty(int_analysis_type_raw)
            if analysis_type == 0 # Unknown
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 1 # Static
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    iteration_ID = int_analysis_type_raw[2],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    load_set = int_analysis_type_raw[5],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 2 # Normal Mode
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    iteration_ID = int_analysis_type_raw[2],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    mode_ID = int_analysis_type_raw[6],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 3 # Complex Eigenvalue first order
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    load_set = int_analysis_type_raw[5],
                    mode_ID = int_analysis_type_raw[6],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 4 # Transient
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    load_set = int_analysis_type_raw[5],
                    time_step_ID = int_analysis_type_raw[7],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 5 # Frequency Response
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    load_set = int_analysis_type_raw[5],
                    freq_step_ID = int_analysis_type_raw[8],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 6 # Buckling
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    load_set = int_analysis_type_raw[5],
                    mode_ID = int_analysis_type_raw[6],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 7 # Complex Eigenvalue second order
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    load_set = int_analysis_type_raw[5],
                    mode_ID = int_analysis_type_raw[6],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )

            elseif analysis_type == 8 # Static non-linear
                int_analysis_type = (
                    design_set_ID = int_analysis_type_raw[1],
                    solution_set_ID = int_analysis_type_raw[3],
                    bc = int_analysis_type_raw[4],
                    time_step_ID = int_analysis_type_raw[7],
                    creation_option = int_analysis_type_raw[9],
                    number_retained = int_analysis_type_raw[10]
                )
            end
        end

        if !isempty(real_analysis_type_raw)
            if analysis_type == 0 # Unknown
                real_analysis_type = ()

            elseif analysis_type == 1 # Static
                real_analysis_type = ()

            elseif analysis_type == 2 # Normal Mode
                real_analysis_type = (
                    frequency = real_analysis_type_raw[2],
                    modal_mass = real_analysis_type_raw[4],
                    modal_visc_dr = real_analysis_type_raw[5],
                    modal_hyst_dr = real_analysis_type_raw[6]
                )

            elseif analysis_type == 3 # Complex Eigenvalue first order
                real_analysis_type = (
                    real_eigenvalue = real_analysis_type_raw[7],
                    imag_eigenvalue = real_analysis_type_raw[8],
                    real_modalA = real_analysis_type_raw[9],
                    imag_modalA = real_analysis_type_raw[10],
                    real_modalB = real_analysis_type_raw[11],
                    imag_modalB = real_analysis_type_raw[12]
                )

            elseif analysis_type == 4 # Transient
                real_analysis_type = (
                    time = real_analysis_type_raw[1]
                )

            elseif analysis_type == 5 # Frequency Response
                real_analysis_type = (
                    frequency = real_analysis_type_raw[2]
                )

            elseif analysis_type == 6 # Buckling
                real_analysis_type = (
                    eigenvalue = real_analysis_type_raw[3]
                )

            elseif analysis_type == 7 # Complex Eigenvalue second order
                real_analysis_type = (
                    real_eigenvalue = real_analysis_type_raw[7],
                    imag_eigenvalue = real_analysis_type_raw[8],
                    real_modalA = real_analysis_type_raw[9],
                    imag_modalA = real_analysis_type_raw[10],
                    real_modalB = real_analysis_type_raw[11],
                    imag_modalB = real_analysis_type_raw[12]
                )

            elseif analysis_type == 8 # Static non-linear
                real_analysis_type = (
                    time = real_analysis_type_raw[1]
                )
            end
        end

        # Parse r14 and r15 based on data_location
        if !isempty(data_info_raw) && !isempty(data_value_raw)
            if dataset_location ==  1 # Nodes
                data_info = (node_ID = reduce(vcat, data_info_raw),)
                data_value = copy(transpose(reduce(hcat, data_value_raw)))

            elseif dataset_location == 2 # Elements
                elt_info = reduce(hcat, data_info_raw)
                data_info = (
                    elt_ID = elt_info[1, :],
                    ndv_per_elt = elt_info[2, :]
                )

                data_value = data_value_raw

            elseif dataset_location == 3 # Nodes on elements
                elt_info = reduce(hcat, data_info_raw)
                data_info = (
                    elt_ID = elt_info[1, :],
                    data_exp_code = elt_info[2, :],
                    nnodes_per_elt = elt_info[3, :],
                    ndv_per_node = elt_info[4, :],
                )

                data_type = eltype(eltype(data_value_raw))
                data_value = Matrix{data_type}[]
                for (i, dv) in enumerate(data_value_raw)
                    nnodes = data_info.nnodes_per_elt[i]
                    ndv = data_info.ndv_per_node[i]
                    push!(data_value, copy(transpose(reshape(dv, ndv, nnodes))))
                end

            elseif dataset_location == 5 # Points
                point_info = reduce(hcat, data_info_raw)
                data_info = (
                    elt_ID = point_info[1, :],
                    data_exp_code = point_info[2, :],
                    npts_per_elt = point_info[3, :],
                    ndv_per_point = point_info[4, :],
                    elt_order = point_info[5, :]
                )

                data_type = eltype(eltype(data_value_raw))
                data_value = Matrix{data_type}[]
                for (i, dv) in enumerate(data_value_raw)
                    npts = data_info.npts_per_elt[i]
                    ndv = data_info.ndv_per_point[i]
                    push!(data_value, copy(reshape(dv, ndv, npts)))
                end
            end
        end

        return new(:Dataset2414, analysis_dlabel, analysis_dname, dataset_location, id_line1, id_line2, id_line3, id_line4, id_line5, model_type, analysis_type, data_characteristic, result_type, dtype, num_data_values, int_analysis_type, real_analysis_type, data_info, data_value)
    end
end