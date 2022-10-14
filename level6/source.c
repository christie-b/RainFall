#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void n()
{
	system("/bin/cat /home/user/level7/.pass");
}

void m()
{
	puts("Nope");
}

int main(int argc, char **argv)
{
	void (*ptr2)();
	void *ptr1;

	ptr1 = malloc(64);
	ptr2 = malloc(4);

	ptr2 = &m;
	printf("%ld\n", sizeof(ptr2));
	strcpy(ptr1, argv[1]);
	(*ptr2)();
}
