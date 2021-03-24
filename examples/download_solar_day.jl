using NeidArchive

include("password.jl")  # Needs to set user_nexsci and passwd_nexsci
cookie_nexsci = "./neidadmincookie.txt"
 query_result_file = "./criteria.csv"


NeidArchive.login(userid=user_nexsci, password=passwd_nexsci, cookiepath=cookie_nexsci)

using Dates
# These are not strictly necessary
using CSV, DataFrames

param = Dict{String,String}()
 param["datalevel"] = "solarl1"
 param["piname"] = "Mahadevan"
 param["object"] = "Sun"
 param["datetime"] = NeidArchive.datetime_one_day(Date(2021,1,13))
 #param["datetime"] = NeidArchive.datetime_range(Date(2021,1,13,00,0,0),Date(2021,1,15))

NeidArchive.query(param, cookiepath=cookie_nexsci, outpath=query_result_file)

if (@isdefined CSV) && (@isdefined DataFrames)
 df = CSV.read(query_result_file, DataFrame)
 nfiles = size(df,1)
 @assert nfiles >= 1
end

NeidArchive.download(query_result_file, param["datalevel"], cookiepath=cookie_nexsci, start_row=1, end_row=3)
