cd(@__DIR__)
pwd()
using UFFFiles
using Test
using FileCmp

@testset "UFFFiles.jl" begin
    # Write your tests here.
end

readpath = "datasets"
writepath = "written_datasets"
#@testset "dataset15" begin

filenames = readdir("datasets")
filenames = [filenames[1:8]; filenames[14:end]] # exclude the 2000 series filesets for now
# dataset = nothing
for (i, filename) in enumerate(filenames)
    println(i, " ", filename)
    dataset = readuff(joinpath(readpath, filename))
    @show(dataset, typeof(dataset[1]))
    # problem writing dataset2414_node.unv this is a later problem
    if typeof(dataset[1]) != Dataset2414
        writeuff(joinpath(writepath, filename), dataset)
    end
    # filecmp(joinpath(writepath, filename), "written_datasets/dataset15_w.unv")
    # dataset_w = readuff("datasets/dataset15.unv")
    # dataset == dataset_w
end