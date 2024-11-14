using LinearAlgebra

function formiraj_pocetnu_tabelu(A, b, c, m, n)

    tabela_bez_fje_cilja = hcat(A, I(m), b)  
    red_fje_cilja = hcat(c', zeros(1, m + 1))  
    tabela = vcat(tabela_bez_fje_cilja, red_fje_cilja) 
    baza = collect(n + 1:n + m) 
    # print("Baza iz prve fje" ,baza)
    return tabela, baza
end

function rijesi_simplex(A, b, c)
    if ndims(A) != 2 || ndims(b) != 1 || ndims(c) != 1
        error("Neispravne dimenzije")
    end

    m, n = size(A)

    if length(b) != m
        error("Neispravne dimenzije")
    end

    if length(c) != n
        error("Neispravne dimenzije")
    end

    tabela, baza = formiraj_pocetnu_tabelu(A, b, c, m, n)

    flag = false
    it = 0

    while !flag
        it += 1

        max = maximum(tabela[end, 1:end-1])
        if max <= 0
            flag = true
            break
        end

        ulazna_varijabla = argmax(tabela[end, 1:end-1])

        t_vrijednosti = tabela[1:end-1, end] ./ tabela[1:end-1, ulazna_varijabla] #b_i / a_ij
        validne_t_vrijednosti = map(x -> x > 0 ? x : Inf, t_vrijednosti)

        izlazna_varijabla = argmin(validne_t_vrijednosti)

        if validne_t_vrijednosti[izlazna_varijabla] == Inf
            return "Rješenje je neograničeno"
        end

        baza[izlazna_varijabla] = ulazna_varijabla
        pivot = tabela[izlazna_varijabla, ulazna_varijabla]

        tabela[izlazna_varijabla, :] ./= pivot

        for i in 1:m
            if i != izlazna_varijabla
                faktor = tabela[i, ulazna_varijabla]
                tabela[i, :] .-= faktor * tabela[izlazna_varijabla, :]
            end
        end

        fja_cilja = tabela[end, ulazna_varijabla]
        tabela[end, :] .-= fja_cilja * tabela[izlazna_varijabla, :]

        # println("Tabela nakon iteracije ", it, ":")
        # println(tabela)
        
    end

    x = zeros(n + m)  
    for i in 1:m
            x[baza[i]] = tabela[i, end]
    end
    Z = -tabela[end, end]  

    return x, Z

end

# println(rijesi_simplex([0.05 0.01 0.01; 17 18 18], [93; 54803], [20; 19; 19]))
# println(rijesi_simplex([30 16; 14 19; 11 26; 0 1], [22800; 14100; 15950; 550], [800; 1000]))
# println(rijesi_simplex([1 0; 1 -1], [7; 8], [5; 4]))
