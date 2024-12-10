using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Min, 3.5x1+5.3x2)


@constraint(m, constraint1, 5.8x1+3.5x2>=358.7)
@constraint(m, constraint2, 2.5x1+0.5x2 <= 1235)
@constraint(m, constraint3, 5.5x1+4.5x2==358.7)

optimize!(m)

value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)


