// Copyright 2022 Nikitin Kirill
// Group: 3821B1PR2

#include <iostream>
#include <vector>
#include <algorithm>
#include <windows.h>
#include <cstdlib>

/*САМОСТОЯТЕЛЬНОЕ ЗАДАНИЕ (часть ЛР 2).

Создать меню для работы с треугольными матрицами. Треугольные матрицы - матрицы, например, вида:

1 2 3 4 5
0 2 3 4 5
0 0 3 4 5
0 0 0 4 5
0 0 0 0 5

1 0 0 0 0
1 2 0 0 0
1 2 3 0 0
1 2 3 4 0
1 2 3 4 5

Матрица - это вектор векторов (std::vector<std::vector<int>>), 
причём вектора внутри разных размеров 
(в данной работе этим можно пренебречь и реализовать пока как вектор векторов одинакового размера).

Использовать std::vector.

Пользователь должен иметь возможность: задавать, складывать, вычитать, умножать (на матрицу, на вектор), транспонировать матрицы.


Дедлайн: 5 октября 23:59.*/


void main_menu() {
	std::cout << "\n\tInput the variant of the act with matrixes: " << std::endl;
	std::cout << "\t\t0) to exit" << std::endl
		<< "\t\t1) to generate the matrixes" << std::endl
		<< "\t\t2) to add matrixes" << std::endl
		<< "\t\t3) to subtract a 2nd matrix from the 1st" << std::endl
		<< "\t\t4) to multiply matrixes" << std::endl
		<< "\t\t5) to multiply the first matrix on a vector" << std::endl
		<< "\t\t6) to transpose the first matrix" << std::endl;
	std::cout << "\tInput: ";
}

void switch_error() {
	std::cout << "\n\tError: input error" << std::endl;
	Sleep(2000);
	system("cls");
}

void switch_exit(std::vector<std::vector<int>> _mtrx1,
				 std::vector<std::vector<int>>& _mtrx2,
				 std::vector<std::vector<int>>& _mtrx_res,
				 bool _loopFlag) {
	_mtrx1.clear();
	_mtrx2.clear();
	_mtrx_res.clear();
	_loopFlag = false;
}

void rndm_init_mtrx(std::vector<std::vector<int>>& _mtrx, int _mtrx_size) {
	int rand_init_var;
	rand_init_var = (rand() % 2) + 1;

	for (int i = 0; i < _mtrx_size; i++) {
		for (int j = 0; j < _mtrx_size; j++) {
			_mtrx[i][j] = 0;
		}
	}
	
	if (rand_init_var == 1) {
		//under the main diagonal
		for (int i = 0; i < _mtrx_size; i++) {
			for (int j = _mtrx_size - 1; j >= i; j--) {
				_mtrx[i][j] = (rand() % 9) + 1;
			}
		}
	}
	else {
		//over the main diagonal
		int k = 0;
		for (int i = _mtrx_size - 1; i >= 0; i--) {
			for (int j = 0; j < _mtrx_size - k; j++) {
				_mtrx[i][j] = (rand() % 9) + 1;
			}
			k++;
		}
	}
	
}

void rndm_init_vec(std::vector <int>& vec) {
	for (auto i = vec.begin(); i != vec.end(); i++) {
		*i = (rand() % 9) + 1;
	}
}

void vec_print(std::vector <int> vec) {
	std::cout << std::endl;
	std::cout << "\n\tVector : ";
	std::cout << "\n\n\t\t";
	for (auto i = vec.begin(); i != vec.end(); i++) {
		std::cout << *i << "\t";
	}
	std::cout << std::endl;
}

void mtrx_print(std::vector<std::vector<int>> _mtrx) {
	std::cout << std::endl;
	std::cout << "\n\tMatrix : ";
	std::cout << "\n\n\t\t";
	for (auto i1 = _mtrx.begin(); i1 != _mtrx.end(); ++i1) {
		for (auto i2 = (*i1).begin(); i2 != (*i1).end(); ++i2) {
			std::cout << *i2 << "\t";
		}
		std::cout << "\n\n\t\t";
	}
	std::cout << std::endl;
}

void print_mtrx_comparence(std::vector<std::vector<int>> _mtrx1, 
						   std::vector<std::vector<int>> _mtrx2, 
						   std::vector<std::vector<int>> _mtrx_res) {
	std::cout << "\n\t1st: ";
	mtrx_print(_mtrx1);
	std::cout << "\n\t2nd: ";
	mtrx_print(_mtrx2);
	std::cout << "\n\tResult: ";
	mtrx_print(_mtrx_res);
}

void print_mtrx_comparence(std::vector<std::vector<int>> _mtrx1,
						   std::vector<int> _vec, std::vector<int> _vec_res) {
	std::cout << "\n\t1st: ";
	mtrx_print(_mtrx1);
	std::cout << "\n\t2nd: ";
	vec_print(_vec);
	std::cout << "\n\tResult: ";
	vec_print(_vec_res);
}

void print_mtrx_comparence(std::vector<std::vector<int>> _mtrx,
						   std::vector<std::vector<int>> _mtrx_res) {
	std::cout << "\n\tMatrix: ";
	mtrx_print(_mtrx);
	std::cout << "\n\tResult: ";
	mtrx_print(_mtrx_res);
}

void mtrx_addition(std::vector<std::vector<int>>& _mtrx1,
				   std::vector<std::vector<int>>& _mtrx2,
				   std::vector<std::vector<int>>& _mtrx_res,
				   int _mtrx_size) {
	for (int i = 0; i < _mtrx_size; ++i) {
		for (int j = 0; j < _mtrx_size; ++j) {
			_mtrx_res[i][j] = _mtrx1[i][j] + _mtrx2[i][j];
		}
	}
}

void mtrx_subtraction(std::vector<std::vector<int>>& _mtrx1,
					  std::vector<std::vector<int>>& _mtrx2,
					  std::vector<std::vector<int>>& _mtrx_res,
					  int _mtrx_size) {
	for (int i = 0; i < _mtrx_size; ++i) {
		for (int j = 0; j < _mtrx_size; ++j) {
			_mtrx_res[i][j] = _mtrx1[i][j] - _mtrx2[i][j];
		}
	}
}

void mtrx_multiplication(std::vector<std::vector<int>>& _mtrx1,
						 std::vector<std::vector<int>>& _mtrx2,
						 std::vector<std::vector<int>>& _mtrx_res,
						 int _mtrx_size) {
	for (int i = 0; i < _mtrx_size; ++i) {
		for (int j = 0; j < _mtrx_size; ++j) {
			_mtrx_res[i][j] = _mtrx1[i][j] * _mtrx2[i][j];
		}
	}
}

void mtrx_vec_multiplication(std::vector<std::vector<int>>& _mtrx,
							 std::vector<int>& _vec, std::vector<int>& _vec_res,
							 int _mtrx_size) {
	for (int i = 0; i < _mtrx_size; ++i) {
		for (int j = 0; j < _mtrx_size; ++j) {
			_vec_res[i] += _mtrx[i][j] * _vec[i];
		}
	}
}

void mtrx_transposition(std::vector<std::vector<int>>& _mtrx,
						std::vector<std::vector<int>>& _mtrx_res,
						int _mtrx_size) {
	for (int i = 0; i < _mtrx_size; ++i) {
		for (int j = 0; j < _mtrx_size; ++j) {
			_mtrx_res[i][j] = _mtrx[j][i];
		}
	}
}

void mtrx_transposition_process(std::vector<std::vector<int>>& _mtrx1,
								std::vector<std::vector<int>>& _mtrx2,
							    std::vector<std::vector<int>>& _mtrx_res,
							    int _mtrx_size, bool _mtrxT_loopFlag , int _user_choice) {
	_mtrxT_loopFlag = true;
	while (_mtrxT_loopFlag) {
		std::cout << "\n\tInput what matrix to transpose (1 or 2) : ";
		std::cin >> _user_choice;
		if (_user_choice == 1 || _user_choice == 2) {
			if (_user_choice == 1) {
				mtrx_transposition(_mtrx1, _mtrx_res, _mtrx_size);
				print_mtrx_comparence(_mtrx1, _mtrx_res);
				_mtrxT_loopFlag = false;
			}
			else {
				mtrx_transposition(_mtrx2, _mtrx_res, _mtrx_size);
				print_mtrx_comparence(_mtrx2, _mtrx_res);
				_mtrxT_loopFlag = false;
			}
		}
		else switch_error();
	}

}

void mtrx_generation_process(std::vector<std::vector<int>>& _mtrx1,
							 std::vector<std::vector<int>>& _mtrx2, 
							 int _mtrx_size) {
	rndm_init_mtrx(_mtrx1, _mtrx_size);
	rndm_init_mtrx(_mtrx2, _mtrx_size);
	std::cout << "\n\t1st:";
	mtrx_print(_mtrx1);
	std::cout << "\n\t2nd:";
	mtrx_print(_mtrx2);
}

void mtrx_addition_process(std::vector<std::vector<int>>& _mtrx1,
						   std::vector<std::vector<int>>& _mtrx2,
						   std::vector<std::vector<int>>& _mtrx_res,
						   int _mtrx_size) {
	mtrx_addition(_mtrx1, _mtrx2, _mtrx_res, _mtrx_size);
	print_mtrx_comparence(_mtrx1, _mtrx2, _mtrx_res);
}

void mtrx_subtraction_process(std::vector<std::vector<int>>& _mtrx1,
							  std::vector<std::vector<int>>& _mtrx2,
							  std::vector<std::vector<int>>& _mtrx_res,
							  int _mtrx_size) {
	mtrx_subtraction(_mtrx1, _mtrx2, _mtrx_res, _mtrx_size);
	print_mtrx_comparence(_mtrx1, _mtrx2, _mtrx_res);
}

void mtrx_multiplication_process(std::vector<std::vector<int>>& _mtrx1,
								 std::vector<std::vector<int>>& _mtrx2,
								 std::vector<std::vector<int>>& _mtrx_res,
								 int _mtrx_size) {
	mtrx_multiplication(_mtrx1, _mtrx2, _mtrx_res, _mtrx_size);
	print_mtrx_comparence(_mtrx1, _mtrx2, _mtrx_res);
}

void mtrx_vec_multiplication_process(std::vector<std::vector<int>>& _mtrx1,
									 std::vector<std::vector<int>>& _mtrx2,
									 std::vector<int>& _vec,
									 std::vector<int>& _vec_res,
									 int _mtrx_size, bool _mtrxT_loopFlag, int _user_choice) {
	_mtrxT_loopFlag = true;
	rndm_init_vec(_vec);
	while (_mtrxT_loopFlag) {
		std::cout << "\n\tInput what matrix to multiply on vector (1 or 2) : ";
		std::cin >> _user_choice;
		if (_user_choice == 1 || _user_choice == 2) {
			if (_user_choice == 1) {
				mtrx_vec_multiplication(_mtrx1, _vec, _vec_res, _mtrx_size);
				print_mtrx_comparence(_mtrx1, _vec, _vec_res);
				_mtrxT_loopFlag = false;
			}
			else {
				mtrx_vec_multiplication(_mtrx2, _vec, _vec_res, _mtrx_size);
				print_mtrx_comparence(_mtrx2, _vec, _vec_res);
				_mtrxT_loopFlag = false;
			}
		}
		else switch_error();
	}
}

int main() {
	srand((unsigned)time(NULL));
	int act_var = 0;
	bool loopFlag = true;

	int mtrx_size = 0;

	std::cout << "\n\tThe matrixes will be square" << std::endl;
	std::cout << "\n\tInput the sizes of the matrix (N x N): ";
	std::cin >> mtrx_size;
	std::vector<std::vector<int>> mtrx1(mtrx_size, std::vector<int>(mtrx_size));
	std::vector<std::vector<int>> mtrx2(mtrx_size, std::vector<int>(mtrx_size));
	std::vector<std::vector<int>> mtrx_res(mtrx_size, std::vector<int>(mtrx_size));
	std::vector<int> vec(mtrx_size);
	std::vector<int> vec_res(mtrx_size);

	while (loopFlag) {
		int user_choice = 1;
		bool mtrxT_loopFlag = true;

		main_menu();
		std::cin >> act_var;
		system("cls");

		switch (act_var) {
		case 0: //exit
			switch_exit(mtrx1, mtrx2, mtrx_res, loopFlag);
			break;
		
		case 1: //matrix generation 
			mtrx_generation_process(mtrx1, mtrx2, mtrx_size);
			break;

		case 2: //matrix addition
			mtrx_addition_process(mtrx1, mtrx2, mtrx_res, mtrx_size);
			break;

		case 3: //matrix subtraction
			mtrx_subtraction_process(mtrx1, mtrx2, mtrx_res, mtrx_size);
			break;

		case 4: //matrix multiplication (on matrix)
			mtrx_multiplication_process(mtrx1, mtrx2, mtrx_res, mtrx_size);
			break;

		case 5: //matrix multiplication (on vector)
			mtrx_vec_multiplication_process(mtrx1, mtrx2, vec, vec_res, mtrx_size, mtrxT_loopFlag, user_choice);
			break;

		case 6: //matrix transposing
			mtrx_transposition_process(mtrx1, mtrx2, mtrx_res, mtrx_size, mtrxT_loopFlag, user_choice);
			break;

		default: // an error
			switch_error();
		}

	}


	system("pause");

	std::cout << "\n\n\t";
	system("cls");
	std::cout << "\n\tGoodbye!" << std::endl;
	return 0;
}