#include <stdio.h>
#include <unistd.h>
#include <string.h>

char	*p(void)
{
	char *ptr;
	char buf[80];
	unsigned int *return_addr;

	fflush(stdout);
	gets(buf);

	return_addr = __builtin_return_address(0);
	printf("return addr: %x\n", *return_addr);

	if ((*return_addr & 0xb0000000) == 0xb0000000 ) {
		printf("(%p)\n", return_addr);
		_exit(1);
	}

	puts(buf);
	ptr = (char *)strdup(buf);
	return ptr;
}



int main(void)
{
	p();
	return (0);
}