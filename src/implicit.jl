# The implicit heat diffusion solver uses a backward-time, centered-space method to obtain a recurrence equation which must be solved.

include.(["h.jl"])

# We will deal with matrices, since they are better to use and express this kind of thing more simply.
# We begin by defining the matrix A, which will serve as the weight matrix for our system.

# function doDirichlet(
#     # DEFAULT ARGS
#     xm,        # the max position (position goes from 0 to sm)
#     Δx,        # the space step
#     tm,        # the max time (time goes from 0 to tm)
#     Δt;        # the time step
#     # KWARGS
#     D = 0.05,          # the thermal diffusivity of the medium
#     Tl = 10,           # the temperature on the leftmost node, a Dirichlet boundary condition
#     Tr = 10,           # the temperature on the rightmost node, a Dirichlet boundary condition
#     b = zeros(Int(xm / Δx) + 1), # the initial distribution
#     anim_func = Plots.gif
#     )
#
#     r = D*Δt/Δx^2     # the constant of implicit difference - should be less than one half for best results.
#     nx = length(0:Δx:xm)         # the dimension of the matrix
#
#     ds = -1*ones(nx-1)*r
#     di = ds
#     dm = ones(nx)*(1+2*r)
#
#     A = Tridiagonal(ds, dm, di)
#
#
#     A[1, 1] = 1
#     A[end, end] = 1
#
#     # THe definition of the A matrix is now complete.
#
#     # Now, we can proceed to defining the vectors.
#     # x is the vector of temperatures at time=n+1
#     # b is the vector of temperatures at time=n.
#
#     b = zeros(nx, 1)
#     # implement boundary contitions
#     b[1]   = Tl
#     b[end] = Tr
#
#     anim = @animate for i ∈ 0:Δt:tm
#         x = A \ b
#         b = x
#         b[1]   = Tl
#         b[end] = Tr
#         p = scatter(
#         0:Δx:xm, b,
#         title = "t=$(string(i)[1:min(end, 4)])",
#         xlabel="x",
#         ylabel="T",
#         ylims = (0, max(Tl, Tr) + 1)
#         )
#     end
#
#     p = anim_func(anim, "lolc.gif", fps=30)
#
# end
#
# doDirichlet(2.5, 0.1, 50, 0.1, D = 0.01, Tl = 3, Tr = 4)
#
# function doVariableDirichlet( # Ladri di dirichlette
#     # DEFAULT ARGS
#     xm,        # the max position (position goes from 0 to sm)
#     Δx,        # the space step
#     tm,        # the max time (time goes from 0 to tm)
#     Δt,        # the time step
#     bb;         # the initial distribution
#     # KWARGS
#     Tl = 10,           # the temperature on the leftmost node, a Dirichlet boundary condition
#     Tr = 10,           # the temperature on the rightmost node, a Dirichlet boundary condition
#     anim_func = Plots.gif,
#     fname = "lolv.gif",
#     fps = 30,
#     nf = 1
#     )
#
#     nx = length(0:Δx:xm)         # the dimension of the matrix
#
#     ds = ones(nx-1)*-1
#     di = ds
#     dm = ones(nx)*(2)
#
#     M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights
#
#     K = Diagonal([x.D*Δt/Δx^2 for x ∈ bb])
#
#     A = K*M + I                                # matrix of the k-independent weights
#
#     A[1, 1] = 1
#     A[end, end] = 1
#
#     # THe definition of the A matrix is now complete.
#
#     # Now, we can proceed to defining the vectors.
#     # x is the vector of temperatures at time=n+1
#     # b is the vector of temperatures at time=n.
#
#     # implement boundary contitions
#
#     b = map(x -> x.T, bb)
#
#     b[1]   = Tl
#     b[end] = Tr
#
#     ymax = maximum(b)
#     ymin = minimum(b)
#
#     anim = @animate for i ∈ 0:Δt:tm
#         x = A \ b
#         b = x
#         b[1]   = Tl
#         b[end] = Tr
#         p = scatter(
#         0:Δx:xm, b,
#         title = "t=$(string(i)[1:min(end, 4)])",
#         xlabel="x",
#         ylabel="T",
#         legend=:none,
#         ylims = (ymin-1, ymax+1)
#         )
#     end every nf
#
#     p = anim_func(anim, fname, fps=fps)
#
# end
#
#
# a = [Block(20.0, 0.01) for i ∈ 1:length(0:0.1:2.5)]
#
# for i in 9:17
#     a[i].T = 30
# end
#
# doVariableDirichlet(2.5, 0.1, 500, 0.1, a, Tl = 10, Tr = 10)
#
# function doVariableNeumann( # Ladri di dirichlette
#     # DEFAULT ARGS
#     xm,        # the max position (position goes from 0 to sm)
#     Δx,        # the space step
#     tm,        # the max time (time goes from 0 to tm)
#     Δt,        # the time step
#     bb;        # the initial distribution
#     # KWARGS
#     anim_func = Plots.gif,
#     fname = "lolnv.gif",
#     fps = 30,
#     nf = 1,
#     αl = 0,
#     αr = 0
#     )
#
#     nx = length(0:Δx:xm)         # the dimension of the matrix
#
#     ds = ones(nx-1)*-1
#     di = deepcopy(ds)
#     dm = ones(nx)*(2)
#
#     M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights
#
#     K = Diagonal([x.D*Δt/Δx^2 for x ∈ bb])
#
#     A = K*M + I                                # matrix of the k-independent weights
#
#     A[1, 2] *= 2
#     A[end, end-1] *= 2
#
#     # THe definition of the A matrix is now complete.
#
#     # Now, we can proceed to defining the vectors.
#     # x is the vector of temperatures at time=n+1
#     # b is the vector of temperatures at time=n.
#
#     # implement boundary contitions
#
#     b = map(x -> x.T, bb)
#
#     ymax = maximum(b)
#     ymin = minimum(b)
#
#     pm = Progress(length(0:Δt:tm), desc="Animating", )
#
#     anim = @animate for i ∈ 0:Δt:tm
#
#         Lc = 2*Δx*αl/b[1]
#         Rc = 2*Δx*αr/b[end]
#
#         A[1, 1]     += Lc      # use the boundary conditions, luke
#         A[end, end] +=  Rc     # use the boundary conditions, warm
#
#         x = A \ b
#         b = x
#
#         A[1, 1]     -= Lc      # remove the boundary conditions, luke
#         A[end, end] -=  Rc     # remove the boundary conditions, warm
#
#         p = scatter(
#         0:Δx:xm, b,
#         title = "t=$(string(i)[1:min(end, 4)])",
#         xlabel="x",
#         ylabel="T",
#         legend=:none,
#         ylims = (ymin-1, ymax+1)
#         )
#         next!(pm)
#     end every nf
#
#     p = anim_func(anim, fname, fps=fps)
#
# end
#
# a = [Block(20.0, 0.01*i) for i ∈ 1:length(0:0.1:2.5)]
#
# for i in 9:17
#     a[i].T = 30
# end
#
# doVariableNeumann(2.5, 0.1, 500, 0.1, a, αl = .1, αr = .1)
#
# doVariableNeumann(2.5, 0.1, 500, 0.1, a, αl = .1, αr = .1, nf = 1)

function simulate( # Ladri di dirichlette
                    # DEFAULT ARGS
                    xm::Real,        # the max position (position goes from 0 to sm)
                    Δx::Real,        # the space step
                    tm::Real,        # the max time (time goes from 0 to tm)
                    Δt::Real,        # the time step
                    bb::Real,        # the initial distribution
                    bl::Real,        # numerical value of left BC
                    br::Real,        # numerical value of right BC
                    tbl::Symbol,     # type of left BC - :flux or :temp
                    tbr::Symbol;     # type of right BC - :flux or :temp
                    # KWARGS
                    anim_func = Plots.gif,
                    fname::String = "lolnv.gif",
                    fps::Int = 30,
                    nf::Int = 1,
                    )

    if !(tbl ∈ (:flux, :temp)) || !(tbr ∈ (:flux, :temp))
        return "Lol noob"
    end

    nx = length(0:Δx:xm)         # the dimension of the matrix

    ds = ones(nx-1)*-1
    di = deepcopy(ds)
    dm = ones(nx)*(2)

    M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights

    K = Diagonal([x.D*Δt/Δx^2 for x ∈ bb])

    A = K*M + I                                # matrix of the k-independent weights

    if tbl == :temp
        A[1, 1] = 1
    else
        A[1, 2] *= 2
    end

    if tbr == :temp
        A[end, end] = 1
    else
        A[end, end-1] *= 2
    end

    # THe definition of the A matrix is now complete.

    # Now, we can proceed to defining the vectors.
    # x is the vector of temperatures at time=n+1
    # b is the vector of temperatures at time=n.

    # implement boundary contitions

    b = map(x -> x.T, bb)

    ymax = maximum(b)
    ymin = minimum(b)

    if tbr == :temp
        ymax = max(ymax, tbr)
        ymin = max(ymin, tbr)
    end
    if tbl == :temp
        ymax = max(ymax, tbl)
        ymin = max(ymin, tbl)
    end

    pm = Progress(length(0:Δt:tm), desc="Animating", )

    anim = @animate for i ∈ 0:Δt:tm

        if tbl == :flux
            Lc = 2*Δx*bl/b[1]
        else
            Lc = 0
        end

        if tbr == :flux
            Rc = 2*Δx*br/b[end]
        else
            Rc = 0
        end


        A[1, 1]     += Lc      # use the boundary conditions, luke
        A[end, end] +=  Rc     # use the boundary conditions, warm

        x = A \ b
        b = x

        if tbl == :flux
            A[1, 1]     -= Lc      # remove the boundary conditions, luke
        else
            b[1] = bl
        end

        if tbr == :flux
            A[end, end] -=  Rc     # remove the boundary conditions, warm
        else
            b[end] = br
        end


        p = scatter(
        0:Δx:xm, b,
        title = "t=$(string(i)[1:min(end, 4)])",
        xlabel="x",
        ylabel="T",
        legend=:none,
        # ylims = (ymin-1, ymax+1)
        )
        next!(pm)
    end every nf

    p = anim_func(anim, fname, fps=fps)

end

a = [Block(20.0, 0.01) for i ∈ 1:length(0:0.1:2.5)]

for i in 9:17
    a[i].T = 30
end

simulate(2.5, 0.1, 4000, 0.1, a, bl = .1, tbl = :flux, br = 20, tbr = :temp, nf = 10, fname="lolnvf.gif")
