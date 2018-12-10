##############################################
#  ________________________________________  #
# /  DO WHAT THE FUCK YOU WANT TO PUBLIC   \ #
# | LICENSE                                | #
# |                                        | #
# | Version 2, December 2004               | #
# |                                        | #
# | Copyright (C) 2018 Anshul Singhvi      | #
# | <asinghvi17@simons-rock.edu>           | #
# |                                        | #
# | Everyone is permitted to copy and      | #
# | distribute verbatim or modified copies | #
# | of this license document, and changing | #
# | it is allowed as long as the name is   | #
# | changed.                               | #
# |                                        | #
# | DO WHAT THE FUCK YOU WANT TO PUBLIC    | #
# | LICENSE                                | #
# |                                        | #
# | TERMS AND CONDITIONS FOR COPYING,      | #
# | DISTRIBUTION AND MODIFICATION          | #
# |                                        | #
# | 0. You just DO WHAT THE FUCK YOU WANT  | #
# \ TO.                                    / #
#  ----------------------------------------  #
#         \   ^__^                           #
#          \  (oo)\_______                   #
#             (__)\       )\/\               #
#                 ||----w |                  #
#                 ||     ||                  #
##############################################
include.(["h.jl"])

function getT(x::Block1D)
    return x.T
end

function adjustBCs(bcs, bb, Δt::Real)
    bcsa = deepcopy(bcs)
    for i ∈ 1:length(bb)   # Adapt boundary conditions since this solver doesn't natively use the Block type
        if bcsa[i].type == :flux
            bcsa[i] = BoundaryCondition(bcsa[i].val*bb[i].Δx*Δt, bcsa[i].type)
        else
            bcsa[i] = bcsa[i]
        end
    end
    return bcsa
end

function simulate( # Ladri di dirichlette
                    # DEFAULT ARGS
                    bb,                        # the initial distribution
                    tm::Real,                  # the max time (time goes from 0 to tm)
                    Δt::Real,                  # the time step
                    bcs::Array{BoundaryCondition, 1}; # the boundary conditions
                    # KWARGS
                    anim_func = Plots.gif,
                    fname::String = "lolnv.gif",
                    fps::Int = 30,
                    nf::Int = 1,
                    )

    nx = length(bb)         # the dimension of the matrix

    bcsa = adjustBCs(bcs, bb, Δt)

    b = getT.(bb)


    xs = zeros(length(b))
    for i in 2:length(b)
        xs[i] = bb[i].Δx + xs[i-1]
    end

    ds = ones(nx-1)*-1
    di = deepcopy(ds)
    dm = ones(nx)*(2)

    M = Tridiagonal(ds, dm, di)                # matrix of the k-depoendent weights

    K = Diagonal((B -> B.D*Δt/B.Δx^2).(bb))

    A = K*M + I                                # matrix of the k-independent weights

    A[1, 2] *= 2

    A[end, end-1] *= 2

    # The definition of the A matrix is now complete.

    # Now, we can proceed to defining the vectors.
    # x is the vector of temperatures at time=n+1
    # b is the vector of temperatures at time=n.

    # implement boundary contitions

    ymax = maximum(b)
    ymin = minimum(b)

    pm = Progress(length(0:Δt:tm), desc="Animating", )

    anim = @animate for i ∈ 0:Δt:tm
        x = A \ b
        b = x
        b .= b .* bcsa

        p = scatter(
        xs, b,
        title = "t=$(string(i)[1:min(end, 4)])",
        xlabel="x",
        ylabel="T",
        legend=:none,
        # ylims = (ymin-2, ymax+2)
        )
        next!(pm)
    end every nf

    p = anim_func(anim, fname, fps=fps)

end

dx = 0.1

xm = 2.5

# a = [Block1D(20.0, 0.01, 0.1) for i ∈ 1:length(0:dx:xm)]
#
# for i in 13:19
#     a[i].T = 30
# end
# xs = [0.0]
# for i ∈ a
#     append!(xs, i.Δx+sum(xs))
# end
# xs = xs[2:end]
#
# bcs = zeros(length(0:dx:xm))
#
# bcs[1] = BoundaryCondition(.1, :flux)
#
# bcs[end] = BoundaryCondition(20.0, :temp)
#
# simulate(a, 5000.0, 0.1, bcs, nf = 50, fname="lolnvfc.gif")

a = [Block1D(20.0, 0.01, 0.1) for i ∈ 1:length(0:dx:xm)]

bcs = zeros(BoundaryCondition, length(0:dx:xm))

bcs[1] = BoundaryCondition(0.2, :flux)
bcs[Int(end/2)-2] = BoundaryCondition(-0.1, :flux)
bcs[Int(end/2)+2] = BoundaryCondition(-0.1, :flux)
bcs[end] = BoundaryCondition(0.2, :flux)

simulate(a, 10000.0, 0.1, bcs, nf = 50, fname="lolnvfcpγ.gif")
