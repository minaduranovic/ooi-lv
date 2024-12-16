using LinearAlgebra

function formiraj_simplex_tabelu(c, A, b, csigns, goal)
    m, n = size(A)  # m je broj redova (broj ograničenja), n je broj kolona (broj varijabli)
    
    # Prvo kreiraj novu matricu A sa dodatnim slack varijablama
    A_aug = hcat(A, Matrix{Float64}(I, m, m))  # Dodaj slack varijable za <= ograničenja
    
    # Dodaj vještačke varijable ako je potrebno
    artificial_vars = []
    if any(csigns .== 1)  # Za >= ograničenja
        for i in findall(csigns .== 1)
            A_aug[i, n + i] = -1  # Za >=, staviti -1 u odgovarajući red
        end
    end
    
    # Ako je cilj minimizacija, preokrenuti znak funkcije cilja
    if goal == "min"
        c = -c
    end
    
    # Kreiraj početni Z-red
    Z = vcat(c, zeros(1, m))  # Cijenimo funkciju cilja i dodajemo nula u Z-redu
    
    # Ako imamo ograničenja jednakosti (=), dodajemo vještačke varijable
    for i in 1:m
        if csigns[i] == 0  # Za = ograničenja
            A_aug[i, end + 1] = 1
            artificial_vars = push!(artificial_vars, n + m + length(artificial_vars))
        end
    end
    
    # Kreiraj početnu simplex tabelu
    table = vcat(A_aug, Z)  # Spajamo A_aug sa Z-rezultatom
    
    return table, 1:m, artificial_vars
end

function nadji_ulaznu_varijablu(table)
    Z_row = table[end, :]
    pivot_col = argmax(Z_row[1:end-1])  # Ignorišemo zadnju kolonu koja je Z-red
    
    if Z_row[pivot_col] <= 0
        return -1  # Optimalno rješenje
    end
    
    return pivot_col
end



function nadji_izlaznu_varijablu(table, pivot_col)
    m = size(table, 1) - 1  # Broj redova, ignorišemo zadnji red (Z)
    ratios = []
    
    for i in 1:m
        if table[i, pivot_col] > 0  # Samo pozitivni koeficijenti
            push!(ratios, table[i, end] / table[i, pivot_col])
        else
            push!(ratios, Inf)  # Ako je koeficijent 0 ili negativan, postavi na Inf
        end
    end
    
    pivot_row = argmin(ratios)
    
    if ratios[pivot_row] == Inf
        return -1  # Neograničeno rješenje
    end
    
    return pivot_row
end


function izracunaj_optimalnu_vrijednost(table)
    return table[end, end]  # Posljednja vrijednost u posljednjem redu (Z)
end

function pivotiraj(table, pivot_row, pivot_col)
    pivot_value = table[pivot_row, pivot_col]
    
    # Normalizuj pivotni red
    table[pivot_row, :] .= table[pivot_row, :] / pivot_value
    
    # Ažuriraj ostale redove
    for i in 1:size(table, 1)-1
        if i != pivot_row
            row_factor = table[i, pivot_col]
            table[i, :] .-= row_factor * table[pivot_row, :]
        end
    end
end


function izracunaj_originalne_promjenljive(table, B, n)
    X = zeros(n)
    
    for i in 1:length(B)
        X[B[i]] = table[i, end]
    end
    
    return X
end


function izracunaj_dualne_promjenljive(table)
    m, n = size(table)
    Y = table[1:m, end]  # Dualne promjenljive su u posljednjoj koloni
    
    return Y
end



function general_simplex(goal, c, A, b, csigns = ones(Int, size(A,1)), vsigns = ones(Int, size(c,1)))
    # 1. Validacija ulaznih parametara
    if !(goal in ["max", "min"])
        println("Greška: goal mora biti 'max' ili 'min'")
        return NaN, [], [], [], [], 5
    end
    if any(x -> !(x in [-1, 0, 1]), csigns) || any(x -> !(x in [-1, 0, 1]), vsigns)
        println("Greška: csigns i vsigns smiju sadržavati samo -1, 0 ili 1")
        return NaN, [], [], [], [], 5
    end
    
    # 2. Priprema Simplex tabele
    (table, B, vjestacke_varijable) = formiraj_simplex_tabelu(c, A, b, csigns, goal)
    
    # 3. Iterativno izvođenje Simplex metoda
    while true
        pivot_kolona = nadji_ulaznu_varijablu(table)
        if pivot_kolona == -1
            break  # Optimalno rješenje
        end
        
        pivot_red = nadji_izlaznu_varijablu(table, pivot_kolona)
        if pivot_red == -1
            println("Funkcija cilja nije ograničena.")
            return Inf, [], [], [], [], 3
        end
        
        # Pivotiranje tabele
        pivotiraj(table, pivot_red, pivot_kolona)
    end
    
    # 4. Ekstrakcija rezultata
    Z = izracunaj_optimalnu_vrijednost(table)
    X = izracunaj_originalne_promjenljive(table, B, length(c))
    Y = izracunaj_dualne_promjenljive(table)
    
    return Z, X, [], Y, [], 0  # Status = 0 (uspješno)
end

#test1
#Z=3000;  X=(60 20) Xd(90 0 60 100 0 40); Y(0 30 0 0 10 0) Yd(0 0) status(0)
goal="max";
c=[40 30];
A=[3 1.5;1 1;2 1;3 4;1 0;0 1];
b=[300 80 200 360 60 60] 
csigns=[-1 -1 -1 -1 -1 -1] 
vsigns=[1  1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test2
#Z=12;  X=(12 0) Xd(14 4 0); Y(0 0 1) Yd(0 0.5); status(0)
goal="min";
c=[1 1.5];
A=[2 1; 1 1; 1 1];
b=[10 8 12] 
csigns=[1 1 1] 
vsigns=[1  1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test3
#Z=38;  X=(0.66 0 0.33 0) Xd(0 0 0.3 0.16); Y(2 0.12 0 0) Yd(0 36 0 34); status(0)
goal="min";
c=[32 56 50 60];
A=[1 1 1 1;250 150 400 200;0 0 0 1;0 1 1 0];
b=[1 300 0.3 0.5] 
csigns=[0 1 -1 -1] 
vsigns=[1  1 1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#dual prethodnog problema
#test4
#Z=38; X(2 0.12 0 0) Xd(0 36 0 34); Y=(0.66 0 0.33 0) Yd(0 0 0.3 0.16);  status(0)
goal="max";
c=[1 300 -0.3 -0.5];
A=[1 250 0 0;1 150 0 -1;1 400 0 -1;1 200 -1 0];
b=[32  56  50  60] 
csigns=[-1 -1 -1 -1] 
vsigns=[0  1 1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test5
#Z=Inf; Problem ima neograniceno rjesenje (u beskonacnosti); status(3)
goal="max";
c=[1 1];
A=[-2 1;-1 2];
b=[-1 4] 
csigns=[-1 1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test6
#Z=Nan; Dopustiva oblast ne postoji; status(4)
goal="max";
c=[1 2];
A=[1 1; 3 3];
b=[2 4] 
csigns=[1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)


#**********************************************************************
#test7
#Z=12*10^6; X(2500 1000) Xd(1500 0 0 2000); Y(0 2000 0 0) Yd(0 0); status(2)
#Z=12*10^6; X(2000 2000) ; status(2)
goal="max";
c=[4000 2000];
A=[3 3;2 1;1 0;0 1];
b=[12000 6000 2500 3000] 
csigns=[-1 -1 -1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)

#**********************************************************************
#test8
#Z=18; X(0 2) Xd(0 0); Y(0 4.5) Yd(1.5 0); status(1)
#Z=18; X(0 2) Xd(0 0); Y(1.5 1.5) Yd(0 0); status(1)
goal="max";
c=[3 9];
A=[1 4;1 2];
b=[8 4] 
csigns=[-1 -1] 
vsigns=[1 1] 
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)