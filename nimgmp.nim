{.deadcodeElim: on.}

type
  Cmpz {.importc: "mpz_t", header: "<gmp.h>", final.} = object
  PCmpz = ptr Cmpz
  Pmpz* = ref Tmpz
  Tmpz {.pure, final.} = object
    d: int
    p: PCmpz
  PrimeProbab = enum
    notPrime = 0, mayPrime = 1, defPrime = 2
  CGmpRandstate {.importc: "gmp_randstate_t", header: "<gmp.h>", final.} = object
  PCGmpRandstate = ptr CGmpRandstate
  PGmpRandstate* = ref TGmpRandstate
  TGmpRandstate {.pure, final.} = object
    d: int
    p: PCGmpRandstate

var globRandState: PGmpRandstate

# C declares
# Integer
# Init & clear funcs
proc CmpzInit(mpz: PCmpz){.cdecl, importc: "mpz_init", header:"<gmp.h>"}

proc CmpzClear(mpz: PCmpz){.cdecl, importc: "mpz_clear", header:"<gmp.h>"}

proc CmpzSet(mpz: PCmpz, mpz2: PCmpz){.cdecl, importc: "mpz_set", header:"<gmp.h>"}

proc CmpzSetUi(mpz: PCmpz, val: culong){.importc: "mpz_set_ui", header:"<gmp.h>", nodecl.}

proc CmpzSetSi(mpz: PCmpz, val: clong){.importc: "mpz_set_si", header:"<gmp.h>", nodecl.}

proc CmpzSetStr(mpz: PCmpz, str: cstring, base: cint): cint {.cdecl, importc: "mpz_set_str", header:"<gmp.h>"}

proc CmpzSwap(mpz, mpz2: PCmpz){.importc: "mpz_swap", header: "<gmp.h>"}

# Conversion Functions
proc CmpzGetStr(str: cstring, base: cint, op: PCmpz): cstring {.importc: "mpz_get_str", header: "<gmp.h>"}

proc CmpzGetUi(mpz: PCmpz): culong {.cdecl, importc: "mpz_get_ui", header: "<gmp.h>"}

proc CmpzGetSi(mpz: PCmpz): clong {.cdecl, importc: "mpz_get_si", header: "<gmp.h>"}

# Arithmetic
proc CmpzAdd(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_add", header:"<gmp.h>"}

proc CmpzAddUi(mpz, mpz2: PCmpz, val: culong) {.cdecl, importc: "mpz_add_ui", header:"<gmp.h>"}

proc CMpzSub(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_sub", header:"<gmp.h>"}

proc CMpzMul(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_mul", header:"<gmp.h>"}

proc CmpzAbs(mpz, mpz2: PCmpz) {.cdecl, importc: "mpz_abs", header:"<gmp.h>"}

# Division
proc CmpzMod(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_mod", header:"<gmp.h>"}

proc CmpzModUi(mpz, mpz2: PCmpz, val: culong) {.cdecl, importc: "mpz_mod_ui", header:"<gmp.h>"}

proc CMpzDivisibleP(mpz, mpz2: PCmpz): cint {.cdecl, importc: "mpz_divisible_p", header:"<gmp.h>"}

proc CMpzDivisibleUiP(mpz: PCmpz, val: culong): cint {.cdecl, importc: "mpz_divisible_ui_p", header:"<gmp.h>"}

# Exponentiation
proc CmpzPowUi(rop: PCmpz, base: PCmpz, exp: culong) {.cdecl, importc: "mpz_pow_ui", header: "<gmp.h>"}

# Root Extraction Functions
proc CmpzSqrt(mpz, mpz2: PCmpz) {.cdecl, importc: "mpz_sqrt", header: "<gmp.h>"}

# Number Theoretic Functions
proc CmpzProbabPrimeP(mpz: PCmpz, reps: cint): cint {.cdecl, importc: "mpz_probab_prime_p", header: "<gmp.h>"}

proc CmpzNextPrime(mpz, mpz2: PCmpz) {.cdecl, importc: "mpz_nextprime", header: "<gmp.h>"}

proc CMpzGcd(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_gcd", header: "<gmp.h>"}

proc CmpzFibUi(mpz: PCmpz, ind: culong) {.cdecl, importc: "mpz_fib_ui", header: "<gmp.h>"}

# Comparison Functions
proc CmpzCmp(mpz, mpz2: PCmpz): cint {.cdecl, importc: "mpz_cmp", header: "<gmp.h>"}

proc CmpzCmpSi(mpz: PCmpz, val: clong): cint {.cdecl, importc: "mpz_cmp_si", header: "<gmp.h>"}

proc CmpzCmpUi(mpz: PCmpz, val: culong): cint {.cdecl, importc: "mpz_cmp_ui", header: "<gmp.h>"}

proc CmpzCmpD(mpz: PCmpz, val: cdouble): cint {.cdecl, importc: "mpz_cmp_d", header: "<gmp.h>"}

# Random number functions
proc CgmpRandinitDefault(state: PCGmpRandstate) {.cdecl, importc: "gmp_randinit_default", header: "<gmp.h>"}

proc CgmpRandclear(state: PCGmpRandstate) {.cdecl, importc: "gmp_randclear", header: "<gmp.h>"}

proc CMpzUrandomm(mpz: PCmpz, state: PCGmpRandstate, n: PCmpz) {.cdecl, importc: "mpz_urandomm", header: "<gmp.h>"}

# Misc
proc CmpzFacUi(rop: PCmpz, exp: culong) {.importc: "mpz_fac_ui", header: "<gmp.h>"}


# NIMROD WRAPPERS
# INTEGERS
proc setStr(mpz: Pmpz, str: string): int # Forward declaration

proc mpzFinalizer(mpz: Pmpz) =
  CmpzClear(mpz.p)

proc newMpz*(initVal: int = 0): PMpz =
  ## Initializes a big integer
  ## optionally sets its value.
  new(result, mpzFinalizer)
  result.p = cast[ptr Cmpz](alloc(sizeof(Cmpz)))
  CmpzInit(result.p)
  if initVal != 0:
    CmpzSetSi(result.p, clong(initVal))

proc newMpz*(initVal: string): PMpz =
  ## Initializes a big integer
  ## optionally sets its value from string containg number.
  result = newMpz(0)
  if initVal != "":
    discard result.setStr(initVal)

proc setSi*(mpz: Pmpz, val: int) =
  ## Set Pmpz from int.
  CmpzSetSi(mpz.p, clong(val))

proc setStr*(mpz: Pmpz, str: string): int = 
  ## Set Pmpz from string.
  result = CmpzSetStr(mpz.p, str, 10)
  
proc swap*(mpz, mpz2: Pmpz) =
  ## Swap the values mpz and mpz2 efficiently.
  CmpzSwap(mpz.p, mpz2.p)

proc toInt*(mpz: PMpz): int =
  ## Converts mpz to int value.
  result = int(CmpzGetSi(mpz.p))

proc `$`*(mpz: PMpz): string =
  ## Pmpz to string
  result = $CmpzGetStr(nil, 10, mpz.p)

proc `<`*(mpz, mpz2: PMpz): bool =
  return int(CmpzCmp(mpz.p, mpz2.p)) < 0

proc `<`*(mpz: PMpz, val: int): bool =
  return int(CmpzCmpD(mpz.p, cdouble(val))) < 0

proc `<`*(val: int, mpz: PMpz): bool =
  return int(CmpzCmpD(mpz.p, cdouble(val))) > 0

proc `==`*(mpz, mpz2: PMpz): bool =
  return int(CmpzCmp(mpz.p, mpz2.p)) == 0

proc `==`*(mpz: PMpz, val: int): bool =
  return int(CmpzCmpD(mpz.p, cdouble(val))) == 0

proc abs*(mpz, mpz2: PMpz) =
  ## Set mpz to the absolute value of op.
  CmpzAbs(mpz.p, mpz2.p)

proc gcd*(mpz, mpz2: PMpz): PMpz =
  result = newMpz()
  CmpzGcd(result.p, mpz.p, mpz2.p)

proc `mod`*(mpz, mpz2: PMpz): PMpz =
  ## Return new mpz set to mpz mod mpz2. 
  ## The sign of the divisor is ignored; the result is always non-negative.
  result = newMpz()
  CmpzMod(result.p, mpz.p, mpz2.p)

proc `mod`*(mpz: PMpz, val: int): PMpz =
  ## Return new mpz set to mpz mod val. 
  ## The sign of the divisor is ignored; the result is always non-negative.
  result = newMpz()
  CmpzModUi(result.p, mpz.p, culong(val))

proc sqrt*(mpz: PMpz): PMpz =
  result = newMpz()
  CmpzSqrt(result.p, mpz.p)

proc `+`*(mpz, mpz2: PMpz): PMpz =
  ## Perform addition on two Mpz objects
  ## return new Mpz object.
  result = newMpz()
  CmpzAdd(result.p, mpz.p, mpz2.p)

proc `+`*(mpz: PMpz, val: int): Pmpz =
  ## Add mpz and int
  ## Return new mpz object.
  ## Negative values produce unexpected results...
  result = newMpz()
  CmpzAddUi(result.p, mpz.p, culong(val))

proc `+=`*(mpz, mpz2: PMpz) =
  ## Same as add, assigns result to first variable
  CmpzAdd(mpz.p, mpz.p, mpz2.p)

proc `+=`*(mpz: PMpz, val: int) =
  ## Same as add, assigns result to first variable
  CmpzAddUi(mpz.p, mpz.p, culong(val))

proc `-`*(mpz, mpz2: PMpz): PMpz =
  ## Performs subtraction on two Mpz objects
  ## returns new Mpz object.
  result = newMpz()
  CmpzSub(result.p, mpz.p, mpz2.p)

proc `-=`*(mpz, mpz2: PMpz) =
  ## Same as subtraction, assigns result to first variable
  CmpzSub(mpz.p, mpz.p, mpz2.p)

proc `*`*(mpz, mpz2: PMpz): PMpz = 
  ## Performs multiplication on two Mpz objects
  ## returns new Mpz object.
  result = newMpz()
  CmpzMul(result.p, mpz.p, mpz2.p)

proc `*=`*(mpz, mpz2: PMpz) =
  ## Same as multiplication, assigns result to first variable.
  CmpzMul(mpz.p, mpz.p, mpz2.p)

proc divisible*(mpz, mpz2: PMpz): bool =
  return CmpzDivisibleP(mpz.p, mpz2.p) != 0

proc divisible*(mpz: PMpz, val: int): bool =
  return CmpzDivisibleUiP(mpz.p, culong(val)) != 0

proc pow *(mpz: PMpz, val: int): PMpz =
  ## Raise PMpz to the power of int.
  result = newMpz()
  CmpzPowUi(result.p, mpz.p, culong(val))

proc isPrime*(mpz: PMpz, reps = 25): PrimeProbab =
  ## Determine whether mpz is prime.
  result = PrimeProbab(CmpzProbabPrimeP(mpz.p, cint(reps)))

proc nextPrime*(mpz: PMpz): PMpz =
  ## Returns the next prime greater than mpz.
  result = newMpz()
  CMpzNextPrime(result.p, mpz.p)

proc getFibonaci(ind: int): PMpz =
  ## Returns number in fibonaci series identified by ind.
  result = newMpz()
  CmpzFibUi(result.p, culong(ind))

iterator primes*(lowerBnd = 0, upprBnd: int): PMpz =
  var 
    mpz: PMpz
    upmpz = newMpz(upprBnd)
  if lowerBnd > 0:
    mpz = newMpz(lowerBnd)
  else:
    mpz = newMpz()
  while true:
    var tmp = newMpz()
    CmpzNextPrime(tmp.p, mpz.p)
    if tmp > upmpz: break
    mpz = tmp
    yield tmp

iterator primes*(mpz, upperBnd: PMpz): PMpz =
  while true:
    var 
      tmp = newMpz()
      tmpz = mpz
    CmpzNextPrime(tmp.p, mpz.p)
    if tmp > upperBnd: break
    tmpz = tmp
    yield tmp

iterator fibonaci*(lim: int, start = 1): PMpz =
  for i in start..lim:
    yield getFibonaci(i)

# RANDOMNESS
proc randstateFinalizer(state: PGmpRandstate) =
  CgmpRandclear(state.p)

proc newRandState*(): PGmpRandstate =
  new(result, randstateFinalizer)
  result.p = cast[ptr CGmpRandstate](alloc(sizeof(CGmpRandstate)))
  CgmpRandinitDefault(result.p)

proc random*(n: PMpz, state: PGmpRandstate = nil): PMpz =
  result = newMpz()
  if state == nil:
    CMpzUrandomm(result.p, globRandState.p, n.p)
  else:
    CMpzUrandomm(result.p, state.p, n.p)

iterator randoms*(upperBnd: Pmpz, lim: int = 0, state: PGmpRandstate = nil): PMpz =
  if lim <= 0:
    while true:
      yield random(upperBnd, state)
  else:
    for i in 0.. <lim:
      yield random(upperBnd, state)
      
# Init global randstate
globRandState = newRandstate()

when isMainModule:
  from strutils import parseInt

  # Solve Euler 56 (Powerful digit sum)
  # http://projecteuler.net/problem=56
  proc digitSum(num: PMpz): int =
    for c in $num:
      result += parseInt($c)
      
  proc solve56(): int =
    for a in 1.. <100:
      var ax = newMpz(a)
      for b in 1.. <100:
        var tmpres = digitSum(pow(ax, b))
        if tmpres > result: result = tmpres
   
  proc main() =
    var 
      a = newMpz(10)
      b = newMpz(10)
      sum = newMpz()
      
    for rnd in randoms(b, 10):
      echo rnd

  main()
  #echo solve56()
    
{.passL: "-L/usr/local/lib -lgmp".}
