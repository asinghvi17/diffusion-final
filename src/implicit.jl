# The implicit heat diffusion solver uses a backward-time, centered-space method to obtain a recurrence equation which must be solved.

include.(["h.jl"])

# We will deal with matrices, since they are better to use and express this kind of thing more simply.
# We begin by defining the matrix A, which will serve as the weight matrix for our system.

function doDirichlet(
    # DEFAULT ARGS
    xm,        # the max position (position goes from 0 to sm)
    Δx,        # the space step
    tm,        # the max time (time goes from 0 to tm)
    Δt;        # the time step
    # KWARGS
    D = 0.05,          # the thermal diffusivity of the medium
    Tl = 10,           # the temperature on the leftmost node, a Dirichlet boundary condition
    Tr = 10,           # the temperature on the rightmost node, a Dirichlet boundary condition
    b = zeros(Int(xm / Δx)) # the initial distribution
    )

    r = D*Δt/Δx^2     # the constant of implicit difference - should be less than one half for best results.
    nx = length(0:Δx:xm)         # the dimension of the matrix

    ds = -1*ones(nx-1)*r
    di = ds
    dm = ones(nx)*(1+2*r)

    A = Tridiagonal(ds, dm, di)


    A[1, 1] = 1
    A[end, end] = 1

    # THe definition of the A matrix is now complete.

    # Now, we can proceed to defining the vectors.
    # x is the vector of temperatures at time=n+1
    # b is the vector of temperatures at time=n.

    b = zeros(nx, 1)
    # implement boundary contitions
    b[1]   = Tl
    b[end] = Tr

    anim = @animate for i ∈ 0:Δt:tm
        x = A \ b
        b = x
        b[1]   = Tl
        b[end] = Tr
        p = scatter(
        0:Δx:xm, b,
        title = "t=$(string(i)[1:min(end, 4)])",
        xlabel="x",
        ylabel="T",
        ylims = (0, max(Tl, Tr) + 1)
        )
    end

    p = gif(anim, "lol.gif", fps=30)

end

doDirichlet(2.5, 0.1, 20, 0.1, D = 0.01, Tl = 3, Tr = 4)
