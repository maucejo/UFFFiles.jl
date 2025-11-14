"""
The Binary 58 Universal File Format (UFF):

The basic (ASCII) universal file format for data is universal file format
58.  This format is completely documented by SDRC and a copy of that
documentation is on the UC-SDRL web site (58.asc). The
universal file format always begins with two records that are prior to the
information defined by each universal file format and ends with a record
that is placed after the information defined by the format.   First of
all, all records are 80 character ASCII records for the basic universal
file format. The first and last record are start/stop records and are
always -1 in the first six columns, right justified (Fortran I6 field
with -1 in the field).  The second record (Identifier Record) always
contains the universal file format number in the first 6 columns, right
justified.

This gives a file structure as follows (where b represent a blank
character):

bbbb-1
bbbb58
...
...
...
bbbb-1

The Binary 58 universal file format was originally developed by UC-SDRL 
in order to eliminate the need to compress the UFF 58 records and to reduce
the time required to load the UFF 58 data records.  The Binary 58 universal file
format yields files that are comparable to compressed files (approximately 3 to
4 times smaller than the equivalent UFF 58 file).  The Binary 58 universal file 
format loads approximately 30 to 40 times faster than the equivalent UFF 58 
file, depending upon the computing environment.  This new format was 
submitted to SDRC and subsequently adopted as a supported format.

The Binary 58 universal file format uses the same ASCII records at the
start of each data file as the ASCII dataset 58 but, beginning with
record 12, the data is stored in binary form rather than the specified
ASCII format.  The identifier record has the same 58 identifier in the
first six columns, right justified, but has additional information in
the rest of the 80 character record that identifies the binary format
(the size of the binary record, the format of the binary structure, etc.).

    -1
    58b     x     y          11        zzzz     0     0           0           0
...
... (11 ASCII header lines)
...
...
... (zzzz BINARY bytes of data, in format specifed by x and y, above)
... (interleaved as specified by the ASCII dataset 58)
...
    -1


When reading or writing a dataset 58b, care must be taken that the
binary data immediately follows the ASCII header lines and the closing
'    -1' immediately follows the binary data.  The binary data content
is written in the same sequence as the ASCII dataset 58 (ie. field
order sequence).  The field size is NOT used, however the data type
(int/float/double) content is.  Note: there are no CR/LF characters
embedded in or following the binary data.


=====================================================================
The Format of 58b ID-Line:
----------------------------

For the traditional dataset 58 (Function at Nodal DOF), the dataset
id-line is composed of four spaces followed by "58". This line has been
enhanced to contain additional information for the binary version of
dataset 58.

    -1
    58b     2     2          11        4096     0     0           0           0

     Format (I6,1A1,I6,I6,I12,I12,I6,I6,I12,I12)

              Field 1       - 58  [I6]
              Field 2       - lowercase b [1A1]
              Field 3       - Byte Ordering Method [I6]
                              1 - Little Endian (DEC VMS & ULTRIX, WIN NT)
                              2 - Big Endian (most UNIX)
              Field 4       - Floating Point Format [I6]
                              1 - DEC VMS
                              2 - IEEE 754 (UNIX)
                              3 - IBM 5/370
              Field 5       - number of ASCII lines following  [I12]
                              11 - for dataset 58
              Field 6       - number of bytes following ASCII lines  [I12]
              Fields 7-10   - Not used (fill with zeros)


The format of this line should remain constant for any other dataset
that takes on a binary format in the future.
"""
function parse_dataset58b(io)
   
    reset(io)
    func = readline(io)
    
    # Need to implement proper error handling
    endian = parse(Int, func[8:13])  # Julia only runs on little endian (as far as I am aware) [I6]
    endian == 1 || println("Only implemented for Little Endian")
    floating_point_format = parse(Int, func[14:19]) # Floating Point Format [I6]
    floating_point_format == 1 || println("Only implemented for IEEE 754")
    num_ascii_lines = parse(Int, func[20:31])   # number of ASCII lines following  [I12]
    num_ascii_lines == 1 || println("Header not correct")
    binary_bytes = parse(Int, func[32:43])         # number of bytes following ASCII lines  [I12]

    id1 = strip(readline(io))
    id2 = strip(readline(io))
    id3 = strip(readline(io))
    id4 = strip(readline(io))
    id5 = strip(readline(io))

    # Record 6
    r6 = readline(io)
    len_r6 = length(r6)
    #=r6 = split(readline(io))

    func_type = parse(Int, strip(r6[1]))
    func_id = parse(Int, strip(r6[2]))
    version_num = parse(Int, strip(r6[3]))
    load_case_id = parse(Int, strip(r6[4]))
    response_entity = strip(r6[5])
    response_node = parse(Int, strip(r6[6]))
    response_direction = parse(Int, strip(r6[7]))
    reference_entity = strip(r6[8])=#
    # This modified for the space in Sample_UFF58b_bin.uff record 6 field 5
    func_type = parse(Int, r6[1:5])
    func_id = parse(Int, r6[6:15])
    version_num = parse(Int, r6[16:20])
    load_case_id = parse(Int, r6[21:30])
    response_entity = r6[32:41]
    # @show(r6[32:41])
    response_node = parse(Int, r6[42:51])
    response_direction = parse(Int, r6[52:55])
    reference_entity = r6[57:66]

    if len_r6 > 8
        reference_node = parse(Int, r6[67:76])
        reference_direction = parse(Int, r6[77:80])
    else
        reference_node = 0
        reference_direction = 0
    end

    # Record 7
    r7 = split(readline(io))
    ord_dtype, num_pts, abs_spacing_type = parse.(Int, strip.(r7[1:3]))
    abs_min, abs_increment, zval = parse.(Float64, strip.(r7[4:6]))

    # Record 8
    r8 = split(readline(io))
    abs_spec_dtype, abs_len_unit_exp, abs_force_unit_exp, abs_temp_unit_exp = parse.(Int, strip.(r8[1:4]))
    abs_axis_label, abs_axis_unit_label = strip.(r8[5:6])

    # Record 9
    r9 = split(readline(io))
    ord_spec_dtype, ord_len_unit_exp, ord_force_unit_exp, ord_temp_unit_exp = parse.(Int, strip.(r9[1:4]))
    ord_axis_label, ord_axis_unit_label = strip.(r9[5:6])

    # Record 10
    r10 = split(readline(io))
    ord_denom_spec_dtype, ord_denom_len_unit_exp, ord_denom_force_unit_exp, ord_denom_temp_unit_exp = parse.(Int, strip.(r10[1:4]))
    ord_denom_axis_label, ord_denom_axis_unit_label = strip.(r10[5:6])

    # Record 11
    r11 = split(readline(io))
    z_spec_dtype, z_len_unit_exp, z_force_unit_exp, z_temp_unit_exp = parse.(Int, strip.(r11[1:4]))
    z_axis_label, z_axis_unit_label = strip.(r11[5:6])

    # Record 12
    _data = read(io, binary_bytes)
    
    # Convert UInt8 to Values
    if (ord_dtype == 2 && abs_spacing_type == 1) # Case 1 - Real, Single Precision, Even Spacing
      abscissa = Float32[]  
      data = reinterpret(Float32, _data)
    elseif (ord_dtype == 2 && abs_spacing_type == 0) # Case 2 - Real, Single Precision, Uneven Spacing
      tmp = reshape(reinterpret(Float32, _data), (2, :))'
      abscissa = tmp[:, 1]
      data = tmp[:, 2]
    elseif (ord_dtype == 5 && abs_spacing_type == 1)  # Case 3 - Complex, Single Precision, Even Spacing
      abscissa = Float32[]  
      data = reinterpret(ComplexF32, _data)
    elseif (ord_dtype == 5 && abs_spacing_type == 0)  # Case 4 - Complex, Single Precision, Uneven Spacing
      tmp = reshape(reinterpret(Float32, _data), (3, :))'
      abscissa = tmp[:, 1]
      data = reinterpret(ComplexF32, reshape(tmp[:, 2:3]', (:, 1)))
    elseif (ord_dtype == 2 && abs_spacing_type == 1) # Case 5 - Real, Double Precision, Even Spacing
      abscissa = Float64[]  
      data = reinterpret(Float64, _data)
    elseif (ord_dtype == 2 && abs_spacing_type == 0) # Case 6 - Real, Double Precision, Uneven Spacing
      2*8*num_pts == binary_bytes || println("Data Integrity Problem")
      tmp = reshape(reinterpret(Float64, _data), (2, :))'
      abscissa = tmp[:, 1]
      data = tmp[:, 2]
    elseif (ord_dtype == 5 && abs_spacing_type == 1)  # Case 7 - Complex, Double Precision, Even Spacing
      abscissa = Float64[] 
      data = reinterpret(ComplexF64, _data)
    elseif (ord_dtype == 5 && abs_spacing_type == 0)  # Case 8 - Complex, Double Precision, Uneven Spacing
      # There is some ambiguity as to whether the abscissa is Float32 or Float64.  This handles both
      if 3*8*num_pts == binary_bytes
        tmp = reshape(reinterpret(Float64, _data), (3, :))'
        abscissa = tmp[:, 1]
        data = reinterpret(ComplexF64, reshape(tmp[:, 2:3]', (:, 1)))
      elseif (4+16)*num_pts == binary_bytes
        abscissa = reinterpret(Float32, Float_data[1:20:binary_bytes])
        data = reinterpret(Float64, _data[5:20:binary_bytes])
      else 
        println("Data Integrity Problem")
      end
    end
    
    readline(io) # remove trailing "    -1" from dataset

    return Dataset58(
        id1,
        id2,
        id3,
        id4,
        id5,
        func_type,
        func_id,
        version_num,
        load_case_id,
        response_entity,
        response_node,
        response_direction,
        reference_entity,
        reference_node,
        reference_direction,
        ord_dtype,
        num_pts,
        abs_spacing_type,
        abs_min,
        abs_increment,
        zval,
        abs_spec_dtype,
        abs_len_unit_exp,
        abs_force_unit_exp,
        abs_temp_unit_exp,
        abs_axis_label,
        abs_axis_unit_label,
        ord_spec_dtype,
        ord_len_unit_exp,
        ord_force_unit_exp,
        ord_temp_unit_exp,
        ord_axis_label,
        ord_axis_unit_label,
        ord_denom_spec_dtype,
        ord_denom_len_unit_exp,
        ord_denom_force_unit_exp,
        ord_denom_temp_unit_exp,
        ord_denom_axis_label,
        ord_denom_axis_unit_label,
        z_spec_dtype,
        z_len_unit_exp,
        z_force_unit_exp,
        z_temp_unit_exp,
        z_axis_label,
        z_axis_unit_label,
        abscissa,
        data
    )
end

function write_dataset58(dataset::Dataset58)
    lines = String[]

    # Start marker
    push!(lines, "    -1")

    # Dataset number
    push!(lines, "    58")

    # Records 1-5: ID Lines (80A1 format)
    push!(lines, dataset.id1)
    push!(lines, dataset.id2)
    push!(lines, dataset.id3)
    push!(lines, dataset.id4)
    push!(lines, dataset.id5)

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
    push!(lines, r6_line)

    # Record 7: Data Form
    # Format: 3I10,3E13.5
    r7_line = @sprintf("%10d%10d%10d%13.5E%13.5E%13.5E",
        dataset.ord_dtype,
        dataset.num_pts,
        dataset.abs_spacing_type,
        dataset.abs_min,
        dataset.abs_increment,
        dataset.zval)
    push!(lines, r7_line)

    # Record 8: Abscissa Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r8_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.abs_spec_dtype,
        dataset.abs_len_unit_exp,
        dataset.abs_force_unit_exp,
        dataset.abs_temp_unit_exp,
        dataset.abs_axis_label,
        dataset.abs_axis_unit_label)
    push!(lines, r8_line)

    # Record 9: Ordinate Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r9_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.ord_spec_dtype,
        dataset.ord_len_unit_exp,
        dataset.ord_force_unit_exp,
        dataset.ord_temp_unit_exp,
        dataset.ord_axis_label,
        dataset.ord_axis_unit_label)
    push!(lines, r9_line)

    # Record 10: Ordinate Denominator Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r10_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.ord_denom_spec_dtype,
        dataset.ord_denom_len_unit_exp,
        dataset.ord_denom_force_unit_exp,
        dataset.ord_denom_temp_unit_exp,
        dataset.ord_denom_axis_label,
        dataset.ord_denom_axis_unit_label)
    push!(lines, r10_line)

    # Record 11: Z-axis Data Characteristics
    # Format: I10,3I5,2(1X,20A1)
    r11_line = @sprintf("%10d%5d%5d%5d %-20s %-20s",
        dataset.z_spec_dtype,
        dataset.z_len_unit_exp,
        dataset.z_force_unit_exp,
        dataset.z_temp_unit_exp,
        dataset.z_axis_label,
        dataset.z_axis_unit_label)
    push!(lines, r11_line)

    # Record 12: Data Values
    # Format depends on ordinate data type and precision
    if dataset.ord_dtype == 2 || dataset.ord_dtype == 4
        # Real data (single or double precision)
        if dataset.ord_dtype == 2
            # Real single precision: 6E13.5
            values_per_line = 6
            fmt = "E13.5"
        else
            # Real double precision: 4E20.12
            values_per_line = 4
            fmt = "E20.12"
        end

        # Write data in chunks
        for i in 1:values_per_line:length(dataset.data)
            end_idx = min(i + values_per_line - 1, length(dataset.data))
            chunk = dataset.data[i:end_idx]

            if dataset.ord_dtype == 2
                line = join([@sprintf(" %12.5E", v) for v in chunk], "")
            else
                line = join([@sprintf(" %19.12E", v) for v in chunk], "")
            end
            push!(lines, line)
        end

    elseif dataset.ord_dtype == 5 || dataset.ord_dtype == 6
        # Complex data (single or double precision)
        if dataset.ord_dtype == 5
            # Complex single precision: 6E13.5 (3 complex values per line)
            values_per_line = 3
        else
            # Complex double precision: 4E20.12 (2 complex values per line)
            values_per_line = 2
        end

        # Write data in chunks (real and imaginary parts interleaved)
        for i in 1:values_per_line:length(dataset.data)
            end_idx = min(i + values_per_line - 1, length(dataset.data))
            chunk = dataset.data[i:end_idx]

            if dataset.ord_dtype == 5
                # 6E13.5 format
                parts = Float64[]
                for c in chunk
                    push!(parts, real(c))
                    push!(parts, imag(c))
                end
                line = join([@sprintf(" %12.5E", v) for v in parts], "")
            else
                # 4E20.12 format
                parts = Float64[]
                for c in chunk
                    push!(parts, real(c))
                    push!(parts, imag(c))
                end
                line = join([@sprintf(" %19.12E", v) for v in parts], "")
            end
            push!(lines, line)
        end
    end

    # End marker
    push!(lines, "    -1")

    return lines
end