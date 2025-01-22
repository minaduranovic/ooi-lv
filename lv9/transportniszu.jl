#Zadatke radile Mina Duranović 19290 i Sara Dautbegović 19463

function nadji_pocetno_SZU(C,I,O)
    i = sum(I)
    m = size(I, 1)
    o = sum(O)
    n = length(O)
    if i != o
        if i > o
            novi_redic = [i - o]  
            I = vcat(I, novi_redic)  
            novi_red = zeros(1, size(C, 2))  
            C = vcat(C, novi_red)  
            m = m+1
        else
            nova_kolonica = [o-i;]
            O = hcat(O, nova_kolonica)
            nova_kolona = zeros(size(C, 1), 1)  
            C = hcat(C, nova_kolona)  
            n = n+1
        end
    end
    A = zeros(m, n)
    T = 0
    i, j = 1, 1

    while i <= m && j <= n
        if i == m && j == n
            A[i, j] = I[i]
            println(C)
            break
        elseif I[i] < O[j]
            A[i, j] = I[i]
            O[j] -= I[i]
            I[i] = 0
            i += 1  # Prelaz u naredni red
        elseif I[i] > O[j]
            A[i, j] = O[j]
            I[i] -= O[j]
            O[j] = 0
            j += 1  # Prelaz u narednu kolonu
        else
            A[i, j] = I[i]
            I[i] = 0
            O[j] = 0
            j += 1  # Prelaz u narednu kolonu
            A[i, j] = 0  
            i += 1  # Prelaz u naredni red
        end
    end

    # Ukupni troškovi
    T = sum(A .* C)
    return A, T    
end

#Testni slučaj iz predavanja 5, strana 6
C = [
    8 9 4 6;
    6 9 5 3;
    5 6 7 4
]
I = [100; 120; 140]
O = [90 125 80 65]
A, T = nadji_pocetno_SZU(C, I, O)
println(A)
println(T)

#Testni slučaj iz predavanja 6, strana 6
C = [
    3 2 5 4;
    6 4 7 8;
    1 6 3 7
]
I = [1; 1; 1]
O = [1 1 1 1]
A, T = nadji_pocetno_SZU(C, I, O)
println(A)
println(T)

#Testni slučaj sa laboratorijske vjezbe jamboard 1.1 SZU
C = [
    2 3 1;
    5 4 8;
    5 6 8
]
I = [20; 15; 40]
O = [20 30 25]
A, T = nadji_pocetno_SZU(C, I, O)
println(A)
println(T)


