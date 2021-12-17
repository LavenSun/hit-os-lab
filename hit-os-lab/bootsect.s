SETUPSEG=0x07e0         ! setup代码的段地址
entry start
start:
    mov ah,#0x03        ! 设置功能号
    xor bh,bh           ! 将bh置0
    int 0x10            
    mov cx,#29          ！要显示的字符串长度
    mov bx,#0x0007      ! bh=0,bl=07(正常的黑底白字)
    mov bp,#msg1        ! es:bp 要显示的字符串物理地址
    mov ax,#0x07c0      ! 将es段寄存器置为#0x07c0
    mov es,ax           
    mov ax,#0x1301      ! ah=13(设置功能号),al=01(目标字符串仅仅包含字符，属性在BL中包含，光标停在字符串结尾处)
    int 0x10            ! 显示字符串

! 将setup模块从磁盘的第二个扇区开始读到0x7e00
load_setup:
    mov dx,#0x0000                  ! 磁头=0；驱动器号=0
    mov cx,#0x0002                  ! 磁道=0；扇区=2
    mov bx,#0x0200                  ! 偏移地址
    mov ax,#0x0200+2                ! 设置功能号；2是需要读出的扇区数量
    int 0x13                        ! 读磁盘扇区到内存
    jnc ok_load_setup               ! CF=0(读入成功)跳转到ok_load_setup  
    mov dx,#0x0000                  ! 如果读入失败，使用功能号ah=0x00————磁盘系统复位
    mov ax,#0x0000
    int 0x13
    jmp load_setup                  ! 尝试重新读入

ok_load_setup:
    jmpi    0,SETUPSEG              ! 段间跳转指令，跳转到setup模块处(0x07e0:0000)

! 字符串信息
msg1:
    .byte   13,10           ! 换行+回车
    .ascii  "LavenOS is running..."
    .byte   13,10,13,10    

.org 510

boot_flag:
    .word   0xAA55        