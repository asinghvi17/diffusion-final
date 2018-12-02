# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#         Version 2, December 2004
#
# Copyright (C) 2018 Anshul Singhvi <asinghvi17@simons-rock.edu>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.


# This file essentially wraps all the imports in a separate file.

# load packages

using   Plots,                    # for plotting
        PlotThemes,               # to theme plots - :dark, :wong, :lime
        ProgressMeter,            # just for lulz
        StatsBase,                # histogram
        LinearAlgebra,            # to solve the matrix equations
        SymPy                     # for them symbols

gr() # set Plots.jl backend

# define Cell struct and methods related to it.
mutable struct Block{T}

    T :: T   # temperature

    D :: T   # diffusivity of the material

end

# This recipe governs the value that Plots.jl will extract out of a Block object.

@recipe f(::Type{Block}, b::Block) = b.T

# This governs what happens when a Block object is multiplied by a value of type Symbolic

Base.zero(::Type{Symbol}) = x -> 0
