#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

char c[68];

void m()
{
    printf("%s - %d\n", c, (int)time(0));
}

int main(int argc, char **argv)
{
    int    *ptr1;
    int    *ptr2;
    FILE    *file;

    ptr1 = malloc(8);
    ptr1[0] = 1;
    ptr1[1] = (unsigned int)malloc(8);

    ptr2 = malloc(8);
    ptr2[0] = 2;
    ptr2[1] = (unsigned int)malloc(8);

    strcpy((char *)ptr1[1], argv[1]);
    strcpy((char *)ptr2[1], argv[2]);

    file = fopen("/home/user/level8/.pass", "r");
    fgets(c, 68, file);
    puts("~~");
    return (0);
}