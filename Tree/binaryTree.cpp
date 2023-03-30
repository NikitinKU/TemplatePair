#include <iostream>

template < class T > class bstNode {
protected:
	T data;
	bstNode* left;
	bstNode* right;
	bstNode* parent;
	
 public:
	/* bstNode(T data) {
		 data = data;
		 left = NULL;
		 right = NULL;
	 }*/
	 //bstNode(T data) : data(data), left(NULL), right(NULL) {}

};

template < class T > class bsTree: public bstNode {
	bstNode* root;
 public:
	 bsTree() {
		 root = NULL;
	 }

	 int isEmpty() {
		 return (root == NULL);
	 }

	 void insert(T _data) {
		 node = new bstNode;
		 if (node == NULL) {
			 node = new bstNode;
			 node->data = _data;
			 node->left = NULL;
			 node->right = NULL;
			 node->parent = NULL;
		 }
		 else if (node->data < _data) {
			 node->right = Insert(_data);
			 node->right->parent = node;
		 }
		 else {
			 node->left = Insert(_data);
			 node->left->parent = node;
		 }

	 }
};