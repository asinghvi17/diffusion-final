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
        LinearAlgebra             # to solve the matrix equations

plotlyjs() # set Plots.jl backend

import Base.*

# define Cell struct and methods related to it.
mutable struct Block1D{T <: Real}

    T :: T   # temperature

    D :: T   # diffusivity of the material

    Δx:: T   # length of the material

end

mutable struct Block2D{T <:Real}

    T :: T   # temperature

    D :: T   # diffusivity of the material

    Δx:: T   # length of the material

    Δy:: T   # length of the material

end

# This recipe governs the value that Plots.jl will extract out of a Block object.

@recipe f(::Type{Block1D}, b::Block1D) = b.T

# @recipe f(::Type{Block2D}, bb::Block2D)
#
# xs = zeros(length(bb))
# for i in 2:length(bb)
#     xs[i] = bb[i].Δx + xs[i-1]
# end
#
# ys = zeros(length(bb))
# for i in 2:length(bb)
#     ys[i] = bb[i].Δy + ys[i-1]
# end
#
#
# end

# This governs what happens when a Block object is multiplied by a value of type Symbolic

Base.zero(::Type{Symbol}) = x -> 0

# a matrix of conditions would do for this particular thing - apply the matrix to the Blocks elementwise.

struct BoundaryCondition

    val::Real

    type::Symbol

end

# now, define the behaviour of the BoundaryCOndition and Block structs

*(a::BoundaryCondition, b::Block1D{<:Real}) = begin
    if a.type ∈ (:temp, :flux)
        if a.type == :temp
            b.T = a.val
            return b
        else
            b.T -= a.val*(2*b.Δx)
            return b
        end
    else
        return b
    end
end

*(b::Block1D, a::BoundaryCondition) = Base.*(a, b)

*(a::BoundaryCondition, b::Block2D) = begin
    if a.type ∈ (:temp, :flux)
        if a.type == :temp
            b.T = a.val
            return b
        else
            b.T -= a.val*(b.Δx+b.Δy)
            return b
        end
    else
        return b
    end
end

*(b::Block2D, a::BoundaryCondition) = Base.*(a, b)
