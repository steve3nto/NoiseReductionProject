/* Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved. */

#include "mex.h"
#include "math.h"
#include "../src/adaptloop.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
   double *insig, *outsig, limit, minlvl;
   double *tau;
   int siglen, nsigs, fs, nloops;
   adaptloopstate s;
   
   /* Check for proper number of arguments. */
   if (nrhs != 5)
   {
      mexErrMsgTxt("Four inputs required.");
   }
   else
   {
      if (nlhs > 1)
      {
	 mexErrMsgTxt("Too many output arguments");
      }
   }
   
   /* The input must be a noncomplex double column vector*/
   siglen = mxGetM(prhs[0]);
   nsigs  = mxGetN(prhs[0]);
   nloops = mxGetM(prhs[4])*mxGetN(prhs[4]);
   if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]))
   {
      mexErrMsgTxt("Input vector must be a noncomplex double column vector.");
   }
   
   fs     = mxGetScalar(prhs[1]);
   limit  = mxGetScalar(prhs[2]);
   minlvl = mxGetScalar(prhs[3]);
   tau    = mxGetPr(prhs[4]);
   
   /* Create matrix for the return argument. */
   plhs[0] = mxCreateDoubleMatrix(siglen,nsigs, mxREAL);
   
   /* Assign pointers to each input and output. */
   insig  = mxGetPr(prhs[0]);
   outsig = mxGetPr(plhs[0]);
   
   /* Call the adaptloop C code. */
   adaptloop_init(&s, nsigs, nloops);
   adaptloop_set(&s, fs, limit, minlvl, tau);
   adaptloop_run(&s, insig, siglen, outsig);
   adaptloop_free(&s);

   /* adaptloop(insig,fs,siglen,nsigs,limit,minlvl,outsig); */
}






























