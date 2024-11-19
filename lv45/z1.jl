# Kod uradile: Emina Efendic 18896 i Hana Mahmutovic 19026

using LinearAlgebra

function simplex_tabela(A, b, c, csigns)
	A_novo = A
	b_novo = b
	c_novo = c
	brojRedova = size(A, 1)
	base = zeros(brojRedova, 1)
	c_novo_M = zeros(1, size(c, 2))
	funkcija_M = 0
	vjestacke = []

	for i ∈ 1:brojRedova

		#Sredivanje u slucaju b_i < 0 
		if (b_novo[i] < 0)
			A_novo[i, :] = -A_novo[i, :]
			b_novo[i] = -b_novo[i]
			if csigns[i] == -1
				csigns[i] = 1
			elseif csigns[i] == 1
				csigns[i] = -1
			end
		end

		#Dodavanje izravnavajucih promjenjivih
		if csigns[i] == -1
			novaKolona = zeros(brojRedova, 1)
			novaKolona[i] = 1
			A_novo = [A_novo novaKolona]
			c_novo_M = [c_novo_M 0]
			c_novo = [c_novo 0]
			base[i] = size(c_novo, 2)
		elseif csigns[i] == 1
			novaKolona = zeros(brojRedova, 1)
			novaKolona[i] = -1
			A_novo = [A_novo novaKolona]
			c_novo_M = [c_novo_M 0]
			c_novo = [c_novo 0]
		end
	end

	#Dodavanje vjestackih promjenjivih
	for i ∈ 1:brojRedova
		if csigns[i] == 1
			novaKolona = zeros(brojRedova, 1)
			novaKolona[i] = 1
			A_novo = [A_novo novaKolona]
			c_novo_M = [c_novo_M -1]
			c_novo = [c_novo 0]
			base[i] = size(c_novo, 2)
			c_novo_M[:] .= c_novo_M[:] .+ A_novo[i, :]
			funkcija_M = funkcija_M .+ b_novo[i]
			#Pamtimo vjestacke promjenjive
			vjestacke = [vjestacke; size(c_novo, 2)]
		elseif csigns[i] == 0
			novaKolona = zeros(brojRedova, 1)
			novaKolona[i] = 1
			A_novo = [A_novo novaKolona]
			c_novo_M = [c_novo_M -1]
			c_novo = [c_novo 0]
			base[i] = size(c_novo, 2)
			c_novo_M[:] .= c_novo_M[:] .+ A_novo[i, :]
			funkcija_M = funkcija_M .+ b_novo[i]
			#Pamtimo vjestacke promjenjive
			vjestacke = [vjestacke; size(c_novo, 2)]
		end
	end

	c_novo = [0 c_novo]
	c_novo_M = [funkcija_M c_novo_M]
	ST = [b_novo A_novo]
	ST = [ST; c_novo_M; c_novo]
	return ST, base, vjestacke
end

function rijesi_simplex(goal, A, b, c, csigns, vsigns)
	if size(b, 1) != size(A, 1) || size(c, 2) != size(A, 2)
		throw("Dimenzije ulaznih parametara nisu validni")
	end

	#Sredivanje slucajeva ako je znak varijable "=" ili "<="
	mapaNeogranicenihVarijabli = []
	for i in 1:lastindex(vsigns)
		if vsigns[i] == -1
			A[:, i] *= -1
			c[i] *= -1
		elseif vsigns[i] == 0
			c = [c -c[i]]
			A = [A -A[:, i]]
			push!(mapaNeogranicenihVarijabli, (i, size(A, 2)))

		end
	end

	#Funkcija za formiranje simplex tabele
	(simplexTabela, vektorIndeksa, vjestacke) = simplex_tabela(A, b, c, csigns)


	#Sredivanje simplex tabele na osnovu min/max
	if goal == "min"
		simplexTabela[end, :] *= -1
	else
		#simplexTabela[end-1, :] *= -1
		simplexTabela[end-1, 1] = abs(simplexTabela[end-1, 1])
	end

	#Pronalazak maksimalnog M i pronalazak po potrebi max reda koeficijenata
	redM = deepcopy(simplexTabela[end-1, :])
	popfirst!(redM)
	(cMax_M, indeksKolone_M) = findmax(redM)
	indeksKolone_M += 1

	indeksKolone = 0
	predzadnjiRed = simplexTabela[end-1, :]
	zadnjiRed = simplexTabela[end, :]
	cMax = -Inf
	for i in 2:lastindex(zadnjiRed)
		if zadnjiRed[i] > cMax && (predzadnjiRed[i] >= 0 || predzadnjiRed[i] == -0)
			cMax = zadnjiRed[i]
			indeksKolone = i
		end
	end

	while cMax > 0 || cMax_M > 0
		if cMax_M > 0
			vodecaKolona = indeksKolone_M
		else
			vodecaKolona = indeksKolone
		end

		tMax = Inf
		vodeciRed = -1
		for i in 1:size(simplexTabela, 1)-2
			if simplexTabela[i, vodecaKolona] > 0
				tPrivremeno = simplexTabela[i, 1] / simplexTabela[i, vodecaKolona]
				if (tPrivremeno < tMax || (tPrivremeno == tMax && rand() > 0.5))
					tMax = tPrivremeno
					vodeciRed = i
				end
			end
		end

		if tMax == Inf
			throw("Rjesenje je neograniceno");
		end
		vektorIndeksa[vodeciRed] = vodecaKolona - 1

		pivotElement = simplexTabela[vodeciRed, vodecaKolona]

		simplexTabela[vodeciRed, :] ./= pivotElement

		for i in 1:size(simplexTabela, 1)
			if i != vodeciRed
				faktor = simplexTabela[i, vodecaKolona]
				for j in 1:size(simplexTabela, 2)
					simplexTabela[i, j] -= simplexTabela[vodeciRed, j] * faktor
				end
			end
		end

		redM = deepcopy(simplexTabela[end-1, :])
		popfirst!(redM)
		(cMax_M, indeksKolone_M) = findmax(redM)
		indeksKolone_M += 1

		if cMax_M <= 1e-8
			cMax_M = 0
		end

		if cMax_M <= 0
			predzadnjiRed = simplexTabela[end-1, :]
			zadnjiRed = simplexTabela[end, :]
			cMax = -Inf
			for i in 2:lastindex(zadnjiRed)
				if zadnjiRed[i] > cMax && (predzadnjiRed[i] >= 0 || predzadnjiRed[i] == -0)
					cMax = zadnjiRed[i]
					indeksKolone = i
				end
			end
		end
	end

	#Provjera da li je ostalo vjestackih promjenjivih
	for i in 1:lastindex(vjestacke)
		if (Float64(vjestacke[i]) in vektorIndeksa)
            throw("Dopustiva oblast ne postoji");
		end
	end
	x = zeros(1, size(b, 1) + size(c, 2))

	#Dodjeljivanje vrijednosti baznih promjenjivih
	for i in 1:lastindex(vektorIndeksa)
		x[Int(round(vektorIndeksa[i]))] = simplexTabela[i, 1]
	end


	#Provjera jedinstvenosti
	jedinstveno = true
	for i in 2:(lastindex(simplexTabela[end, :])-lastindex(vjestacke))
		if x[i-1] == 0 && simplexTabela[end, i] == 0
			jedinstveno = false
		end
	end

	jedinstvenoString = ""
	if jedinstveno == true
		jedinstvenoString = "Rjesenje je jedinstveno"
	else
		jedinstvenoString = "Rjesenje nije jedinstveno"
	end

	#Sredivanje krajnjeg rjesenja u slucaju da je "=" bilo zadano kao znak varijable
	#Potrebno je varijablu koju smo rastavile kao razliku dvije varijable vratiti na orginalni oblik
	if !isempty(mapaNeogranicenihVarijabli)
		for i in 1:lastindex(mapaNeogranicenihVarijabli)
			prviEl = findall(y -> y == mapaNeogranicenihVarijabli[i][1], x)
			drugiEl = findall(y -> y == mapaNeogranicenihVarijabli[i][2], x)
			if !isempty(prviEl) && !isempty(drugiEl)

			elseif isempty(prviEl) && !isempty(drugiEl)
				x[mapaNeogranicenihVarijabli[i][1]] = -x[drugiEl]
				deleteat!(x, drugiEl[1])
			end
		end
	end

	#Provjera degenerisanosti rjesenja
	degenerirano = false
	for i in 1:(lastindex(simplexTabela[:, 1])-2)
		if simplexTabela[i, 1] == 0
			degenerirano = true
		end
	end

	degeneriranoString = ""
	if degenerirano == true
		degeneriranoString = "Rjesenje je degenerirano"
	else
		degeneriranoString = "Rjesenje nije degenerisano"
	end


	#Ispravka znaka na osnovu min/max
	if goal == "min"
		Z = simplexTabela[end, 1]
	else
		Z = -simplexTabela[end, 1]
	end
	return Z, x, jedinstvenoString, degeneriranoString
end

#Zadatak Poglavlje 3_Linearno programiranje strana 38

b = [150, 60]
A = [[0.5 0.3]; [0.1 0.2]]
c = [3 1]
goal = "max"
csigns = [-1, -1]
vsigns = [1, 1]
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

#Zadatak Poglavlje 3_Linearno programiranje strana 40

b = [22800, 14100, 15950, 550]
A = [[30 16]; [14 19]; [11 26]; [0 1]]
c = [800 1000]
goal = "max"
csigns = [-1, -1, -1, -1]
vsigns = [1, 1]
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

#Zadatak Poglavlje 3_Linearno programiranje strana 45

b = [0, 0, 1]
A = [[0.25 -8 -1 9]; [0.5 -12 -0.5 3]; [0 0 1 0]]
c = [3 -80 2 -24]
csigns = [-1, -1, -1]
vsigns = [1, 1, 1, 1]
goal = "max"
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

#Zadatak Poglavlje 3_Linearno programiranje strana 45

b = [1, 300, 0.3, 0.5]
csigns = [0, 1, -1, -1];
vsigns = [1, 1, 1, 1];
A = [[1 1 1 1]; [250 150 400 200]; [0 0 0 1]; [0 1 1 0]]
c = [32 56 50 60]
(rjesenje, x) = rijesi_simplex("min", A, b, c, csigns, vsigns)

#Zadatak Poglavlje 3_Linearno programiranje strana 53

b = [0.2, 0.3, 3, 1.2]
A = [[0.1 0]; [0 0.1]; [0.5 0.3]; [0.1 0.2]]
c = [40 30]
csigns = [1, 1, 1, 1]
vsigns = [1, 1]
goal = "min"
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

#Zadatak Poglavlje 3_Linearno programiranje strana 57

b = [1, 300, 0.3, 0.5]
A = [[1 1 1 1]; [250 150 400 200]; [0 0 0 1]; [0 1 1 0]]
c = [32 56 50 60]
csigns = [0, 1, -1, -1]
vsigns = [1, 1, 1, 1]
goal = "min"
(rjesenje, x) = rijesi_simplex(goal, A, b, c, csigns, vsigns)

#Testni primjeri za Zadacu 5, modificirani da budu pogodni za ovu funkciju / SVI PROLAZE
#test1
#Z=3000;  X=(60 20) Xd(90 0 60 100 0 40); Y(0 30 0 0 10 0) Yd(0 0) status(0)
goal = "max"
c = [40 30]
A = [3 1.5; 1 1; 2 1; 3 4; 1 0; 0 1]
b = [300, 80, 200, 360, 60, 60]
csigns = [-1; -1; -1; -1; -1; -1]
vsigns = [1; 1]
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#test2
#Z=12;  X=(12 0) Xd(14 4 0); Y(0 0 1) Yd(0 0.5); status(0)
goal = "min"

c = [1 1.5];
A = [2 1; 1 1; 1 1];
b = [10; 8; 12];
csigns = [1; 1; 1];
vsigns = [1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#test3
#Z=38;  X=(0.66 0 0.33 0) Xd(0 0 0.3 0.16); Y(2 0.12 0 0) Yd(0 36 0 34); status(0)
goal = "min";
c = [32 56 50 60];
A = [1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0];
b = [1; 300; 0.3; 0.5];
csigns = [0; 1; -1; -1];
vsigns = [1; 1; 1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#dual prethodnog problema
#test4
#Z=38; X(2 0.12 0 0) Xd(0 36 0 34); Y=(0.66 0 0.33 0) Yd(0 0 0.3 0.16);  status(0)
goal = "max";
c = [1 300 -0.3 -0.5];
A = [1 250 0 0; 1 150 0 -1; 1 400 0 -1; 1 200 -1 0];
b = [32; 56; 50; 60];
csigns = [-1; -1; -1; -1];
vsigns = [0; 1; 1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#test5
#Z=Inf; Problem ima neograniceno rjesenje (u beskonacnosti); status(3)
goal = "max";
c = [1 1];
A = [-2 1; -1 2];
b = [-1; 4];
csigns = [-1; 1];
vsigns = [1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#test6
#Z=Nan; Dopustiva oblast ne postoji; status(4)
goal = "max";
c = [1 2];
A = [1 1; 3 3];
b = [2; 4];
csigns = [1; -1];
vsigns = [1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#test7
#Z=12*10^6; X(2500 1000) Xd(1500 0 0 2000); Y(0 2000 0 0) Yd(0 0); status(2)
#Z=12*10^6; X(2000 2000) ; status(2)
goal = "max";
c = [4000 2000];
A = [3 3; 2 1; 1 0; 0 1];
b = [12000; 6000; 2500; 3000];
csigns = [-1; -1; -1; -1];
vsigns = [1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
#**********************************************************************
#test8
#Z=18; X(0 2) Xd(0 0); Y(0 4.5) Yd(1.5 0); status(1)
#Z=18; X(0 2) Xd(0 0); Y(1.5 1.5) Yd(0 0); status(1)
goal = "max";
c = [3 9];
A = [1 4; 1 2]
b = [8; 4];
csigns = [-1; -1];
vsigns = [1; 1];
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)


#test9 tutorijal 4
goal = "min";
c = [200 300];
A = [2 3; 1 1; 2 1.5]
b = [1200; 400; 900]
csigns = [1; -1; 1]
vsigns = [1; 1]
Z, X = rijesi_simplex(goal, A, b, c, csigns, vsigns)
