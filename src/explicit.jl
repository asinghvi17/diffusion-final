# The explicit heat diffusion solver uses a forward-time, centered-space method to obtain a recurrence equation for the temperature at

include.(["h.jl"])

"""
    step_1s_p(arr)

This function will step a periodic array of Blocks in one spatial dimension by 1 time-increment.
It assumes that arr is periodic, i.e., that the neighbours of arr[end] are arr[end-1] and arr[1].
It will iterate from 1 to the end of the array.
"""
function step_1s_p(
    arr
    )

    k = 1
    h = 1
    r = k/h^2
    ret = deepcopy(arr); # copy the contents of arr into ret, to avoid len(arr) constructor calls
    lA0 = length(arr) - 1

    for i ∈ 0:1:(lA0)
        k = (1-2*r)*arr[i + 1].Q + r*arr[((i - 1) % lA0) + 1].Q + r*arr[((i + 1) % lA0) + 1].Q
    end

    return ret.data
end

# Begin test section - remove this after done

# a = [Block(1, 1), Block(0, 1), Block(0, 1), Block(0, 1), Block(0, 1), Block(0, 1)]
# b = deepcopy(a)
# for i in 1:10
#     print(map(x -> Base.string(x.Q/x.D)*" ", a))
#     a = step_1s_p(a)
# end
