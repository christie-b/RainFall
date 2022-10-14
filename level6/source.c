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
	unsigned int *ptr2;
	char *ptr1;

	ptr1 = malloc(64);
	ptr2 = malloc(4);
	*ptr2 = (unsigned int)m;
	strcpy(ptr1, argv[1]);
	((void (*)())*ptr2)();
}
