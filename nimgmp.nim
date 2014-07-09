{.deadcodeElim: on.}

type
  Cmpz {.final.} = object
  PCmpz = ptr Cmpz
  Tmpz* {.final.} = object
    p: ptr Cmpz
  PMpz* = ref Tmpz

# C declares
# Integer functions
proc CmpzInit(mpz: PCmpz){.cdecl, importc: "mpz_init", header:"<gmp.h>"}
proc CmpzClear(mpz: PCmpz){.cdecl, importc: "mpz_clear", header:"<gmp.h>"}
proc CmpzSet(mpz: PCmpz, mpz2: PCmpz){.cdecl, importc: "mpz_set", header:"<gmp.h>"}
proc CmpzSetUi(mpz: PCmpz, val: culong){.importc: "mpz_set_ui", header:"<gmp.h>", nodecl.}
proc CmpzSetStr(mpz: PCmpz, str: cstring, base: cint): cint {.cdecl, importc: "mpz_set_str", header:"<gmp.h>"}
proc CmpzGetStr(str: cstring, base: cint, op: PCmpz): cstring {.importc: "mpz_get_str", header: "<gmp.h>"}
proc CmpzAdd(rop: PCmpz, op: PCmpz, optwo: PCmpz): void {.importc: "mpz_add", header: "<gmp.h>"}
proc CmpzPowUi(rop: PCmpz, base: PCmpz, exp: culong): void {.importc: "mpz_pow_ui", header: "<gmp.h>"}
proc CmpzFacUi(rop: PCmpz, exp: culong): void {.importc: "mpz_fac_ui", header: "<gmp.h>"}

proc mpzFinalizer(mpz: Pmpz) =
  CmpzClear(mpz.p)

proc newMpz*(initVal: int = 0): PMpz =
  new(result, mpzFinalizer)
  result.p = cast[ptr Cmpz](alloc(sizeof(Cmpz)))
  CmpzInit(result.p)
  if initVal != 0:
    CmpzSetUi(result.p, culong(initVal))

proc setStr*(mpz: Pmpz, str: string): int = 
  result = CmpzSetStr(mpz.p, str, 10)

proc `$`*(mpz: Pmpz): string =
  result = $CmpzGetStr(nil, 10, mpz.p)

when isMainModule:
  var 
    a = newMpz(10)
  assert ($a == "10")

{.passL: "-L/usr/local/lib -lgmp".}
