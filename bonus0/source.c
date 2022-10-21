#include <stdio.h>
#include <string.h>
#include <unistd.h>


void p(char *buf, char *str)
{
	int buf3[1024];

	puts(str);
	read(0, buf3, 4096);
	*(strchr(buf3, '\n')) = 0; // 10 is \n
	strncpy(buf, buf3, 20);

}

void	pp(char *buf)
{
	int buf1[5];
	int buf2[5];

	p(buf1, " - ");
	p(buf2, " - ");

	strcpy(buf, buf1);

	int i = 0;
	while (buf[i])
	{
		i++;
	}
	buf[i] = ' ';
	strcat(buf, buf2);
}

int main(int argc, char **argv)
{
	short buf[21]; // 0x40 - 0x16

	pp(buf);
	puts(buf);

	return (0);
}