include.(["../src/external.jl"])

a = [Block(1, 1), Block(0, 1), Block(0, 1), Block(0, 1), Block(0, 1), Block(0, 1)]

for i in 1:10
    print(string(map(x -> string(x.Q/x.D)*" ", a)))
    a = step_1s_p(a)
end
