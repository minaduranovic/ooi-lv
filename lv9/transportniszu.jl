#Zadatke radile Mina Duranović 19290 i Sara Dautbegović 19463

function inicijalno_rješenje(C, ulaz, izlaz)
    m = length(ulaz)
    n = length(izlaz)
    ukupno_ulaz = sum(ulaz)
    ukupno_izlaz = sum(izlaz)

    # provjera ravnoteže sistema
    if ukupno_ulaz > ukupno_izlaz
        izlaz = vcat(izlaz, ukupno_ulaz - ukupno_izlaz)
        C = hcat(C, zeros(m))
        n += 1
    elseif ukupno_ulaz < ukupno_izlaz
        ulaz = vcat(ulaz, ukupno_izlaz - ukupno_ulaz)
        C = vcat(C, zeros(1, n))
        m += 1
    end

    A = zeros(m, n)
    i, j = 1, 1

    # algoritam za inicijalno rješenje
    while i <= m && j <= n
        if ulaz[i] > izlaz[j]
            A[i, j] = izlaz[j]
            ulaz[i] -= izlaz[j]
            izlaz[j] = 0
            j += 1
        elseif ulaz[i] < izlaz[j]
            A[i, j] = ulaz[i]
            izlaz[j] -= ulaz[i]
            ulaz[i] = 0
            i += 1
        else
            A[i, j] = ulaz[i]
            izlaz[j] = 0
            ulaz[i] = 0
            i += 1
            j += 1
        end
    end

    T = sum(A .* C)
    return T, A
end

# primjer 1 - 5.1 iz knjige
ulaz = [100, 120, 140]
izlaz = [90, 125, 80, 65]
troškovi = [8 9 4 6; 6 9 5 3; 5 6 7 4]
T, A = inicijalno_rješenje(troškovi, ulaz, izlaz)

println("vrijednost ciljne funkcije T = ", T)
println("početna matrica rješenja A = ", A)

# primjer 2 - 1 iz zsra
ulaz = [20, 30, 20, 10]
izlaz = [40, 10, 30]
troškovi = [10 12 0; 8 4 3; 6 9 4; 7 8 5]
T, A = inicijalno_rješenje(troškovi, ulaz, izlaz)

println("vrijednost ciljne funkcije T = ", T)
println("početna matrica rješenja A = ", A)

# primjer 3 - 1 iz tutorijala 3b
ulaz = [90, 50, 80]
izlaz = [30, 50, 40, 70, 30]
troškovi = [8 18 16 9 10; 10 12 10 3 15; 12 15 7 16 4]
T, A = inicijalno_rješenje(troškovi, ulaz, izlaz)

println("vrijednost ciljne funkcije T = ", T)
println("početna matrica rješenja A = ", A)
