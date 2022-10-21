(gdb) disas main
Dump of assembler code for function main:
   0x080485a4 <+0>:		push   %ebp
   0x080485a5 <+1>:		mov    %esp,%ebp
   0x080485a7 <+3>:		and    $0xfffffff0,%esp
   0x080485aa <+6>:		sub    $0x40,%esp
   0x080485ad <+9>:		lea    0x16(%esp),%eax					; move pointer in esp+22 in eax
   0x080485b1 <+13>:	mov    %eax,(%esp)						; move pointer in esp+22 to esp
   0x080485b4 <+16>:	call   0x804851e <pp>					; call pp with pointer on esp+22 as argument || esp+22 = 0xbffff6f6 = buf
   0x080485b9 <+21>:	lea    0x16(%esp),%eax					; move pointer in esp+22 in eax
   0x080485bd <+25>:	mov    %eax,(%esp)						; move pointer in esp+22 to esp
   0x080485c0 <+28>:	call   0x80483b0 <puts@plt>				; call puts with pointer on esp+22 as argument
   0x080485c5 <+33>:	mov    $0x0,%eax
   0x080485ca <+38>:	leave  
   0x080485cb <+39>:	ret      								; return (0)
End of assembler dump.


(gdb) disas pp
Dump of assembler code for function pp:
   0x0804851e <+0>:		push   %ebp
   0x0804851f <+1>:		mov    %esp,%ebp
   0x08048521 <+3>:		push   %edi
   0x08048522 <+4>:		push   %ebx
   0x08048523 <+5>:		sub    $0x50,%esp						; allocate 80 bytes for the local variables
   0x08048526 <+8>:		movl   $0x80486a0,0x4(%esp)				; (gdb) x/s 0x80486a0: " - ", moved to esp+4
   0x0804852e <+16>:	lea    -0x30(%ebp),%eax					; move pointer in ebp-48 to eax || ebp-48 = buf1
>   0x08048531 <+19>:	mov    %eax,(%esp)						; move ebp-48 to esp, buf1 is at 0xbffff6a8
   0x08048534 <+22>:	call   0x80484b4 <p>					; call to p(ebp-48, " - ")
   0x08048539 <+27>:	movl   $0x80486a0,0x4(%esp)				; (gdb) x/s 0x80486a0: " - "
   0x08048541 <+35>:	lea    -0x1c(%ebp),%eax					; move pointer in ebp-28 to eax || ebp-28 = buf2
>   0x08048544 <+38>:	mov    %eax,(%esp)						; move eax to esp, buf2 is at 0xbffff6bc
   0x08048547 <+41>:	call   0x80484b4 <p>					; call to p(ebp-28, " - ") || buf2[20]?
   0x0804854c <+46>:	lea    -0x30(%ebp),%eax					; move pointer in ebp-48 to eax
   0x0804854f <+49>:	mov    %eax,0x4(%esp)					; move ebp-48 to esp+4
   0x08048553 <+53>:	mov    0x8(%ebp),%eax					; move ebp+0x8 to eax
>   0x08048556 <+56>:	mov    %eax,(%esp)						; move ebp+0x8 to esp || with a breakpoint here, we see that ebp+8 = 0xbffff6f6 = buf
   0x08048559 <+59>:	call   0x80483a0 <strcpy@plt>			; strcpy(ebp+0x8, ebp-48)
   0x0804855e <+64>:	mov    $0x80486a4,%ebx					; x/s: " " | x/d: 32, moved to ebx
   0x08048563 <+69>:	mov    0x8(%ebp),%eax					; move ebp+0x8 to eax
   0x08048566 <+72>:	movl   $0xffffffff,-0x3c(%ebp)			; set the value at ebp-0x3c to 0xffffffff (aka -1)
   0x0804856d <+79>:	mov    %eax,%edx						; move ebp+0x08 to edx
   0x0804856f <+81>:	mov    $0x0,%eax						; set eax to 0
   0x08048574 <+86>:	mov    -0x3c(%ebp),%ecx					; set ecx to 0xffffffff (-1)
   0x08048577 <+89>:	mov    %edx,%edi						; move ebp+0x08 to edi
   0x08048579 <+91>:	repnz scas %es:(%edi),%al				; equivalent to strlen
   0x0804857b <+93>:	mov    %ecx,%eax						;
   0x0804857d <+95>:	not    %eax
   0x0804857f <+97>:	sub    $0x1,%eax						; eax - 1 (to not count \0?)
   0x08048582 <+100>:	add    0x8(%ebp),%eax					; eax = eax + ebp+0x8 || len + buf
   0x08048585 <+103>:	movzwl (%ebx),%edx						; Move Zero-Extended Word to Long - move ebx to edx
   0x08048588 <+106>:	mov   %dx,(%eax)
   0x0804858b <+109>:	lea   -0x1c(%ebp),%eax					; move pointer in ebp-28 (buf2) to eax
   0x0804858e <+112>:	mov   %eax,0x4(%esp)					; move ebp-28 to esp+4
   0x08048592 <+116>:	mov   0x8(%ebp),%eax					; move ebp+0x8 to eax
   0x08048595 <+119>:	mov   %eax,(%esp)						; move eax to esp
   0x08048598 <+122>:	call  0x8048390 <strcat@plt>			; strcat(ebp+0x8, ebp-28) | strcat(buf, buf2)
   0x0804859d <+127>:	add   $0x50,%esp						; esp = esp+80
   0x080485a0 <+130>:	pop   %ebx
   0x080485a1 <+131>:	pop   %edi
   0x080485a2 <+132>:	pop   %ebp
   0x080485a3 <+133>:	ret
End of assembler dump.


(gdb) disas p
Dump of assembler code for function p:
   0x080484b4 <+0>:		push   %ebp
   0x080484b5 <+1>:		mov    %esp,%ebp
   0x080484b7 <+3>:		sub    $0x1018,%esp						; 4120 bytes are allocated for its variable
   0x080484bd <+9>:		mov    0xc(%ebp),%eax					; move ebp+12 to eax (0x80486a0: " - ")
>   0x080484c0 <+12>:	mov    %eax,(%esp)						; move ebp+12 to esp
   0x080484c3 <+15>:	call   0x80483b0 <puts@plt>				; puts(ebp+12)
   0x080484c8 <+20>:	movl   $0x1000,0x8(%esp)				; move 4096 to esp+8
   0x080484d0 <+28>:	lea    -0x1008(%ebp),%eax				; move pointer in ebp-4104 to eax, 0xbfffe670? new buffer?-> after, "hello" is stored there
>   0x080484d6 <+34>:	mov    %eax,0x4(%esp)					; move ebp-4104 to esp+4, 0xbfffe670?
   0x080484da <+38>:	movl   $0x0,(%esp)						; move 0 to esp
   0x080484e1 <+45>:	call   0x8048380 <read@plt>				; read(0, ebp-4104, 4096)
   0x080484e6 <+50>:	movl   $0xa,0x4(%esp)					; move 10 to esp+4
   0x080484ee <+58>:	lea    -0x1008(%ebp),%eax				; move pointer in ebp-4104 to eax
   0x080484f4 <+64>:	mov    %eax,(%esp)						; move ebp-4104 to esp
   0x080484f7 <+67>:	call   0x80483d0 <strchr@plt>			; strchr(ebp-4104, 10)
   0x080484fc <+72>:	movb   $0x0,(%eax)						; set eax = return value of strchr to 0
   0x080484ff <+75>:	lea    -0x1008(%ebp),%eax				; move pointer in ebp-4104 to eax
   0x08048505 <+81>:	movl   $0x14,0x8(%esp)					; move 20 to esp+8
>   0x0804850d <+89>:	mov    %eax,0x4(%esp)					; move ebp-4104 to esp+4, 0xbfffe670: "hello", and "you" after second read
   0x08048511 <+93>:	mov    0x8(%ebp),%eax					; move ebp+8 to eax
>   0x08048514 <+96>:	mov    %eax,(%esp)						; move ebp+8 to esp, 0xbffff6a8 = buf1, after 2nd read: 0xbffff6bc = buf2
   0x08048517 <+99>:	call   0x80483f0 <strncpy@plt>			; strncpy(ebp+8, ebp-4104, 20)
   0x0804851c <+104>:	leave  
   0x0804851d <+105>:	ret    
End of assembler dump.