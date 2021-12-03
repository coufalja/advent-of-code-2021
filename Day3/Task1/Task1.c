// Task1.c : This file contains the 'main' function. Program execution begins and ends there.
//

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_LENGTH 12
#define MAX_FILE_LENGTH 2000

struct data
{
	int bits[12];
};

int countlines(FILE* fp) {
	int ch = 0;
	int lines = 0;
	while (!feof(fp))
	{
		ch = fgetc(fp);
		if (ch == '\n')
		{
			lines++;
		}
	}
	return lines;
}

int toint(int arrs[], size_t len)
{
	int mult = 1;
	int ret = 0;
	for (size_t i = len; i-- > 0;)
	{
		if (i < len - 1)
		{
			mult = mult * 2;
		}
		ret += mult * arrs[i];
	}
	return ret;
}

struct data p[MAX_FILE_LENGTH];
int main(void)
{
	FILE* fp = NULL;
	fopen_s(&fp, "..\\input.txt", "r+");
	if (fp == NULL) {
		exit(EXIT_FAILURE);
	}

	int lines = countlines(fp);
	if (lines > MAX_FILE_LENGTH) {
		exit(EXIT_FAILURE);
	}

	rewind(fp);

	char buf[1000];
	int i = 0;
	while (fgets(buf, sizeof buf, fp) != NULL)
	{
		for (size_t j = 0; j < LINE_LENGTH; j++)
		{
			p[i].bits[j] = buf[j] - '0';
		}
		i++;
	}

	int result[LINE_LENGTH] = { 0,0,0,0,0,0,0,0,0,0,0,0 };
	for (size_t k = 0; k < lines; k++)
	{
		for (size_t l = 0; l < LINE_LENGTH; l++)
		{
			result[l] += p[k].bits[l];
		}
	}

	int gamma[LINE_LENGTH] = { 0,0,0,0,0,0,0,0,0,0,0,0 };
	int epsilon[LINE_LENGTH] = { 0,0,0,0,0,0,0,0,0,0,0,0 };
	for (size_t x = 0; x < LINE_LENGTH; x++)
	{
		if (result[x] > lines/2)
		{
			gamma[x] = 1;
		}
		else
		{
			epsilon[x] = 1;
		}
	}
	printf_s("Gamma: %d\n", toint(gamma, LINE_LENGTH));
	printf_s("Epsilon: %d\n", toint(epsilon, LINE_LENGTH));
	printf_s("Sum: %d\n", toint(gamma, LINE_LENGTH) * toint(epsilon, LINE_LENGTH));
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu
// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file