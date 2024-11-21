using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Min, 0.45x1+0.46x2)

@constraint(m, constraint1, 0.25x1+0.15x2<=7.9)
@constraint(m, constraint2, 0.55x1+0.55x2 == 2.36)
@constraint(m, constraint3, 0.65x1+0.45x2>=2.36)

optimize!(m)

value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)


