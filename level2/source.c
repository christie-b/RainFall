#include <stdio.h>

char	*p(void)
{
	char buf[80];

	fflush(stdout);
	gets(buf);

}



int main(void)
{
	return p();
}