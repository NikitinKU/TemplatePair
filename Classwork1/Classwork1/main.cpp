// ������
// ������������ �������� ����� - 1 �������
// ������ �����, 2 �������� ����� ������� 10
// ��������� O(n), nlog(n)

#include <iostream>
#include <set>
#include <stdlib.h>



int main() {
	srand(time(NULL));
	int size = 1000;
	std::set <int> set1();

	for (int i = 0; i < size; i++) {
		int rand_value = rand() % 20 - 10;
		set1().insert(rand_value);
		//std::cout << rand_value;
	}
	
	return 0;
}