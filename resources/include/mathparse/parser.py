#!/usr/bin/env python
# -*- coding: utf-8 -*-

import ply.yacc as yacc
from lexer import tokens, literals

class YaccError(Exception): pass

start = "expr"
precedence = (
    ("left", "OR"),
    ("left", "AND"),
    ("right", "NOT"),
    ("left", "LE", "GE", "NE", "EQ", "<", ">"),
    ("left", "-", "+"),
    ("left",  "/", "*", "IMPMULT"),
    ("right", "UMINUS"),
    ("right", "^"),
    ("left", "!"),
    ("left", "FNCALL"),

	("left", "PARENTHESES"),
    ("left", "|"),
)

def p_kernel_numeric(p):
    """kernel : DEC
              | INT
              | BOOL"""
    p[0] = str(float(p[1]))

def p_kernel_ident(p):
    """kernel : IDENT"""
    p[0] = p[1]

def p_expr_or(p):
    """expr : expr OR expr"""
    p[0] = "(" + p[1] + ") || (" + p[3] + ")"

def p_expr_and(p):
    """expr : expr AND expr"""
    p[0] = "(" + p[1] + ") && (" + p[3] + ")"

def p_expr_not(p):
    """expr : NOT expr"""
    p[0] = "!(" + p[2] + ")"

def p_expr_eq(p):
    """expr : expr NE expr
            | expr EQ expr"""
    p[0] = "double((" + p[1] + ") " + p[2] + " (" + p[3] + "))"

def p_expr_math(p):
    """expr : expr '+' expr
            | expr '-' expr
            | expr '*' expr
            | expr '/' expr"""
    p[0] = "(" + p[1] + ") " + p[2] + " (" + p[3] + ")"

def p_expr_impmult(p):
    """expr : expr expr %prec IMPMULT"""
    p[0] = "(" + p[1] + ") * (" + p[2] + ")"

def p_expr_comp(p):
    """expr : expr LE expr
            | expr '<' expr
            | expr '>' expr
            | expr GE expr"""
    p[0] = "double(decc(" + p[1] + ") " + p[2] + " decc(" + p[3] + "))"

def p_expr_exp(p):
    """expr : expr '^' expr"""
    p[0] = "pow(" + p[1] + ", " + p[3] + ")"

def p_expr_postcall(p):
    """expr : expr '!' IDENT"""
    p[0] = p[3] + "(" + p[1] + ")"

def p_fncall_start(p):
    """fncall : IDENT '(' arg %prec FNCALL"""
    p[0] = p[1] + "(" + p[3]

def p_expr_emptyfncall(p):
    """expr : IDENT '(' ')' %prec FNCALL"""
    p[0] = p[1] + "()"

def p_arg_expr(p):
    """arg : expr"""
    p[0] = p[1]

def p_fncall(p):
    """fncall : fncall ',' arg"""
    p[0] = p[1] + ", " + p[3]

def p_expr_fncall(p):
    """expr : fncall ')'
            | fncall ',' ')'"""
    p[0] = p[1] + ")"

def p_expr_parenthesised(p):
    """expr : '(' expr ')' %prec PARENTHESES"""
    p[0] = p[2]

def p_expr_unary(p):
    """expr : '-' expr %prec UMINUS
            | '+' expr %prec UMINUS"""
    p[0] = p[1] + p[2]

def p_expr_conj(p):
    """expr : '~' expr %prec UMINUS"""
    p[0] = "conj(" + p[2] + ")"

def p_expr_abs(p):
    """expr : '|' expr '|'"""
    p[0] = "abs(" + p[2] + ")"

def p_expr_kernel(p):
    """expr : kernel"""
    p[0] = p[1]

def p_error(p):
    raise YaccError("Error parsing input. Try checking for syntax" \
            " errors (unbalanced parentheses, unfinished " \
            "expressions).")

parser = yacc.yacc(debug=0)
