#include "mex.h"

#include "../src/meddishaircell.c"
 
void mexFunction(int nlhs, mxArray  *plhs[],
		 int nrhs, const mxArray  *prhs[])
{

   int siglen,nsigs;            /* temporary array size holders */
   int fs;

   siglen = mxGetM(prhs[0]);
   nsigs  = mxGetN(prhs[0]);
   fs     = mxGetScalar(prhs[1]);

/*   Step 1: Error Checking Step 1a: is nlhs 1?  If not,
     generate an error message and exit mexample (mexErrMsgTxt
     does this for us!) */
   if (nlhs!=1)
      mexErrMsgTxt("mhc requires one output argument.");
      
   /*   Step 1b: is nrhs 2? */
   if (nrhs!=2)
      mexErrMsgTxt("mhc requires two input arguments, \
    prhs[0] and SAMPLERATE");   
   
   plhs[0] = mxCreateDoubleMatrix(siglen, nsigs, mxREAL);
      
   meddishaircell(mxGetPr(prhs[0]), fs, siglen, nsigs,
		  mxGetPr(plhs[0]));
 
}
