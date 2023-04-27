load('csidh.sage')
load('csi-fish.sage')
import hashlib 
h = hashlib.sha256()

A,B = init_relation_lattices()
class_number = 254652442229484275177030186010639202161620514305486423592570860975597611726191

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

s = ''
s += str(Sa)
h.update(s.encode())
hashS = (int(h.hexdigest(), 16)) % class_number
#short coming of the sage csi-fish implementation
hashS = hashS % 2^20
hashS_reduced = reduce(hashS,A,B)

P = action(M,hashS_reduced)

#Bob
Sb = action(R, m)
pv = []
for i,_ in enumerate(m):
    pv.append(m[i]+hashS_reduced[i])

assert Sa == Sb
assert P == action(base,pv)

