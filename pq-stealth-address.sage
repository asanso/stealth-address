load('csidh.sage')
load('csi-fish.sage')


A,B = init_relation_lattices()

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
Sa_reduced = 100
hashS = reduce(Sa_reduced,A,B)

P = action(M,hashS)

#Bob
Sb = action(R, m)
pv = []
for i,_ in enumerate(m):
    pv.append(m[i]+hashS[i])

assert Sa == Sb
assert P == action(base,pv)

