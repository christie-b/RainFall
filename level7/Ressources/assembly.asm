(gdb) disas main
Dump of assembler code for function main:
   0x08048521 <+0>:	push   %ebp
   0x08048522 <+1>:	mov    %esp,%ebp
   0x08048524 <+3>:	and    $0xfffffff0,%esp
   0x08048527 <+6>:	sub    $0x20,%esp		; 32 bytes allocated for the variables
   0x0804852a <+9>:	movl   $0x8,(%esp)
   0x08048531 <+16>:	call   0x80483f0 <malloc@plt>	; 1st malloc (8) - ptr1
   0x08048536 <+21>:	mov    %eax,0x1c(%esp)		; store the return value at esp + 0x1c
   0x0804853a <+25>:	mov    0x1c(%esp),%eax		; set eax to the area of the 1st malloc (esp + 0x1c)
   0x0804853e <+29>:	movl   $0x1,(%eax)		; set the 1st case at 0x1 - ptr1[0] = 1
   0x08048544 <+35>:	movl   $0x8,(%esp)
   0x0804854b <+42>:	call   0x80483f0 <malloc@plt>	; 2nd malloc (8)
   0x08048550 <+47>:	mov    %eax,%edx		; save the return of the 2nd malloc function into edx
   0x08048552 <+49>:	mov    0x1c(%esp),%eax		; set eax to the area of the 1st malloc (esp + 0x1c)
   0x08048556 <+53>:	mov    %edx,0x4(%eax)		; set the second case of eax at edx, which is the address of the 2nd malloc - ptr1[1] = malloc(8)
   0x08048559 <+56>:	movl   $0x8,(%esp)
   0x08048560 <+63>:	call   0x80483f0 <malloc@plt>	; 3rd malloc (8) - ptr2
   0x08048565 <+68>:	mov    %eax,0x18(%esp)		; store the return value at esp + 0x18
   0x08048569 <+72>:	mov    0x18(%esp),%eax		; set eax at the address of the 3rd malloc
   0x0804856d <+76>:	movl   $0x2,(%eax)		; set 1st case of the malloc at 0x2 - ptr2[0] = 2
   0x08048573 <+82>:	movl   $0x8,(%esp)
   0x0804857a <+89>:	call   0x80483f0 <malloc@plt>	; 4th malloc (8)
   0x0804857f <+94>:	mov    %eax,%edx		; store the return value at edx
   0x08048581 <+96>:	mov    0x18(%esp),%eax		; set eax at the address of the 3rd malloc
   0x08048585 <+100>:	mov    %edx,0x4(%eax)		; put the address of the 4th malloc (at edx), to the 3rd malloc (eax) + 4 bytes - ie the 2nd case - ptr2[1] = malloc(8)
   ///////////////////
   0x08048588 <+103>:	mov    0xc(%ebp),%eax		; set eax to ebp + 12 ?  ebp + 12 = argv[0]?
   0x0804858b <+106>:	add    $0x4,%eax		; Add 4 to eax (argv[1] ?)
   0x0804858e <+109>:	mov    (%eax),%eax
   0x08048590 <+111>:	mov    %eax,%edx		; store eax (argv[1]) at edx
   0x08048592 <+113>:	mov    0x1c(%esp),%eax		; set the area of the 1st malloc (esp + 0x1c) to eax
   0x08048596 <+117>:	mov    0x4(%eax),%eax		; move to 4 bytes after the address of the 1st malloc, i.e the 2nd case of the area - ptr1[1]
   0x08048599 <+120>:	mov    %edx,0x4(%esp)		; store edx (= argv[1]) at esp + 4
   0x0804859d <+124>:	mov    %eax,(%esp)		; store eax (2nd case of 1st malloc'ed area - ptr1[1]) at esp
   0x080485a0 <+127>:	call   0x80483e0 <strcpy@plt>	; strcpy(esp, esp + 4) - strcpy(ptr1[1], argv[1])
   ///////////////////
   0x080485a5 <+132>:	mov    0xc(%ebp),%eax		; set eax to ebp + 12 ? ebp + 12 = argv[0]?
   0x080485a8 <+135>:	add    $0x8,%eax		; Add 8 to eax (argb[2] ?)
   0x080485ab <+138>:	mov    (%eax),%eax
   0x080485ad <+140>:	mov    %eax,%edx		; store eax (argv[2]) at edx
   0x080485af <+142>:	mov    0x18(%esp),%eax		; set eax at the address of the 3rd malloc (esp + 0x18)
   0x080485b3 <+146>:	mov    0x4(%eax),%eax		; move to 4 bytes after the address of the 3rd malloc, i.e the 2nd case of the area - ptr2[1]
   0x080485b6 <+149>:	mov    %edx,0x4(%esp)		; store edx (= argv[2]) at esp + 4
   0x080485ba <+153>:	mov    %eax,(%esp)		; store eax (2nd case of 3rd malloc'ed area - ptr2[1]) at esp
   0x080485bd <+156>:	call   0x80483e0 <strcpy@plt>	; strcpy(esp, esp + 4 - strcpy(ptr2[1], argv[2])
   0x080485c2 <+161>:	mov    $0x80486e9,%edx		; "r"
   0x080485c7 <+166>:	mov    $0x80486eb,%eax		; "/home/user/level8/.pass"
   0x080485cc <+171>:	mov    %edx,0x4(%esp)		; store "r" at esp + 4
   0x080485d0 <+175>:	mov    %eax,(%esp)		; store "/home/user/level8/.pass" at esp
   0x080485d3 <+178>:	call   0x8048430 <fopen@plt>	; call fopen(esp, esp + 4), returns a file pointer
   0x080485d8 <+183>:	mov    %eax,0x8(%esp)		; store return value at esp + 8
   0x080485dc <+187>:	movl   $0x44,0x4(%esp)		; store 68 (0x44) at esp + 4
   0x080485e4 <+195>:	movl   $0x8049960,(%esp)	; store the c variable at esp
   0x080485eb <+202>:	call   0x80483c0 <fgets@plt>	; call to fgets(esp, esp+4, esp+8) - fgets(c, 68, "/home/user/level8/.pass")
   0x080485f0 <+207>:	movl   $0x8048703,(%esp)	; "~~"
   0x080485f7 <+214>:	call   0x8048400 <puts@plt>	; puts("~~")
   0x080485fc <+219>:	mov    $0x0,%eax
   0x08048601 <+224>:	leave  
   0x08048602 <+225>:	ret    				; return (0);
End of assembler dump.

(gdb) disas m
Dump of assembler code for function m:
   0x080484f4 <+0>:		push   %ebp
   0x080484f5 <+1>:		mov    %esp,%ebp
   0x080484f7 <+3>:		sub    $0x18,%esp
   0x080484fa <+6>:		movl   $0x0,(%esp)
   0x08048501 <+13>:	call   0x80483d0 <time@plt>
   0x08048506 <+18>:	mov    $0x80486e0,%edx		; "%s - %d\n"
   0x0804850b <+23>:	mov    %eax,0x8(%esp)
   0x0804850f <+27>:	movl   $0x8049960,0x4(%esp)	; c variable
   0x08048517 <+35>:	mov    %edx,(%esp)
   0x0804851a <+38>:	call   0x80483b0 <printf@plt>
   0x0804851f <+43>:	leave  
   0x08048520 <+44>:	ret    
End of assembler dump.