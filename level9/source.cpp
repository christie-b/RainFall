#include <iostream>
#include <cstring>
#include <cstdlib>
#include <cstdio>

class N
{
	public:

	N(int n) : number(n)
	{
	}

	void	setAnnotation(char *str)
	{
		memcpy(buf, str, strlen(str));
	}

	virtual int operator+(N& n)
	{
		return number + n.number;
	}

	virtual int operator-(N& n)
	{
		return number - n.number;
	}

	private:
	char buf[100];
	int	number;
};


int main(int argc, char **argv)
{
	if (argc <= 1)
		exit(1);

	N *nb1 = new N(5);
	N *nb2 = new N(6);

	N *nb3 = nb2;
	N *nb4 = nb1;    

	nb3->setAnnotation(argv[1]);

	*nb3 + *nb4;
}