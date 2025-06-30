#!/usr/bin/env python3

from fraction import *


def main ():
    p = PI ()
    print ("PI = ", p)
    one = fraction ().assign (1) ;
    two = fraction ().assign (2) ;
    three_and_half = fraction ().assign (3, 1, 2)
    print ("one =", one)
    print ("two =", two)
    print ("three_and_half =", three_and_half)
    copy = three_and_half
    print ("copy =", copy)
    result = one
    print ("result =", result)
    result += two
    print ("1 + 2 =", result)
    print ("3 1/2 =", three_and_half)
    print ("1 + 3 1/2 =", one + three_and_half)
    quarter = fraction ().assign (0, 1, 4)
    print ("1/4 + 3 1/2 =", quarter + three_and_half)
    third = fraction ().assign (0, 1, 3)
    print (quarter, "+", third, "=", quarter + third)
    third = fraction ().assign (0, 1, 3)
    seventh = fraction ().assign (0, 1, 7)
    print (seventh, "+", third, "=", seventh + third)
    val = fraction ().assign (60)
    # fpc = fraction ().assign (0, 4, 10)
    fpc = fraction ().assign (10)
    print (val)
    print (fpc)
    print (val, "*", fpc, "=", val * fpc)
    sixsevenths = fraction ().assign (0, 6, 7)
    threeeights = fraction ().assign (0, 3, 8)
    print (sixsevenths, "*", threeeights, "=", sixsevenths * threeeights)


main ()
