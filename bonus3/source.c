#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	FILE *file = fopen("test", "r");
	int buf[33] = {0};

	// // printf("buf[0] : |%c| | strcmp(buf[0], %s) = %d\n", buf[0], argv[1], strcmp(buf, argv[1]));
	// FILE *file = fopen("/home/user/end/.pass", "r");
	if (file == 0 || argc != 2)
		return (-1);
	
	fread(buf, 1, 66, file);
	buf[65] = 0;
	((char *)buf)[atoi(argv[1])] = 0;
	fread(buf + 66, 1, 65, file);
	fclose(file);
	if (strcmp((char *)buf, argv[1]) == 0)
	{
		execl("/bin/sh", "sh", NULL);
	}
	else
	{
		puts((char *)buf + 65);
	}
	return(0);
}
