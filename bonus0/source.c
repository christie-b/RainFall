#include <stdio.h>
#include <string.h>
#include <unistd.h>


void p(char *buf, char *str)
{
	char buf3[4096];
	char *ret;

	puts(str);
	read(0, buf3, 4096);
	ret = strchr(buf3, '\n'); // 10 is \n
	*ret = 0;
	strncpy(buf, buf3, 20);

}

void	pp(char *buf)
{
	char buf1[20];
	char buf2[20];

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
	char buf[42]; // 0x40 - 0x16

	pp(buf);
	puts(buf);

	return (0);
}