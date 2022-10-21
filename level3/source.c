#include <stdio.h>
#include <stdlib.h>

int m;

void v(void)
{
	int buf[128];

	fgets(buf, 512, stdin);
	printf(buf);

	if (m == 64)
	{
		fwrite("Wait what?!\n", 1, 12, stdout);
		system("/bin/sh");
	}
}

int main(void)
{
	v();
}