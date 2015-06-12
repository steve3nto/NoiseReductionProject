#include <octave/oct.h>
#include "../src/meddishaircell.c"

DEFUN_DLD (comp_meddishaircell, args, ,
  "This function calls the C-library\n\
  c=comp_meddishaircell(insig,fs);\n\
  Yeah.")
{
   
   const Matrix insig = args(0).matrix_value();
   
   const int siglen = insig.rows();
   const int nsigs  = insig.columns();

   const int fs     = args(1).int_value();
   

   Matrix outsig(siglen,nsigs);  
   
   meddishaircell((double*)insig.data(),
		  fs,
		  siglen,
          nsigs,
		  (double*)outsig.fortran_vec());

   return octave_value (outsig);
}

