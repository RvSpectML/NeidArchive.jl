using NeidArchive
using Test
using Dates

@testset "NeidArchive.jl" begin
    user_nexsci = "pyneidprop"
    passwd_nexsci = "pielemonquietyellow"
    cookie_nexsci = "./neidadmincookie.txt"
    query_result_file = "./criteria.csv"

    @testset "login" begin
        NeidArchive.login(userid=user_nexsci, password=passwd_nexsci, cookiepath=cookie_nexsci)
    end

    @testset "Query" begin
        param = Dict{String,String}()
        param["datalevel"] = "l0"
        param["piname"] = "Logsdon"
        param["datetime"] = NeidArchive.datetime_one_day(Date(2021,1,31))
        NeidArchive.query(param, cookiepath=cookie_nexsci, outpath=query_result_file)
        num_lines = countlines(query_result_file) - 1
        #println("# Query resulted in file with ", num_lines, " entries.")
        #
        #df = CSV.read(query_result_file, DataFrame)
        #num_files = size(df, 1)
        @test num_lines == 238
    end

end
