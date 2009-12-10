#!/usr/bin/env python
# -*- coding: utf-8 -*-

import ply.lex as lex

tokens = [
    "DEC", "INT", "BOOL", "IDENT",
    "GE", "LE", "NE", "EQ", "AND", "OR",
    "NOT",
]

def t_BOOL(t):
    r"true|false"

    t.value = "1.0" if t.value == "true" else "0.0"
    return t

def t_DEC(t):
    r"(?P<number>(?:(?:[ \t]*[0-9])+\.(?:[ \t]*[0-9])+)|(?:\.(?:[ \t]*[0-9])+)|(?:(?:[ \t]*[0-9])+\.))(?P<exponent>(?:[eE][+-]?(?:[ \t]*[0-9])*)?)"

    t.value = t.value.replace(" ", "").replace("\t", "")
    return t

def t_INT(t):
    r"""(?:[ \t]*[0-9])+"""

    t.value = t.value.replace(" ", "").replace("\t", "") + ".0"
    return t

def t_IDENT(t):
    r"(?P<value>[a-zA-Z0-9\$_]+)"

    if t.value in ["and", "or", "not"]:
        t.type = t.value.upper()
    elif t.value in ["z", "w", "s"]:
        t.value = "z"

    return t

literals = "()+-*/^|<>~,"

t_LE = r"\<\=|\=\<"
t_GE = r"\>\=|\=\>"
t_NE = r"\!\="
t_EQ = r"\=\="

t_ignore = " \t\f\v\r\n"

lex.lex()

def parse(s):
    lex.lexer.lineno = 0
    lex.input(s)

    return list(iter(lex.token, None))

