#Zadatke radile Mina Duranović 19290 i Sara Dautbegović 19463

# autori zadatka nisu navedeni

function nadji_pocetno_SZU(C, I, O)
    m = length(I)
    n = length(O)
    sumaI = sum(I)
    sumaO = sum(O)

    # provjera balansiranosti
    if sumaI > sumaO
        O = [O sumaI - sumaO]
        C = [C zeros(m)]
        n += 1
    elseif sumaI < sumaO
        I = [I sumaO - sumaI]
        C = [C; zeros(n)']
        m += 1
    end

    A = zeros(m, n)
    i, j = 1, 1

    # algoritam za inicijalno rješenje
    while i <= m && j <= n
        if I[i] > O[j]
            A[i, j] = O[j]
            I[i] -= O[j]
            O[j] = 0
            j += 1
        elseif I[i] < O[j]
            A[i, j] = I[i]
            O[j] -= I[i]
            I[i] = 0
            i += 1
        else
            A[i, j] = I[i]
            O[j] = 0
            I[i] = 0
            i += 1
            j += 1
        end
    end

    T = sum(A .* C)
    return T, A
end

# primjer 1 - 5.1 iz knjige
I = [100, 120, 140]
O = [90, 125, 80, 65]
C = [8 9 4 6; 6 9 5 3; 5 6 7 4]
T, A = nadji_pocetno_SZU(C, I, O)

println("vrijednost ciljne funkcije T = ", T)
println("početna matrica rješenja A = ", A)

# primjer 2 - 1 iz zsra
I = [20, 30, 20, 10]
O = [40, 10, 30]
C = [10 12 0; 8 4 3; 6 9 4; 7 8 5]
T, A = nadji_pocetno_SZU(C, I, O)

println("vrijednost ciljne funkcije T = ", T)
println("početna matrica rješenja A = ", A)

# primjer 3 - 1 iz tutorijala 3b
I = [90, 50, 80]
O = [30, 50, 40, 70, 30]
C = [8 18 16 9 10; 10 12 10 3 15; 12 15 7 16 4]
T, A = nadji_pocetno_SZU(C, I, O)

println("vrijednost ciljne funkcije T = ", T)
println("početna matrica rješenja A = ", A)
