Module mod_test
  Implicit none
  Real :: x = 100., y = 200.
End module mod_test
  
Program test
  use mod_test
  Implicit none
  Integer :: i = 1, j = 2
  Write(*,'(a,2I7,2f7.1)') ' Begining:', i, j, x, y
  call sub1( i, j )
  Write(*,'(a,2I7,2f7.1)') ' after sub1:', i, j, x, y
  call sub2
  Write(*,'(a,2I7,2f7.1)') ' after sub2:', i, j, x, y
Contains
  Subroutine sub2
    Implicit none
    Real :: x
    x = 1000.
    y = 2000.
    Write(*,'(a,2f7.1)') ' in sub2:', x, y
  End subroutine sub2
End program test
  
Subroutine sub1( i, j )
  Implicit none
  Integer, intent(inout) :: i, j
  Integer :: arr(5)
  Write(*,'(a,2I7)') ' in sub1 before sub2:', i, j
  call sub2
  Write(*,'(a,2I7)') ' in sub1 after sub2:', i, j
  arr = [ (100*i, i = 1, 5) ]
  Write(*,'(a,7I7)') ' after arr def in sub1:', i, j, arr
Contains  
  Subroutine sub2
    Implicit none
    Integer :: i
    i = 1000
    j = 2000
    Write(*,'(a,2I7)') ' in sub1 in sub2:', i, j
  End subroutine sub2
End subroutine sub1