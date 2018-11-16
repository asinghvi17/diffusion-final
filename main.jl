#!/usr/bin/env julia

# add flags: -O3 --compile=all

###
# ordinary differential equation of diffusion:
# ∂Ψ/∂t = D⋅∇²Ψ
# in one dimension:
# ∂Ψ/∂t = D⋅∂²Ψ/∂x²
# ⟹ Ψ = cos(ax)⋅eᵇᵗ such that a = Db

# change to stochastic where ⅊ is noise:
# ∂Ψ/∂t = D⋅∂²Ψ/∂x² + ⅊
# can only be solved analytically, use Runge-Kutta 4 or Euler's method.
###
using   Plots,                    # for plotting
        PlotThemes,               # to theme plots - :dark, :wong, :lime
        ProgressMeter,            # just for lulz
        StatsBase,                # histogram
        DifferentialEquations     # diffyq solve

function Ψ(x, t, a=1, b=1, D=1)
    cos(a*x)*exp(b*t)
end

function main()

    gr();   # set the plot backend; for publication figures, use pgfplots.
            # GR is a nice quick framework that just works.
    a::Int = 1; # constant in cosine
    b::Int = 1; # constant in exponential
    D::Int = 2; # diffucion constant

end
