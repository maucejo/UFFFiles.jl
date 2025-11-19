"""
    Dataset151

A struct containing UFF Dataset 151 (Header) data.

**Fields**
- `type::Symbol`: Data set type
- `name::String`: Data set name
- `model_name::String`: model file name
- `description::String`: model file description
- `application::String`: Program which created the dataset
- `datetime_created::DateTime`: dataset creation date and time
- `version::String`: version from dataset
- `version2::String`: version from dataset
- `file_type::Int`: file type
- `datetime_last_saved::DateTime`: dataset last saved date and time
- `program::String`: program which created uff file
- `datetime_written::DateTime`: uff file written date and time
"""
@show_data struct Dataset151 <: UFFDataset
    # Fields specific to Dataset151
    type::Symbol                    # Data set type
    name::String                    # Data set name
    model_name::String              # Record 1 - field 1
    description::String             # Record 2 - field 1
    application::String             # Record 3 - field 1
    datetime_created::String        # Record 4 - fields 1 and 2
    version::Int                    # Record 4 - fields 3
    version2::Int                   # Record 4 - fields 4
    file_type::Int                  # Record 4 - field 5
    datetime_last_saved::String     # Record 5 - fields 1 and 2
    program::String                 # Record 6 - field 1
    datetime_written::String        # Record 7 - fields 1 and 2

    Dataset151(
        model_name = "",
        description = "",
        application = "",
        datetime_created = "",
        version = 0,
        version2 = 0,
        file_type = 0,
        datetime_last_saved = "",
        program = "",
        datetime_written = ""
    ) = new(:Dataset151, "Header", model_name, description, application, datetime_created, version, version2, file_type, datetime_last_saved, program, datetime_written)
end

"""
Universal Dataset Number: 151

**Name:   Header**

    Record 1: FORMAT(80A1)
                Field 1      -- model file name

    Record 2: FORMAT(80A1)
                Field 1      -- model file description

    Record 3: FORMAT(80A1)
                Field 1      -- program which created DB

    Record 4: FORMAT(10A1,10A1,3I10)
                Field 1      -- date database created (DD-MMM-YY)
                Field 2      -- time database created (HH:MM:SS)
                Field 3      -- Version from database
                Field 4      -- Version from database
                Field 5      -- File type
                                =0  Universal
                                =1  Archive
                                =2  Other

    Record 5: FORMAT(10A1,10A1)
                Field 1      -- date database last saved (DD-MMM-YY)
                Field 2      -- time database last saved (HH:MM:SS)

    Record 6: FORMAT(80A1)
                Field 1      -- program which created universal file

    Record 7: FORMAT(10A1,10A1)
                Field 1      -- date universal file written (DD-MMM-YY)
                Field 2      -- time universal file written (HH:MM:SS)
"""
function parse_dataset151(io)
    model_name = strip(readline(io))  # Record 1
    description = strip(readline(io))  # Record 2
    application = strip(readline(io))  # Record 3

    # Record 4 contains multiple fields in one line
    line_creation = extend_line(readline(io))
    datetime_created = strip(line_creation[1:20])   # Field 1 & 2
    # compensate for files that only have date in Record 4
    tmp = strip(line_creation[21:30])
    version = isempty(tmp) ? 0 : parse(Int, tmp)    # Field 3
    tmp = strip(line_creation[31:40])
    version2 = isempty(tmp) ? 0 : parse(Int, tmp)    # Field 4
    tmp = strip(line_creation[41:50])
    file_type = isempty(tmp) ? 0 : parse(Int, tmp)   # Field 5

    datetime_last_saved = strip(readline(io))   # Record 5
    program = strip(readline(io))               # Record 6
    datetime_written = strip(readline(io))      # Record 7

    _ = readline(io)    # Read trailing "    -1"

    return Dataset151(
        model_name,
        description,
        application,
        datetime_created,
        version,
        version2,
        file_type,
        datetime_last_saved,
        program,
        datetime_written
    )
end

"""
    write_dataset(dataset::Dataset151) -> Vector{String}

Write a UFF Dataset 151 (Header) to a vector of strings.

**Input**
- `dataset::Dataset151`: The dataset structure containing header information

**Output**
- `Vector{String}`: Vector of formatted strings representing the UFF file content
"""
function write_dataset(io, dataset::Dataset151)
    # Write header
    println(io, "    -1")
    println(io, "   151")

    # Record 1: FORMAT(80A1) - model file name
    println(io, extend_line(dataset.model_name))

    # Record 2: FORMAT(80A1) - model file description (empty line if no description)
    println(io, extend_line(dataset.description))

    # Record 3: FORMAT(80A1) - program which created DB
    println(io, extend_line(dataset.application))

    # Record 4: FORMAT(10A1,10A1,3I10) - date/time created, version, version, file_type
    # The datetime_created field should already contain both date and time
    # The version field should be formatted as two 10-character fields
    # File type should be formatted as I10
    record4 = dataset.datetime_created
    # the commented out lines appear to compensate for a badly formatted dataset151
    #=if !isempty(dataset.version)
        record4 *= dataset.datetime_created
    end
    if !isempty(dataset.version2)
        record4 *= dataset.version2
    end
    if dataset.file_type != 0
        record4 *= @sprintf("%10d", dataset.file_type)
    end=#

    record4 = @sprintf("%-10s%-10s%10i%10i%10i%30s", 
                    split(dataset.datetime_created)[1], 
                    split(dataset.datetime_created)[2], 
                    dataset.version, 
                    dataset.version2, 
                    dataset.file_type,
                    " "
                    )

    println(io, record4)

    # Record 5: FORMAT(10A1,10A1) - date/time last saved
    record5 = @sprintf("%-10s%-10s%60s", 
                    split(dataset.datetime_last_saved)[1], 
                    split(dataset.datetime_last_saved)[2], 
                    " "
                    )

    println(io, record5)

    # Record 6: FORMAT(80A1) - program which created universal file
    println(io, extend_line(dataset.program))

    # Record 7: FORMAT(10A1,10A1) - date/time written
    record7 = @sprintf("%-10s%-10s%60s", 
                    Dates.format(now(), "dd-uuu-yy"), 
                    Dates.format(now(), "HH:MM:SS"),
                    " "
                    )

    println(io, record7)

    # Write footer
    println(io, "    -1")

    return nothing
end