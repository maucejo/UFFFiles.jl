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


"""
    write_dataset(dataset::Dataset58) -> Vector{String}

Write a UFF Dataset 58 (Function Data) to a vector of strings.

**Input**
- `dataset::Dataset58`: The Dataset58 instance to write.

**Output**
- `Vector{String}`: A vector of strings representing the lines of the dataset.
"""
function write_dataset(io, dataset::Dataset58)
    # the abcissa for uneven double precision ASCII datasets are Float32. 
    # the abscissa for uneven double precision binary datasets are Float64
    # Start marker
    println(io, "    -1")

    n = length(dataset.data)
    binary_bytes =
    if (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 1)      # Case 1 - Real, Single Precision, Even Spacing
        n*4
    elseif (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 0)  # Case 2 - Real, Single Precision, Uneven Spacing
        2n*4
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 1)  # Case 3 - Complex, Single Precision, Even Spacing
        2n*4
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 0)  # Case 4 - Complex, Single Precision, Uneven Spacing
        3n*4
    elseif (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 1)  # Case 5 - Real, Double Precision, Even Spacing
        n*8
    elseif (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 0)  # Case 6 - Real, Double Precision, Uneven Spacing
        2n*8  # both abscissa and ordinate written in Float64
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 1)  # Case 7 - Complex, Double Precision, Even Spacing
        2n*8
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 0)  # Case 8 - Complex, Double Precision, Uneven Spacing
        3n*8  # both abscissa and ordinate written in Float64
    end

    # Dataset number
    ds = if binary_write
            @sprintf("%6i%c%6i%6i%12i%12i%6i%6i%12i%12i",
                58,             # 58
                'b',            # lowercase b
                1,              # little endian
                2,              # IEEE 754
                11,             # number of ASCII lines following
                binary_bytes,   # number of bytes following ASCII lines
                0, 0, 0, 0
            )
            else
                "    58"
            end
    println(io, ds)

    # Records 1-5: ID Lines (80A1 format)
    println(io, dataset.id1)
    println(io, dataset.id2)
    println(io, dataset.id3)
    println(io, dataset.id4)
    println(io, dataset.id5)

    # Record 6: DOF Identification
    # Format: 2(I5,I10),2(1X,10A1,I10,I4)
    r6_line = @sprintf("%5d%10d%5d%10d %-10s%10d%4d %-10s%10d%4d",
        dataset.func_type,
        dataset.func_id,
        dataset.ver_num,
        dataset.load_case,
        dataset.resp_name,
        dataset.resp_node,
        dataset.resp_dir,
        dataset.ref_name,
        dataset.ref_node,
        dataset.ref_dir)
    println(io, r6_line)

    # Record 7: Data Form
    # Format: 3I10,3E13.5
    r7_line = @sprintf("%10d%10d%10d%13.5E%13.5E%13.5E",
        dataset.ord_dtype,
        dataset.num_pts,
        dataset.abs_spacing_type,
        dataset.abs_min,
        dataset.abs_increment,
        dataset.zval)
    println(io, r7_line)

    # Record 8: Abscissa Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r8_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.abs_spec_dtype,
        dataset.abs_len_unit_exp,
        dataset.abs_force_unit_exp,
        dataset.abs_temp_unit_exp,
        dataset.abs_axis_label,
        dataset.abs_axis_unit_label)
    println(io, r8_line)

    # Record 9: Ordinate Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r9_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.ord_spec_dtype,
        dataset.ord_len_unit_exp,
        dataset.ord_force_unit_exp,
        dataset.ord_temp_unit_exp,
        dataset.ord_axis_label,
        dataset.ord_axis_unit_label)
    println(io, r9_line)

    # Record 10: Ordinate Denominator Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r10_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.ord_denom_spec_dtype,
        dataset.ord_denom_len_unit_exp,
        dataset.ord_denom_force_unit_exp,
        dataset.ord_denom_temp_unit_exp,
        dataset.ord_denom_axis_label,
        dataset.ord_denom_axis_unit_label)
    println(io, r10_line)

    # Record 11: Z-axis Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r11_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.z_spec_dtype,
        dataset.z_len_unit_exp,
        dataset.z_force_unit_exp,
        dataset.z_temp_unit_exp,
        dataset.z_axis_label,
        dataset.z_axis_unit_label)
    println(io, r11_line)

    # Record 12: Data Values
    # Call binary or ASCII routine
    if binary_write
        write_dataset58b_data(io, dataset)
    else
        write_dataset58_data(io, dataset)
    end

    # End marker
    println(io, "    -1")

    return nothing
end