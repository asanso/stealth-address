import hashlib 
h = hashlib.sha256()

# 256k1
p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
a = 0x0000000000000000000000000000000000000000000000000000000000000000
b = 0x0000000000000000000000000000000000000000000000000000000000000007
Gx= 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
Gy= 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141

# To verify some properties:
E = EllipticCurve(GF(p),[a,b])
G = E([Gx,Gy])
 
#Bob

#private
m = ZZ.random_element(n)
#public
M = m*G

#Alice

#private
r = ZZ.random_element(n)
#publish
R = r*G
Sa = r * M
s = ''
s+=str(R[0])
s+=str(R[1])
s+=str(Sa[0])
s+=str(Sa[1])
h.update(s.encode())

hashS = (int(h.hexdigest(), 16)) % n
Pa  = M + hashS*G 

#Bob
Sb = m*R
Pb = M + hashS*G 
p = m+hashS

assert Sa == Sb
assert Pa == Pb == p*G
