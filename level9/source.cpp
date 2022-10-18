#include <iostream>
#include <cstring>

class N
{
	public:
	N(int n) : number(n)
	{}

	void	setAnnotation(char *str)
	{
		memcpy(buf, str, strlen(str));
	}

	int operator+(N& n)
	{
		return number + n->number;
	}

	int operator-(N& n)
	{
		return number - n->number;
	}

	private:
	int	number;
	char buf[108];
}


int main(int argc, char **argv)
{
	if (argc <= 1)
		_exit(1);

	N *nb1 = new N(5);
	N *nb2 = new N(6);

	nb1->setAnnotation(argv[1]);

	// something
	return (?);
}