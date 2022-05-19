#ifndef _AST_H_
#define _AST_H_

#include <list>
#include <string>


class Expr{
    public:
        int line;
        virtual float evaluate() = 0;
};

class Statement{
    public:
        int line;
        virtual void execute() = 0;
};

class PrintStatement : public Statement{
    public:
        PrintStatement(int line, Expr * expr){
            this-> line = line;
            this->expr = expr;
        }
        int line;
        Expr * expr;
        void execute();
};
#endif