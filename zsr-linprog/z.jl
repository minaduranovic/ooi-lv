using JuMP, GLPK;|

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 30x1+25x2)

@constraint(m, constraint1, x1+5x2>=25)
@constraint(m, constraint2, 2x1+x2 <=10)


optimize!(m)

termination_status(m)
value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)
