#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int language = 0;

void	greetuser(char *buf)
{
	char str[72];
	if (language == 1)
	{
		strcpy(str, "Hyvää päivää ");
	}
	else if (language == 2)
	{
		strcpy(str, "Goedemiddag! ");
	}
	else
	{
		strcpy(str, "Hello ");
	}
	strcat(str, buf);
	puts(str);
}

int main (int argc, char **argv)
{
	char *env = NULL;

	if (argc != 3)
		return (1);

	char buf[76];
	memset(buf, 0, 19 * 4);
	strncpy(buf, argv[1], 40);
	strncpy(buf, argv[2], 32);
	env = getenv("LANG");
	if (env != 0)
	{
		if (memcmp(env, "fi", 2) == 0)
		{
			language = 1;
		}
		else if (memcmp(env, "nl", 2) == 0)
		{
			language = 2;
		}
	}
	greetuser(buf);
	return (0);
}