# UFFFiles.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://maucejo.github.io/UFFFiles.jl/)
[![Generic badge](https://img.shields.io/badge/Version-1.1.0-cornflowerblue.svg)]()
[![MIT License](https://img.shields.io/badge/License-MIT-forestgreen)](https://github.com/maucejo/elsearticle/blob/main/LICENSE)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![DispatchDoctor](https://img.shields.io/badge/%F0%9F%A9%BA_tested_with-DispatchDoctor.jl-blue?labelColor=white)](https://github.com/MilesCranmer/DispatchDoctor.jl)

A Julia package for reading and writing Universal File Format (UFF) files, commonly used in engineering applications.

> [Notes]
> The basic read and write functionality has been tested.
>
> Unit conversions are being done on an as needed basis, please submit a PR (with tests) for your particular needs.

## Installation

Install `UFFFiles.jl` via Julia's package manager:

```julia
import Pkg
Pkg.add("UFFFiles")
```

or

```julia
(Yourenv) pkg> add UFFFiles
```

## Basic usage

```julia
using UFFFiles

data = readuff("path/to/your/file.uff")
writeuff("path/to/save/file.uff", data)
```

## Helper functions

- Converting units to SI `convert_to_si(data)`

- Convert a series of similar datasets to a matrix (for datasets 55 or 58) `collect_to_mat(data)`

## Supported formats

Currently, `UFFFiles.jl` supports reading and writing UFF files with the following blocks:

- Dataset 15
- Dataset 18
- Dataset 55
- Dataset 58
- Dataset 82
- Dataset 151
- Dataset 164
- Dataset 1858
- Dataset 2411
- Dataset 2412
- Dataset 2414

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

MIT licensed

Copyright (C) 2025 Mathieu AUCEJO (maucejo)
