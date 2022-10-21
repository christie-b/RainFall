Dump of assembler code for function main:
   0x080485f4 <+0>:	   push   ebp
   0x080485f5 <+1>:	   mov    ebp,esp
   0x080485f7 <+3>:	   push   ebx
   0x080485f8 <+4>:	   and    esp,0xfffffff0
   0x080485fb <+7>:	   sub    esp,0x20
   0x080485fe <+10>:	   cmp    DWORD PTR [ebp+0x8],0x1         ; compare argc to 1
   0x08048602 <+14>:	   jg     0x8048610 <main+28>             ; if (argc > 1), go to main+28
   0x08048604 <+16>:	   mov    DWORD PTR [esp],0x1             ; move 1 to esp
   0x0804860b <+23>:	   call   0x80484f0 <_exit@plt>           ; _exit(1)
   0x08048610 <+28>:	   mov    DWORD PTR [esp],0x6c            ; move 108 to esp
   0x08048617 <+35>:	   call   0x8048530 <_Znwj@plt>           ; _Znwj(108); (?) new(108)
   0x0804861c <+40>:	   mov    ebx,eax                         ; move return value to ebx: seems to be a pointer to a zeroed memory space, maybe 108bytes long? address : 0x804a008
   0x0804861e <+42>:	   mov    DWORD PTR [esp+0x4],0x5         ; move 5 to esp + 4
   0x08048626 <+50>:	   mov    DWORD PTR [esp],ebx             ; move ebx to esp
   0x08048629 <+53>:	   call   0x80486f6 <_ZN1NC2Ei>           ; _ZN1Nc2Ei(ebx, 5) / N::N(int) -> new N(5)
   0x0804862e <+58>:	   mov    DWORD PTR [esp+0x1c],ebx        ; move ebx to esp+28 
   0x08048632 <+62>:	   mov    DWORD PTR [esp],0x6c            ;  put 108 to esp
   0x08048639 <+69>:	   call   0x8048530 <_Znwj@plt>           ; _Znwj(108); call to new
   0x0804863e <+74>:	   mov    ebx,eax                         ; move return value to ebx, points to address 0x804a078
   0x08048640 <+76>:	   mov    DWORD PTR [esp+0x4],0x6         ; move 6 to esp+4
   0x08048648 <+84>:	   mov    DWORD PTR [esp],ebx             ; move ebx to esp
   0x0804864b <+87>:	   call   0x80486f6 <_ZN1NC2Ei>           ; _ZN1NC2Ei(ebx, 6) / N::N(int) -> new N(6)
   0x08048650 <+92>:	   mov    DWORD PTR [esp+0x18],ebx        ; move ebx to esp + 24 <<< move 0x804a078 to esp + 24
   0x08048654 <+96>:	   mov    eax,DWORD PTR [esp+0x1c]        ; move esp + 28 to eax
   0x08048658 <+100>:	mov    DWORD PTR [esp+0x14],eax           ; move eax to esp + 20 
   0x0804865c <+104>:	mov    eax,DWORD PTR [esp+0x18]           ; move esp + 24 to eax 
   0x08048660 <+108>:	mov    DWORD PTR [esp+0x10],eax           ; move eax to esp + 16 : move 0x804a078 to esp + 16
   0x08048664 <+112>:	mov    eax,DWORD PTR [ebp+0xc]            ; move esp + 12 to eax
   0x08048667 <+115>:	add    eax,0x4                            ; eax += 4
   0x0804866a <+118>:	mov    eax,DWORD PTR [eax]                ; move the dereference of eax to eax
   0x0804866c <+120>:	mov    DWORD PTR [esp+0x4],eax            ; move eax to esp + 04
   0x08048670 <+124>:	mov    eax,DWORD PTR [esp+0x14]           ; move esp + 20 to eax
   0x08048674 <+128>:	mov    DWORD PTR [esp],eax                ; move eax to esp
   0x08048677 <+131>:	call   0x804870e <_ZN1N13setAnnotationEPc> _ZN1N13setAnnotationEPc(esp+20, esp + 16) / N::setAnnotation(char*)
   0x0804867c <+136>:	mov    eax,DWORD PTR [esp+0x10]           ; move esp + 16 to eax; move 0x804a078 to eax
   0x08048680 <+140>:	mov    eax,DWORD PTR [eax]                ; move value in [eax] to eax; dereference move 0x804a078  --- if we overflow, instead of 0x08048848, we have... 0x804a078
   0x08048682 <+142>:	mov    edx,DWORD PTR [eax]                ; move value in eax to edx   ---> This is where we segfault
   0x08048684 <+144>:	mov    eax,DWORD PTR [esp+0x14]           ; move esp + 20 to eax
   0x08048688 <+148>:	mov    DWORD PTR [esp+0x4],eax            ; move eax to esp + 4
   0x0804868c <+152>:	mov    eax,DWORD PTR [esp+0x10]           ; move esp + 16 to eax
   0x08048690 <+156>:	mov    DWORD PTR [esp],eax                ; move eax to esp
   0x08048693 <+159>:	call   edx                                ; call edx => edx is a function
   0x08048695 <+161>:	mov    ebx,DWORD PTR [ebp-0x4]            ; move ebp - 4 to ebx
   0x08048698 <+164>:	leave  
   0x08048699 <+165>:	ret    

Dump of assembler code for function _Znwj@plt:
   0x08048530 <+0>:	jmp    DWORD PTR ds:0x8049b70                 ; jump to function _Znwj@got.plt
   0x08048536 <+6>:	push   0x40
   0x0804853b <+11>:	jmp    0x80484a0


(gdb) disas _ZN1NC2Ei
Dump of assembler code for function _ZN1NC2Ei:
   0x080486f6 <+0>:	push   %ebp
   0x080486f7 <+1>:	mov    %esp,%ebp
   0x080486f9 <+3>:	mov    0x8(%ebp),%eax
   0x080486fc <+6>:	movl   $0x8048848,(%eax)
   0x08048702 <+12>:	mov    0x8(%ebp),%eax
   0x08048705 <+15>:	mov    0xc(%ebp),%edx
   0x08048708 <+18>:	mov    %edx,0x68(%eax)
   0x0804870b <+21>:	pop    %ebp
   0x0804870c <+22>:	ret    
End of assembler dump.

(gdb) disas _ZN1N13setAnnotationEPc
Dump of assembler code for function _ZN1N13setAnnotationEPc:
   0x0804870e <+0>:	push   %ebp
   0x0804870f <+1>:	mov    %esp,%ebp
   0x08048711 <+3>:	sub    $0x18,%esp
   0x08048714 <+6>:	mov    0xc(%ebp),%eax
   0x08048717 <+9>:	mov    %eax,(%esp)
   0x0804871a <+12>:	call   0x8048520 <strlen@plt>
   0x0804871f <+17>:	mov    0x8(%ebp),%edx
   0x08048722 <+20>:	add    $0x4,%edx
   0x08048725 <+23>:	mov    %eax,0x8(%esp)
   0x08048729 <+27>:	mov    0xc(%ebp),%eax
   0x0804872c <+30>:	mov    %eax,0x4(%esp)
   0x08048730 <+34>:	mov    %edx,(%esp)
   0x08048733 <+37>:	call   0x8048510 <memcpy@plt>
   0x08048738 <+42>:	leave  
   0x08048739 <+43>:	ret    
End of assembler dump.

0x0804873a  N::operator+(N&)
(gdb) disas 0x0804873a
Dump of assembler code for function _ZN1NplERS_:
   0x0804873a <+0>:	push   %ebp
   0x0804873b <+1>:	mov    %esp,%ebp
   0x0804873d <+3>:	mov    0x8(%ebp),%eax
   0x08048740 <+6>:	mov    0x68(%eax),%edx
   0x08048743 <+9>:	mov    0xc(%ebp),%eax
   0x08048746 <+12>:	mov    0x68(%eax),%eax
   0x08048749 <+15>:	add    %edx,%eax
   0x0804874b <+17>:	pop    %ebp
   0x0804874c <+18>:	ret    
End of assembler dump.

0x0804874e  N::operator-(N&)
(gdb) disas 0x0804874e
Dump of assembler code for function _ZN1NmiERS_:
   0x0804874e <+0>:	push   %ebp
   0x0804874f <+1>:	mov    %esp,%ebp
   0x08048751 <+3>:	mov    0x8(%ebp),%eax
   0x08048754 <+6>:	mov    0x68(%eax),%edx
   0x08048757 <+9>:	mov    0xc(%ebp),%eax
   0x0804875a <+12>:	mov    0x68(%eax),%eax
   0x0804875d <+15>:	mov    %edx,%ecx
   0x0804875f <+17>:	sub    %eax,%ecx
   0x08048761 <+19>:	mov    %ecx,%eax
   0x08048763 <+21>:	pop    %ebp
   0x08048764 <+22>:	ret    
End of assembler dump.