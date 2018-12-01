# The implicit heat diffusion solver uses a backward-time, centered-space method to obtain a recurrence equation which must be solved.

include.(["h.jl"])

# """
#     step_1s_p(arr::Array{Block, 1})
#
# This function will step a periodic array of Blocks in one spatial dimension by 1 time-increment.
# It assumes that arr is periodic, i.e., that the neighbours of arr[end] are arr[end-1] and arr[1].
# It will iterate from 1 to the end of the array.
# """
# function step_1s_p(
#     arr::Array{Block, 1}
#     )
#
#     k = 1
#     h = 1
#     r = k/h^2
#     ret = deepcopy(arr); # copy the contents of arr into ret, to avoid len(arr) constructor calls
#
#     for i ∈ (length(A)-1):-1:1
#
#     end
#
# end

# We will deal with matrices, since they are better to use and express this kind of thing more simply.
# We begin by defining the matrix A, which will serve as the weight matrix for our system.

function main()
    L = 2.5             # the length of the grid
    Δx = 0.1          # the space step in one dimension
    nx = length(0:Δx:L)         # the dimension of the matrix
    tm = 100
    Δt = 0.1          # the time step

    D = 0.05          # the thermal diffusivity of the medium

    r = D*Δt/Δx^2     # the constant of implicit difference - should be less than one half for best results.

    ds = -1*ones(nx-1)*r
    di = ds
    dm = ones(nx)*(1+2*r)

    A = Tridiagonal(ds, dm, di)

    Di = Diagonal(ones(nx)*0.9)

    # Now, we will set boundary conditions.  In particular, these are Dirichlet boundary conditions, meaning that the temperature on each end is held constant.  In this case, we will chooose to set them both to a predefined temperature of 10, for simplicity's sake.

    Tl = 10
    Tr = 10

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
        x = inv(A)*Di*b
        b = x
        b[1]   = Tl
        b[end] = Tr
        p = scatter(
        0:Δx:L, b,
        title = "t=$(string(i)[1:min(end, 4)])",
        xlabel="x",
        ylabel="T",
        ylims = (0, 10.2)
        )
    end

    p = gif(anim, "lol.gif", fps=30)

end

main()
