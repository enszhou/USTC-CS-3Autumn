#include <iostream>
#include <cmath>
using namespace std;

#define D 128

int strMatch(string text, string pattern, int q) {
	int m = pattern.size();
	int n = text.size();
	int p = 0, t = 0, i, j, h = 1;
	for (i = 1; i < m; i++) {
		h = (D * h) % q;
	}
	for (i = 0; i < m; i++) {

		p = (D * p + pattern.at(i)) % q;
		t = (D * t + text.at(i)) % q;
	}

	for (i = 0; i <= n - m; i++) {
		if (p == t) {
			for (j = 0; j < m; j++) {
				if (pattern[j] != text[i + j])
					break;
			}
			if (j == m)
				return i;
		}
		if (i < n - m) {
			t = (D * (t - text[i] * h) + text[i + m]) % q;
			if (t < 0)
				t += q;
		}
	}
	return -1;
}

int main() {
	string text, pattern;
	int index;
	cout << "String:";
	cin >> text;
	cout << "Pattern:";
	cin >> pattern;
	index = strMatch(text, pattern, 67);
	if (index == -1)
		cout << "Match Failed";
	else {
		cout << "The first index is " << index;
	}

}