include.(["../src/explicit.jl"])

a = [Block(1, 1), Block(0, 1), Block(0, 1), Block(0, 1), Block(0, 1), Block(0, 1)]
b = deepcopy(a)
for i in 1:10
    print(Base.string(map(x -> Base.string(x.Q/x.D)*" ", a)))
    a = step_1s_p(a)
end
