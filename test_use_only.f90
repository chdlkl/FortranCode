Module m
  Implicit none
  Integer :: mod_a = 1
  Real :: mod_b = 2.0
End module m
  
Program test_use_only
  use m, only : a => mod_a  !// only前面要有逗号，only后面是单冒号
  Implicit none
  print*, a 
End program test_use_only