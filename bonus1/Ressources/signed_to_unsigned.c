#include <stdio.h>
#include <stdlib.h>

int main(int ac, char **av)
{
	unsigned int nb = atoi(av[1]);

	printf("nb as signed: %d\nnb as unsigned * 4: %u\n", nb, nb * 4);
	return (0);

}