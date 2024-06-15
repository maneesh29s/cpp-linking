#include "sum.hpp"  // sumI, sumF
#include <iostream> // std::cout, std::endl

void printSum(int a, int b) {
  std::cout << a << " + " << b << " = " << sum(a, b) << std::endl;
}

void printSum(float a, float b) {
  std::cout << a << " + " << b << " = " << sum(a, b) << std::endl;
}