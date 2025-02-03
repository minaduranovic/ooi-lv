using JuMP, GLPK;

m = Model(GLPK.Optimizer);

@variable(m, x12>=0, x12<=10);

@objective(m, Min, 2x12);

@constraint(m, constraint, x12>=5);