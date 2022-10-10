#define _GNU_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
extern FILE *stderr;


int main (int argc, char **argv)
{
	char	*tab[2];
	gid_t	gid;
	uid_t	uid;

	if (atoi(argv[1]) == 423)
	{
		tab[0] = strdup("/bin/sh");
		tab[1] = 0;
		gid = getegid();
		uid = geteuid();
		setresgid(gid, gid, gid);
		setresuid(uid, uid, uid);
		execv("/bin/sh", tab);
	}
	else
	{
		fwrite("No !\n", 1, 5, stderr);
	}

	return (0);
}