# Fabrika koja proizvodi tri proizvoda od tri sirovine  P1, P2, P3 - S1, S2, S3

using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)
@variable(m, x3>=0)

@objective(m, Max, 2x1+3x2+x3)

@constraint(m, constraint1, 2x1+2x2+2x3<=4)
@constraint(m, constraint2, 3x1+3x2<=2)
@constraint(m, constraint3, x2+x3<=3)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
value(x3)
objective_value(m)
value(constraint1)
value(constraint2)
value(constraint3)