Module m
  Implicit none
  Integer :: mod_a = 1
  Real :: mod_b = 2.0
End module m
  
Program test_use_only
  use m, only : a => mod_a  !// onlyǰ��Ҫ�ж��ţ�only�����ǵ�ð��
  Implicit none
  print*, a 
End program test_use_only