#Napišite Julia funkciju odredi, koja prima parametre M i reduced koji označavaju matricu cijena raspoređivanja i reduciranu matricu respektivno.
#Funkcija vraća R i Z , matricu raspoređivanja s jedinicama na uparenim lokacijama i vrijednost funkcije cilja odnosno ukupni trošak raspoređivanja. 
#Pretpostavite da funkcija prima samo probleme koji nakon tehnike Flooda rezultiraju s rješenjem.

function odredi(M, reduced)
   m,n = size(M);
    R = zeros(m,n);
    Z = 0;

    for i in 1:m 
        for j in 1:n
            if reduced[i,j] == 0
                R[i,j] = 1;
                Z+=M[i,j];
            end
        end             
    end
  
    return R, Z
end