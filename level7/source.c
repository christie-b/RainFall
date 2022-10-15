#include <stdlib.h>
#include <string.h>

void m()
{
}

int main(int argc, char **argv)
{
    unsigned int tmp;
    char *ptr1;
    char *ptr2;

    ptr1 = malloc(8);
    *(int *)ptr1 = 0x1;
    int *)ptr1 + 1) = (unsigned int)malloc(8);
    ptr2 = malloc(8);
    *(int *)ptr2 = 0x2;
    tmp = (unsigned int) malloc(8);
    ptr2[4] = tmp;
    strcpy((char *)ptr1 + 4, argv[1]);
}