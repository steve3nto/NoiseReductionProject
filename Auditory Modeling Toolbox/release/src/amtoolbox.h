#ifndef AMTOOLBOX_H
#define AMTOOLBOX_H

/* BEGIN_C_DECLS */

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

typedef struct adaptloopstatevar
{
  int    loops;
  int    nsigs;
  double *state;
  double corr;
  double mult;
  double limit;
  double minlvl;
  double *a1;
  double *factor, *expfac, *offset;
} adaptloopstate;


void adaptloop_init(adaptloopstate *s, const int nsigs, const int loops);

void adaptloop_set(adaptloopstate *s, const int fs, const double limit,
		   const double minlvl, const double *tau);

void adaptloop_run(adaptloopstate *s, const double *insig, const int siglen,
		   double *outsig);

void adaptloop_free(adaptloopstate *s);


#ifdef __cplusplus
}  /* extern "C" */
#endif /* __cplusplus */

/* END_C_DECLS */


#endif /* AMTOOLBOX_H */
