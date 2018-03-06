Module m
  Implicit none
Contains
  Subroutine sub ( str1, str2, str3 )
    Implicit none
    Character(len=*), intent(in) :: str1
    Character(len=*), optional :: str2, str3  !// 可选参数不能改变其值
    Character(len=20) :: res
    If ( present(str2) ) then
      res = str2//' is a '//str1
      print*, res
    End if
    If ( present(str3) ) then
      res = str3//' is a '//str1
      print*, res
    End if
  End subroutine sub
End module m
  
Program test_optional
  use m
  Implicit none
  Character(len=20) :: str2, str3 
  call sub( 'good man!', str2 = 'luk' )
  call sub( 'good man!', str3 = 'lkl' )
End program test_optional