using NeidArchive
using Documenter

DocMeta.setdocmeta!(NeidArchive, :DocTestSetup, :(using NeidArchive); recursive=true)

makedocs(;
    modules=[NeidArchive],
    authors="Eric Ford",
    repo="https://github.com/RvSpectML/NeidArchive.jl/blob/{commit}{path}#{line}",
    sitename="NeidArchive.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://RvSpectML.github.io/NeidArchive.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/RvSpectML/NeidArchive.jl",
    devbranch="main",
)
