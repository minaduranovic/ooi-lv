# Fabrika proizvodi dva proizvoda od jedne sirovine

using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 3x1+7x2)

@constraint(m, constraint1, 0.25x1+0.75x2<=20)
@constraint(m, constraint2, x1<=10)
@constraint(m, constraint3, x2<=9)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
objective_value(m)
value(constraint1)
value(constraint2)