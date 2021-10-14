""" Julia interface to the PyNeid API for accessing the NEID archive at NExScI """
__precompile__()
module NeidArchive
  using PyCall
  using Dates
  #using CSV, DataFrames

  const PyNeid = PyNULL()
  const archive = PyNULL()
  const valid_datalevel = [ "l0", "l1", "l2", "eng", "solarl0", "solarl1", "solarl2", "solareng"]
  const valid_format = [ "ipac", "votable", "csv", "tsv"]
  const default_format = "csv"
  const datefmt = DateFormat("yyyy-mm-dd HH:MM:SS")

  function __init__()
      copy!(PyNeid, pyimport("pyneid.neid"))
      copy!(archive, PyNeid.Neid)
  end

  #= Broken:  Code doesn't get an updated token.
  function login(;userid::String, password::String, token::String)
    neid.login(userid=userid, password=password, token=token)
    return token
  end
  =#

  """
      login(;userid, password, cookiepath)
  Login to the NEID archive at NExScI.  All three named arguments are required.  Login credentials stored in cookiepath.
  """
  function login(;userid::String, password::String, cookiepath::String)
    archive.login(userid=userid, password=password, cookiepath=cookiepath) #, debugfile="./archive.debug")
  end

  """
      query_criteria(param::Dict{String,String}; cookiepath, [outpath] )
  Query the NEID archive using constraints in param.  Named argument cookiepath is required.
  """
  function query_criteria(param::Dict{String,String}; cookiepath::String, outpath::String=".", format::String = default_format)
    archive.query_criteria(param, cookiepath=cookiepath, format=format, outpath=outpath)
  end

  """
      query(param::Dict{String,String}; cookiepath, [outpath] )
  Shorthaned for query_criteria """
  query = query_criteria

# TODO: Implement query_adql, query_datetime, query_object, query_piname, query_program, query_qobject


  """
      download(filename, datalevel; cookiepath, [format, outdir, start_row, end_row] )
  Download files returned from a query of the NEID archive.
  Named argument cookiepath is required.
  """
  function download(filename::String, datalevel::String; format::String = default_format, outdir::String=".", cookiepath::String = "", start_row::Integer=0, end_row::Integer=1000)
    @assert datalevel ∈ valid_datalevel
    @assert format ∈ valid_format
    @assert 0 <= start_row <= end_row
    @assert end_row-start_row <= 10000

    if length(cookiepath) >= 1
      archive.download(filename, datalevel, format, outdir, cookiepath=cookiepath, start_row=start_row, end_row=end_row)
    else
      archive.download(filename, datalevel, format, outdir, start_row=start_row, end_row=end_row)
    end
  end

  #=
  # TODO: See if there's a clever way to pass all extra optional args to pyneid.  Maybe something like
  function download(filename::String, datalevel::String; format::String = default_format, outdir::String="."), kwargs...)
    archive.download(filename, datalevel, format, outdir, kwargs...)
  end
  =#


  """ Create a date range string in PyNeid format from start to stop."""
  function datetime_range(start::DateTime, stop::DateTime)
    Dates.format(start,datefmt) * "/" * Dates.format(stop,datefmt)
  end

  function datetime_range(start::Date, stop::Date)
    datetime_range(DateTime(start), DateTime(year(stop),month(stop),day(stop),23,59,59))
  end

  """ Create a date range string in PyNeid format for one day."""
  function datetime_one_day(day::Date)
    datetime_range(day, day)
  end

  """ Create a date range string in PyNeid format for 24 hours starting at given DateTime."""
  function datetime_one_day(start::DateTime)
    datetime_range(start, start+Dates.Day(1))
  end

  """ Create a date range string in PyNeid format for 24 hours starting at 15:00 on given Date."""
  function datetime_one_day_solar(start::Date)
    datetime_one_day(DateTime(start)+Dates.Hour(15))
  end

  """ Create a date range string in PyNeid format starting at 00:00:00 on start date."""
  function datetime_range_after(start::DateTime )
    Dates.format(start,datefmt) * "/"
  end

  function datetime_range_after(start::Date )
    datetime_range_after(DateTime(start))
  end

  """ Create a date range string in PyNeid format ending at 23:59:59 on stop date."""
  function datetime_range_before(stop::DateTime)
    datetime_range_before(DateTime(year(stop),month(stop),day(stop),23,59,59))
  end

end
