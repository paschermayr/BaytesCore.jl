using BaytesCore
using Documenter

DocMeta.setdocmeta!(BaytesCore, :DocTestSetup, :(using BaytesCore); recursive=true)

makedocs(;
    modules=[BaytesCore],
    authors="Patrick Aschermayr <p.aschermayr@gmail.com>",
    repo="https://github.com/paschermayr/BaytesCore.jl/blob/{commit}{path}#{line}",
    sitename="BaytesCore.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://paschermayr.github.io/BaytesCore.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Introduction" => "intro.md",
    ],
)

deploydocs(;
    repo="github.com/paschermayr/BaytesCore.jl",
    devbranch="gh-pages",
)
