##############################################
#  ________________________________________  #
# /  DO WHAT THE FUCK YOU WANT TO PUBLIC   \ #
# | LICENSE                                | #
# |                                        | #
# | Version 2, December 2004               | #
# |                                        | #
# | Copyright (C) 2018 Anshul Singhvi      | #
# | <asinghvi17@simons-rock.edu>           | #
# |                                        | #
# | Everyone is permitted to copy and      | #
# | distribute verbatim or modified copies | #
# | of this license document, and changing | #
# | it is allowed as long as the name is   | #
# | changed.                               | #
# |                                        | #
# | DO WHAT THE FUCK YOU WANT TO PUBLIC    | #
# | LICENSE                                | #
# |                                        | #
# | TERMS AND CONDITIONS FOR COPYING,      | #
# | DISTRIBUTION AND MODIFICATION          | #
# |                                        | #
# | 0. You just DO WHAT THE FUCK YOU WANT  | #
# \ TO.                                    / #
#  ----------------------------------------  #
#         \   ^__^                           #
#          \  (oo)\_______                   #
#             (__)\       )\/\               #
#                 ||----w |                  #
#                 ||     ||                  #
##############################################

# This file essentially wraps all the imports in a separate file.

# load packages

using   Plots,                    # for plotting
        PlotThemes,               # to theme plots - :dark, :wong, :lime
        ProgressMeter,            # just for lulz
        StatsBase,                # histogram
        LinearAlgebra             # to solve the matrix equations

import Base.*                     # to redefine multiplication behaviours for our Structs.

gr() # set Plots.jl backend


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

mutable struct BoundaryCondition

    val::Real

    type::Symbol

end

# define setter methodsa for easier mapping

function setT!(b::Block1D, T::Real)
    b.T = T
end

function setD!(b::Block1D, D::Real)
    b.D = D
end

function setΔx!(b::Block1D, Δx::Real)
    b.Δx = Δx
end

function setT!(b::Block2D, T::Real)
    b.T = T
end

function setD!(b::Block2D, D::Real)
    b.D = D
end

function setΔx!(b::Block2D, Δx::Real)
    b.Δx = Δx
end

function setΔy!(b::Block2D, Δy::Real)
    b.Δy = Δy
end

# These recipes govern the values that Plots.jl will extract out of Block objects.

@recipe f(::Type{Block1D{<:Real}}, b::Block1D{<:Real}) = b.T

@recipe f(::Type{Block1D{Float64}}, b::Block1D{Float64}) = b.T

@recipe f(::Type{Block2D{Float64}}, b::Block2D{Float64}) = b.T

# Here, we define the prototypical objects of Block, such that they can be used by Base.zeros and Base.ones

Base.zero(::Type{Block1D}) = Block1D(0, 0, 0)
Base.zero(::Type{Block2D}) = Block2D(0, 0, 0, 0)
Base.zero(::Type{Block2D{Float64}}) = Block2D(0.0, 0.0, 0.0, 0.0)


Base.zero(::Type{BoundaryCondition}) = BoundaryCondition(0, :none)

Base.one(::Type{Block1D}) = Block1D(1, 1, 1)
Base.one(::Type{Block2D}) = Block2D(1, 1, 1, 1)
Base.one(::Type{Block2D{Float64}}) = Block2D(Float64(1), Float64(1), Float64(1), Float64(1))

# now, define the multiplication behaviour of the BoundaryCondition struct

*(a::BoundaryCondition, b::Block1D{<:Real}) = begin
    if a.type ∈ (:temp, :flux)
        if a.type == :temp
            b.T = a.val
            return b
        else
            b.T = b.T - a.val*(2*b.Δx)
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
            b.T = b.T - a.val*(b.Δx+b.Δy)
            return b
        end
    else
        return b
    end
end

*(b::Block2D, a::BoundaryCondition) = Base.*(a, b)

*(a::BoundaryCondition, b::Real) = begin
    if a.type ∈ (:temp, :flux)
        if a.type == :temp
            b = a.val
            return b
        else
            b = b - a.val*2
            return b
        end
    else
        return b
    end
end

*(b::Real, a::BoundaryCondition) = *(a, b)

*(a::BoundaryCondition, b::AbstractFloat) = begin
    if a.type ∈ (:temp, :flux, :none)
        if a.type == :temp
            b = a.val
            return b
        elseif a.type == :flux
            b = b - a.val*2
            return b
        else
            return b
        end
    else
        return b
    end
end

*(b::AbstractFloat, a::BoundaryCondition) = *(a, b)

*(a::BoundaryCondition, b::Float64) = begin
    if a.type ∈ (:temp, :flux, :none)
        if a.type == :temp
            b = a.val
            return b
        elseif a.type == :flux
            b = b - a.val*2
            return b
        else
            return b
        end
    else
        return b
    end
end


*(b::Float64, a::BoundaryCondition) = *(a, b)
