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

!Program test_ptr3
!  implicit none
!  real, pointer :: P1, P2, P3
!  real, target :: a = 11., b = 12.5, c = 3.151492
!  
!  nullify( P1, P2, P3 )  !.. 指针初始化
!  write( *,* ) associated( P1 )  !.. P1未被关联，返回值为假
!  
!  P1 => a  !.. 指针P1指向变量a的地址
!  P2 => b  !.. 指针P2指向变量b的地址
!  P3 => c  !.. 指针P3指向变量c的地址
!  
!  write( *,* ) associated( P1 )  !.. P1被关联，返回值为真
!  write( *,* ) associated( P1, b )  !.. P1与变量a的地址关联，所以返回值为假
!  
!End program test_ptr3

!.. 指针指向与赋值的区别
!.. => 表示内存位置的指向
!.. =  表示指针所指内存处变量值的引用以及改变
!Program test_ptr4
!  implicit none
!  real, pointer :: P1, P2, P3
!  real,  target :: a = 11., b = 12.5, c
!  
!  nullify( P1, P2, P3 )  !.. 指针初始化
!  P1 => a  !.. P1 points to a
!  P2 => b  !.. P2 points to b
!  P3 => c  !.. P3 points to c
!  P3 = P1 + P2  !.. same as c = a + b
!  write( *,* ) ' P3 = ', P3
!  
!  P2 => P1  !.. P2 points to a
!  P3 = P1 + P2  !.. same as c = a + a
!  write( *,* ) ' P3 = ', P3
!  P3 = P1  !.. same as c = a
!  P3 => P1  !.. P3 points to a
!  write( *,* ) ' P3 = ', P3
!  
!  write( *,* ) ' a, b, c = ', a, b, c
!End Program test_ptr4


!.. Part2: 数组指针
!.. 指向数组的指针必须声明其将指向的数组类型以及维数，但是不需要声明每一维的宽度
!.. Warning: 当释放某片内存空间时，一定要总是对指向同一内存的所有指针进行置空或重赋值。它们中的一个会因为deallocate自动置空，但是其他的必须通过nullify置空，或通过指针赋值语句重新赋值
!Program array_ptr
!  implicit none
!  Integer :: i
!  Integer, target :: info(16) = [ (i, i = 1, 16) ]
!  Integer, dimension(:), pointer :: ptr1, ptr2, ptr3, ptr4, ptr5
!  
!  ptr1 => info
!  ptr2 => ptr1(2::2)  !.. 第一个2表示从第二个元素开始，最后一个2表示隔两个元素
!  ptr3 => ptr2(2::2)  !.. 第一个:为语法固定格式，第二个:表示数组片段的末尾
!  ptr4 => ptr3(2::2)
!  ptr5 => ptr4(2::2)
!  write( *,'(1x,a,16I3)' )  'ptr1 = ', ptr1
!  write( *,'(1x,a,16I3)' )  'ptr2 = ', ptr2
!  write( *,'(1x,a,16I3)' )  'ptr3 = ', ptr3
!  write( *,'(1x,a,16I3)' )  'ptr4 = ', ptr4
!  write( *,'(1x,a,16I3)' )  'ptr5 = ', ptr5
!End program array_ptr

!.. 尽管指针可以用于三元组(例如a(1:5:2))所定义的数组片段，但是不能用于向量下标所定义的数组片段，所以下面的语句是非法的，会产生编译错误
!.. integer :: i
!.. integer :: subs(3) = [1,2,3]
!.. integer, target :: info(10) = [ (i, i = 1, 10) ]
!.. integer, pointer :: ptr(:)
!.. ptr => info(subs)  !.. 不能用于向量下标说定义的数组片段
!.. 上述代码会产生编译错误
  
!.. ***---***
!.. 在排序或交换大型数组或派生数据类型时，交换指向数据的指针要比交换数据本身高效得多
!.. example
!.. real, dimension(100,100) :: array1, array2, temp
!.. ---
!.. temp = array1
!.. array1 = array2
!.. array2 = temp
!.. 上述代码虽然简单，但是每条赋值语句都要移动100*100的数据量，需要大量时间。可以用下面的代码进行优化

!.. real, dimension(100,100), target :: array1, array2
!.. real, dimension(:,:), pointer :: P1, P2, temp
!.. P1 => array1
!.. P2 => array2
!.. ---
!.. temp => P1
!.. P1 = > P2
!.. P2 = > temp
!Program main
!  implicit none
!  real, target :: array1(10) = [1.,2.,3.,4.,5.,6.,7.,8.,9.,10.]
!  real, target :: array2(10) = [10.,9.,8.,7.,6.,5.,4.,3.,2.,1.]
!  real, pointer :: P1(:), P2(:), temp(:)
!  integer :: i
!  
!  P1 => array1
!  P2 => array2
!  write( *,'(10f6.2)' ) ( P1(i), i = 1, 10 )
!  write( *,'(10f6.2)' ) ( P2(i), i = 1, 10 )
!  
!  temp => P1
!  P1 => P2
!  P2 => temp
!  
!  write( *,'(10f6.2)' ) ( P1(i), i = 1, 10 )
!  write( *,'(10f6.2)' ) ( P2(i), i = 1, 10 )
!  
!End program main

!.. 使用指针的动态内存分配
Program mem_leak  !.. 一般来说, 动态指针才会造成内存泄漏
  implicit none
  Integer :: i, istat
  Integer, parameter :: n = 10
  Integer, pointer :: ptr1(:), ptr2(:)
  
  !.. check associated status of ptrs
  write( *,'(1x,a,2L5)' ) 'Are ptr1, ptr2 associated?', &
  associated( ptr1 ), associated( ptr2 )
  
  !.. allocate and initialize memory
  allocate( ptr1(n), stat = istat )
  allocate( ptr2(n), stat = istat )
  ptr1 = [ ( i, i = 1, n ) ]
  ptr2 = [ ( i, i = 11, n+10 ) ]
  
  !.. check associated status of ptrs
  write( *,'(1x,a,2L5)' ) 'Are ptr1, ptr2 associated?', &
  associated( ptr1 ), associated( ptr2 )
  
  write( *,'(1x,a,*(I3))' ) 'ptr1 = ', ptr1  !.. write out data
  write( *,'(1x,a,*(I3))' ) 'ptr2 = ', ptr2
  
  deallocate( ptr2, stat = istat )  !.. 与可分配数组不同，这里不叫释放内存，而是置空指针，置空后不需要重新分配内存，只需要重新进行指向即可
  ptr2 => ptr1  !.. 此处ptr2的指向改变，所以ptr2先前指向的内存无法访问，造成内存泄漏。应该先deallocate(ptr2),再重新allocate(ptr2)
  write( *,'(1x,a,*(I3))' ) 'ptr1 = ', ptr1  !.. write out data
  write( *,'(1x,a,*(I3))' ) 'ptr2 = ', ptr2
  
  deallocate( ptr2, stat = istat )  !.. deallocate memory
  nullify( ptr1 )  !.. nullify pointer
  
End program mem_leak