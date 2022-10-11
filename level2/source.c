#include <stdio.h>
#include <unistd.h>
#include <string.h>

char	*p(void)
{
	char buf[64];
	int n[4];
	int o;

	fflush(stdout);
	gets(buf);

	n[0] = o;
	if ((buf[0] & 0xb0000000) == 0xb0000000 ) {
		printf("(%p)\n", pointer);
		_exit(1);
	}

	puts(buf);
	strdup(buf);
}



int main(void)
{
	p();
}