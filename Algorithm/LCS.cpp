#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

enum Direction { Up, UL, Left };

typedef struct cell {
	int max_len;
	Direction dir;
}Cell;

string SearchLcs(string s1, string s2) {
	if (s1.size() < s2.size()) {
		s1.swap(s2);
	}
	int len1 = s1.size();
	int len2 = s2.size();
	Cell cell0;
	cell0.dir = Up;
	cell0.max_len = 0;
	vector<vector<Cell> > c(len1 + 1, vector<Cell>(len2 + 1, cell0));
	for (int i = 1; i <= len1; i++) {
		for (int j = 1; j <= len2; j++) {
			if (s1.at(i - 1) == s2.at(j - 1))
			{
				c[i][j].max_len = c[i - 1][j - 1].max_len + 1;
				c[i][j].dir = UL;
			}
			else {
				if (c[i][j - 1].max_len > c[i - 1][j].max_len) {
					c[i][j].max_len = c[i][j - 1].max_len;
					c[i][j].dir = Left;
				}
				else {
					c[i][j].max_len = c[i - 1][j].max_len;
					c[i][j].dir = Up;
				}
			}
		}
	}
	string lcs;
	int i = len1, j = len2;
	while (i && j)
	{
		if (c[i][j].dir == UL) {
			lcs = lcs + s1.at(i - 1);
			i--;
			j--;
		}
		else if (c[i][j].dir == Left) {
			j--;
		}
		else {
			i--;
		}
	}
	reverse(lcs.begin(), lcs.end());
	return lcs;
}

int main() {
	cout << "Please input two strings:\n";
	string s1, s2, lcs;
	cin >> s1 >> s2;
	lcs = SearchLcs(s1, s2);
	cout << "The max length is " << lcs.size() << endl;
	cout << "The longest common subsequence is: \n" << lcs;
}