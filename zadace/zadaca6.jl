using JuMP, GLPK;
m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)
@variable(m, x3>=0)


@objective(m, Max, 3x1+2x2+5x3)

@constraint(m, constraint1, x1+2x2 +x3<=450)
@constraint(m, constraint2, 3x1+2x3 <= 460)
@constraint(m, constraint3, x1+4x2 <= 400)


optimize!(m)

value(x1)
value(x2)
value(x3)

objective_value(m)
value(constraint1)
value(constraint2)

