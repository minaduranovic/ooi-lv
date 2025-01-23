#Zadatke radile Mina Duranović i Sara Dautbegović

function rasporedi(M)
    original_M = copy(M)

    for i in 1:size(M, 1)
        M[i, :] .-= minimum(M[i, :])
    end

    for j in 1:size(M, 2)
        M[:, j] .-= minimum(M[:, j])
    end

    raspored = zeros(Int, size(M))
    marker = typemax(Int) 

    while count(==(0), M) > 0
        for i in 1:size(M, 1)
            red = findall(x -> x == 0, M[i, :])
            if length(red) == 1
                raspored[i, red[1]] = 1
                M[:, red[1]] .= marker  
                M[i, :] .= marker      
            end
        end

        for j in 1:size(M, 2)
            kolona = findall(x -> x == 0, M[:, j])
            if length(kolona) == 1
                raspored[kolona[1], j] = 1
                M[kolona[1], :] .= marker  
                M[:, j] .= marker          
            end
        end
    end

    Z = 0
    for i in 1:size(raspored, 1)
        for j in 1:size(raspored, 2)
            if raspored[i, j] == 1
                Z += original_M[i, j] 
            end
        end
    end

    return raspored, Z
end

# Test primjeri
M1 = [80 20 23; 31 40 12; 61 1 1]
M2 = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65]

println("Test 1:")
raspored1, Z1 = rasporedi(M1)
println("Raspored:")
println(raspored1)
println("Optimalna vrijednost funkcije cilja Z: $Z1")

println("\nTest 2:")
raspored2, Z2 = rasporedi(M2)
println("Raspored:")
println(raspored2)
println("Optimalna vrijednost funkcije cilja Z: $Z2")
