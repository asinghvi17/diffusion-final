# The implicit heat diffusion solver uses a backward-time, centered-space method to obtain a recurrence equation which must be solved.

include.(["h.jl"])

function getT(x::Block1D)
    x.T
end

function simulate( # Ladri di dirichlette
                    # DEFAULT ARGS
                    bb,                        # the initial distribution
                    tm::Real,                  # the max time (time goes from 0 to tm)
                    Δt::Real,                  # the time step
                    bl::Real,                  # numerical value of left BC
                    tbl::Symbol,               # type of left BC - :flux or :temp
                    br::Real,                  # numerical value of right BC
                    tbr::Symbol;               # type of right BC - :flux or :temp
                    # KWARGS
                    anim_func = Plots.gif,
                    fname::String = "lolnv.gif",
                    fps::Int = 30,
                    nf::Int = 1,
                    )

    if !(tbl ∈ (:flux, :temp)) || !(tbr ∈ (:flux, :temp))
        return "Lol noob"
    end

    nx = length(bb)         # the dimension of the matrix

    xs = zeros(length(bb))
    for i in 2:length(bb)
        xs[i] = bb[i].Δx + xs[i-1]
    end

    ds = ones(nx-1)*-1
    di = deepcopy(ds)
    dm = ones(nx)*(2)

    M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights

    K = Diagonal((B -> B.D*Δt/B.Δx^2).(bb))

    A = K*M + I                                # matrix of the k-independent weights

    # THe definition of the A matrix is now complete.

    # Now, we can proceed to defining the vectors.
    # x is the vector of temperatures at time=n+1
    # b is the vector of temperatures at time=n.

    # implement boundary contitions

    b = getT.(bb)

    ymax = maximum(b)
    ymin = minimum(b)

    if tbr == :temp
        ymax = max(ymax, br)
        ymin = max(ymin, br)
        A[end, end] = 1
    else
        A[end, end-1] *= 2
    end
    if tbl == :temp
        ymax = max(ymax, bl)
        ymin = max(ymin, bl)
        A[1, 1] = 1
    else
        A[1, 2] *= 2
    end

    pm = Progress(length(0:Δt:tm), desc="Animating", )

    anim = @animate for i ∈ 0:Δt:tm

        if tbl == :flux
            Lc = 2*bb[1].Δx*bl/b[1]
        else
            Lc = 0
        end

        if tbr == :flux
            Rc = 2*bb[end].Δx*br/b[end]
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
        xs, b,
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

a = [Block1D(20.0, 0.01, 0.1) for i ∈ 1:length(0:0.1:25)]

for i in 63:187
    a[i].T = 30
end

simulate(a, 500.0, 0.1, .1, :flux, 20, :temp, nf = 50, fname="lolnvf.gif")
