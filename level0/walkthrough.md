# Walkthrough

## Solution
```
$ ./level0 423
$ cat /home/user/level1/.pass
-> 1fe8a524fa4bec01ca4ea2a869af2a02260d4a7d5fe7e7c24d8617e6dca12d3a
```

## Explanation

### Execution
```
level0@RainFall:~$ ./level0 
Segmentation fault (core dumped)
level0@RainFall:~$ ./level0 1
No !
```

### Disassembly
```
-> gdb level0
-> disas main
0x08048ed4 <+20>:	call   0x8049710 <atoi>
0x08048ed9 <+25>:	cmp    $0x1a7,%eax		// Compares eax to 423
0x08048ede <+30>:	jne    0x8048f58 <main+152>
0x08048ee0 <+32>:	movl   $0x80c5348,(%esp)
0x08048ee7 <+39>:	call   0x8050bf0 <strdup>
0x08048eec <+44>:	mov    %eax,0x10(%esp)
0x08048ef0 <+48>:	movl   $0x0,0x14(%esp)
-> break strdup
-> run 423
(gdb) x/s 0x80c5348
0x80c5348:	 "/bin/sh"
```