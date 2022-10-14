#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void o(void)
{
	system("/bin/sh");
	exit(1);
}

void n(void)
{
	char buf[520];

	fgets(buf, 512, stdin);
	printf(buf);
	exit(1);
}

int main(void)
{
	n();
	return (0);
}