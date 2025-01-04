#Zadatke radile Mina Duranović 19290 i Sara Dautbegović 19463

function indexx(str, A, m)
    for i = 1 : m
        if string(str) == A[i]
            return i
        end
    end
end

function CPM(A, P, T)
    m = length(A)
    M = fill(0, m, m)

    indeks = 0
    for i = 1 : m
        prethodnici = P[i]
        if prethodnici == "-"
            M[i, i] = T[i]
        else 
            prethodnici_lista = split(prethodnici, ",")
            for prethodnik in prethodnici_lista
                indeks = indexx(prethodnik, A, m)
                if indeks !== nothing
                    M[indeks, i] = T[i]
                end
            end              
        end
    end

    putevi = ["" for _ in 1:m]  
    trajanja = zeros(m)
    for j = 1 : m
        for i = 1 : j
            if M[i, j] != 0
                    if trajanja[i] + M[i, j] > trajanja[j]
                        trajanja[j] = trajanja[i] + M[i, j]
                        if length(putevi[i]) == 0
                            putevi[j] = A[j]
                        else
                            putevi[j] = putevi[i] * A[j] 
                        end
                    end
                end
        end
        
    end
    Z = Int(trajanja[m])
    put = join(split(putevi[m], ""), "-")
    return Z, put

end

#Testni slučaj iz postavke laboratorijske vježbe
 A=["A","B","C","D","E","F","G","H","I"]
 P =["-","-","-","C","A","A","B,D","E","F,G"] 
 T=[3,3,2,2,4,1,4,1,4]
 Z,put = CPM(A,P,T)
 println(Z)
 println(put)

#Testni slučaj iz predavanja 8, strana 9
 A=["A","B","C","D","E","F","G"]
 P =["-","A","B","A","D","E","C,F"] 
 T=[25,30,60,1,50,4,6]
 Z,put = CPM(A,P,T)
 println(Z)
 println(put)



