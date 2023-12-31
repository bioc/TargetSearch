#ifndef _FIND_PEAKS_H
#define _FIND_PEAKS_H

/* require spectra_t data type */
#include "file.h"

/* Function prototypes */

struct point_s {
	double rt;   /* Ret. Time  */
	double ri;   /* Ret. Index */
	int    in;   /* Intensity  */
	int    mz;   /* mass to charge */
	double err;  /* abs time error */
	int    idx;  /* library index */
};

struct point_list_s {
	struct point_s *p;
	int length;
	int alloc;
};

int
find_all_peaks(double, double, double, double, spectra_t *,
		struct point_list_s *, int, int);

SEXP find_peaks(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);

#endif
