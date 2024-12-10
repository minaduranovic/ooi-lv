using JuMP, GLPK;|

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 8x1+10x2)

@constraint(m, constraint1, 0.5x1+0.5x2<=150)
@constraint(m, constraint2, 0.6x1+0.4x2 <= 145)
@constraint(m, constraint3, x2>=40)
@constraint(m, constraint4, x2<=200)


optimize!(m)

termination_status(m)
value(x1)
value(x2)


objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)
value(constraint4)