#include <stdio.h>

char	*auth;
char	*service;

int main (void)
{
	int buf[32];
	int i;
	
	while (1)
	{
		printf("%p, %p\n", auth, service);
		if (fgets(buf, 128, stdin) != 0)
		{
			if (memcmp(buf, "auth ", 5) == 0)
			{
				auth = malloc(4);
				*(int *)auth = 0;
				i = 5;
				while (buf[i] != 0) {
					++i;
				}
				if (i <= 30) {
					strcpy(buf + 5, auth);
				}
			}
			if (memcmp(buf, "reset", 5) == 0)
			{
				free(auth);
			}
			if (memcmp(buf, "service", 7) == 0)
			{
				service = strdup(buf+7);
			}
			if (memcmp(buf, "login", 5) == 0)
			{			
				if (auth[32] != 0) {
					system("/bin/sh");
				}
				else {
					fwrite("Password:\n", 1, 10, stdout);
				}
			}
		}
		else
			break;
	}
}