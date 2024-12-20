using JuMP, GLPK;
#  b)  dodato ogranicenje 
m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 3x1+2x2)

@constraint(m, constraint1, x1+2x2<=85)
@constraint(m, constraint2, 2x1+x2 <= 50)

optimize!(m)

value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)




#  c)  dodato ogranicenje 
m = Model(GLPK.Optimizer)

@variable(m, x1>=0)
@variable(m, x2>=0)

@objective(m, Max, 3x1+2x2)

@constraint(m, constraint1, x1+2x2<=40)
@constraint(m, constraint2, 2x1+x2 <= 117)

optimize!(m)

value(x1)
value(x2)

objective_value(m)
value(constraint1)
value(constraint2)


