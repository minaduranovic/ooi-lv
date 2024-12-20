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


M = [
    0  1  3  0  0  0;
    0  0  2  3  0  0;
    0  0  0 -4  9  0;
    0  0  0  0  1  2;
    0  0  0  0  0  2;
    0  0  0  0  0  0
]

putevi = najkraci_put(M)
println("Putevi:")
println(putevi)
