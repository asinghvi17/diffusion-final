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

We solve the one-dimensional case numerically, using a backward-time centered-space 'implicit' method of solving a system.  Currently, only the Dirichlet, one-dimensional case has been implemented.

The two-dimensional case is planned for the ω release, but since we are currently on version `dVersion`, it is being neglected.  The method, however, is simple - it is an extension, in fact, of the one-dimensional case - as is the three-dimensional case, although this has vast memory requirements.

As for plotting, it is planned to store the plots in the `.hdf5` format to allow for easy replotting.

# Terminology

A *Dirichlet boundary condition* is a boundary condition that forces the temperature on the edges of a system to be a certain value.  

A *Neumann boundary condition* is a boundary condition that forces the flux on the edges of a system to be a certain value, i.e., that there is a constant flow of heat outwards.  
