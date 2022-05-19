#include "ast.h"
#include <iostream>
#include <sstream>
#include <set>


void PrintStatement::execute(){
    printf("%f\n", this->expr->evaluate());
}