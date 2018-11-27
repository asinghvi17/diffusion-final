# This file essentially wraps all the imports in a separate file.

# load packages

using   Plots,                    # for plotting
        PlotThemes,               # to theme plots - :dark, :wong, :lime
        ProgressMeter,            # just for lulz
        StatsBase,                # histogram
        DifferentialEquations     # diffyq solve


# define Cell struct and methods related to it.
mutable struct cell{T} <: Real

    Q :: T   # heat

    D :: T   # positive nonzero - heat capacity of that material

end

@recipe f(::Type{cell}, c::cell) = c.Q/c.D
