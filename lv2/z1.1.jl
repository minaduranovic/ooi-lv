using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 3x1+2x2)

@constraint(m, constraint1, 0.5x1+0.3x2<=150)
@constraint(m, constraint2, 0.1x1+0.2x2<=60)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
objective_value(m)
value(constraint1)
value(constraint2)