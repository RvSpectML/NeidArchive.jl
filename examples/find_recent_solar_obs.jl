using NeidArchive
using Dates
last_day_retreived_solar_data = Date(2021,3,19)

include("password.jl")  # Needs to set user_nexsci and passwd_nexsci
cookie_nexsci = "./neidadmincookie.txt"
 query_result_file = "./criteria.csv"

NeidArchive.login(userid=user_nexsci, password=passwd_nexsci, cookiepath=cookie_nexsci)

param = Dict{String,String}()
 param["datalevel"] = "solarl1"
 param["piname"] = "Mahadevan"
 param["object"] = "Sun"
 param["datetime"] = NeidArchive.datetime_range_after(last_day_retreived_solar_data)

NeidArchive.query(param, cookiepath=cookie_nexsci, outpath=query_result_file)
num_lines = countlines(query_result_file) - 1
println("# Query resulted in file with ", num_lines, " entries.")

#= If you want to parse the file
using CSV, DataFrames
if (@isdefined CSV) && (@isdefined DataFrames)
 df = CSV.read(query_result_file, DataFrame)
 nfiles = size(df,1)
 @assert nfiles >= 1
end
=#
