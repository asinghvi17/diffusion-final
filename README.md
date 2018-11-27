# Diffusion

## CMPT 260 Final Project

### Anshul Singhvi

#### Language - Julia

# Broad goals

Explore heat diffusion

Examine them for stability (or not)

Implement a diffusion animator

# Formulae

∂Ψ/∂t = D⋅∇²Ψ

Ψ = cos(ax)⋅eᵇᵗ

∂Ψ/∂t = D⋅∂²Ψ/∂x² + ℽ (where ℽ is the noise term)

# Method

Solve numerically, using RK4 or other methods

Use a 'cell method' for 2 or 3 dimensions, where the material is discretized into 'cells', described by structs with material properties.  Or, continuously sample from functions - more computationally intensive, though.


Store data using the Julia Plots.jl backend HDF5, which writes data into a file that can be easily plotted later.
