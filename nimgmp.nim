{.deadcodeElim: on.}

type
  Cmpz {.final.} = object
  PCmpz = ptr Cmpz
  Pmpz* = ref Tmpz
  Tmpz {.pure, final.} = object
    d: int
    p: PCmpz

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

# Getters
proc CmpzGetStr(str: cstring, base: cint, op: PCmpz): cstring {.importc: "mpz_get_str", header: "<gmp.h>"}

# Arithmetic
proc CmpzAdd(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_add", header:"<gmp.h>"}

proc CmpzAddUi(mpz, mpz2: PCmpz, val: culong) {.cdecl, importc: "mpz_add_ui", header:"<gmp.h>"}

proc CMpzSub(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_sub", header:"<gmp.h>"}

proc CMpzMul(mpz, mpz2, mpz3: PCmpz) {.cdecl, importc: "mpz_mul", header:"<gmp.h>"}

# Exponentiation
proc CmpzPowUi(rop: PCmpz, base: PCmpz, exp: culong) {.cdecl, importc: "mpz_pow_ui", header: "<gmp.h>"}

# Misc
proc CmpzFacUi(rop: PCmpz, exp: culong): void {.importc: "mpz_fac_ui", header: "<gmp.h>"}

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

proc setSi*(mpz: Pmpz, val: int) =
  ## Set Pmpz from int.
  CmpzSetSi(mpz.p, clong(val))

proc setStr*(mpz: Pmpz, str: string): int = 
  ## Set Pmpz from string.
  result = CmpzSetStr(mpz.p, str, 10)
  
proc swap*(mpz, mpz2: Pmpz) =
  ## Swap the values mpz and mpz2 efficiently.
  CmpzSwap(mpz.p, mpz2.p)

proc `$`*(mpz: Pmpz): string =
  ## Pmpz to string
  result = $CmpzGetStr(nil, 10, mpz.p)

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

proc pow *(mpz: PMpz, val: int): PMpz =
  ## Raise PMpz to the power of int.
  result = newMpz()
  CmpzPowUi(result.p, mpz.p, culong(val))

when isMainModule:
  from strutils import parseInt

  # Solve Euler 56
  proc digitSum(num: string): int =
    for c in num:
      result += parseInt($c)
      
  proc solve56() =
    var 
      sum = 0
    for a in 1.. <100:
      var ax = newMpz(a)
      for b in 1.. <100:
        var tmpres = digitSum($pow(ax, b))
        if tmpres > sum: sum = tmpres
    echo sum

  solve56()
    
{.passL: "-L/usr/local/lib -lgmp".}
