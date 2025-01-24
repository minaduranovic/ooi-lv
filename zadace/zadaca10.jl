using JuMP
using GLPK

function transport(C, S, P)
    num_suppliers, num_consumers = size(C)

    total_supply = sum(S)
    total_demand = sum(P)

    if total_supply > total_demand
        C = hcat(C, zeros(num_suppliers))
        P = vcat(P, total_supply - total_demand)
    elseif total_demand > total_supply
        C = vcat(C, zeros(1, num_consumers))
        S = vcat(S, total_demand - total_supply)
    end

    num_suppliers, num_consumers = size(C)

    model = Model(GLPK.Optimizer)

    @variable(model, X[1:num_suppliers, 1:num_consumers] >= 0)

    @constraint(model, [i=1:num_suppliers], sum(X[i, j] for j in 1:num_consumers) <= S[i])

    @constraint(model, [j=1:num_consumers], sum(X[i, j] for i in 1:num_suppliers) == P[j])

    @objective(model, Min, sum(C[i, j] * X[i, j] for i in 1:num_suppliers, j in 1:num_consumers))

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        X_opt = value.(X)  
        V_opt = objective_value(model)  

        if total_supply != total_demand
            X_opt = X_opt[1:end - (total_supply < total_demand), 1:end - (total_supply > total_demand)]
        end

        return X_opt, V_opt
    else
        error("Optimalno rješenje nije pronađeno.")
    end
end

#
# Primjer:
C = [3 2 10; 5 8 12; 4 10 5; 7 15 10]
S = [20, 50, 60, 10]
P = [20, 40, 30]

X, V = transport(C, S, P)

println("X =")
println(X)
println("\nV =")
println(V)


#Primjer 1, KOLEKCIJA ZADATAKA IZ TRANSPORTNIH PROBLEMA I PROBLEMA RASPOREĐIVANJA, zadatak 1
C1 = [10 12 0; 8 4 3; 6 9 4; 7 8 5]
S1 = [20, 30, 20, 10]
P1 = [40, 10, 30]

X1, V1 = transport(C1, S1, P1)

println("X1 =")
println(X1)
println("\nV1 =")
println(V1)


#Primjer 2, KOLEKCIJA ZADATAKA IZ TRANSPORTNIH PROBLEMA I PROBLEMA RASPOREĐIVANJA, zadatak 3
C2 = [4 2 5 7 6; 7 8 3 4 5; 2 1 4 3 2]
S2 = [20, 110, 120]
P2 = [70, 40, 30, 60, 50]

X2, V2 = transport(C2, S2, P2)

println("X2 =")
println(X2)
println("\nV2 =")
println(V2)

#Primjer 3, KOLEKCIJA ZADATAKA IZ TRANSPORTNIH PROBLEMA I PROBLEMA RASPOREĐIVANJA, zadatak 4
C3 = [30 28 3 10 25; 27 4 11 2 17; 5 12 1 22 8; 13 21 19 15 23]
S3 = [200, 150, 250, 400]
P3 = [90, 170, 220, 330, 190]

X3, V3 = transport(C3, S3, P3)

println("X3 =")
println(X3)
println("\nV3 =")
println(V3)

