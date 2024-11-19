using JuMP, GLPK;|

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Min, 200x1+300x2)

@constraint(m, constraint1, 2x1+3x2>=1200)
@constraint(m, constraint2, x1+x2 <= 400)
@constraint(m, constraint3, 2x1+1.5x2>=900)

optimize!(m)

termination_status(m)
value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)