# Solving Project Euler 2
# http://projecteuler.net/problem=2

import nimgmp

proc main() =
  var 
    sum = newMpz(0)
    lim = 4000000
  for num in fibonaci(4000000):
    if num > lim: break
    sum += num
  echo "Returned: ", sum, " Expected: 9227464"

main()
