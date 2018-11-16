#!/usr/bin/env julia
# add flags: -O3 --compile=all

using   Plots,        # for plotting
        PlotThemes,   # to theme plots - :dark, :wong, :lime
        ProgressMeter,  # just for lulz
        StatsBase     # histogram

function main()

    gr();   # set the plot backend; for publication figures, use pgfplots.  GR is a nice quick framework that just works.


    # ordinary differential equation of diffusion:
    # ∂Ψ/∂t = D⋅∇²Ψ
    # in one dimension:
    # ∂Ψ/∂t = D⋅∂²Ψ/∂x²
    # ⟹ Ψ = cos(ax)⋅exp(bt) such that a = Db

    # change to stochastic where ⅊ is noise:
    # ∂Ψ/∂t = D⋅∂²Ψ/∂x² + ⅊
    # can only be solved analytically, use Runge-Kutta 4 or Euler's method.

    a = 1;
    b::Int = 1;

end
