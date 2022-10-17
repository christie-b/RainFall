#include <stdlib.h>
#include <string.h>

void m()
{
    printf("%s - %d\n", c, time(0));
}

// int main(int argc, char **argv)
// {
//     volatile unsigned int tmp;
//     volatile char *ptr1;
//     volatile char *ptr2;

//     ptr1 = malloc(8);
//     *(int *)ptr1 = 0x1;
//     tmp = (unsigned int)malloc(8);
//     ptr2 = (char *)tmp;
//     // ptr2 = malloc(8);
//     // *(int *)ptr2 = 0x2;
//     // tmp = (unsigned int) malloc(8);
//     // ptr2[4] = tmp;
//     // strcpy((char *)ptr1 + 4, argv[1]);
// }

char c[68];

int main(int argc, char **argv)
{
    int    *ptr1;
    int    *ptr2;
    FILE    *file;

    ptr1 = malloc(8);
    ptr1[0] = 1;
    ptr1[1] = malloc(8);

    ptr2 = malloc(8);
    ptr2[0] = 2;
    ptr2[1] = malloc(8);

    strcpy(ptr1[1], argv[1]);
    strcpy(ptr2[1], argv[2]);

    file = fopen("/home/user/level8/.pass", "r");
    fgets(c, 68, file);
    puts("~~");
    return (0);
}