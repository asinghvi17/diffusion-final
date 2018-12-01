# The implicit heat diffusion solver uses a backward-time, centered-space method to obtain a recurrence equation which must be solved.

include.(["h.jl"])

"""
    step_1s_p(arr::Array{Block, 1})

This function will step a periodic array of Blocks in one spatial dimension by 1 time-increment.
It assumes that arr is periodic, i.e., that the neighbours of arr[end] are arr[end-1] and arr[1].
It will iterate from 1 to the end of the array.
"""
function step_1s_p(
    arr::Array{Block, 1}
    )

    k = 1
    h = 1
    r = k/h^2
    ret = deepcopy(arr); # copy the contents of arr into ret, to avoid len(arr) constructor calls

    for i ∈ (length(A)-1):-1:1

    end

end
