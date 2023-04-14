load('csidh.sage')

#Bob
#private
m = private()
#public
M = action(base, m)

#private
r =private()
#publish
R = action(base, r)
Sa = action(M, r)
#hashS = Sa[0]
#Pa  = M + hashS*G 

#Bob
Sb = action(R, m)

assert Sa == Sb