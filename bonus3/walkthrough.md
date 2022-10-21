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
-> The program takes one argument and prints a \n  

### Disassembly

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  

### Steps

The program is opening and reading the .pass file, putting its content in a variable (buf).  
It then put buf[65] = 0 and buf[atoi(argv[1])] = 0.  
It is then comparing buf and argv[1], if they are equal, it launches a shell.  
-> we have to make argv[1] equal to buf.  

Argv[1] is converted to an int (with atoi), and used as an index for buf, to put it at 0.  
If we input 0 for argv[1], argv[1] will be 0, and buf[0] will also be 0, so strcmp should be returning 0.  
However, when the program does buf[atoi(0)] = 0, it is actually doing buf[atoi(0)] = '\0', which is different from 0.  

--> Therefore, we have to input an empty string "" into argv[1], to make both buf and atoi("") equal.  
(atoi("") returns 0)