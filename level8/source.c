char	*auth;
char	*service;

int main (void)
{
	char	buf[128];
	char	consts[4] = {"auth ", "reset", "service", "login"};
	char	str1[] = "auth ";
	char	str2[] = "reset";
	char	str3[] = "service";
	char	str4[] = "login";
	int cmp;
	int i;

	while (1)
	{
		printf("%p, %p\n", auth, service);
		if (fgets(buf, 128, stdin) == 0)
		{
			break;
		}
		cmp = 0;
		for (i = 0; i < 5; ++i)
		{
			if (buf[i] != str1[i])
			{
				cmp = 1;
				break;
			}
		}
		if (cmp == 0) {
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

		cmp = 0;
		for (i = 0; i < 5; ++i) {
			if (buf[i] != str2[i])
			{
				cmp = 1;
				break;
			}
		}
		if (cmp == 0) {
			free(auth);
		}
		for (i = 0; i < 7; ++i) {
			if (buf[i] != str3[i])
			{
				cmp = 1;
				break;
			}
		}
		if (cmp == 0) {
			service = strdup(buf+7);
		}
		for (i = 0; i < 5; ++i) {
			if (buf[i] != str4[i])
			{
				cmp = 1;
				break;
			}
		}
		if (cmp == 0) {
			if (auth[32] != 0) {
				system("/bin/sh");
			}
			else {
				fwrite("Password:\n", 1, 10, stdout);
			}
		}
	}
}