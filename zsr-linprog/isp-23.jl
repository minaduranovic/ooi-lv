# graficki 
using JuMP, GLPK;|

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 2x1+5x2)

@constraint(m, constraint1, -0.5x1+x2<=20)
@constraint(m, constraint2, -0.25x1+x2 <= 100)



optimize!(m)

termination_status(m)
value(x1)
value(x2)


objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)
value(constraint4)