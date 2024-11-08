using JuMP, GLPK;|

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)
@variable(m, x3>=0)


@objective(m, Max, 20x1+19x2+19x3)

@constraint(m, constraint1, 0.05x1+0.01x2+0.01x3<=93)
@constraint(m, constraint2, 17x1+18x2+18x3<=54803)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
value(x3)
objective_value(m)
value(constraint1)
value(constraint2)
