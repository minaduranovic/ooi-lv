using JuMP, GLPK;|

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Min, 4x1-3x2)

@constraint(m, constraint1, 8x1+8x2<=7)
@constraint(m, constraint2, 7x1+6x2<=9)
@constraint(m, constraint3, 2x1+3x2<=2)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)