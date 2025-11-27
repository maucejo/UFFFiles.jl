using UFFFiles
using Test
# using FileCmp
using Glob

cd(@__DIR__)
@show(pwd())

@testset "UFFFiles.jl" begin
    # Write your tests here.
end

readpath = "datasets"
writepath = "written_datasets"

# ToDo - write a test for each dataset type

# Dataset15
@testset "dataset15" begin
        filename = "dataset15.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].node_ID == ds1[1].node_ID
        @test ds[1].def_cs_num == ds1[1].def_cs_num
        @test ds[1].disp_cs_num == ds1[1].disp_cs_num
        @test ds[1].color == ds1[1].color
        @test ds[1].node_coords ≈ ds1[1].node_coords
end

# Dataset18
@testset "dataset18" begin
        filename = "dataset18.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].cs_num ≈ ds1[1].cs_num
        @test ds[1].cs_type ≈ ds1[1].cs_type
        @test ds[1].ref_cs_num ≈ ds1[1].ref_cs_num
        @test ds[1].color ≈ ds1[1].color
        @test ds[1].method_def ≈ ds1[1].method_def
        @test ds[1].cs_name == ds1[1].cs_name
        @test ds[1].cs_origin ≈ ds1[1].cs_origin
        @test ds[1].cs_x ≈ ds1[1].cs_x
        @test ds[1].cs_xz ≈ ds1[1].cs_xz
end

# Dataset55
@testset "dataset55" begin
        filename = "dataset55.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].id1 == ds1[1].id1
        @test ds[1].id2 == ds1[1].id2
        @test ds[1].id3 == ds1[1].id3
        @test ds[1].id4 == ds1[1].id4
        @test ds[1].id5 == ds1[1].id5
        @test ds[1].model_type == ds1[1].model_type
        @test ds[1].analysis_type == ds1[1].analysis_type
        @test ds[1].data_charac == ds1[1].data_charac
        @test ds[1].spec_dtype == ds1[1].spec_dtype
        @test ds[1].dtype == ds1[1].dtype
        @test ds[1].ndv_per_node == ds1[1].ndv_per_node
        @test ds[1].r7 == ds1[1].r7
        @test ds[1].r8 == ds1[1].r8
        @test ds[1].node_number == ds1[1].node_number
        @test ds[1].data ≈ ds1[1].data

end

# Dataset58
# read in an ASCII file write out as binary and read in and write out as ASCII
# test that the data is good
@testset "dataset58_ASCII2binary" begin
    readname = "dataset58_nospacing.uff"
    writename = splitext(readname)[1] * ".ufb"
    writename1 = splitext(readname)[1] * ".unv"
    writename2 = splitext(readname)[1] * "_dp.ufb"
    ds = readuff(joinpath(readpath, readname))
    writeuff(joinpath(writepath, writename), ds; w58b=true)
    ds1 = readuff(joinpath(writepath, writename))
    writeuff(joinpath(writepath, writename1), ds1; w58b=false)
    ds2 = readuff(joinpath(writepath, writename1))
    rm(joinpath(writepath, writename))
    rm(joinpath(writepath, writename1))

    @test ds[1].data ≈ ds1[1].data ≈ ds2[1].data
end


# Test all the cases in dataset58
@testset "Dataset58" begin
    readpath = "datasets"
    writepath = "written_datasets"
    filenames = glob("dataset58_*.unv", "datasets")
    for filename in filenames
        # println("Start $filename")
        filename = splitpath(filename)[end]
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))
        ab = ds[1].abscissa ≈ ds1[1].abscissa
        or = ds[1].data ≈ ds1[1].data
        # println("$filename: abscissa match $ab; data match $or")
        # all other fields could be matched as well
        @test ds[1].id1 == ds1[1].id1
        @test ds[1].id2 == ds1[1].id2
        @test ds[1].id3 == ds1[1].id3
        @test ds[1].id4 == ds1[1].id4
        @test ds[1].id5 == ds1[1].id5
        @test ds[1].abscissa ≈ ds1[1].abscissa
        @test ds[1].data ≈ ds1[1].data
        @test ds[1].abs_len_unit_exp ≈ ds1[1].abs_len_unit_exp
        @test ds[1].abs_force_unit_exp ≈ ds1[1].abs_force_unit_exp
        @test ds[1].abs_temp_unit_exp ≈ ds1[1].abs_temp_unit_exp
        @test ds[1].abs_axis_label == ds1[1].abs_axis_label
        @test ds[1].abs_axis_unit_label == ds1[1].abs_axis_unit_label
        @test ds[1].ord_spec_dtype ≈ ds1[1].ord_spec_dtype
        @test ds[1].ord_len_unit_exp ≈ ds1[1].ord_len_unit_exp
        @test ds[1].ord_force_unit_exp ≈ ds1[1].ord_force_unit_exp
        @test ds[1].ord_temp_unit_exp ≈ ds1[1].ord_temp_unit_exp
        @test ds[1].ord_axis_label == ds1[1].ord_axis_label
        @test ds[1].ord_axis_unit_label == ds1[1].ord_axis_unit_label
        @test ds[1].ord_denom_spec_dtype ≈ ds1[1].ord_denom_spec_dtype
        @test ds[1].ord_denom_len_unit_exp ≈ ds1[1].ord_denom_len_unit_exp
        @test ds[1].ord_denom_force_unit_exp ≈ ds1[1].ord_denom_force_unit_exp
        @test ds[1].ord_denom_temp_unit_exp ≈ ds1[1].ord_denom_temp_unit_exp
        @test ds[1].ord_denom_axis_label == ds1[1].ord_denom_axis_label
        @test ds[1].ord_denom_axis_unit_label == ds1[1].ord_denom_axis_unit_label
        @test ds[1].z_spec_dtype ≈ ds1[1].z_spec_dtype
        @test ds[1].z_len_unit_exp ≈ ds1[1].z_len_unit_exp
        @test ds[1].z_force_unit_exp ≈ ds1[1].z_force_unit_exp
        @test ds[1].z_temp_unit_exp ≈ ds1[1].z_temp_unit_exp
        @test ds[1].z_axis_label == ds1[1].z_axis_label
        @test ds[1].z_axis_unit_label == ds1[1].z_axis_unit_label
    end
end

# Dataset82
@testset "dataset82" begin
        filename = "dataset82.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].line_number == ds1[1].line_number
        @test ds[1].num_nodes == ds1[1].num_nodes
        @test ds[1].color == ds1[1].color
        @test ds[1].id_line == ds1[1].id_line
        @test all(ds[1].line_nodes .== ds1[1].line_nodes)
end

# Dataset151
@testset "dataset151" begin
        filename = "dataset151.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].model_name == ds1[1].model_name
        @test ds[1].description == ds1[1].description
        @test ds[1].application == ds1[1].application
        @test ds[1].datetime_created[1] == ds1[1].datetime_created[1]
        @test ds[1].datetime_created[2] == ds1[1].datetime_created[2]
        @test ds[1].version == ds1[1].version
        @test ds[1].version2 == ds1[1].version2
        @test ds[1].file_type == ds1[1].file_type
        @test ds[1].datetime_last_saved[1] == ds1[1].datetime_last_saved[1]
        @test ds[1].datetime_last_saved[2] == ds1[1].datetime_last_saved[2]

end

# Dataset164
@testset "dataset164" begin
        filename = "dataset164.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].units == ds1[1].units
        @test ds[1].description == ds1[1].description
        @test ds[1].temperature_mode == ds1[1].temperature_mode
        @test ds[1].conversion_length == ds1[1].conversion_length
        @test ds[1].conversion_force == ds1[1].conversion_force
        @test ds[1].conversion_temperature == ds1[1].conversion_temperature
        @test ds[1].conversion_temperature_offset == ds1[1].conversion_temperature_offset

end

# Dataset1858
@testset "dataset1858" begin
        filename = "dataset1858.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].set_record_number == ds1[1].set_record_number
        @test ds[1].octave_format == ds1[1].octave_format
        @test ds[1].meas_run == ds1[1].meas_run
        @test ds[1].octave_weighting == ds1[1].octave_weighting
        @test ds[1].window == ds1[1].window
        @test ds[1].amp_scaling == ds1[1].amp_scaling
        @test ds[1].normalization == ds1[1].normalization
        @test ds[1].abs_data_type_qual == ds1[1].abs_data_type_qual
        @test ds[1].ord_num_data_type_qual == ds1[1].ord_num_data_type_qual
        @test ds[1].ord_denom_data_type_qual == ds1[1].ord_denom_data_type_qual
        @test ds[1].z_axis_data_type_qual == ds1[1].z_axis_data_type_qual
        @test ds[1].sampling_type == ds1[1].sampling_type
        @test ds[1].z_rpm_value ≈ ds1[1].z_rpm_value
        @test ds[1].z_time_value ≈ ds1[1].z_time_value
        @test ds[1].z_order_value ≈ ds1[1].z_order_value
        @test ds[1].num_samples ≈ ds1[1].num_samples
        @test ds[1].uv1 ≈ ds1[1].uv1
        @test ds[1].uv2 ≈ ds1[1].uv2
        @test ds[1].uv3 ≈ ds1[1].uv3
        @test ds[1].uv4 ≈ ds1[1].uv4
        @test ds[1].exp_window_damping ≈ ds1[1].exp_window_damping
        @test ds[1].resp_dir == ds1[1].resp_dir
        @test ds[1].ref_dir == ds1[1].ref_dir
end


# Dataset2411
@testset "dataset2411" begin
        filename = "dataset2411.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].nodes_ID == ds1[1].nodes_ID
        @test ds[1].coord_system == ds1[1].coord_system
        @test ds[1].disp_coord_system == ds1[1].disp_coord_system
        @test ds[1].color == ds1[1].color
        @test ds[1].node_coords ≈ ds1[1].node_coords

end


# Dataset2412
@testset "dataset2412" begin
        filename = "dataset2412.unv"
        ds = readuff(joinpath(readpath, filename));
        writeuff(joinpath(writepath, filename), ds)
        ds1 = readuff(joinpath(writepath, filename));
        rm(joinpath(writepath, filename))

        @test ds[1].elements_ID == ds1[1].elements_ID
        @test ds[1].fe_descriptor_id == ds1[1].fe_descriptor_id
        @test ds[1].phys_property == ds1[1].phys_property
        @test ds[1].mat_property == ds1[1].mat_property
        @test ds[1].color == ds1[1].color
        @test ds[1].nodes_per_elt == ds1[1].nodes_per_elt
        @test ds[1].connectivity == ds1[1].connectivity
        @test ds[1].beam_info == ds1[1].beam_info

end


# Dataset2414
@testset "dataset2414" begin
        filenames = glob("dataset2414*.unv", readpath)
        for filename in filenames
            filename = splitpath(filename)[end]
            #filename = "dataset2414_elt.unv"
            ds = readuff(joinpath(readpath, filename))
            writeuff(joinpath(writepath, filename), ds)
            ds1 = readuff(joinpath(writepath, filename))
            rm(joinpath(writepath, filename))

            @test ds[1].analysis_dlabel == ds1[1].analysis_dlabel
            @test ds[1].analysis_dname == ds1[1].analysis_dname
            @test ds[1].dataset_location == ds1[1].dataset_location
            @test ds[1].id_line1 == ds1[1].id_line1
            @test ds[1].id_line2 == ds1[1].id_line2
            @test ds[1].id_line3 == ds1[1].id_line3
            @test ds[1].id_line4 == ds1[1].id_line4
            @test ds[1].id_line5 == ds1[1].id_line5
            @test ds[1].model_type == ds1[1].model_type
            @test ds[1].analysis_type == ds1[1].analysis_type
            @test ds[1].data_characteristic == ds1[1].data_characteristic
            @test ds[1].result_type == ds1[1].result_type
            @test ds[1].dtype == ds1[1].dtype
            @test ds[1].num_data_values == ds1[1].num_data_values

            # To Do: implement these test properly
            #ds[1].int_analysis_type_raw ≈ ds1[1].int_analysis_type_raw
            #ds[1].real_analysis_type_raw ≈ ds1[1].real_analysis_type_raw
            #ds[1].data_info_raw ≈ ds1[1].data_info_raw
            #ds[1].data_value_raw ≈ ds1[1].data_value_raw
        end
end


