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
   # this function should be able to read the abscissa for uneven datasets if they are Float32 or Float64.
    reset(io)
    func = readline(io)
    n, _, type, endian, floating_point_format, num_ascii_lines, binary_bytes, _... = @scanf(func, "%6i%c%6i%6i%12i%12i%6i%6i%12i%12i",
        Int, Char, Int, Int, Int, Int, Int, Int, Int, Int)

    # Need to implement proper error handling
    type == 'b' || error("Expected UFF58 binary file but type is $type")
    endian == 1 || println("Only implemented for Little Endian")
    floating_point_format == 2 || println("Only implemented for IEEE 754")
    num_ascii_lines == 11 || println("Header not correct")

    id1 = strip(readline(io))
    id2 = strip(readline(io))
    id3 = strip(readline(io))
    id4 = strip(readline(io))
    id5 = strip(readline(io))

    # Record 6
    r6 = readline(io)
    n, func_type, func_id, version_num, load_case_id, _,
        response_entity, response_node, response_direction, _,
        reference_entity, reference_node,  reference_direction=
        @scanf(r6, "%5i%10i%5i%10i%c%10c%10i%4i%c%10c%10i%4i", Int, Int, Int, Int, Char, String, Int, Int, Char, String, Int, Int)

    # Record 7
    r7 = (readline(io))
    n, ord_dtype, num_pts, abs_spacing_type, abs_min, abs_increment, zval = @scanf(r7, "%10i%10i%10i%13e%13e%13e", Int, Int, Int, Float64, Float64, Float64)

    # Record 8
    r8 = (readline(io))
    n, abs_spec_dtype, abs_len_unit_exp, abs_force_unit_exp, abs_temp_unit_exp, _, abs_axis_label, _, abs_axis_unit_label =
        @scanf(r8, "%10i%5i%5i%5i%c%20c%c%20c", Int, Int, Int, Int, Char, String, Char, String)

    # Record 9
    r9 = (readline(io))
    n, ord_spec_dtype, ord_len_unit_exp, ord_force_unit_exp, ord_temp_unit_exp, _, ord_axis_label, _, ord_axis_unit_label =
        @scanf(r9, "%10i%5i%5i%5i%c%20c%c%20c", Int, Int, Int, Int, Char, String, Char, String)

    # Record 10
    r10 = (readline(io))
    n, ord_denom_spec_dtype, ord_denom_len_unit_exp, ord_denom_force_unit_exp, ord_denom_temp_unit_exp, _, ord_denom_axis_label, _, ord_denom_axis_unit_label =
        @scanf(r10, "%10i%5i%5i%5i%c%20c%c%20c", Int, Int, Int, Int, Char, String, Char, String)

    # Record 11
    r11 = (readline(io))
    n, z_spec_dtype, z_len_unit_exp, z_force_unit_exp, z_temp_unit_exp, _, z_axis_label, _, z_axis_unit_label =
        @scanf(r11, "%10i%5i%5i%5i%c%20c%c%20c", Int, Int, Int, Int, Char, String, Char, String)

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

function write_dataset58b_data(io, dataset)    
    # Record 12: Data Values
    # Format depends on ordinate data type and precision

    if (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 1) # Case 1 - Real, Single Precision, Even Spacing
        write(io, Float32.(dataset.data))
    elseif (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 0) # Case 2 - Real, Single Precision, Uneven Spacing
        tmp = Float32.(reshape(reduce(vcat, [dataset.abscissa', dataset.data']), :, 1))
        write(io, tmp)
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 1)  # Case 3 - Complex, Single Precision, Even Spacing
        tmp = Float32.(reshape(reduce(vcat, [real(dataset.data)', imag(dataset.data)']), :, 1))
        write(io, tmp)
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 0)  # Case 4 - Complex, Single Precision, Uneven Spacing
        tmp = Float32.(reshape(reduce(vcat, [dataset.abscissa', real(dataset.data)', imag(dataset.data)']), :, 1))
        write(io, tmp)
    elseif (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 1) # Case 5 - Real, Double Precision, Even Spacing
        write(io, Float64.(dataset.data))
    elseif (dataset.ord_dtype == 2 && dataset.abs_spacing_type == 0) # Case 6 - Real, Double Precision, Uneven Spacing
        # Both abscissa and ordinate are Float64
        tmp = Float64.(reshape(reduce(vcat, [dataset.abscissa', dataset.data']), :, 1))
        write(io, tmp)
    elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 1)  # Case 7 - Complex, Double Precision, Even Spacing
        tmp = Float64.(reshape(reduce(vcat, [real(dataset.data)', imag(dataset.data)']), :, 1))
        write(io, tmp)
     elseif (dataset.ord_dtype == 5 && dataset.abs_spacing_type == 0)  # Case 8 - Complex, Double Precision, Uneven Spacing
        # Both abscissa and ordinate are Float64
        tmp = Float64.(reshape(reduce(vcat, [dataset.abscissa', real(dataset.data)', imag(dataset.data)']), :, 1))
        write(io, tmp)
    end

    return nothing
end