#include "mex.h"
#include "matrix.h"
#include "f2c.h"

/* parcoe.f -- translated by f2c (version 20000121).
   You must link the resulting object file with the libraries:
	-lf2c -lm   (in that order)
*/

/* Common Block Declarations */

struct {
    integer i__[39];
} pars_;

#define pars_1 pars_

struct {
    doublereal c__[50];
} coefs_;

#define coefs_1 coefs_

struct {
    doublereal pit, twopit;
} pixx_;

#define pixx_1 pixx_

/* Table of constant values */

static integer c__0 = 0;

/*     PARCOE.FOR             D.H. KLATT              8/1/78 */

/*     "PARAM-TO-COEF" TRANSFORMATION SUBROUTINE */

/*   THIS PROGRAM CONVERT SYNTHESIZER CONTROL PARAMETERS FROM ARRAY I(39) */
/*   INTO DIFFERENCE EQUATION CONSTANTS FOR SYNTHESIZER HARDWARE */
/*   STORED IN ARRAY C(50) */

/* Subroutine */ int parcoe_(integer *initpc)
{
    /* Initialized data */

    static doublereal pi = 3.14159265;
    static integer ndbsca[12] = { -58,-65,-73,-78,-79,-80,-58,-84,-72,-102,
	    -72,-44 };
    static integer ndbcor[10] = { 10,9,8,7,6,5,4,3,2,1 };

    /* System generated locals */
    integer i__1;

    /* Local variables */
#define nnab ((integer *)&pars_1 + 17)
#define nnaf ((integer *)&pars_1 + 1)
#define nnah ((integer *)&pars_1 + 2)
#define nnan ((integer *)&pars_1 + 10)
#define anpp ((doublereal *)&coefs_1 + 11)
#define nnav ((integer *)&pars_1)
#define nnsr ((integer *)&pars_1 + 35)
#define nnsw ((integer *)&pars_1 + 21)
    static doublereal delf1, delf2, a2cor, a3cor;
    static integer n3cor, ndbaf, ndbah;
    static doublereal t;
    static integer ndbav;
#define nnnfc ((integer *)&pars_1 + 38)
#define nnbgp ((integer *)&pars_1 + 23)
    static integer n12cor;
#define nnbgs ((integer *)&pars_1 + 34)
#define nnfgp ((integer *)&pars_1 + 22)
    static integer n23cor, n34cor;
#define nnbnp ((integer *)&pars_1 + 32)
#define nnbgz ((integer *)&pars_1 + 25)
#define nnfnp ((integer *)&pars_1 + 31)
    static integer nxbgp, mnfgz;
#define a1 ((doublereal *)&coefs_1 + 21)
#define b1 ((doublereal *)&coefs_1 + 22)
#define c1 ((doublereal *)&coefs_1 + 23)
#define a2 ((doublereal *)&coefs_1 + 24)
#define b2 ((doublereal *)&coefs_1 + 25)
#define c2 ((doublereal *)&coefs_1 + 26)
#define a3 ((doublereal *)&coefs_1 + 27)
#define b3 ((doublereal *)&coefs_1 + 28)
#define c3 ((doublereal *)&coefs_1 + 29)
#define a4 ((doublereal *)&coefs_1 + 30)
#define b4 ((doublereal *)&coefs_1 + 31)
#define c4 ((doublereal *)&coefs_1 + 32)
#define a5 ((doublereal *)&coefs_1 + 33)
#define b5 ((doublereal *)&coefs_1 + 34)
#define c5 ((doublereal *)&coefs_1 + 35)
#define a6 ((doublereal *)&coefs_1 + 36)
#define b6 ((doublereal *)&coefs_1 + 37)
#define c6 ((doublereal *)&coefs_1 + 38)
#define nnavs ((integer *)&pars_1 + 3)
#define nnfnz ((integer *)&pars_1 + 9)
#define nnfgz ((integer *)&pars_1 + 24)
#define nnbnz ((integer *)&pars_1 + 33)
#define nnnws ((integer *)&pars_1 + 36)
    static integer mnfnz;
    static doublereal a2scrt, a2skrt;
    extern /* Subroutine */ int setabc_(integer *, integer *, doublereal *, 
	    doublereal *, doublereal *);
    static integer naflas;
    extern doublereal getamp_(integer *);
    static integer ndbavs;
#define sinamp ((doublereal *)&coefs_1 + 1)
    static doublereal samrat;
#define a1p ((doublereal *)&coefs_1 + 4)
#define a2p ((doublereal *)&coefs_1 + 5)
#define a3p ((doublereal *)&coefs_1 + 6)
#define a4p ((doublereal *)&coefs_1 + 7)
#define a5p ((doublereal *)&coefs_1 + 8)
#define a6p ((doublereal *)&coefs_1 + 9)
#define plstep ((doublereal *)&coefs_1 + 45)
#define impuls ((doublereal *)&coefs_1)
    static integer npulsn;
#define aff ((doublereal *)&coefs_1 + 2)
#define ahh ((doublereal *)&coefs_1 + 3)
#define abp ((doublereal *)&coefs_1 + 10)
    static integer ndb, nf21;
#define agp ((doublereal *)&coefs_1 + 12)
#define bgp ((doublereal *)&coefs_1 + 13)
#define cgp ((doublereal *)&coefs_1 + 14)
#define ags ((doublereal *)&coefs_1 + 18)
#define bgs ((doublereal *)&coefs_1 + 19)
#define cgs ((doublereal *)&coefs_1 + 20)
    static integer nf32;
#define anp ((doublereal *)&coefs_1 + 39)
#define bnp ((doublereal *)&coefs_1 + 40)
#define cnp ((doublereal *)&coefs_1 + 41)
#define agz ((doublereal *)&coefs_1 + 15)
#define bgz ((doublereal *)&coefs_1 + 16)
#define cgz ((doublereal *)&coefs_1 + 17)
    static integer nf43;
#define anz ((doublereal *)&coefs_1 + 42)
#define bnz ((doublereal *)&coefs_1 + 43)
#define cnz ((doublereal *)&coefs_1 + 44)
#define nna1 ((integer *)&pars_1 + 11)
#define nna2 ((integer *)&pars_1 + 12)
#define nna3 ((integer *)&pars_1 + 13)
#define nna4 ((integer *)&pars_1 + 14)
#define nnf0 ((integer *)&pars_1 + 4)
#define nnf1 ((integer *)&pars_1 + 5)
#define nnf2 ((integer *)&pars_1 + 6)
#define nnf3 ((integer *)&pars_1 + 7)
#define nnf4 ((integer *)&pars_1 + 8)
#define nna5 ((integer *)&pars_1 + 15)
#define nna6 ((integer *)&pars_1 + 16)
#define nnb1 ((integer *)&pars_1 + 18)
#define nnb2 ((integer *)&pars_1 + 19)
#define nnb3 ((integer *)&pars_1 + 20)
#define nnb4 ((integer *)&pars_1 + 26)
#define nnf5 ((integer *)&pars_1 + 27)
#define nnb5 ((integer *)&pars_1 + 28)
#define nnf6 ((integer *)&pars_1 + 29)
#define nnb6 ((integer *)&pars_1 + 30)
#define nng0 ((integer *)&pars_1 + 37)

/*             INITPC INITIALIZES THIS ROUTINE IF =-1 */

/*   INPUT PARAMETER VALUES (CONSTANT AND VIRIABLE) PASSED THROUGH I */
/*   COEFFICIENT VALUES IN C(50) ARE REAL */
/*   NAMES OF INPUT CONTROL PARAMETERS */
/*   CONSTANTS NEEDED BY SUBROUTINE SETABC */

/*   SCALE FACTORS IN DB FOR GENERAL ADJUSTMENT TO: */
/*                  A1  A2  A3  A4  A5  A6  AN  AB  AV   AH  AF AVS */
/*   INCREMENT IN DB TO FORMANT AMPLITUDES OF PARALLEL BRANCH IF */
/*   FORMANT FREQUENCY DIFFERENT 50, 100, 150, ... HZ */


/*   INITIALIZE SYNTHESIZER BEFORE COMPUTING WAVEFORM HCUNK IF ARG.LT.0 */
/* L100: */
    if (*initpc >= 0) {
	goto L130;
    }
    *initpc = 0;
    naflas = 0;
/*   COMPUTE SAMPLING PERIOD T (ALL CONSTANT CONTROL PARAMETERS */
/*   MUST BE SET BEFORE CALLING INIT) */
    samrat = (doublereal) (*nnsr);
    t = 1. / samrat;
    pixx_1.pit = pi * t;
    pixx_1.twopit = pixx_1.pit * 2.;
/*   CONVERT INHERENTLY INTEGER PARAMS TO REAL COEFFICIENTS */
    coefs_1.c__[47] = (doublereal) (*nnnws);
    coefs_1.c__[48] = (doublereal) (*nnsw);
    coefs_1.c__[49] = (doublereal) (*nnnfc);
/* L110: */



/*   UPDATE ALL COEFICIENTS OF HARDWARE SYNTHESIZER */

/*   COMPUTE PARALLEL BRANCH AMPLITUDE CORRECTION TO F2 DUE TO F1 */
L130:
    delf1 = (doublereal) (*nnf1) / 500.;
    a2cor = delf1 * delf1;
/*   COMPUTE AMPLITUDE CORRECTION TO F3-5 DUE TO F1 AND F2 */
    delf2 = (doublereal) (*nnf2) / 1500.;
    a2skrt = delf2 * delf2;
    a3cor = a2cor * a2scrt;
/*   TAKE INTO ACCOUNT FIRST DIFF OF GLOTTAL WAVE FOR F2 */
    a2cor /= delf2;
/*   COMPUTE AMPLITUDE CORRECTIONS DUE TO PROXIMITY OF 2 FORMANTS */
    n12cor = 0;
    n23cor = 0;
    n34cor = 0;
    nf21 = *nnf2 - *nnf1;
    if (nf21 < 50) {
	goto L135;
    }
    if (nf21 < 550) {
	n12cor = ndbcor[nf21 / 50 - 1];
    }
    nf32 = *nnf3 - *nnf2 - 50;
    if (nf32 < 50) {
	goto L135;
    }
    if (nf32 < 550) {
	n23cor = ndbcor[nf32 / 50 - 1];
    }
    nf43 = *nnf4 - *nnf3 - 150;
    if (nf43 < 50) {
	goto L135;
    }
    if (nf43 < 550) {
	n34cor = ndbcor[nf43 / 50 - 1];
    }
L135:
/*   SET AMPLITUDE OF VOICING */
    ndbav = *nng0 + *nnav + ndbsca[8];
    *impuls = getamp_(&ndbav);
/*   AMPLITUDE OF ASPIRATION */
/* L150: */
    ndbah = *nng0 + *nnah + ndbsca[9];
    *ahh = getamp_(&ndbah);
/*   AMPLITUDE OF FRICATION */
/*   (IN AN ALL-PARALLEL CONFIGURATION, AF=MAX[AF,AH]) */
    if (*nnah > *nnaf && *nnsw == 1) {
	*nnaf = *nnah;
    }
    ndbaf = *nng0 + *nnaf + ndbsca[10];
    *aff = getamp_(&ndbaf);
/*   ADD A STEP TO WAVEFORM AT PLOSIVE RELEASE */
    *plstep = 0.;
    if (*nnaf - naflas < 49) {
	goto L151;
    }
    i__1 = *nng0 + ndbsca[10] + 44;
    *plstep = getamp_(&i__1);
L151:
    naflas = *nnaf;
/*   AMPLITUDE OF QUASI-SINUSOIDAL VOICING SOURCE */
    ndbavs = *nng0 + *nnavs + ndbsca[11];
    *sinamp = getamp_(&ndbavs) * 10.;
/*   SET AMPLITUDES OF PARALLEL FORMANTS A1 THRU A6 */
    ndb = *nna1 + n12cor + ndbsca[0];
    *a1p = getamp_(&ndb);
    ndb = *nna2 + n12cor + n12cor + n23cor + ndbsca[1];
    *a2p = a2cor * getamp_(&ndb);
    ndb = *nna3 + n23cor + n23cor + n34cor + ndbsca[2];
    *a3p = a3cor * getamp_(&ndb);
    ndb = *nna4 + n34cor + n34cor + ndbsca[3];
    *a4p = a3cor * getamp_(&ndb);
    ndb = *nna5 + ndbsca[5];
    *a5p = n3cor * getamp_(&ndb);
    ndb = *nna6 + ndbsca[5];
    *a6p = a3cor * getamp_(&ndb);
/*   SET AMPLITUDE OF PARALLEL NASAL FORMANT */
    ndb = *nnan + ndbsca[6];
    *anpp = getamp_(&ndb);
/*   SET AMPLITUDE OF BYPASS PATH OF FRICATION TRACT */
    ndb = *nnab + ndbsca[7];
    *abp = getamp_(&ndb);
/*   RESET DIFFERENCE EQUATION CONSTANTS FOR RESONATORS */
/* L230: */
    setabc_(nnf1, nnb1, a1, b1, c1);
    setabc_(nnf2, nnb2, a2, b2, c2);
    setabc_(nnf3, nnb3, a3, b3, c3);
    setabc_(nnf4, nnb4, a4, b4, c4);
    setabc_(nnf5, nnb5, a5, b5, c5);
    setabc_(nnf6, nnb6, a6, b6, c6);
    setabc_(nnfnp, nnbnp, anp, bnp, cnp);
/*   AND FOR NASAL ANTIRESONATOR */
    mnfnz = -(*nnfnz);
    if (mnfnz >= 0) {
	mnfnz = -1;
    }
    setabc_(&mnfnz, nnbnz, anz, bnz, cnz);
/*   AND FOR GLOTTAL RESONATORS AND ANTIRESONATORS */
    npulsn = 1;
    if (*nnf0 <= 0) {
	goto L245;
    }
/*   ISSUE NO PULSE IF NNAV AND NNAVS BOTH .LE.0 */
    if (*nnav <= 0 && *nnavs <= 0) {
	goto L245;
    }
/*   WAVEFORM MORE SINUSOIDAL AT HIGH FUNDAMENTAL FREQUENCY */
    nxbgp = *nnbgp * 100 / *nnf0;
    setabc_(nnfgp, &nxbgp, agp, bgp, cgp);
    setabc_(&c__0, nnbgs, ags, bgs, cgs);
    mnfgz = -(*nnfgz);
    if (mnfgz >= 0) {
	mnfgz = -1;
    }
    setabc_(&mnfgz, nnbgz, agz, bgz, cgz);
/*   SET GAIN TO CONSTANT IN MID-FREQUENCY REGION FOR RGP */
    *agp = .007;
/*   DO NOT LET F0 DROP BELOW 40 HZ */
    if (*nnf0 < 40) {
	*nnf0 = 40;
    }
/*   MAKE AMPLITUDE OF IMPULSE INCREASE WITH INCREASING F0 */
    *impuls *= *nnf0;
/*   NUMBER OF SAMPLES BEFORE A NEW GLOTTAL PULSE MAY BE GENERATED */
    npulsn = *nnsr / *nnf0;
L245:
/*   CONVERT INHERENTLY INTEGER PARAMS TO REAL COEFICIENTS */
    coefs_1.c__[46] = (doublereal) npulsn;
    return 0;
} /* parcoe_ */

#undef nng0
#undef nnb6
#undef nnf6
#undef nnb5
#undef nnf5
#undef nnb4
#undef nnb3
#undef nnb2
#undef nnb1
#undef nna6
#undef nna5
#undef nnf4
#undef nnf3
#undef nnf2
#undef nnf1
#undef nnf0
#undef nna4
#undef nna3
#undef nna2
#undef nna1
#undef cnz
#undef bnz
#undef anz
#undef cgz
#undef bgz
#undef agz
#undef cnp
#undef bnp
#undef anp
#undef cgs
#undef bgs
#undef ags
#undef cgp
#undef bgp
#undef agp
#undef abp
#undef ahh
#undef aff
#undef impuls
#undef plstep
#undef a6p
#undef a5p
#undef a4p
#undef a3p
#undef a2p
#undef a1p
#undef sinamp
#undef nnnws
#undef nnbnz
#undef nnfgz
#undef nnfnz
#undef nnavs
#undef c6
#undef b6
#undef a6
#undef c5
#undef b5
#undef a5
#undef c4
#undef b4
#undef a4
#undef c3
#undef b3
#undef a3
#undef c2
#undef b2
#undef a2
#undef c1
#undef b1
#undef a1
#undef nnfnp
#undef nnbgz
#undef nnbnp
#undef nnfgp
#undef nnbgs
#undef nnbgp
#undef nnnfc
#undef nnsw
#undef nnsr
#undef nnav
#undef anpp
#undef nnan
#undef nnah
#undef nnaf
#undef nnab


/*     SETABC.FOR               D.H. KLATT              8/1/78 */

/*     CONVERT FORMANT FREQUENCIES AND BANDWIDTH TO RESONATOR */
/*     DIFFERENCE EQUATION CONSTANTS */

/* Subroutine */ int setabc_(integer *f, integer *fb, doublereal *a, 
	doublereal *b, doublereal *c__)
{
    /* Builtin functions */
    double exp(doublereal), cos(doublereal);

    /* Local variables */
    static doublereal r__;



/* ---REPLACE BY R=EXPTAB(FB) FOR FASTER EXECUTION */
    r__ = exp(-pixx_1.pit * (doublereal) (*fb));
    
    *c__ = -r__ * r__;

/* ---REPLACE BY B=COSTAB(F) FOR FASTER EXECUTION */
    *b = r__ * 2. * cos(pixx_1.twopit * (doublereal) (*f));

    *a = 1. - *b - *c__;
/* L620: */
/*   IF F IS MINUS, COMPUTE A,B,C, FOR A ZERO PAIR */
    if (*f >= 0) {
	return 0;
    }
    *a = 1. / *a;
    *b = -(*a) * *b;
    *c__ = -(*a) * *c__;
    return 0;
} /* setabc_ */

/*     GETAMP.FOR              D.H. KLATT              8/1/78 */

/*     CONVERT DB ATTEN. (FROM 96 TO -72) TO A LINEAR SCALE FACTOR. */
/*             (TRUNCATE NDB IF OUTSIDE RANGE) */

doublereal getamp_(integer *ndb)
{
    /* Initialized data */

    static doublereal dtable[11] = { 1.8,1.6,1.43,1.26,1.12,1.,.89,.792,.702,
	    .623,.555 };
    static doublereal stable[28] = { 65536.,32768.,16384.,8192.,4096.,2048.,
	    1024.,512.,256.,128.,64.,32.,16.,8.,4.,2.,1.,.5,.25,.125,.0625,
	    .0312,.0156,.0078,.0039,.00195,9.75e-4,4.87e-4 };

    /* System generated locals */
    doublereal ret_val;

    /* Local variables */
    static doublereal xx1, xx2;
    static integer ndb1, ndb2, ndb3;



/* L650: */
    ndb1 = *ndb;
    ret_val = 0.;
    if (ndb1 <= -72) {
	return ret_val;
    }
    if (ndb1 > 96) {
	ndb1 = 96;
    }
    ndb2 = ndb1 / 6;
    ndb3 = ndb1 - ndb2 * 6;
    xx1 = stable[17 - ndb2 - 1];
    xx2 = dtable[6 - ndb3 - 1];
    ret_val = xx1 * xx2;
/* L660: */
    return ret_val;
} /* getamp_ */

#define NINPUT 39
#define NCOEFS 50

void mexFunction( int nlhs, mxArray *plhs[],
		  int nrhs, const mxArray *prhs[] )
{
	/* names of input control parameters */
	const char *inames[NINPUT] = {"av","af","ah","avs","f0","f1",
		"f2","f3","f4","fnz","an","a1","a2","a3","a4","a5","a6",
		"ab","b1","b2","b3","sw","fgp","bgp","fgz","bgz","b4","f5",
		"b5","f6","b6","fnp","bnp","bnz","bgs","sr","nws","g0","nfc"};
	const char *cnames[NCOEFS] = {"impuls","sinamp","africi","aaspi",
		"a1par","a2par","a3par","a4par","a5par","a6par","abpar",
		"anpar","agp","bgp","cgp","agz","bgz","cgz","ags","bgs",
		"cgs","a1","b1","c1","a2","b2","c2","a3","b3","c3","a4",
		"b4","c4","a5","b5","c5","a6","b6","c6","anp","bnp","cnp",
		"anz","bnz","cnz","plstep","npulsn","nnxws","nxsw","nnxfc"};
	double *input[NINPUT];
	double *coefs[NCOEFS];
	mxArray *field;
	int nchunks=0;
	int nelements;
	register int i,j;
	integer initpc=-1;

	/* Check for proper number of arguments. */
	if (nrhs!=1) {
		mexErrMsgTxt("One input required.");
	} else if(nlhs>1) {
		mexErrMsgTxt("Too many output arguments.");
	}

	if (!mxIsStruct(prhs[0])) {
		mexErrMsgTxt("Argument must be a struct.");
	}

	for (i=0; i<NINPUT; ++i) {
		field = mxGetField(prhs[0], 0, inames[i]);
		if (field == NULL) {
			mexPrintf("Field '%s' not present.", inames[i]);
			mexErrMsgTxt("Invalid input structure.");
		}
		switch (i) {
			case 34:
			case 35:
			case 36:
			case 37:
			case 38:
				break;
			default:
				nelements = mxGetNumberOfElements(field);
				if (nchunks && nchunks != nelements) {
					mexErrMsgTxt("All fields must have "
							"same number of "
							"elements.");
				} else {
					nchunks = nelements;
				}
		}
		input[i] = mxGetPr(field);
	}

	plhs[0] = mxCreateStructMatrix(1, 1, NCOEFS, cnames);
	for (i=0; i<NCOEFS; ++i) {
		switch (i) {
			case 47:
			case 49:
				field = mxCreateDoubleMatrix(1,1,mxREAL);
				break;
			default:
				field = mxCreateDoubleMatrix(nchunks,1,mxREAL);
		}
		coefs[i] = mxGetPr(field);
		mxSetField(plhs[0], 0, cnames[i], field);
	}
	
	for (i=0; i<nchunks; ++i) {
		for (j=0; j<NINPUT; ++j) {
			switch (j) {
				case 34:
				case 35:
				case 36:
				case 37:
				case 38:
					pars_.i__[j] = (integer) (input[j][0]);
					break;
				default:
					pars_.i__[j] = (integer) (input[j][i]);
			}
		}
		parcoe_(&initpc);
		for (j=0; j<NCOEFS; ++j) {
			switch (j) {
				case 47:
				case 49:
					coefs[j][0] = (double) (coefs_.c__[j]);
					break;
				default:
					coefs[j][i] = (double) (coefs_.c__[j]);
			}
		}
	}
}


