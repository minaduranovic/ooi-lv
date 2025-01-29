# Napišite Julia funkciju reduction koja prima uravnoteženu matricu M.
# Funkcija vraća izmijenjenu matricu M. Funkcija vrši pripremne radnje za tehniku Flood-a 
# i to vršeći redukciju prvo po kolonama pa po redovima. 

function reduction(M)

    for j in 1:size(M, 2)

        min = minimum(M[:, j])
        M[:, j] .-= min
    end

    for i in 1:size(M, 1)

        min = minimum(M[i, :])
        M[i, :] .-= min
    end

end