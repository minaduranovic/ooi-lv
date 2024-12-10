function najkraci_put(M)
    n = size(M, 1)  # Broj čvorova
    inf = typemax(Int)  # Koristimo najveći mogući broj za beskonačnost

    # Inicijalizacija: Udaljenosti od početnog čvora i prethodni čvorovi
    udaljenosti = [i == 1 ? 0 : inf for i in 1:n]
    prethodni = [1 for _ in 1:n]  # Svi čvorovi inicijalno "dolaze" iz početnog čvora

    for _ in 1:(n - 1)  # Bellman-Ford algoritam iterira najviše n-1 puta
        for i in 1:n
            for j in 1:n
                if M[i, j] != 0  # Ako postoji veza između čvorova
                    nova_udaljenost = udaljenosti[i] + M[i, j]
                    if nova_udaljenost < udaljenosti[j]
                        udaljenosti[j] = nova_udaljenost
                        prethodni[j] = i
                    end
                end
            end
        end
    end

    # Formiranje matrice putevi
    putevi = hcat(1:n, udaljenosti, prethodni)
    return putevi
end

# Testni primjer
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
