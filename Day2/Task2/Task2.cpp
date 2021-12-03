// Task2.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>

using namespace std;

vector<string> split(string s, string delimiter) {
	size_t pos_start = 0, pos_end, delim_len = delimiter.length();
	string token;
	vector<string> res;

	while ((pos_end = s.find(delimiter, pos_start)) != string::npos) {
		token = s.substr(pos_start, pos_end - pos_start);
		pos_start = pos_end + delim_len;
		res.push_back(token);
	}

	res.push_back(s.substr(pos_start));
	return res;
}

int main()
{
	ifstream infile("..\\input.txt");
	int depth = 0;
	int distance = 0;
	int aim = 0;
	for (string line; getline(infile, line); )
	{
		vector<string> parsed = split(line, " ");
		if (parsed[0].compare("forward") == 0) {
			distance += stoi(parsed[1]);
			depth += aim * stoi(parsed[1]);
		}
		if (parsed[0].compare("down") == 0) {
			aim += stoi(parsed[1]);
		}
		if (parsed[0].compare("up") == 0) {
			aim -= stoi(parsed[1]);
		}
	}

	cout << "Depth: " << depth << " Distance: " << distance << " Sum: " << depth * distance;
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
