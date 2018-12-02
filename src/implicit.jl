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
    b = zeros(Int(xm / Δx) + 1), # the initial distribution
    anim_func = Plots.gif
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

    p = anim_func(anim, "lolc.gif", fps=30)

end

doDirichlet(2.5, 0.1, 50, 0.1, D = 0.01, Tl = 3, Tr = 4)

function doVariableDirichlet( # Ladri di dirichlette
    # DEFAULT ARGS
    xm,        # the max position (position goes from 0 to sm)
    Δx,        # the space step
    tm,        # the max time (time goes from 0 to tm)
    Δt,        # the time step
    bb;         # the initial distribution
    # KWARGS
    Tl = 10,           # the temperature on the leftmost node, a Dirichlet boundary condition
    Tr = 10,           # the temperature on the rightmost node, a Dirichlet boundary condition
    anim_func = Plots.gif,
    fname = "lolv.gif",
    fps = 120
    )

    nx = length(0:Δx:xm)         # the dimension of the matrix

    ds = ones(nx-1)*-1
    di = ds
    dm = ones(nx)*(2)

    M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights

    K = Diagonal([x.D*Δt/Δx^2 for x ∈ bb])

    A = K*M + I                                # matrix of the k-independent weights

    A *= 2

    A[1, 1] = 1
    A[end, end] = 1

    # THe definition of the A matrix is now complete.

    # Now, we can proceed to defining the vectors.
    # x is the vector of temperatures at time=n+1
    # b is the vector of temperatures at time=n.

    # implement boundary contitions

    b = map(x -> x.T, bb)

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

    p = anim_func(anim, fname, fps=fps)

end

doVariableDirichlet(2.5, 0.1, 300, 0.1, [Block(0.0, 0.001*i) for i ∈ 1:length(0:0.1:2.5)], Tl = 10, Tr = 10)
