function rijesi_simplex(goal,c,A,b,csigns,vsigns) 


    if(goal =="min")
        for i in 1:length(c)
        c[i] = -c[i]
        end
    end
    
    dopunske_promjenjive = zeros(Float64, length(csigns), 2*length(csigns)) #maksimalna velicina
    B = Vector{Int}(undef, length(csigns))#baza
    broj_x = length(c) #duzina c je broj pocetnih promjenjihvih
    i = 1 
    B_i = 1
    vjestacke_varijable = [] 
    vjestacke = 0
    
    for element in csigns
        #println(i)
    
        if element == -1 
            broj_x+=1
            dopunske_promjenjive[i,broj_x - length(c)] = 1
        end
        if element == 1  #treba dodati i vjestacku i dopunsku promjenjivu
            broj_x+=1 
            dopunske_promjenjive[i,broj_x - length(c)] = -1
            vjestacke = 1
        end
        if element == 0  
            vjestacke = 1
        end
    
        i += 1
    end
    i = 1
    vjestacke_promjenjive = 0
    #println("dodavanje vjestackih promjenjivih")
    for element in csigns
        if element == 0 
            broj_x+=1
            push!(vjestacke_varijable, broj_x)
            dopunske_promjenjive[i,broj_x - length(c)] = 1
            vjestacke_promjenjive += 1
            vjestacke = 1
        end
        if element == 1  #treba dodati i vjestacku i dopunsku promjenjivu
            broj_x+=1
            push!(vjestacke_varijable, broj_x)
            vjestacke_promjenjive += 1
            dopunske_promjenjive[i,broj_x - length(c)] = 1
        end
        i += 1
    end
    B = vcat(B,0) #jos jednu 0 dodajemo cisto da bi se moglo spojiti sa simplex tabelom
    
    #odstraniti visak kolona u matrici dopunskih promjenjivih
    # pronalazak svih nenultih kolona
    broj_kolona = size(dopunske_promjenjive, 2)
    brojac = 0
    for kolona in 1:broj_kolona
        # ako je pronadjena nulta kolona
        if(all(dopunske_promjenjive[:, kolona] .== 0))
            break
        end
        brojac = brojac + 1
       
    end
    #stimanje baze
    kolona = length(c) + 1
    for i in 1:size(dopunske_promjenjive, 1)
        #println(dopunske_promjenjive[i, :])
        for j in 1:size(dopunske_promjenjive, 2)
            
            if dopunske_promjenjive[i, j] == 1
            #    println("1")
                B[B_i] = kolona
                B_i+=1
            end
            kolona += 1
        end
        kolona = length(c) + 1
    end
    
    
    dopunske_i_vjestacke = dopunske_promjenjive[:, 1:brojac] # svi redovi i kolone do specificirane
    
    
    simplex_table = hcat(b, A);
    
    simplex_table = hcat(simplex_table, dopunske_i_vjestacke)
    Z_red = vcat(0, c[:])
    
    
    for i in 1:size(dopunske_i_vjestacke, 2)
        Z_red = vcat(Z_red, 0)
    end
    
    #formirati M vektor ukoliko ima vjestackih promjenjivih
    M = zeros(Float64, size(simplex_table, 2))
    if vjestacke == 1
        B = vcat(B,0)
        #vjestacke u vektoru M su 0
        for i in 1:length(b)
            if B[i] in vjestacke_varijable
                M[1] += b[i]
            end
        end
        
        for i in 2:size(simplex_table, 2) - vjestacke_promjenjive 
            #println(i)
            for j in 1: size(simplex_table, 1)
              #  println(j)
                if B[j] in vjestacke_varijable
                    M[i] += simplex_table[j, i]
                end
            end
            #println("M za taj red glasi")
            #println(M[i])
        end
    
        for i in size(simplex_table, 2) - vjestacke_promjenjive + 1:size(simplex_table,2)
            M[i] = 0
        end
        simplex_table = vcat(simplex_table, M')
        end
    
        
    simplex_table = vcat(simplex_table, Z_red')
    
    simplex_table = hcat(B, simplex_table)
    
    
    iteracija = 0
    br_kol = size(simplex_table, 2)
    br_red = size(simplex_table, 1)
    kolone_bez_v =  size(simplex_table, 2) - vjestacke_promjenjive
    br_kol2 = br_kol
    granica = 1
    brojac_min = 0
    
    vektor_jednakih_t = [-1]
    pocetna_simplex = simplex_table
    
    vjestacke_izletile = 0
    degenerisano = 0
    while true
    
    #println("ITERACIJA")
    
    #println(iteracija)
    
    #println(simplex_table)
    
    #println("max prije")
    
    
    max = 0
    #println(max)
    j = 1
    v = 0
    if vjestacke == 1 && vjestacke_izletile==0 && iteracija == 0
       br_red -= 1  
       granica = 2
    end
    if vjestacke_izletile == 1
        br_kol2 = kolone_bez_v
    end
    for v in 3:br_kol2
        if max < simplex_table[br_red, v] 
            max = simplex_table[br_red, v]
            j = v 
        end
    end
    
    if vjestacke == 1 && vjestacke_izletile == 0
    if  simplex_table[br_red, 2] <= 0
        vjestacke_izletile = 1
    end
    end
    
    if max <= 0
        if vjestacke == 1
            for o in 1:vjestacke_promjenjive
                if vjestacke_varijable[o] in simplex_table[:, 1]
                    
                    println("Vjestačke promjenjive su u bazi, nema rješenja!!!")
                    return 
                end
            end
            if vjestacke_izletile == 1  
                println("Rjesenje je pronađeno.")
                break
            end
            vjestacke_izletile = 1
            br_red += 1 #vratiti na staro
            granica = 1
            
        else
            println("Rjesenje je pronađeno.")
                break
        end
    end
    t_max = []
    
    
    for i in 1:size(simplex_table,1)-granica 
        if simplex_table[i, j] < 0
           push!(t_max, Inf)
        else
            push!(t_max, simplex_table[i, 2] / simplex_table[i, j])
        end
    end
    
    
    if all(x -> x == Inf, t_max) && 
        println("Rješenje se nalazi u beskonacnosti.")
        return
    end
    #negativne ili nule su beskonacnosti
    min = Inf
    k = 1
    
    jednaki = 0
    
    for p in 1:length(t_max)
        if t_max[p] >= 0
        if min > t_max[p] 
        min = t_max[p]
        k = p
    
        elseif t_max[p] == min && min == 0
            jednaki = 1
            push!(vektor_jednakih_t, p)
            push!(vektor_jednakih_t, p)
        end
        end
    end
    
        random_indeks = -1
    if jednaki == 1
        degenerisano = 1
        println("Radi se o problemu degeneracije.")
    while true
    random_indeks = rand(1:length(vektor_jednakih_t))
    if vektor_jednakih_t[random_indeks] != -1 
        break
    end
    end
    k = vektor_jednakih_t[random_indeks]
    end
    
    vektor_jednakih_t = [-1] #restart vektora jednakih 
    jednaki = 0
    
    if(min < 0)
        println("Nema rješenja.")
        return
    end
    
    simplex_table[k,1] = j-2
    pivot = simplex_table[k, j]
    simplex_table[k, 2:br_kol] .= simplex_table[k, 2:br_kol] ./ pivot
    for r in 1: size(simplex_table, 1)
        if r!=k #ako nije pivot red
       #     println(r)
            mnozitelj = simplex_table[r, j]
            pivot_red = simplex_table[k, 2:size(simplex_table,2)].*mnozitelj
            simplex_table[r, 2:size(simplex_table,2)] = simplex_table[r, 2:size(simplex_table,2)] - pivot_red
        end
    end
    
    iteracija+=1
    
    end
    println(simplex_table)
    if degenerisano == 0
    println("Optimalno rješenje je jedinstveno.")
    else println("Rješenje je degenerisano.")
    end
    if goal == "max" || (goal == "min" && vjestacke == 0) 
        rjesenje = -1*simplex_table[size(simplex_table,1), 2]
    println("Glasi: ", -1*simplex_table[size(simplex_table,1), 2])
    end
    if goal == "min" && vjestacke == 1
        rjesenje = simplex_table[size(simplex_table,1), 2]
        println("Glasi: ", simplex_table[size(simplex_table,1), 2])
        end
        if vjestacke == 1
            oduzmi = 2
        else oduzmi = 1
        end
    for i in 1:size(simplex_table, 1)-oduzmi
        indeks = Int(simplex_table[i, 1])
    println("x", indeks)
    println(" = ", simplex_table[i, 2])
    end
    
    println("Vrijednosti preostalih x-eva iznose 0.")
    
    return simplex_table[i, 2], rjesenje
    end
    
    #Pogl.3 str.40  
    c = [800, 1000] #Z = 800x1 + 1000x2
    A = [30 16; 14 19; 11 26; 0 1] #bez zareza
    b = [22800, 14100, 15950, 550]
    csigns = [-1, -1, -1, -1]
    vsigns = [1, 1]
    
    rijesi_simplex("max",c,A,b,csigns,vsigns)
    
    #Pogl.3 str.45
    
    b = [0, 0, 1]
    A = [0.25 -8 -1 9; 0.5 -12 -0.5 3; 0 0 1 0]
    c = [-3 -80 2 -24]
    csigns = [-1, -1, -1]
    vsigns = [1, 1, 1, 1]
    goal = "max"
    rijesi_simplex("max",c,A,b,csigns,vsigns)
    
    #Pogl.3 str.45
    
    b = [1, 300, 0.3, 0.5]
    csigns = [0, 1, -1, -1]
    vsigns = [1, 1, 1, 1]
    A = [1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0]
    c = [32 56 50 60]
    rijesi_simplex("max",c,A,b,csigns,vsigns)
    
    
    #Pogl.3 str.57
    
    b = [1, 300, 0.3, 0.5]
    A = [1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0]
    c = [32 56 50 60]
    csigns = [0, 1, -1, -1]
    vsigns = [1, 1, 1, 1]
    goal = "min"
    rijesi_simplex("max",c,A,b,csigns,vsigns)
    
    