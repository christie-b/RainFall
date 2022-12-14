(gdb) disas p
Dump of assembler code for function p:
080484d4 <p>:
80484d4:       55                      push   ebp
80484d5:       89 e5                   mov    ebp,esp
80484d7:       83 ec 68                sub    esp,0x68                 ; stack = 104bytes
80484da:       a1 60 98 04 08          mov    eax,ds:0x8049860         ; stdout file stream to eax
80484df:       89 04 24                mov    DWORD PTR [esp],eax      ; eax as first argument to function
80484e2:       e8 c9 fe ff ff          call   80483b0 <fflush@plt>     ; fflush(stdout)
80484e7:       8d 45 b4                lea    eax,[ebp-0x4c]           ; load to eax the stack - 76 bytes address
80484ea:       89 04 24                mov    DWORD PTR [esp],eax      ; eax as argument to function
80484ed:       e8 ce fe ff ff          call   80483c0 <gets@plt>       ; gets to this buffer
80484f2:       8b 45 04                mov    eax,DWORD PTR [ebp+0x4]  ; load value in stack + 4 to eax 
80484f5:       89 45 f4                mov    DWORD PTR [ebp-0xc],eax  ; put eax into stack - 16 
80484f8:       8b 45 f4                mov    eax,DWORD PTR [ebp-0xc]  ; put stack - 16 into eax (repeating?)
80484fb:       25 00 00 00 b0          and    eax,0xb0000000           ; put to 0 all except first 2 bits
8048500:       3d 00 00 00 b0          cmp    eax,0xb0000000           ; compare eax with 0xb0000000
8048505:       75 20                   jne    8048527 <p+0x53>         ; jump if not equal
8048507:       b8 20 86 04 08          mov    eax,0x8048620            ; load the string "(%p)\n" into ax
804850c:       8b 55 f4                mov    edx,DWORD PTR [ebp-0xc]  ; load stack - 16 into edx
804850f:       89 54 24 04             mov    DWORD PTR [esp+0x4],edx  ; load edx as second argument
8048513:       89 04 24                mov    DWORD PTR [esp],eax      ; load eax as first argument
8048516:       e8 85 fe ff ff          call   80483a0 <printf@plt>     ; call printf
804851b:       c7 04 24 01 00 00 00    mov    DWORD PTR [esp],0x1      ; 1 as exit value;
8048522:       e8 a9 fe ff ff          call   80483d0 <_exit@plt>      ; _exit(1);
8048527:       8d 45 b4                lea    eax,[ebp-0x4c]           ; stack - 76 (buf);
804852a:       89 04 24                mov    DWORD PTR [esp],eax      ; buf as first argument
804852d:       e8 be fe ff ff          call   80483f0 <puts@plt>       ; puts(buf)
8048532:       8d 45 b4                lea    eax,[ebp-0x4c]           ; stack - 76 (buf);
8048535:       89 04 24                mov    DWORD PTR [esp],eax      ; buf as argument
8048538:       e8 a3 fe ff ff          call   80483e0 <strdup@plt>     ; strdup(buf);
804853d:       c9                      leave  
804853e:       c3                      ret
End of assembler dump.


(gdb) disas main
Dump of assembler code for function main:
   0x0804853f <+0>:	push   %ebp
   0x08048540 <+1>:	mov    %esp,%ebp
   0x08048542 <+3>:	and    $0xfffffff0,%esp
   0x08048545 <+6>:	call   0x80484d4 <p>		; calls p
   0x0804854a <+11>:	leave                         // put a breakpoint here, to get return address of strdup
   0x0804854b <+12>:	ret    
End of assembler dump.