"""
    Dataset164

A struct containing UFF Dataset 164 (Units) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `units::Int`: Units code
- `description::String`: Units description
- `temperature_mode::Int`: Temperature mode
- `conversion_length::Float64`: Units factors for converting to SI units
- `conversion_force::Float64`: Units factors for converting to SI units
- `conversion_temperature::Float64`: Units factors for converting to SI units
- `conversion_temperature_offset::Float64`: Units factors for converting to SI units
"""
@show_data struct Dataset164 <: UFFDataset
    # Fields specific to Dataset164
    type::Symbol                            # Data set type
    name::String                            # Data set name
    units::Int                              # Record 1 - field 1
    description::String                     # Record 1 - field 2
    temperature_mode::Int                   # Record 1 - field 3
    conversion_length::Float64              # Record 2 - fields 1
    conversion_force::Float64               # Record 2 - fields 2
    conversion_temperature::Float64         # Record 2 - fields 3
    conversion_temperature_offset::Float64  # Record 2 - fields  4

    Dataset164(
        units = 1,
        description = "",
        temperature_mode = 0,
        conversion_length = 1.,
        conversion_force = 1.,
        conversion_temperature = 1.,
        conversion_temperature_offset = 0.
    ) = new(:Dataset164, "Units",units, description, temperature_mode, conversion_length, conversion_force, conversion_temperature, conversion_temperature_offset)
end

"""
Universal Dataset Number: 164

**Name:   Units**

    Record 1: FORMAT(I10,20A1,I10)
                Field 1      -- units code
                                = 1 - SI: Meter (newton)
                                = 2 - BG: Foot (pound f)
                                = 3 - MG: Meter (kilogram f)
                                = 4 - BA: Foot (poundal)
                                = 5 - MM: mm (milli newton)
                                = 6 - CM: cm (centi newton)
                                = 7 - IN: Inch (pound f)
                                = 8 - GM: mm (kilogram f)
                                = 9 - US: USER_DEFINED
                Field 2      -- units description (used for
                                documentation only)
                Field 3      -- temperature mode
                                = 1 - absolute
                                = 2 - relative

    Record 2: FORMAT(3D25.17)
                Unit factors for converting universal file units to SI.
                To convert from universal file units to SI divide by
                the appropriate factor listed below.
                Field 1      -- length
                Field 2      -- force
                Field 3      -- temperature
                Field 4      -- temperature offset
"""
function parse_dataset164(io)
    # Record 1: FORMAT(I10,20A1,I10)
    r1 = readline(io)
    units, description, temperature_mode = @scanf(r1, "%10d%20s%10d", Int, String, Int)[2:end]

    # Record 2: FORMAT(3D25.17)
    conversion_length, conversion_force, conversion_temperature = @scanf(readline(io), "%25e%25e%25e", Float64, Float64, Float64)[2:end]

    conversion_temperature_offset = @scanf(readline(io), "%25e", Float64)[2]

    # Read trailing "    -1"
    readline(io)

    return Dataset164(
        units,
        description,
        temperature_mode,
        conversion_length,
        conversion_force,
        conversion_temperature,
        conversion_temperature_offset
    )
end

"""
    write_dataset(dataset::Dataset164) -> Vector{String}

Write a UFF Dataset 164 (Units) to a vector of strings.

**Input**
- `dataset::Dataset164`: The dataset structure containing units information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset164)
    # Write header
    println(io, "    -1")
    println(io, "   164")

    # Write Record 1: FORMAT(I10,20A1,I10)
    # Field 1: units code (I10)
    # Field 2: units description (20A1)
    # Field 3: temperature mode (I10)

    # Pad or truncate description to exactly 20 characters
    desc = rpad(dataset.description[1:min(length(dataset.description), 20)], 20)

    r1 = @sprintf("%10d%20s%10d",
        dataset.units,
        desc,
        dataset.temperature_mode
    )
    println(io, r1)

    # Write Record 2: FORMAT(3D25.17)
    # First line: 3 conversion factors (length, force, temperature)
    r2_1 = @sprintf("%25.17E%25.17E%25.17E",
        dataset.conversion_length,
        dataset.conversion_force,
        dataset.conversion_temperature
    )
    println(io, r2_1)

    # Second line: temperature offset
    r2_2 = @sprintf("%25.17E",
        dataset.conversion_temperature_offset
    )
    println(io, r2_2)

    # Write footer
    println(io, "    -1")
end