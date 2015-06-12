#include <octave/oct.h>
#include "../src/adaptloop.c"

DEFUN_DLD (comp_adaptloop, args, ,
  "This function calls the C-library\n\
  c=comp_adaptloop(insig,fs,limit,minlvl);\n\
  Yeah.")
{
   
   const Matrix insig = args(0).matrix_value();
   
   const int siglen = insig.rows();
   const int nsigs  = insig.columns();

   const int fs     = args(1).int_value();
   const double limit  = args(2).double_value();
   const double minlvl = args(3).double_value();
   const Matrix tau    = args(4).matrix_value();

   const int nloops = tau.rows()*tau.columns();
   
   adaptloopstate s;

   Matrix outsig(siglen,nsigs);  
   
   adaptloop_init(&s, nsigs, nloops);
   adaptloop_set(&s, fs, limit, minlvl, (const double*)tau.data());
   adaptloop_run(&s, (double*)insig.data(), siglen, (double*)outsig.data());
   adaptloop_free(&s);

   //adaptloop((double*)insig.data(),fs,siglen,nsigs,limit,minlvl,(double*)outsig.data());
   return octave_value (outsig);
}

