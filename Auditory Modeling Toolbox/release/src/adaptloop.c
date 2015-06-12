/* Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved. */
#include <stdlib.h>
#include "math.h"
#include "amtoolbox.h"


void adaptloop_notused(double *insig, const int fs, const int siglen, const int nsigs,
	       const double limit, const double minlvl, double *outsig)
{
   double tau[5], corr, mult, tmp1;
   double *state, *pstate, b0[5], a1[5];
   double maxvalue, factor[5], expfac[5], offset[5];
   int loops, ii, jj, w;
      
   loops=5;

   tau[0]=0.005;
   tau[1]=0.050;
   tau[2]=0.129;
   tau[3]=0.253;
   tau[4]=0.500;
   
   state = (double*)malloc(loops*nsigs*sizeof(double));

   /* get the b0 and a1 of the RC-lowpass recursion relation y(n)=b0*x(n)+a1*y(n-1)
      and the steady state */
   for ( jj=0; jj<loops; jj++)
   {
      a1[jj]=exp(-1/(tau[jj]*((double)fs)));
      b0[jj]=1-a1[jj];
      
      /* This is a clever way of avoiding exponents by taking the sqrt of the previous entry */
      if ( jj == 0 )
      {
	 state[jj] = sqrt(minlvl);
      } else {
	 state[jj] = sqrt(state[jj-1]);
      }

      /* Copy the initial state to all the other subband signals */
      for (w=1; w<nsigs; w++)
      {
	 state[jj+w*loops]=state[jj];
      }
   }
   
   corr = state[loops-1];
   mult = 100.0/(1-corr);
   
   /* Advance pointer through array for easy indexing */
   pstate=state;

   if (limit<=1.0)
   {
      /* Main loop, no overshoot limitation */

      for ( w=0; w<nsigs; w++)
      {
	 for ( ii=0; ii<siglen; ii++)
	 {	 
	    tmp1 = insig[ii+w*siglen];
	    
	    if ( tmp1 < minlvl )	
    {
	       tmp1 = minlvl;
	    }
	    
	    /* for each aloop */
	    for ( jj=0; jj<loops; jj++)
	    {	       
	       tmp1 /= pstate[jj];
	       pstate[jj] = a1[jj]*pstate[jj] + b0[jj]*tmp1;	 
	    }
	    
	    /* Scale to model units */		
	    outsig[ii+w*siglen] = (tmp1 - corr) * mult;	
	 }	
	 pstate+=loops;
      }
   }
   else
   {
      /* Main loop, overshoot limitation */

      /* Calculate constants for overshoot limitation */
      for ( jj=0; jj<loops; jj++)
      {
	 /* Max. possible output value */
	 maxvalue = (1.0-state[jj]*state[jj])*limit-1.0;
	 
	 /* Factor in formula to speed it up  */
	 factor[jj] = maxvalue*2; 			
	 
	 /*Exponential factor in output limiting function*/
	 expfac[jj] = -2./maxvalue;
	 offset[jj] = maxvalue - 1.0;
      }
      
      for ( w=0; w<nsigs; w++)
      {
	 for ( ii=0; ii<siglen; ii++)
	 {	 
	    tmp1 = insig[ii+w*siglen];
	    
	    if ( tmp1 < minlvl )
	    {
	       tmp1 = minlvl;
	    }
	    
	    /* compute the adaptation loops */
	    for ( jj=0; jj<loops; jj++)
	    {
	       tmp1 /= pstate[jj];
	       
	       if (tmp1 > 1.0)
	       {
		  tmp1 = factor[jj]/(1+exp(expfac[jj]*(tmp1-1)))-offset[jj];
	       }
	       pstate[jj] = a1[jj]*pstate[jj] + b0[jj]*tmp1;	 
	    }
	    
	    /* Scale to model units */		
	    outsig[ii+w*siglen] = (tmp1 - corr) * mult;	
	 }
	 pstate+=loops;
      }
   }

   free(state);
}

void adaptloop_init(adaptloopstate *s, const int nsigs, const int loops)
{
   s->loops  = loops;
   s->nsigs  = nsigs;
   s->state  = (double*)malloc(loops*nsigs*sizeof(double));
   s->a1     = (double*)malloc(loops*sizeof(double));
   s->factor = (double*)malloc(loops*sizeof(double));
   s->expfac = (double*)malloc(loops*sizeof(double));
   s->offset = (double*)malloc(loops*sizeof(double));   
}

void adaptloop_free(adaptloopstate *s)
{
   free(s->offset);
   free(s->expfac);
   free(s->factor);
   free(s->a1);
   free(s->state);
}


void adaptloop_set(adaptloopstate *s, const int fs, const double limit,
		   const double minlvl, const double *tau)
{

   double *pstate;
   double maxvalue;
   int jj, w, loops;
         
   pstate = s->state;
   loops = s->loops;

   /* get the b0 and a1 of the RC-lowpass recursion relation y(n)=b0*x(n)+a1*y(n-1)
      and the steady state */
   for ( jj=0; jj<loops; jj++)
   {
      s->a1[jj]=exp(-1/(tau[jj]*((double)fs)));
      
      /* This is a clever way of avoiding exponents by taking the sqrt
       * of the previous entry */
      if ( jj == 0 )
      {
	 pstate[jj] = sqrt(minlvl);
      } else {
	 pstate[jj] = sqrt(pstate[jj-1]);
      }

      /* Copy the initial state to all the other subband signals */
      for (w=1; w<s->nsigs; w++)
      {
	 pstate[jj+w*loops]=pstate[jj];
      }
   }

   /* Calculate constants for overshoot limitation */
   for ( jj=0; jj<loops; jj++)
   {
      /* Max. possible output value */
      maxvalue = (1.0-pstate[jj]*pstate[jj])*limit-1.0;
      
      /* Factor in formula to speed it up  */
      s->factor[jj] = maxvalue*2; 			
      
      /*Exponential factor in output limiting function*/
      s->expfac[jj] = -2./maxvalue;
      s->offset[jj] = maxvalue - 1.0;
   }
   
   s->corr  = pstate[loops-1];
   s->mult  = 100.0/(1-s->corr);
   s->limit = limit;
   s->minlvl = minlvl;   
}


void adaptloop_run(adaptloopstate *s, const double *insig, const int siglen,
		   double *outsig)
{
   double tmp1;
   double *pstate, minlvl, *b0;
   int ii, jj, w;      

   /* Unpack for easier reference */
   pstate = s->state;
   minlvl = s->minlvl;

   b0 = (double*)malloc(s->loops*sizeof(double));

   for ( jj=0; jj<s->loops; jj++)
   {
      b0[jj]=1-s->a1[jj];
   }

   if (s->limit<=1.0)
   {
      /* Main loop, no overshoot limitation */

      for ( w=0; w<s->nsigs; w++)
      {
	 for ( ii=0; ii<siglen; ii++)
	 {	 
	    tmp1 = insig[ii+w*siglen];
	    
	    if ( tmp1 < minlvl )
	    {
	       tmp1 = minlvl;
	    }
	    
	    /* for each aloop */
	    for ( jj=0; jj<s->loops; jj++)
	    {	       
	       tmp1 /= pstate[jj];
	       pstate[jj] = s->a1[jj]*pstate[jj] + b0[jj]*tmp1;	 
	    }
	    
	    /* Scale to model units */		
	    outsig[ii+w*siglen] = (tmp1 - s->corr) * s->mult;	
	 }	
	 pstate+=s->loops;
      }
   }
   else
   {

      /* Main loop, overshoot limitation */
            
      for ( w=0; w<s->nsigs; w++)
      {
	 for ( ii=0; ii<siglen; ii++)
	 {	 
	    tmp1 = insig[ii+w*siglen];
	    
	    if ( tmp1 < minlvl )
	    {
	       tmp1 = minlvl;
	    }
	    
	    /* compute the adaptation loops */
	    for ( jj=0; jj<s->loops; jj++)
	    {
	       tmp1 /= pstate[jj];
	       
	       if (tmp1 > 1.0)
	       {
	       tmp1 = s->factor[jj]/(1+exp(s->expfac[jj]*(tmp1-1)))-s->offset[jj];
	       }
	       pstate[jj] = s->a1[jj]*pstate[jj] + b0[jj]*tmp1;	 
	    }
	    
	    /* Scale to model units */		
	    outsig[ii+w*siglen] = (tmp1 - s->corr) * s->mult;	
	 }
	 pstate+=s->loops;
      }
   }

   free(b0);

}

