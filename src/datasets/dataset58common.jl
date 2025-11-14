"""
    Dataset58

A struct containing UFF Dataset 58 (Function at nodal dof) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
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
- `abscissa` - Data Values (empty if evenly spaced otherwise filled in)
- `data::AbstractVector`: Data values
"""
@show_data struct Dataset58 <: UFFDataset
    # Fields specific to Dataset58
    type::Symbol    # Data set type
    name::String    # Data set name
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
    abs_min ::Float64       # Record 7 - field 4
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
    abscissa::AbstractVector    # Record 12 if unevely spaced
    data::AbstractVector        # Record 12

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
        abs_min = 0.0,
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
        abscissa = [],
        data = []
    ) = new(:Dataset58, "Function at nodal dof", id1, id2, id3, id4, id5, func_type, func_id, ver_num, load_case, resp_name, resp_node, resp_dir, ref_name, ref_node, ref_dir, ord_dtype, num_pts, abs_spacing_type, abs_min, abs_increment, zval, abs_spec_dtype, abs_len_unit_exp, abs_force_unit_exp, abs_temp_unit_exp, abs_axis_label, abs_axis_unit_label, ord_spec_dtype, ord_len_unit_exp, ord_force_unit_exp, ord_temp_unit_exp, ord_axis_label, ord_axis_unit_label, ord_denom_spec_dtype, ord_denom_len_unit_exp, ord_denom_force_unit_exp, ord_denom_temp_unit_exp, ord_denom_axis_label, ord_denom_axis_unit_label, z_spec_dtype, z_len_unit_exp, z_force_unit_exp, z_temp_unit_exp, z_axis_label, z_axis_unit_label, abscissa, data)
end