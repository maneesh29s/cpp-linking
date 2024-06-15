#include "print.hpp"

// g++ -c cpp-main.cpp
// nm cpp-main.o
// g++ -o cpp-app sum.o print.o cpp-main.o
int main(int argc, char* argv[]) {
    printSum(1, 2);
    printSum(1.5f, 2.5f);
    return 0;
}

