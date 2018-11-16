#!/usr/bin/env julia

using   Plots,        # for plotting
        PlotThemes,   # to theme plots - :dark, :wong, :lime
        ProgressBar,  # just for lulz
        StatsBase     # histogram

gr();   # set the plot backend; for publication figures, use pgfplots.  GR is a nice quick framework that just works.


# ordinary differential equation of diffusion:
# ∂Ψ/∂t = D⋅∂²Ψ/∂x²
# ⟹ Ψ = cos(ax)⋅exp(bt) such that a = Db

# change to stochastic
# ∂Ψ/∂t = D⋅∂²Ψ/∂x² + ⅊
# where ⅊ is noise
# can only be solved analytically

a = 1;
b = 1;
