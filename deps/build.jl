ENV["PYTHON"] = ""
using Pkg
Pkg.build("PyCall")

using Conda
env = Conda.ROOTENV
Conda.pip_interop(true, env)
Conda.pip("install", "pyneid")
