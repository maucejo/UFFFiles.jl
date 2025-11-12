"""
    Dataset164

A struct containing UFF Dataset 164 (Units) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `units::Int`: Units code
- `description::String`: Units description
- `temperature_mode::Int`: Temperature mode
- `conversion_length::Float64`: Length conversion factor
- `conversion_force::Float64`: Force conversion factor
- `conversion_temperature::Float64`: Temperature conversion factor
- `conversion_temperature_offset::Float64`: Temperature offset conversion factor
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
        conversion_factor = [1., 1., 1., 0.]
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
function parse_dataset164(block)
    record1 = extend_line(strip(block[2]))
    units = parse(Int, record1[1])
    description = strip(record1[2:29])
    temperature_mode = parse(Int, strip(record1[31:end]))

    (conversion_length, conversion_force, conversion_temperature) .= parse.(Float64, split(replace(block[3], "D" => "E")))
    conversion_temperature_offset = parse(Float64, strip(replace(block[4], "D" => "E")))

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
function write_dataset(dataset::Dataset164)
    lines = String[]

    # Write header
    push!(lines, "    -1")
    push!(lines, "   164")

    # Write Record 1: FORMAT(I10,20A1,I10)
    # Field 1: units code (I10)
    # Field 2: units description (20A1)
    # Field 3: temperature mode (I10)

    # Pad or truncate description to exactly 20 characters
    desc = rpad(dataset.description[1:min(length(dataset.description), 20)], 20)

    line1 = @sprintf("%10d%20s%10d",
        dataset.units,
        desc,
        dataset.temperature_mode
    )
    push!(lines, line1)

    # Write Record 2: FORMAT(3D25.17)
    # First line: 3 conversion factors (length, force, temperature)
    line2 = @sprintf("%25.17E%25.17E%25.17E",
        dataset.conversion_length,
        dataset.conversion_force,
        dataset.conversion_temperature
    )
    push!(lines, line2)

    # Second line: temperature offset
    line3 = @sprintf("%25.17E",
        dataset.conversion_temperature_offset
    )
    push!(lines, line3)

    # Write footer
    push!(lines, "    -1")

    return lines
end