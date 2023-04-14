
#!/usr/bin/env sage
#coding: utf8

proof.all(False)


# parameters.

ls = list(primes(3, 374)) + [587] # Elkies primes
#ls = list(primes(3, 47)) + [97] # (a smaller example)
p = 4 * prod(ls) - 1
assert is_prime(p)
#print ("\nElkies primes:", " ".join(map(str, ls)))

max_exp = ceil((sqrt(p) ** (1/len(ls)) - 1) / 2)
assert (2 * max_exp + 1) ** len(ls) >= sqrt(p)
#print ("exponents are chosen in the range {}..{}.".format(-max_exp, max_exp))

base = GF(p)(0) # Montgomery coefficient of starting curve


# helper functions.

# NB: all the operations can be computed entirely over the prime field,
# but for simplicity of this implementation we will make use of curves
# defined over GF(p^2).  note this slows everything down quite a bit.

Fp2.<i> = GF(p**2, modulus = x**2 + 1)

def montgomery_curve(A):
    return EllipticCurve(Fp2, [0, A, 0, 1, 0])

# sage's isogeny formulas return Weierstraß curves, hence we need this...
def montgomery_coefficient(E):
    Ew = E.change_ring(GF(p)).short_weierstrass_model()
    _, _, _, a, b = Ew.a_invariants()
    R.<z> = GF(p)[]
    r = (z**3 + a*z + b).roots(multiplicities=False)[0]
    s = sqrt(3 * r**2 + a)
    if not is_square(s): s = -s
    A = 3 * r / s
    assert montgomery_curve(A).change_ring(GF(p)).is_isomorphic(Ew)
    return GF(p)(A)


# actual implementation.

def private():
    return [randrange(-max_exp, max_exp + 1) for _ in range(len(ls))]

def validate(A):
    while True:
        k = 1
        P = montgomery_curve(A).lift_x(GF(p).random_element())
        for l in ls:
            Q = (p + 1) // l * P
            if not Q: continue
            if l * Q: return False
            k *= l
            if k > 4 * sqrt(p): return True

def action(pub, priv):

    E = montgomery_curve(pub)
    es = priv[:]

    while any(es):

        E._order = (p + 1)**2 # else sage computes this

        P = E.lift_x(GF(p).random_element())
        s = +1 if P.xy()[1] in GF(p) else -1
        k = prod(l for l, e in zip(ls, es) if sign(e) == s)
        P *= (p + 1) // k

        for i, (l, e) in enumerate(zip(ls, es)):

            if sign(e) != s: continue

            Q = k // l * P
            if not Q: continue
            Q._order = l # else sage computes this
            phi = E.isogeny(Q)

            E, P = phi.codomain(), phi(P)
            es[i] -= s
            k //= l

    return montgomery_coefficient(E)

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