function max_flow(C)
    n = size(C, 1)
    model = Model(GLPK.Optimizer)
    
    @variable(model, flow[1:n, 1:n] >= 0, Int)  
    @objective(model, Max, sum(flow[1, j] for j in 2:n)) 
    
    for i in 1:n
        for j in 1:n
            if i != j
                @constraint(model, flow[i, j] <= C[i, j])
            end
        end
    end
    
    for i in 2:n-1
        @constraint(model, sum(flow[j, i] for j in 1:n if j != i) == sum(flow[i, j] for j in 1:n if j != i))
    end
    
    optimize!(model)
    
    X = round.(Int, value.(flow)) 
    V = objective_value(model)
    
    return X, V
end
