using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 150x1+40x2)

@constraint(m, constraint1, x1<=10)
@constraint(m, constraint2, x2 <= 27)
@constraint(m, constraint3, 9x1+4x2<=144)

optimize!(m)

value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)


