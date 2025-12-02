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
function convert_to_si!(datasets)
    ds164 = Dataset164(1,"SI", 2, 1.0, 1.0, 1.0, 273.15)
    for ds in datasets
        ds164 = convert_to_si!(ds, ds164)
    end
end

function convert_to_si!(ds::Dataset15, ds164)

    ds.node_coords ./= ds164.conversion_length
    return ds164
end

function convert_to_si!(ds::Dataset18, ds164)

    ds.cs_origin ./= ds164.conversion_length
    ds.cs_x ./= ds164.conversion_length
    ds.cs_xz ./= ds164.conversion_length
    return ds164
end


function convert_to_si!(ds::Dataset82, ds164)

    return ds164
end

function convert_to_si!(ds::Dataset151, ds164)

    return ds164
end

function convert_to_si!(ds::Dataset58, ds164)

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
        factor /= ds164.conversion_length
    elseif any(ds.ord_spec_dtype .== (9, 13))
        factor /= ds164.conversion_force
    elseif any(ds.ord_spec_dtype .== (15))
        factor /= (ds164.conversion_force/ds164.conversion_length^2)
    else
        @warn "Conversion factor for $(ds.ord_spec_dtype) not implemented, please submit PR"
    end

    # Ordinate Denominator
    if any(ds.ord_denom_spec_dtype .== (0, 1))
        factor *= 1.
    elseif any(ds.ord_denom_spec_dtype .== (8, 11, 12))
        factor *= ds164.conversion_length
    elseif any(ds.ord_denom_spec_dtype .== (9, 13))
        factor *= ds164.conversion_force
    elseif any(ds.ord_denom_spec_dtype .== (15))
        factor *= (ds164.conversion_force/ds164.conversion_length^2)
    else
        @warn "Conversion factor for $(ds.ord_denom_spec_dtype) not implemented, please submit PR"
    end

    ds.data .*= factor
    return ds164
end

function convert_to_si!(ds::Dataset164, ds164)

    return ds
end

function convert_to_si!(ds::Dataset1858, ds164)

    return ds164
end

function convert_to_si!(ds::Dataset2411, ds164)

    ds.node_coords ./= conversion_length
end

function convert_to_si!(ds::Dataset2412, ds164)

    return ds164
end

function convert_to_si!(ds::Dataset2414, ds164)

    # To Do
    return ds164
end