function najkraci_put(M)
    n = size(M, 1) 
    inf = typemax(Int) 

    udaljenosti = [i == 1 ? 0 : inf for i in 1:n]
    prethodni = [0 for _ in 1:n] 

    for iteracija in 1:(n - 1)
        promjena = false  
        for i in 1:n
            for j in 1:n
                if M[i, j] != 0 && udaljenosti[i] != inf 
                    nova_udaljenost = udaljenosti[i] + M[i, j]
                    if nova_udaljenost < udaljenosti[j]
                        udaljenosti[j] = nova_udaljenost
                        prethodni[j] = i  
                        promjena = true  
                    end
                end
            end
        end
        if !promjena
            break
        end
    end
    putevi = hcat(1:n, udaljenosti, [prethodni[i] == 0 ? i : prethodni[i] for i in 1:n])
    return putevi
end

#Testni slučaj iz postavke laboratorijske vježbe
M = [0 1 3 0 0 0; 0 0 2 3 0 0; 0 0 0 -4 9 0; 0 0 0 0 1 2; 0 0 0 0 0 2; 0 0 0 0 0 0]
putevi = najkraci_put(M);
println(putevi)

#Testni slučaj iz predavanja 7, strana 33
M = [0 3 7 4 0 0; 0 0 1 0 1 0; 0 0 0 0 2 3; 0 0 1 0 0 5; 0 0 0 0 0 1; 0 0 0 0 0 0]
putevi = najkraci_put(M);
println(putevi)

#Testni slučaj iz predavanja 7, strana 37
M = [0 2 10 7 0 0 0; 0 0 0 3 9 0 0; 0 0 0 6 0 6 0; 0 0 0 0 5 8 12; 0 0 0 0 0 1 7; 0 0 0 0 0 0 4; 0 0 0 0 0 0 0]
putevi = najkraci_put(M);
println(putevi)