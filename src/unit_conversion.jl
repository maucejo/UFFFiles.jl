"""
    convert_to_si!(ds, ds164)
    convert_to_si!(ds, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

Converts the units of the given UFF dataset `ds` to SI units in place.

**Input**
- `ds`: A UFF dataset object that contains dimensional data to be converted.
- `ds164`: (Optional) A Dataset164 object that provides conversion factors.
- `conversion_length`: (Optional) Conversion factor for length units.
- `conversion_force`: (Optional) Conversion factor for force units.
- `conversion_temperature`: (Optional) Conversion factor for temperature units.
- `temperature_offset`: (Optional) Offset to be applied for temperature conversion.

**Output**
- `ds`: Dataset with its data converted to SI units.
"""
function convert_to_si!(ds, ds164)
    conversion_length = ds164.conversion_length
    conversion_force = ds164.conversion_force
    conversion_temperature = ds164.conversion_temperature
    temperature_offset = ds164.temperature_offset

    convert_to_si!(ds, conversion_length, conversion_force, conversion_temperature, temperature_offset)
end

function convert_to_si!(ds::Dataset15, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    ds.node_coords ./= conversion_length
end

function convert_to_si!(ds::Dataset18, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    ds.cs_origin ./= conversion_length
    ds.cs_x ./= conversion_length
    ds.cs_xz ./= conversion_length
end


function convert_to_si!(ds::Dataset82, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    return nothing
end

function convert_to_si!(ds::Dataset151, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    return nothing
end

function convert_to_si!(ds::Dataset58, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    # Convert data vector
    # Implemented for ordinate data types 8, 11, 12, 9, 13, 15

    # z-axis unit conversion not implemented
    # if abscissa has odd units then complain
    if any(ds.abs_spec_dtype .== (2, 3, 5, 6, 8, 9, 11, 12, 13, 15, 16))
        @warn "Unit Conversion not implemented for abscissa"
    end

    factor = 1.
    # Ordinate Numerator
    if any(ds.ord_spec_dtype .== (0, 1))
        factor /= 1.
    elseif any(ds.ord_spec_dtype .== (8, 11, 12))
        factor /= conversion_length
    elseif any(ds.ord_spec_dtype .== (9, 13))
        factor /= conversion_force
    elseif any(ds.ord_spec_dtype .== (15))
        factor /= (conversion_force/conversion_length^2)
    else
        @warn "Conversion factor for $(ds.ord_spec_dtype) not implemented, please submit PR"
    end

    # Ordinate Denominator
    if any(ds.ord_denom_spec_dtype .== (0, 1))
        factor /= 1.
    elseif any(ds.ord_denom_spec_dtype .== (8, 11, 12))
        factor /= conversion_length
    elseif any(ds.ord_denom_spec_dtype .== (9, 13))
        factor /= conversion_force
    elseif any(ds.ord_denom_spec_dtype .== (15))
        factor /= (conversion_force/conversion_length^2)
    else
        @warn "Conversion factor for $(ds.ord_denom_spec_dtype) not implemented, please submit PR"
    end

    ds.data .*= factor
end

function convert_to_si!(ds::Dataset164, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    return nothing
end

function convert_to_si!(ds::Dataset2411, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    ds.node_coords .*= conversion_length
end

function convert_to_si!(ds::Dataset2412, conversion_length = 1., conversion_force = 1., conversion_temperature = 1., temperature_offset = 0.)

    return nothing
end