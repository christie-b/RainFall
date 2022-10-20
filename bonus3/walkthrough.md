# Walkthrough


## Solution
```
./bonus3 ""
```

## Explanation

### Execution
```
bonus3@RainFall:~$ ./bonus3 
bonus3@RainFall:~$ ./bonus3 hello

bonus3@RainFall:~$ ./bonus3 hello you
bonus3@RainFall:~$ 
```

### Assembly
```
(gdb) disas main
Dump of assembler code for function main:
   0x080484f4 <+0>:		push   %ebp
   0x080484f5 <+1>:		mov    %esp,%ebp
   0x080484f7 <+3>:		push   %edi
   0x080484f8 <+4>:		push   %ebx
   0x080484f9 <+5>:		and    $0xfffffff0,%esp
   0x080484fc <+8>:		sub    $0xa0,%esp					; allocate 160bytes to the variables
   0x08048502 <+14>:	mov    $0x80486f0,%edx				; edx = "r"
   0x08048507 <+19>:	mov    $0x80486f2,%eax				; eax = "/home/user/end/.pass"
   0x0804850c <+24>:	mov    %edx,0x4(%esp)				; esp+4 = "r"
   0x08048510 <+28>:	mov    %eax,(%esp)					; esp = "/home/user/end/.pass"
   0x08048513 <+31>:	call   0x8048410 <fopen@plt>		; fopen("/home/user/end/.pass", "r")
   0x08048518 <+36>:	mov    %eax,0x9c(%esp)				; save return value (file pointer) to esp+156
   0x0804851f <+43>:	lea    0x18(%esp),%ebx				; move pointer in esp+24 to ebx - buffer[33?]
   0x08048523 <+47>:	mov    $0x0,%eax					; eax = 0
   0x08048528 <+52>:	mov    $0x21,%edx					; edx = 33
   0x0804852d <+57>:	mov    %ebx,%edi					; move pointer in esp+24 to edi
   0x0804852f <+59>:	mov    %edx,%ecx					; ecx = 33
   0x08048531 <+61>:	rep stos %eax,%es:(%edi)			; equivalent to memset(buffer, '\0', 33), store the content of eax (0), ecx times (33), into where edi points (esp+24)
   0x08048533 <+63>:	cmpl   $0x0,0x9c(%esp)				; compare esp+156 to 0
   0x0804853b <+71>:	je     0x8048543 <main+79>			; if file == NULL, jump to 79
   0x0804853d <+73>:	cmpl   $0x2,0x8(%ebp)				; else, compare ebp+8 to 2 (argc == 2)
   0x08048541 <+77>:	je     0x804854d <main+89>			; if equal, jump to 89
   0x08048543 <+79>:	mov    $0xffffffff,%eax				; eax = -1
   0x08048548 <+84>:	jmp    0x8048615 <main+289>			; jump to 289
   0x0804854d <+89>:	lea    0x18(%esp),%eax				; move pointer in esp+24 to eax
   0x08048551 <+93>:	mov    0x9c(%esp),%edx				; move esp+156 to edx
   0x08048558 <+100>:	mov    %edx,0xc(%esp)				; esp+12 = esp+156 = /home/user/end/.pass
   0x0804855c <+104>:	movl   $0x42,0x8(%esp)				; esp+8 = 66
   0x08048564 <+112>:	movl   $0x1,0x4(%esp)				; esp+4 = 1
   0x0804856c <+120>:	mov    %eax,(%esp)					; esp = esp+24
;  The function fread() reads nmemb items of data, each size bytes long, from the stream pointed to by stream, storing them at the location given by ptr.
; size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
   0x0804856f <+123>:	call   0x80483d0 <fread@plt>		; fread(buf, 1, 42, /home/user/end/.pass)
   0x08048574 <+128>:	movb   $0x0,0x59(%esp)				; esp+89 = buf[65] = 0
   0x08048579 <+133>:	mov    0xc(%ebp),%eax				; eax = ebp+12
   0x0804857c <+136>:	add    $0x4,%eax					; eax = ebp+16 (argv[1])
   0x0804857f <+139>:	mov    (%eax),%eax					; dereference ebp+16
   0x08048581 <+141>:	mov    %eax,(%esp)					; *esp = ebp+16
   0x08048584 <+144>:	call   0x8048430 <atoi@plt>			; atoi(*(ebp+16)) - argv[1]
   0x08048589 <+149>:	movb   $0x0,0x18(%esp,%eax,1)		; set esp+eax*1+24 to 0 buf[atoi(argv[1])]
   <!-- 0x08048589 <+149>:	mov    BYTE PTR [esp+eax*1+0x18],0x0 -->
   0x0804858e <+154>:	lea    0x18(%esp),%eax				; move pointer in esp+24 to eax
   0x08048592 <+158>:	lea    0x42(%eax),%edx				; move pointer in eax+66 to edx
   0x08048595 <+161>:	mov    0x9c(%esp),%eax				; move esp+156 to eax
   0x0804859c <+168>:	mov    %eax,0xc(%esp)				; esp+12 = esp+156
   0x080485a0 <+172>:	movl   $0x41,0x8(%esp)				; esp+8 = 65
   0x080485a8 <+180>:	movl   $0x1,0x4(%esp)				; esp+4 = 1
   0x080485b0 <+188>:	mov    %edx,(%esp)					; esp = eax+66
   0x080485b3 <+191>:	call   0x80483d0 <fread@plt>		; fread(eax+66, 1, 65, esp+156)
   0x080485b8 <+196>:	mov    0x9c(%esp),%eax				; eax = esp+156
   0x080485bf <+203>:	mov    %eax,(%esp)					; esp = esp+156
   0x080485c2 <+206>:	call   0x80483c0 <fclose@plt>		; fclose(esp+156)
   0x080485c7 <+211>:	mov    0xc(%ebp),%eax				; eax = ebp+12
   0x080485ca <+214>:	add    $0x4,%eax					; eax = ebp+16 (argv[1])
   0x080485cd <+217>:	mov    (%eax),%eax					; dereference eax (*ebp+16)
   0x080485cf <+219>:	mov    %eax,0x4(%esp)				; esp+4 = *esp+16
   0x080485d3 <+223>:	lea    0x18(%esp),%eax				; move pointer in esp+24 to eax
   0x080485d7 <+227>:	mov    %eax,(%esp)					; esp = esp+24
   0x080485da <+230>:	call   0x80483b0 <strcmp@plt>		; strcmp(esp+24, esp+16)
   0x080485df <+235>:	test   %eax,%eax					; compare return value
   0x080485e1 <+237>:	jne    0x8048601 <main+269>			; if not =0, jump to 269
   0x080485e3 <+239>:	movl   $0x0,0x8(%esp)				; else set esp+8 = 0
   0x080485eb <+247>:	movl   $0x8048707,0x4(%esp)			; esp+4 = "sh"
   0x080485f3 <+255>:	movl   $0x804870a,(%esp)			; esp = "/bin/sh"
   0x080485fa <+262>:	call   0x8048420 <execl@plt>		; execl("/bin/sh", "sh",0)
   0x080485ff <+267>:	jmp    0x8048610 <main+284>			; jump to 284
   0x08048601 <+269>:	lea    0x18(%esp),%eax				; move pointer in esp+24 to eax
   0x08048605 <+273>:	add    $0x42,%eax					; eax = esp+90 (+66)
   0x08048608 <+276>:	mov    %eax,(%esp)					; esp = esp+90
   0x0804860b <+279>:	call   0x80483e0 <puts@plt>			; puts(esp+90)
   0x08048610 <+284>:	mov    $0x0,%eax					; eax = 0
   0x08048615 <+289>:	lea    -0x8(%ebp),%esp
   0x08048618 <+292>:	pop    %ebx
   0x08048619 <+293>:	pop    %edi
   0x0804861a <+294>:	pop    %ebp
   0x0804861b <+295>:	ret    								; return 0
End of assembler dump.
```