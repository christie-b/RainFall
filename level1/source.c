#include <stdio.h>
#include <stdlib.h>


int	run(void)
{
	fwrite("Good... Wait what?\n", 1, 19, stdout);
	return system("/bin/sh");
}


int	main(void)
{
	int buf[16];

	return gets(buf);
}
