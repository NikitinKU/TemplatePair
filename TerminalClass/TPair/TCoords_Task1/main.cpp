// Copyright 2022 Nikitin Kirill
// Group: 3821B1PR2

// сделать template с помощью файлов в репозитории
// объединить то, что есть сейчас и то, что есть в файлах

#include <iostream>

using namespace std;

class Coordinates {
	int first;
	int second;

public:

	Coordinates() :first(0), second(0) {}

	Coordinates(const Coordinates& coords) {
		first = coords.first;
		second = coords.second;
	}

	Coordinates(int _first, int _second) {
		first = _first;
		second = _second;
	}

	Coordinates operator+ (const Coordinates& right) {
		Coordinates res;
		res.first = this->first + right.first;
		res.second = this->second + right.second;
		return res;
	}

	Coordinates& operator= (const Coordinates& right) {
		if (this == &right)
			return *this;
		first = right.first;
		second = right.second;
		return *this;
	}


	friend ostream& operator<<(ostream& out, const Coordinates& right);
	friend void Print(Coordinates&, int _first, int _second);
};
ostream& operator<<(ostream& out, const Coordinates& right) {
	out << "(" << right.first << ", " << right.second << ")" << endl;
	return out;
};
void Print(Coordinates&, int _first, int _second) {
	cout << "(" << _first << ", " << _second << ")" << endl;
}

int main() {



	return 0;
}