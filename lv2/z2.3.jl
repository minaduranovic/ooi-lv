# Kompanija za proizvodnju slatkiša koja proizvodi visokokvalitetne čokoladne proizvode 

using JuMP, GLPK;

m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 2x1+4x2)

@constraint(m, constraint1, x1<=3)
@constraint(m, constraint2, x2<=6)
@constraint(m, constraint3, 3x1+2x2<=18)

print(m)

optimize!(m)

termination_status(m)

value(x1)
value(x2)
objective_value(m)
value(constraint1)
value(constraint2)

