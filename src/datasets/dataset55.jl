"""
    Dataset55

A struct containing UFF Dataset 55 (Data at nodes) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
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
    name::String       # Data set name

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

        return new(:Dataset55, "Data at nodes", id1, id2, id3, id4, id5, model_type, analysis_type, data_charac, spec_dtype, dtype, ndv_per_node, r7, r8, node_number, data)
    end
end

"""
Universal Dataset Number: 55

**Name:   Data at Nodes**

          RECORD 1:      Format (40A2)
               FIELD 1:          ID Line 1

          RECORD 2:      Format (40A2)
               FIELD 1:          ID Line 2

          RECORD 3:      Format (40A2)

               FIELD 1:          ID Line 3

          RECORD 4:      Format (40A2)
               FIELD 1:          ID Line 4

          RECORD 5:      Format (40A2)
               FIELD 1:          ID Line 5

          RECORD 6:      Format (6I10)

          Data Definition Parameters

               FIELD 1: Model Type
                           0:   Unknown
                           1:   Structural
                           2:   Heat Transfer
                           3:   Fluid Flow

               FIELD 2:  Analysis Type
                           0:   Unknown
                           1:   Static
                           2:   Normal Mode
                           3:   Complex eigenvalue first order
                           4:   Transient
                           5:   Frequency Response
                           6:   Buckling
                           7:   Complex eigenvalue second order

               FIELD 3:  Data Characteristic
                           0:   Unknown
                           1:   Scalar
                           2:   3 DOF Global Translation
                                Vector
                           3:   6 DOF Global Translation
                                & Rotation Vector
                           4:   Symmetric Global Tensor
                           5:   General Global Tensor

               FIELD 4: Specific Data Type
                           0:   Unknown
                           1:   General
                           2:   Stress
                           3:   Strain
                           4:   Element Force
                           5:   Temperature
                           6:   Heat Flux
                           7:   Strain Energy
                           8:   Displacement
                           9:   Reaction Force
                           10:   Kinetic Energy
                           11:   Velocity
                           12:   Acceleration
                           13:   Strain Energy Density
                           14:   Kinetic Energy Density
                           15:   Hydro-Static Pressure
                           16:   Heat Gradient
                           17:   Code Checking Value
                           18:   Coefficient Of Pressure

               FIELD 5:  Data Type
                           2:   Real
                           5:   Complex

               FIELD 6:  Number Of Data Values Per Node (NDV)

          Records 7 And 8 Are Analysis Type Specific

          General Form

          RECORD 7:      Format (8I10)
               FIELD 1:          Number Of Integer Data Values
                           1 < Or = Nint < Or = 10
               FIELD 2:          Number Of Real Data Values
                           1 < Or = Nrval < Or = 12
               FIELDS 3-N:       Type Specific Integer Parameters

          RECORD 8:      Format (6E13.5)
               FIELDS 1-N:       Type Specific Real Parameters

          For Analysis Type = 0, Unknown

          RECORD 7:
               FIELD 1:   1
               FIELD 2:   1
               FIELD 3:   ID Number

          RECORD 8:

               FIELD 1:   0.0

          For Analysis Type = 1, Static

          RECORD 7:
               FIELD 1:    1
               FIELD 2:    1
               FIELD 3:    Load Case Number

          RECORD 8:
               FIELD 11:    0.0

          For Analysis Type = 2, Normal Mode

          RECORD 7:
               FIELD 1:    2
               FIELD 2:    4
               FIELD 3:    Load Case Number
               FIELD 4:    Mode Number

          RECORD 8:
               FIELD 1:    Frequency (Hertz)
               FIELD 2:    Modal Mass
               FIELD 3:    Modal Viscous Damping Ratio
               FIELD 4:    Modal Hysteretic Damping Ratio

          For Analysis Type = 3, Complex Eigenvalue

          RECORD 7:
               FIELD 1:    2
               FIELD 2:    6
               FIELD 3:    Load Case Number
               FIELD 4:    Mode Number

          RECORD 8:
               FIELD 1:    Real Part Eigenvalue
               FIELD 2:    Imaginary Part Eigenvalue
               FIELD 3:    Real Part Of Modal A
               FIELD 4:    Imaginary Part Of Modal A
               FIELD 5:    Real Part Of Modal B
               FIELD 6:    Imaginary Part Of Modal B

          For Analysis Type = 4, Transient

          RECORD 7:
               FIELD 1:    2
               FIELD 2:    1
               FIELD 3:    Load Case Number
               FIELD 4:    Time Step Number

          RECORD 8:
               FIELD 1: Time (Seconds)

          For Analysis Type = 5, Frequency Response

          RECORD 7:
               FIELD 1:    2
               FIELD 2:    1
               FIELD 3:    Load Case Number
               FIELD 4:    Frequency Step Number

          RECORD 8:
               FIELD 1:    Frequency (Hertz)

          For Analysis Type = 6, Buckling

          RECORD 7:
               FIELD 1:    1
               FIELD 2:    1
               FIELD 3:    Load Case Number

          RECORD 8:
               FIELD 1: Eigenvalue

          RECORD 9:      Format (I10)
               FIELD 1:          Node Number

          RECORD 10:     Format (6E13.5)
               FIELDS 1-N:       Data At This Node (NDV Real Or
                         Complex Values)

          Records 9 And 10 Are Repeated For Each Node.

          Notes:
          1        Id Lines May Not Be Blank.  If No Information Is
                      Required, The Word "None" Must Appear  Columns 1-4.

          2        For Complex Data There Will Be 2*Ndv Data Items At Each
                      Node. The Order Is Real Part For Value 1,  Imaginary
                      Part For Value 1, Etc.
          3        The Order Of Values For Various Data  Characteristics
                      Is:
                          3 DOF Global Vector:
                                  X, Y, Z

                          6 DOF Global Vector:
                                  X, Y, Z,
                                  Rx, Ry, Rz

                          Symmetric Global Tensor:
                                  Sxx, Sxy, Syy,
                                  Sxz, Syz, Szz

                          General Global Tensor:
                                  Sxx, Syx, Szx,
                                  Sxy, Syy, Szy,
                                  Sxz, Syz, Szz

                          Shell And Plate Element Load:
                                  Fx, Fy, Fxy,
                                  Mx, My, Mxy,
                                  Vx, Vy

          4        Id Line 1 Always Appears On Plots In Output Display.
          5        If Specific Data Type Is "Unknown," ID Line 2 Is
                      Displayed As Data Type In Output Display.
          6        Typical Fortran I/O Statements For The Data Sections
                      Are:

                                   Read(Lun,1000)Num
                                   Write
                          1000 Format (I10)
                                   Read(Lun,1010) (VAL(I),I=1,NDV)
                                   Write
                          1010 format (6e13.5)

                          Where:     Num Is Node Number
                                     Val Is Real Or Complex Data  Array
                                     Ndv Is Number Of Data Values  Per Node

          7         Data Characteristic Values Imply The Following Values
                      Of Ndv:
                        Scalar: 1
                        3 DOF Global Vector: 3
                        6 DOF Global Vector: 6
                        Symmetric Global Tensor: 6
                        General Global Tensor: 9

          8        Data Associated With I-DEAS Test Has The Following
                      Special Forms of Specific Data Type and ID Line 5.

                   For Record 6 Field 4-Specific Data Type, values 0
                   through 12 are as defined above.  13 and 15 through 19 are:

                               13: excitation force
                               15: pressure
                               16: mass
                               17: time
                               18: frequency
                               19: rpm

                   The form of ID Line 5 is:

                   Format (4I10)
                   FIELD 1:  Reference Coordinate Label

                   FIELD 2:  Reference Coordinate Direction
                                1: X Direction
                               -1: -X Direction
                                2: Y Direction
                               -2: -Y Direction
                                3: Z Direction
                               -3: -Z Direction

                   FIELD 3:  Numerator Signal Code
                                see Specific Data Type above

                   FIELD 4:  Denominator Signal Code
                                see Specific Data Type above


                   Also note that the modal mass in record 8 is calculated
                   from the parameter table by I-DEAS Test.

          9        Any Record With All 0.0's Data Entries Need Not (But
                      May) Appear.

          10       A Direct Result Of 9 Is That If No Records 9 And 10
                      Appear, All Data For The Data Set Is 0.0.

          11       When New Analysis Types Are Added, Record 7 Fields 1
                      And 2 Are Always > Or = 1 With Dummy Integer And
                      Real Zero Data If Data Is Not Required. If Complex
                      Data Is Needed, It Is Treated As Two Real Numbers,
                      Real Part Followed By Imaginary Point.

          12       Dataloaders Use The Following ID Line Convention:
                              1.   (80A1) Model
                                  Identification
                              2.   (80A1) Run
                                  Identification
                              3.   (80A1) Run
                                  Date/Time
                              4.   (80A1) Load Case
                                  Name

                          For Static:
                              5.   (17h Load Case
                                  Number;, I10) For
                                  Normal Mode:
                              5.   (10h Mode Same,
                                  I10, 10H Frequency,
                                  E13.5)
          13       No Maximum Value For Ndv .

          14       Typical Fortran I/O Statements For Processing Records 7
                      And 8.

                            Read (LUN,1000)NINT,NRVAL,(IPAR(I),I=1,NINT
                       1000 Format (8I10)
                            Read (Lun,1010) (RPAV(I),I=1,NRVAL)
                       1010 Format (6E13.5)

          15       For Situations With Reduced # Dof's, Use 3 DOF
                      Translations Or 6 DOF Translation And Rotation With
                      Unused Values = 0.
"""
function parse_dataset55(io)
     # Record 1 to 5 - Format (40A2)
     id1 = strip(readline(io))
     id2 = strip(readline(io))
     id3 = strip(readline(io))
     id4 = strip(readline(io))
     id5 = strip(readline(io))

     # Parse Record 6 - Format (6I10)
     r6 = readline(io)
     model_type, analysis_type, data_charac, spec_dtype, dtype, ndv_per_node = @scanf(r6, "%10d%10d%10d%10d%10d%10d", Int, Int, Int, Int, Int, Int)[2:end]
     # model_type, analysis_type, data_charac, spec_dtype, dtype, ndv_per_node = parse.(Int, split(strip(readline(io))))

     # Record 7 - Format (8I10)
     r7 = readline(io)
     r7_raw = @scanf(r7, "%10d%10d%10d%10d%10d%10d%10d%10d", Int, Int, Int, Int, Int, Int, Int, Int)[2:end]
     # r7_raw = parse.(Int, split(strip(readline(io))))

     # Record 8 - Format (6E13.5)
     r8 = readline(io)
     r8_raw = @scanf(r8, "%13e%13e%13e%13e%13e%13e", Float64, Float64, Float64, Float64, Float64, Float64)[2:end]
     # r8_raw = parse.(Float64, split(strip(readline(io))))

     # Record 9 and 10
     node_number = Int[]
     data, ndv = if dtype == 2
          Vector{Float64}[], ndv_per_node
     elseif dtype == 5
          Vector{ComplexF64}[], 2ndv_per_node
     end

     # Start parsing from Record 9 and 10
     _data = similar(eltype(data), 0)
     while (r9 = readline(io))[1:6] != "    -1"
          # Record 9 - Format (I10)
          push!(node_number, parse(Int, strip(r9)))

          # Record 10 - Format (6E13.5)
          record10 = readline(io)
          nv = 0
          while nv < ndv
               r10 = @scanf(record10, "%13e%13e%13e%13e%13e%13e", Float64, Float64, Float64, Float64, Float64, Float64)[2:end]
               # r10 = parse.(Float64, split(strip(record10)))
               nv += length(r10)

               if dtype == 2
                    append!(_data, r10)
               elseif dtype == 5
                    append!(_data, complex.(r10[1:2:end], r10[2:2:end]))
               end
          end

          push!(data, copy(_data))
          empty!(_data)
     end

     return Dataset55(
          id1,
          id2,
          id3,
          id4,
          id5,
          model_type,
          analysis_type,
          data_charac,
          spec_dtype,
          dtype,
          ndv_per_node,
          r7_raw,
          r8_raw,
          node_number,
          copy(reduce(hcat, data))
     )
end

"""
    write_dataset(dataset::Dataset55) -> Vector{String}

Write a UFF Dataset 55 (Data at Nodes) to a vector of strings.

**Input**
- `dataset::Dataset55`: The dataset structure containing node data

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset55)
    # Write header
    println(io, "    -1")
    println(io, "    55")

    # Write Records 1-5: ID lines (format 40A2 or 80A1)
    println(io, dataset.id1)
    println(io, dataset.id2)
    println(io, dataset.id3)
    println(io, dataset.id4)

    # Properly indent the line
    println(io, " "^9 * dataset.id5)

    # Write Record 6: format 6I10
    r6 = @sprintf("%10d%10d%10d%10d%10d%10d",
        dataset.model_type,
        dataset.analysis_type,
        dataset.data_charac,
        dataset.spec_dtype,
        dataset.dtype,
        dataset.ndv_per_node
    )
    println(io, r6)

    # Write Record 7: format 8I10
    # Get r7_raw from the r7 NamedTuple
    r7_values = collect(values(dataset.r7))
    line7_parts = [@sprintf("%10d", val) for val in r7_values]
    println(io, join(line7_parts, ""))

    # Write Record 8: format 6E13.5
    # Get r8_raw from the r8 NamedTuple
    r8_values = collect(values(dataset.r8))
    line8_parts = [@sprintf("%13.5e", val) for val in r8_values]
    # Write up to 6 values per line
    for i in 1:6:length(line8_parts)
        end_idx = min(i + 5, length(line8_parts))
        println(io, join(line8_parts[i:end_idx], ""))
    end

    # Write Records 9 and 10 for each node
    nnodes = length(dataset.node_number)

    for i in 1:nnodes
        # Record 9: format I10 - node number
        r9 = @sprintf("%10d", dataset.node_number[i])
        println(io, r9)

        # Record 10: format 6E13.5 - data values
        # Get data for this node
        node_data = dataset.data[:, i]

        # Convert complex data to alternating real/imag if dtype is 5 (complex)
        if dataset.dtype == 5
            # Complex data: write real, imag, real, imag, ...
            data_values = Float64[]
            for val in node_data
                if isa(val, Complex)
                    push!(data_values, real(val))
                    push!(data_values, imag(val))
                else
                    push!(data_values, Float64(val))
                    push!(data_values, 0.0)
                end
            end
        else
            # Real data: convert to Float64 array
            data_values = [Float64(val) for val in node_data]
        end

        # Write data values, 6 per line in format 6E13.5
        for j in 1:6:length(data_values)
            end_idx = min(j + 5, length(data_values))
            line_parts = [@sprintf("%13.5e", val) for val in data_values[j:end_idx]]
            println(io, join(line_parts, ""))
        end
    end

    # Write footer
    println(io, "    -1")
end