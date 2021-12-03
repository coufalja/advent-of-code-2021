// Task2.c : This file contains the 'main' function. Program execution begins and ends there.
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
	int discard;
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

int mostcommon(struct data p[], int len, int idx)
{
	int ones = 0;
	int zeros = 0;
	for (size_t i = 0; i < len; i++)
	{
		if (p[i].discard == 1) continue;
		if (p[i].bits[idx] == 0)
		{
			zeros += 1;
		}
		else
		{
			ones += 1;
		}
	}

	return zeros > ones ? 0 : 1;
}

int leastcommon(struct data p[], int len, int idx)
{
	return mostcommon(p, len, idx) == 0 ? 1 : 0;
}

struct data p[2000];

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

	char buf[MAX_FILE_LENGTH];
	int i = 0;
	while (fgets(buf, sizeof buf, fp) != NULL)
	{
		for (size_t j = 0; j < LINE_LENGTH; j++)
		{
			p[i].bits[j] = buf[j] - '0';
		}
		i++;
	}

	int oxygen = 0;
	int co2 = 0;

	for (size_t l = 0; l < LINE_LENGTH; l++)
	{
		int count = 0;
		int idx = 0;
		int most = mostcommon(p, lines, l);
		for (size_t i = 0; i < lines; i++)
		{
			if (p[i].discard == 1) continue;
			if (p[i].bits[l] != most)
			{
				p[i].discard = 1;
			}
			else
			{
				count += 1;
				idx = i;
			}
		}
		if (count == 1)
		{
			oxygen = toint(p[idx].bits, LINE_LENGTH);
			break;
		}
	}

	for (size_t i = 0; i < lines; i++)
	{
		p[i].discard = 0;
	}

	for (size_t l = 0; l < LINE_LENGTH; l++)
	{
		int count = 0;
		int idx = 0;
		int most = leastcommon(p, lines, l);
		for (size_t i = 0; i < lines; i++)
		{
			if (p[i].discard == 1) continue;
			if (p[i].bits[l] != most)
			{
				p[i].discard = 1;
			}
			else
			{
				count += 1;
				idx = i;
			}
		}
		if (count == 1)
		{
			co2 = toint(p[idx].bits, LINE_LENGTH);
			break;
		}
	}

	printf_s("Oxygen: %d\n", oxygen);
	printf_s("CO2: %d\n", co2);
	printf_s("Sum: %d\n", oxygen * co2);

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
