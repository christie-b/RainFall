#include <stdio.h>
#include <stdlib.h>

int m;

void p(char *buf)
{
	printf(buf);
}

void n()
{
	int buf[128];

	fgets(buf, 512, stdin);
	p(buf);

	if (m == 16930116)
		system("/bin/cat /home/user/level5/.pass");

}

int main()
{
	n();
}