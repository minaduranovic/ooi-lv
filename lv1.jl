# 1. zad

3 * 456/23 + 31.54 +2^6
sin(pi/7) * ℯ^0.3 * (2 + 0.9im)
sqrt(2) * log(10) 
(5 + 3im) / (1.2 + 4.5im)

# 2. zad
a = (atan(5) + ℯ^5.6) / 3 
b = (sin(pi/3))^(1/15)
c = (log(15)+1) / 23
d = (sin(pi/2) + cos(pi))

e = (a+b)*c
f = acos(b) * asin(c / 11)
g = ((a-b)^4) / d
h = c^(1/a) + (b*im)/(3+2im)

# 3. zad
using LinearAlgebra
A = [1 -4*im sqrt(2); log(im) sin(pi/2) cos(pi/3); asin(0.5) acos(0.8) ℯ^0.8]
B = tr(A)
# A + B
B * A
det(A)
inv(A)

# 4. zad
matrica1 = zeros(8, 9)
matrica2 = ones(7, 5)
matrica3 = I(5)
matrica4 = rand(4, 9)

# 5. zad
a = [2 7 6
     9 5 1  
     4 3 8]
sum(a)
sum(a, dims=1)
sum(a, dims=2)
sum(diag(a))
minimum(a, dims=1)
minimum(a, dims=2)
maximum(a, dims=1)
maximum(a, dims=2)
minimum(diag(a))
maximum(diag(a))

# 6. zad
A = [1 2 3
     4 5 6
     7 8 9]
B = [1 1 1
     2 2 2
     3 3 3]

C = sin.(A)

C = sin.(A)*cos.(B)

C = A^(1/3)

C = A.^(1/3)

# 7. zad
v1 = [0:99;]'
v2 = [0:99;]' /100
v3 = [39: -2: 1;] 

# 8. zad
a = [7*ones(4,4) zeros(4,4) 
     3*ones(4,8)]
b = I(8) + a
c = b[1:2:8,:]
d = b[:,1:2:8]
e = b[1:2:8,1:2:8]

# Funkcije za crtanje 
# 1. zad
using Plots
x = range(-π, π, length=101)
y = sin.(x)
plot(x, y, label="y = sin(x)", xlabel="x", ylabel="y", title="Grafik funkcije y = sin(x)")


y = cos.(x)
plot(x, y, label="y = cos(x)", xlabel="x", ylabel="y", title="Grafik funkcije y = cos(x)")


x = range(1, 10, length=101)
y = sin.(1 ./ x)
plot(x, y, label="y = sin(1/x)", xlabel="x", ylabel="y", title="Grafik funkcije y = sin(1/x)", lw=2, color=:black, linestyle=:solid)


x = range(1, 10, length=101)
y = sin.(1 ./ x)
plot(x, y, label="y = sin(1/x)", xlabel="x", ylabel="y", title="Grafik funkcije y = sin(1/x)", lw=2, color=:black, linestyle=:solid)

y2 = cos.(1 ./x)
plot!(x, y2, label="y2 = cos(1/x)", color=:blue, marker=:circle, linestyle=:none)

# 2. zad
x = y = range(-8, 8, step=0.5)
X, Y = [i for i in x], [j for j in y]
Z = [sin(sqrt((x^2 + y^2))) for x in X, y in Y]
plot(surface(X, Y, Z), xlabel="x", ylabel="y", zlabel="z", 
     title="Grafik funkcije z")

# funkcije i metaprogramiranje

function saberi_oduzmi(a::Array=0, b::Array=0)
     if !isa(a, AbstractArray)
         a = [a]
     end
     if !isa(b, AbstractArray)
         b = [b]
     end
          if size(a) != size(b)
         println("Dimenzije matrica se ne podudaraju.")
         return 0, 0
     end
      zbir = a + b
     razlika = a - b
     return zbir, razlika
 end

