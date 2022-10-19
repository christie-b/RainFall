

int main (int argc, char **av)
{
	int	nb;
	char buf[40]; //0x3c (esp+60) - 0x14 (esp+20)

	nb = atoi(argv[1]);
	if (nb > 9)
		return (1);
	memcpy(buf, argv[2], nb * 4);
	if (nb == 0x574f4c46)
	{
		execl("/bin/sh", "sh", 0);
	}
	return (0);
}