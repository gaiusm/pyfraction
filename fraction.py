#!/usr/bin/env python3

import fractapi

trace = False

def tprint (*args):
    if trace:
        print (args)

def tprintf (format, *args):
    if trace:
        print(str(format) % args, end="")

def PI ():
    return fraction ().PI ()

class fraction:
    def __init__ (self, fract = None):
        tprint ("__init__")
        if fract is None:
            tprint ("fract is None")
            fract = fractapi.Constructor (0, 0, 1)
            tprint ("fract now assigned to", fract)
        else:
            tprint ("fract is", fract)
        self._fract = fract
        tprint ("__init__ called", self._fract)
    def assign (self, whole = 0, numerator = 0, demoninator = 1):
        tprint ("assign")
        self._fract = fractapi.Constructor (whole, numerator, demoninator)
        return self
    def __del__ (self):
        tprint ("__del__ called", self._fract)
        fractapi.Decon (self._fract)
    def __add__ (self, right):
        lid = self._fract
        rid = right._fract
        return fraction (fractapi.Add (lid, rid))
    def __sub__ (self, right):
        lid = self._fract
        rid = right._fract
        return fraction (fractapi.Sub (lid, rid))
    def __divide__ (self, right):
        lid = self._fract
        rid = right._fract
        return fraction (fractapi.Div (lid, rid))
    def __mul__ (self, right):
        tprint ("__mul__")
        lid = self._fract
        rid = right._fract
        tprint ("__mul__ calling m2 Mult", lid, rid)
        res = fractapi.Mult (lid, rid)
        tprint ("__mul__ res =", res)
        return fraction (res)
        # return fraction (fractapi.Mult (lid, rid))
    def __str__ (self):
        tprint ("print called for", self._fract)
        whole = fractapi.GetWhole (self._fract)
        numerator  = fractapi.GetNumerator (self._fract)
        denominator = fractapi.GetDenominator (self._fract)
        if whole == 0:
            if numerator == 0:
                return "0"
            result = "%d/%d" % (numerator, denominator)
        else:
            result = "%d" % whole
            if numerator != 0:
                result += " "
                value = "%d/%d" % (numerator, denominator)
                result += value
        return result
    def __repr__ (self):
        tprint ("__repr__ called for", self._fract)
        return "__repr__ called"
    def __eq__ (self, other):
        return fractapi.IsEqual (self._fract, other._fract)
    def PI (self):
        # Assign fraction to PI
        tprint ("assigning PI to fraction")
        self._fract = fractapi.PI ()
        return self
