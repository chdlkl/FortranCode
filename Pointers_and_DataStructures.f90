!.. Part1: 变量指针
!Program test_ptr1
!  implicit none
!  real, pointer :: P
!  real, target :: t1 = 10., t2 = -17.
!  
!  nullify( P )  !.. 指针初始化
!  P => t1
!  write( *,* ) ' P, t1, t2 = ', P, t1, t2  !.. P首先指向t1
!  P => t2 
!  write( *,* ) ' P, t1, t2 = ', P, t1, t2  !.. 指针重新指向另一个变量时，自动与前一个目标地址断开
!  
!End program test_ptr1
  

!Program test_ptr2
!  implicit none
!  real, pointer :: P1, P2
!  real, target :: t1 = 10., t2 = -17.
!  
!  nullify( P1, P2 )  !.. 指针初始化
!  P1 => t1
!  P2 => P1  !.. 这里要特别注意，P2指向的不是P1的内存位置，而是与P1关联的变量的内存位置，所以下面当P1指向更改之后，P2的指向不变
!  write( *,* ) ' P1, P2, t1, t2 = ', P1, P2, t1, t2  !.. P1与P2指向同一个变量的地址
!  P1 => t2  !.. 注意，此时P1的指向已变，但是P2的指向不随P1指向的改变而改变
!  write( *,* ) ' P1, P2, t1, t2 = ', P1, P2, t1, t2  !.. P1与变量t1的地址断开，与变量t2关联
!  
!End program test_ptr2  

!.. 指针初始化为未关联状态有两种方式
!.. 1. 在声明的同时就初始化: integer, pointer :: P => null()
!.. 2. 在声明语句结束后初始化: nullify( P )

Program test_ptr3
  implicit none
  real, pointer :: P1, P2, P3
  real, target :: a = 11., b = 12.5, c = 3.151492
  
  nullify( P1, P2, P3 )  !.. 指针初始化
  write( *,* ) associated( P1 )  !.. P1未被关联，返回值为假
  
  P1 => a  !.. 指针P1指向变量a的地址
  P2 => b  !.. 指针P2指向变量b的地址
  P3 => c  !.. 指针P3指向变量c的地址
  
  write( *,* ) associated( P1 )  !.. P1被关联，返回值为真
  write( *,* ) associated( P1, b )  !.. P1与变量a的地址关联，所以返回值为假
  
End program test_ptr3