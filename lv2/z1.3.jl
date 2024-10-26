using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 3x1+2x2)

@constraint(m, constraint1, 0.5x1+0.25x2<=12)
@constraint(m, constraint2, 500x1-200x2<=3000)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
objective_value(m)
value(constraint1)
value(constraint2)
