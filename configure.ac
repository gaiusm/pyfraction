
AC_INIT([fractions], [1.0], [gaiusmod2@gmail.com])
AM_INIT_AUTOMAKE([-Wall])
AC_PREREQ(2.69)

AC_PROG_AWK
AC_PROG_CPP
AC_PROG_CXX
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AM_PROG_AR

AC_CONFIG_SRCDIR([version.c])
AC_CONFIG_MACRO_DIR([m4])

LT_INIT
LT_PREREQ([])
AC_SUBST([LIBTOOL_DEPS])

dnl create these files
AC_CONFIG_FILES([Makefile localrun.sh],
                [chmod +x localrun.sh])

AC_OUTPUT
