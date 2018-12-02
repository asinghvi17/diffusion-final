# The explicit heat diffusion solver uses a forward-time, centered-space method to obtain a recurrence equation for the temperature at

include.(["h.jl"])

function doVariableDirichlet(
    # DEFAULT ARGS
    xm,        # the max position (position goes from 0 to sm)
    Δx,        # the space step
    tm,        # the max time (time goes from 0 to tm)
    Δt,        # the time step
    b;         # the initial distribution
    # KWARGS
    Tl = 10,           # the temperature on the leftmost node, a Dirichlet boundary condition
    Tr = 10,           # the temperature on the rightmost node, a Dirichlet boundary condition
    anim_func = Plots.gif
    )

    nx = length(0:Δx:xm)         # the dimension of the matrix

    ds = ones(nx-1)
    di = ds
    dm = ones(nx)*(-2)

    M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights

    K = Diagonal([x.D*Δt/Δx^2 for x ∈ b])

    A = K*M + I                                # matrix of the k-independent weights

    A[1, 1] = x -> x.T
    A[end, end] = x -> x.T

    # THe definition of the A matrix is now complete.

    # Now, we can proceed to defining the vectors.
    # x is the vector of temperatures at time=n+1
    # b is the vector of temperatures at time=n.

    # implement boundary contitions
    b[1].T   = Tl
    b[end].T = Tr

    anim = @animate for i ∈ 0:Δt:tm
        x = A * b
        b = x
        b[1].T   = Tl
        b[end].T = Tr
        p = scatter(
        0:Δx:xm, b,
        title = "t=$(string(i)[1:min(end, 4)])",
        xlabel="x",
        ylabel="T",
        ylims = (0, max(Tl, Tr) + 1)
        )
    end

    p = anim_func(anim, "lol", fps=30)

end

b = [Block(0, 0.01*i) for i ∈ 1:nx]

doVariableDirichlet()
