ENV["PYTHON"] = ""
using Pkg
Pkg.build("PyCall")

using Conda
pipcmd = joinpath(Conda.PYTHONDIR,"pip")
run(`$pipcmd install pyneid`)

#=
env = Conda.ROOTENV
Conda.pip_interop(true, env)
Conda.pip("install", "pyneid")
=#

