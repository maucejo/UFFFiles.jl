"""
    Dataset1858

A struct containing UFF Dataset 1858 (Dataset 58 qualifiers) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `set_record_number::Int`: Set record number
- `octave_format::Int`: Set record number
- `meas_run::Int`: Measurement run number
- `octave_weighting::Int`: Octave format
- `window::Int`: Window type
- `amp_scaling::Int`: Unknown, half-peak, peak, rms
- `normalization::Int`: Unknown, auto-spectra, PSD, ESD
- `abs_data_type_qual::Int`: Translation, Rotation, Translation Squared, Rotation Squared
- `ord_num_data_type_qual::Int`: Ordinate Numerator Data Type Qualifier
- `ord_denom_data_type_qual::Int`: Ordinate Denominator Data Type Qualifier
- `z_axis_data_type_qual::Int`: Z-axis Data Type Qualifier
- `sampling_type::Int`: Dynamic, Static, RPM from tach, Frequency from tach
- `z_rpm_value::Float64`: Z rpm value
- `z_time_value::Float64`: Z time value
- `z_order_value::Float64`: Z order value
- `num_samples::Int`: Number of Sample
- `uv1::Float64`: User Value 1
- `uv2::Float64`: User Value 2
- `uv3::Float64`: User Value 3
- `uv4::Float64`: User Value 4
- `exp_window_damping::Float64`: Exponential window damping factor
- `resp_dir::String`: Response direction
- `ref_dir::String`: Reference direction
"""
@show_data struct Dataset1858 <: UFFDataset
    # Fields specific to Dataset1858
    type::Symbol                             # Data set type
    name::String                             # Data set name
    set_record_number::Int                   # Record 1 - field 1
    octave_format::Int                       # Record 1 - field 2
    meas_run::Int                            # Record 1 - field 3
    octave_weighting::Int                    # Record 2 - field 1
    window::Int                              # Record 2 - field 2
    amp_scaling::Int                         # Record 2 - field 3
    normalization::Int                       # Record 2 - field 4
    abs_data_type_qual::Int                  # Record 2 - field 5
    ord_num_data_type_qual::Int              # Record 2 - field 6
    ord_denom_data_type_qual::Int            # Record 2 - field 7
    z_axis_data_type_qual::Int               # Record 2 - field 8
    sampling_type::Int                       # Record 2 - field 9
    z_rpm_value::Float64                     # Record 3 - field 1
    z_time_value::Float64                    # Record 3 - field 2
    z_order_value::Float64                   # Record 3 - field 3
    num_samples::Int                         # Record 3 - field 4
    uv1::Float64                             # Record 4 - field 1
    uv2::Float64                             # Record 4 - field 2
    uv3::Float64                             # Record 4 - field 3
    uv4::Float64                             # Record 4 - field 4
    exp_window_damping::Float64              # Record 4 - field 5
    resp_dir::String                         # Record 6 - field 1
    ref_dir::String                          # Record 6 - field 2

    Dataset1858(
        set_record_number = 0,
        octave_format = 0,
        meas_run = 0,
        octave_weighting = 0,
        window = 0,
        amp_scaling = 0,
        normalization = 0,
        abs_data_type_qual = 0,
        ord_num_data_type_qual = 0,
        ord_denom_data_type_qual = 0,
        z_axis_data_type_qual = 0,
        sampling_type = 0,
        z_rpm_value = 0.,
        z_time_value = 0.,
        z_order_value = 0.,
        num_samples = 0,
        uv1 = 0.,
        uv2 = 0.,
        uv3 = 0.,
        uv4 = 0.,
        exp_window_damping = 0.,
        resp_dir = "x+",
        ref_dir = "NONE"
        ) = new(:Dataset1858, "Units", set_record_number, octave_format, meas_run,
            octave_weighting, window, amp_scaling, normalization, abs_data_type_qual,
            ord_num_data_type_qual, ord_denom_data_type_qual, z_axis_data_type_qual,
            sampling_type, z_rpm_value, z_time_value, z_order_value, num_samples,
            uv1, uv2, uv3, uv4, exp_window_damping, resp_dir, ref_dir)
end

"""
Universal Dataset Number: 1858

Name:   Dataset 58 qualifiers
----------------------------------------------------------------------------

Record 1:     FORMAT(6I12)
              Field 1       - Set record number
              Field 2       - Octave format
                              0 - not in octave format (default)
                              1 - octave
                              3 - one third octave
                              n - 1/n octave
              Field 3       - Measurement run number
              Fields 4-6    - Not used (fill with zeros)

Record 2:     FORMAT(12I6)
              Field 1       - Weighting Type
                              0 - No weighting or Unknown (default)
                              1 - A weighting
                              2 - B weighting
                              3 - C weighting
                              4 - D weighting (not yet implemented)
              Field 2       - Window Type
                              0 - No window or unknown (default)
                              1 - Hanning Narrow
                              2 - Hanning Broad
                              3 - Flattop
                              4 - Exponential
                              5 - Impact
                              6 - Impact and Exponential
              Field 3       - Amplitude units
                              0 - unknown (default)
                              1 - Half-peak scale
                              2 - Peak scale
                              3 - RMS
              Field 4       - Normalization Method
                              0 - unknown (default)
                              1 - Units squared
                              2 - Units squared per Hz (PSD)
                              3 - Units squared seconds per Hz (ESD)
              Field 5       - Abscissa Data Type Qualifier
                              0 - Translation
                              1 - Rotation
                              2 - Translation Squared
                              3 - Rotation Squared
              Field 6       - Ordinate Numerator Data Type Qualifier
                              0 - Translation
                              1 - Rotation
                              2 - Translation Squared
                              3 - Rotation Squared
              Field 7       - Ordinate Denominator Data Type Qualifier
                              0 - Translation
                              1 - Rotation
                              2 - Translation Squared
                              3 - Rotation Squared
              Field 8       - Z-axis Data Type Qualifier
                              0 - Translation
                              1 - Rotation
                              2 - Translation Squared
                              3 - Rotation Squared

              Field 9       - Sampling Type
                              0 - Dynamic
                              1 - Static
                              2 - RPM from Tach
                              3 - Frequency from tach
              Fields 10-12  - not used (fill with zeros)

Record 3:     FORMAT  (1P5E15.7)
              Field 1       - Z RPM value
              Field 2       - Z Time value
              Field 3       - Z Order value
              Field 4       - Number of samples
              Field 5       - not used (fill with zero)

Record 4:     FORMAT  (1P5E15.7)
              Field 1       - User value 1
              Field 2       - User value 2
              Field 3       - User value 3
              Field 4       - User value 4
              Field 5       - Exponential window damping factor

Record 5:     FORMAT  (1P5E15.7)
              Fields 1-5    - not used (fill with zeros)

Record 6:     FORMAT  (2A2,2X,2A2)
              Field 1       - Response direction
              Field 2       - Reference direction

Record 7:     FORMAT  (40A2)
              Field 1       - not used

----------------------------------------------------------------------------

"""
function parse_dataset1858(io)
    # Record 1 - FORMAT(6I12)
    r1 = readline(io)
    set_record_number, octave_format, meas_run = @scanf(r1, "%12i%12i%12i", Int, Int, Int)[2:end]

    # Record 2 - FORMAT(12I6)
    r2 = readline(io)
    octave_weighting, window, amp_scaling, normalization, abs_data_type_qual,
    ord_num_data_type_qual, ord_denom_data_type_qual, z_axis_data_type_qual,
    sampling_type = @scanf(r2, "%6i%6i%6i%6i%6i%6i%6i%6i%6i",
    Int, Int, Int, Int, Int, Int, Int, Int, Int)[2:end]

    # Record 3 - FORMAT (1P5E15.7)
    r3 = readline(io)
    z_rpm_value, z_time_value, z_order_value, num_samples = @scanf(r3, "%15e%15e%15e%15e", Float64, Float64, Float64, Int)[2:end]

    # Record 4 - FORMAT (1P5E15.7)
    r4 = readline(io)
    uv1, uv2, uv3, uv4, exp_window_damping = @scanf(r4, "%15e%15e%15e%15e%15e", Float64, Float64, Float64, Float64, Float64)[2:end]

    # Record 5 Unused
    readline(io)

    # Record 6 - FORMAT (2A2,2X,2A2)
    r6 = readline(io)
    resp_dir, _, ref_dir = @scanf(r6, "%4c%2c%4c", String, String, String)[2:end]

    # Record 7 Unused
    readline(io)

    # Read trailing "    -1"
    readline(io)

    return Dataset1858(
        set_record_number,
        octave_format,
        meas_run,
        octave_weighting,
        window,
        amp_scaling,
        normalization,
        abs_data_type_qual,
        ord_num_data_type_qual,
        ord_denom_data_type_qual,
        z_axis_data_type_qual,
        sampling_type,
        z_rpm_value,
        z_time_value,
        z_order_value,
        num_samples,
        uv1,
        uv2,
        uv3,
        uv4,
        exp_window_damping,
        strip(resp_dir),
        strip(ref_dir)
    )
end

"""
    write_dataset1858(dataset::Dataset1858) -> Vector{String}

Write a UFF Dataset 1858 (Dataset58 qualifiers) to a vector of strings.

**Input**
- `dataset::Dataset1858`: The dataset structure containing units information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset1858) #::Dataset1858) #the remainder is a copy from 164 and needs to be implemented
    # Write header
    println(io, "    -1")
    println(io, "  1858")

    # Write Record 1: FORMAT(6I12)
    # Field 1       - Set record number
    # Field 2       - Octave format
    # Field 3       - Measurement run number
    # Fields 4-6    - Not used (fill with zeros)

    r1 = @sprintf("%12i%12i%12i%12i%12i%12i",
        dataset.set_record_number,
        dataset.octave_format,
        dataset.meas_run,
        0, 0, 0
    )
    println(io, r1)

    # Write Record 2: FORMAT(12I6)
    # Field 1       - Weighting Type
    # Field 2       - Window Type
    # Field 3       - Amplitude units
    # Field 4       - Normalization Method
    # Field 5       - Abscissa Data Type Qualifier
    # Field 6       - Ordinate Numerator Data Type Qualifier
    # Field 7       - Ordinate Denominator Data Type Qualifier
    # Field 8       - Z-axis Data Type Qualifier
    # Field 9       - Sampling Type
    # Fields 10-12  - not used (fill with zeros)
    r2 = @sprintf("%6i%6i%6i%6i%6i%6i%6i%6i%6i%6i%6i%6i",
        dataset.octave_weighting,
        dataset.window,
        dataset.amp_scaling,
        dataset.normalization,
        dataset.abs_data_type_qual,
        dataset.ord_num_data_type_qual,
        dataset.ord_denom_data_type_qual,
        dataset.z_axis_data_type_qual,
        dataset.sampling_type,
        0, 0, 0
    )
    println(io, r2)

    # Write Record 3:     FORMAT  (1P5E15.7)
    # Field 1       - Z RPM value
    # Field 2       - Z Time value
    # Field 3       - Z Order value
    # Field 4       - Number of samples
    # Field 5       - not used (fill with zero)

    r3 = @sprintf("%15.8e%15.8e%15.8e%15.8e%15.8e",
        dataset.z_rpm_value,
        dataset.z_time_value,
        dataset.z_order_value,
        dataset.num_samples,
        0.0
    )
    println(io, r3)

    # Write Record 4:     FORMAT  (1P5E15.7)
    # Field 1       - User value 1
    # Field 2       - User value 2
    # Field 3       - User value 3
    # Field 4       - User value 4
    # Field 5       - Exponential window damping factor
    r4 = @sprintf("%15.8e%15.8e%15.8e%15.8e%15.8e",
        dataset.uv1,
        dataset.uv2,
        dataset.uv3,
        dataset.uv4,
        dataset.exp_window_damping
        )
    println(io, r4)

    # Write Record 5:     FORMAT  (1P5E15.7)
    # Fields 1-5    - not used (fill with zeros)
    r5 = @sprintf("%15.8e%15.8e%15.8e%15.8e%15.8e",
        0.0, 0.0, 0.0, 0.0, 0.0)
    println(io, r5)

    # Write Record 6:     FORMAT  (2A2,2X,2A2)
    # Field 1       - Response direction
    # Field 2       - Reference direction
    r6 = @sprintf("%-4s  %-2s",
        dataset.resp_dir,
        dataset.ref_dir)
    println(io, r6)

    # Write Record 7:     FORMAT  (40A2)
    # Field 1       - not used
    r7 = @sprintf("%-4s","NONE")
    println(io, r7)

    # Write footer
    println(io, "    -1")
end