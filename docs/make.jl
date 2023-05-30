using HDF5Channels
using Documenter

DocMeta.setdocmeta!(HDF5Channels, :DocTestSetup, :(using HDF5Channels); recursive=true)

makedocs(;
    modules=[HDF5Channels],
    authors="Mark Kittisopikul <markkitt@gmail.com> and contributors",
    repo="https://github.com/mkitti/HDF5Channels.jl/blob/{commit}{path}#{line}",
    sitename="HDF5Channels.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mkitti.github.io/HDF5Channels.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mkitti/HDF5Channels.jl",
    devbranch="main",
)
