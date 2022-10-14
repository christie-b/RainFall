### Walkthrough
---
The commande `objdump -D level6` shows the existence of two functions: \<m> and \<n>. \<n> is never called and has the address 0x08048454. \<m> is called by its address, which is stored in a heap address nex to another heap address of size 64 to which is copied argv[1] with strcpy. Overflowing argv[1] with the address of the function \<n> overwrite the call to function \<m>.

```bash
./level6 $(python -c "print '\x54\x84\x04\x08' * 19")
```