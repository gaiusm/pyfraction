# PyFraction

This project introduces a fractional datatype for Python3.

* Why the project is useful

The project is primarily a pedagogical example of how a Python3 module
might be constructed using GNU Modula-2 and swig.  It also
demonstrates how objects produced by gm2 can be linked as a shared
library and accessed by Python3.  It provides a fractional data type
and overloaded Python3 methods for the basic mathematical operators
and string output methods.

* How can users get started with the project

```bash
$ git clone https://github.com/gaiusm/pyfraction
$ cd pyfraction
$ mkdir build
$ cd build
$ ../configure --prefix=$HOME/opt
$ make
$ ./localrun.sh ../testfract.py
```

```
PI =  3 1/7
one = 1
two = 2
three_and_half = 3 1/2
copy = 3 1/2
result = 1
1 + 2 = 3
3 1/2 = 3 1/2
1 + 3 1/2 = 4 1/2
1/4 + 3 1/2 = 3 3/4
1/4 + 1/3 = 7/12
1/7 + 1/3 = 10/21
60
10
60 * 10 = 600
6/7 * 3/8 = 9/28
```

* Who maintains and contributes to the project

gaiusmod2@gmail.com maintains and contributes to this project.
