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
        DifferentialEquations     # diffyq solve


# define Cell struct and methods related to it.
mutable struct Block{T}

    Q :: T   # heat

    D :: T   # positive nonzero - heat capacity of that material

end

# This recipe governs the value that Plots.jl will extract out of a Block object.

@recipe f(::Type{Block}, b::Block) = b.Q/b.D

struct CircularArray{T} <: AbstractArray{T,1}
    data::AbstractArray{T,1}
end

circindex(i::Int,N::Int) = 1 + mod(i-1,N)
circindex(I,N::Int) = [circindex(i,N)::Int for i in I]

Base.size(A::CircularArray) = size(A.data)

Base.getindex(A::CircularArray, i::Int) = getindex(A.data, circindex(i,length(A.data)))
Base.getindex(A::CircularArray, I) = getindex(A.data, circindex(I,length(A.data)))

Base.setindex!(A::CircularArray, v, i::Int) = setindex!(A.data, v, circindex(i,length(A.data)))
Base.setindex!(A::CircularArray, v, I) = setindex!(A.data, v, circindex(I,length(A.data)))
