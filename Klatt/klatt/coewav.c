/* coewav.f -- translated by f2c (version 20000121).
   You must link the resulting object file with the libraries:
	-lf2c -lm   (in that order)
*/

#include "f2c.h"

/* Common Block Declarations */

struct {
    doublereal c__[50];
} coefs_;

#define coefs_1 coefs_

/*     coewav.for              D.H. Klatt              8/1/78 */

/*     "coef-to-wave" transformation subroutine */
/*             (for a 16-bit pdp-11 computer) */

/*     simulation of the hardware klatt synthesizer */
/*     take 50 coefiecients from common array c, and */
/*     synthesize next nnxws samples of the output waveform */

/* Subroutine */ int coewav_(integer *iwave, doublereal *outma)
{
    /* Initialized data */

    static doublereal wavma = 32767.;
    static doublereal wavmax = -32767.;

    /* System generated locals */
    integer i__1;

    /* Local variables */
    static doublereal daff, dahh, yl11c, yl12c, yl21c, yl22c, yl31c, yl32c, 
	    yl41c, yl42c, yl51c, yl52c, yl61c, yl62c, yl11p, yl12p, yl21p, 
	    yl22p, yl31p, yl32p, yl41p, yl42p, yl51p, yl52p, yl61p, yl62p, 
	    step, uasp;
    static integer nxsw;
#define a1par ((doublereal *)&coefs_1 + 4)
#define a2par ((doublereal *)&coefs_1 + 5)
#define a3par ((doublereal *)&coefs_1 + 6)
#define a4par ((doublereal *)&coefs_1 + 7)
#define a5par ((doublereal *)&coefs_1 + 8)
#define a6par ((doublereal *)&coefs_1 + 9)
    static integer iran1, iran2;
    static doublereal ylgp1, ylgp2, ylgs1, ylgs2, ylgs3, ylgs4, ylnp1, ylnp2, 
	    ylgz1, ylgz2, afric;
#define abpar ((doublereal *)&coefs_1 + 10)
#define aaspi ((doublereal *)&coefs_1 + 3)
#define anpar ((doublereal *)&coefs_1 + 11)
    static doublereal ufric, noise;
    static integer nnxfc, ntime;
    static doublereal randx;
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
    static doublereal input;
#define a5 ((doublereal *)&coefs_1 + 33)
#define b5 ((doublereal *)&coefs_1 + 34)
#define c5 ((doublereal *)&coefs_1 + 35)
#define a6 ((doublereal *)&coefs_1 + 36)
#define b6 ((doublereal *)&coefs_1 + 37)
#define c6 ((doublereal *)&coefs_1 + 38)
    static doublereal uglot, ulips;
    static integer nnxws;
    static doublereal ylnp1c, ylnp2c, uglot1, uglot2, ylnz1c, ylnz2c;
#define africi ((doublereal *)&coefs_1 + 2)
    static doublereal yn, aaspir;
#define sinamp ((doublereal *)&coefs_1 + 1)
    static doublereal xnsami, ulipsf;
    static integer mpulse, npulse;
#define plstep ((doublereal *)&coefs_1 + 45)
    static doublereal uglotl;
#define impuls ((doublereal *)&coefs_1)
    static doublereal y1c, y2c;
    static integer npulsn;
    static doublereal y4c, y5c, inputs, uglotx, y6c, y3c, ulipsv, y1p, y2p, 
	    y3p, y4p, y5p, y6p;
#define agp ((doublereal *)&coefs_1 + 12)
#define bgp ((doublereal *)&coefs_1 + 13)
#define cgp ((doublereal *)&coefs_1 + 14)
#define ags ((doublereal *)&coefs_1 + 18)
#define bgs ((doublereal *)&coefs_1 + 19)
#define cgs ((doublereal *)&coefs_1 + 20)
#define anp ((doublereal *)&coefs_1 + 39)
#define bnp ((doublereal *)&coefs_1 + 40)
#define cnp ((doublereal *)&coefs_1 + 41)
#define agz ((doublereal *)&coefs_1 + 15)
#define bgz ((doublereal *)&coefs_1 + 16)
#define cgz ((doublereal *)&coefs_1 + 17)
    doublereal ran_(integer *, integer *);
#define anz ((doublereal *)&coefs_1 + 42)
#define bnz ((doublereal *)&coefs_1 + 43)
#define cnz ((doublereal *)&coefs_1 + 44)
    static doublereal ypc, ygp, ygs, yzc, ygz;

/*             iwave is an array in which waveform samples are placed */
/*               left-justified in a 36-bit word */
/*             outma is return arg indicating max absol. value of wave */
/*               if calling program sets to -1., coewav is initialized */

/*   coeficient values in c(50) are real */
/*   maximum value for a waveform sample (left-justified in 36-bit word) */
    /* Parameter adjustments */
    --iwave;

    /* Function Body */

/*   initialize coewav if outma=-1 */
/*   zero memory registers in all resonators */
    if (*outma >= 0.) {
	goto L250;
    }
/* L249: */
    yl11p = 0.;
    yl12p = 0.;
    yl21p = 0.;
    yl22p = 0.;
    yl31p = 0.;
    yl32p = 0.;
    yl41p = 0.;
    yl42p = 0.;
    yl51p = 0.;
    yl52p = 0.;
    yl61p = 0.;
    yl62p = 0.;
    ylnp1 = 0.;
    ylnp2 = 0.;
    yl11c = 0.;
    yl12c = 0.;
    yl21c = 0.;
    yl22c = 0.;
    yl31c = 0.;
    yl32c = 0.;
    yl41c = 0.;
    yl42c = 0.;
    yl51c = 0.;
    yl52c = 0.;
    yl61c = 0.;
    yl62c = 0.;
    ylnp1c = 0.;
    ylnp2c = 0.;
    ylnz1c = 0.;
    ylnz2c = 0.;
    ylgp1 = 0.;
    ylgp2 = 0.;
    ylgs1 = 0.;
    ylgs2 = 0.;
    ylgs3 = 0.;
    ylgs4 = 0.;
    ylgz1 = 0.;
    ylgz2 = 0.;
/*   zero all other memory registers */
    npulse = 1;
    mpulse = 0;
    uglotx = 0.;
    uglotl = 0.;
    *outma = 0.;
    afric = 0.;
    step = 0.;
    aaspir = 0.;

/*   generate nnxws samples of output waveform */
L250:
/*   translate some coeficients to integer */
    npulsn = (integer) coefs_1.c__[46];
    nnxws = (integer) coefs_1.c__[47];
    nxsw = (integer) coefs_1.c__[48];
    nnxfc = (integer) coefs_1.c__[49];
    xnsami = 1. / (doublereal) nnxws;
/*   delta amplitude of aspiration */
    dahh = (*aaspi - aaspir) * xnsami;
/*   delta amplitude of frication */
    daff = (*africi - afric) * xnsami;

/*   main loop */
    i__1 = nnxws;
    for (ntime = 1; ntime <= i__1; ++ntime) {
/*   generate new glottal pulse if period counter exceeded */
	--npulse;
	if (npulse > 0) {
	    goto L260;
	}
/*   and if npulsn.gt.1 (i.e. if f0>0 and av+avs>0) */
	if (npulsn <= 1) {
	    goto L260;
	}
/*   reset pulse counter */
	npulse = npulsn;
/*   pulse counter for modulated noise */
	mpulse = npulse / 2;
/*   set amplitude of normal voicing impulse */
	input = *impuls;
/*   amplitude of quasi-sinusoidal voicing */
	inputs = *sinamp;
	goto L275;
/*   set input to zoer between glottal impulses */
L260:
	input = 0.;
	inputs = 0.;
/*   resonator rgp: */
L275:
	ygp = *agp * input + *bgp * ylgp1 + *cgp * ylgp2;
	ylgp2 = ylgp1;
	ylgp1 = ygp;
/*   glottal zero pair rgz: */
/* L290: */
	ygz = *agz * ygp + *bgz * ylgz1 + *cgz * ylgz2;
	ylgz2 = ylgz1;
	ylgz1 = ygp;
/*   quasi-sinusoidal voicing produced by impulse into rgp and rgs: */
	ygs = inputs * *ags + *bgs * ylgs1 + *cgs * ylgs2;
	ylgs2 = ylgs1;
	ylgs1 = ygs;
	ygs = *agp * ygs + *bgp * ylgs3 + *cgp * ylgs4;
	ylgs4 = ylgs3;
	ylgs3 = ygs;
/*   glottal volume velocity is the sum of normal and */
/*   quasi-sinusoidal voicing */
	uglot2 = ygz + ygs;
/*   radiation characteristic  is a zero at the origin */
	uglot = uglot2 - uglotx;
	uglotx = uglot2;

/*   turbulence noise of aspiration and frication */
/*   generate random noise, random produces uniform dist. (0. to 1.) */
/* L370: */
	noise = 0.;
/*   make pseud-gaussian */
	for (randx = 1.; randx <= 16.; randx += 1.) {
/* L371: */
	    noise += ran_(&iran1, &iran2);
	}
/*   subtract off dc */
	noise += -8.;
/*   modulate noise during second half of a glottal period */
/* L375: */
	if (mpulse <= 0) {
	    noise /= 2.;
	}
	--mpulse;
/*   low-pass noise at -6 dB/octave to simulate source impedance */
/*   high-pass noise at +6 dB/octave for radiation characteristic */
/*        (two effects cancel one another) */
/*   glottal source volume velocitiy = voicing+aspiration */
	aaspir += dahh;
	uasp = aaspir * noise;
/* L380: */
	uglot += uasp;
/*   set frication source volume velocity */
/* L390: */
	afric += daff;
/*   prepare to add in a step excitation of vocal tract */
/*   if plosive released (i.e. if plstep.gt.0) */
	if (*plstep <= 0.) {
	    goto L391;
	}
	step = -(*plstep);
	*plstep = 0.;
L391:
	ufric = afric * noise;

/*   send glottal source thru cascade vocal tract resonators */
/*   do formant equations for nnxfc formants in descending order */
/*   to minimize tranisients */
	if (nxsw == 1) {
	    goto L430;
	}
/*   bypass r6 if nnxfc less than 6 */
	y6c = uglot;
	if (nnxfc < 6) {
	    goto L415;
	}
	y6c = *a6 * uglot + *b6 * yl61c + *c6 * yl62c;
	yl62c = yl61c;
	yl61c = y6c;
/*   bypass r5 if nnxfc less than 5 */
L415:
	y5c = y6c;
	if (nnxfc < 5) {
	    goto L416;
	}
	y5c = *a5 * y6c + *b5 * yl51c + *c5 * yl52c;
	yl52c = yl51c;
	yl51c = y5c;
L416:
	y4c = *a4 * y5c + *b4 * yl41c + *c4 * yl42c;
	yl42c = yl41c;
	yl41c = y4c;
	y3c = *a3 * y4c + *b3 * yl31c + *c3 * yl32c;
	yl32c = yl31c;
	yl31c = y3c;
	y2c = *a2 * y3c + *b2 * yl21c + *c2 * yl22c;
	yl22c = yl21c;
	yl21c = y2c;
	y1c = *a1 * y2c + *b1 * yl11c + *c1 * yl12c;
	yl12c = yl11c;
	yl11c = y1c;
/*   nasal zero-pair rnz: */
/* L420: */
	yzc = *anz * y1c + *bnz * ylnz1c + *cnz * ylnz2c;
	ylnz2c = ylnz1c;
	ylnz1c = y1c;
/*   nasal resonator rnp: */
	ypc = *anp * yzc + *bnp * ylnp1c + *cnp * ylnp2c;
	ylnp2c = ylnp1c;
	ylnp1c = ypc;
	ulipsv = ypc;
/*   zero out voicing input to parallel branch */
/*   if cascade branch has been used */
/* L425: */
	uglot = 0.;
	uglotl = 0.;

/*   send voicing and frication noise thru parallel resonators */
/*   increment resonator amplitudes gradually */
L430:
/*   first parallel formant r1' (excited by voicing only) */
	y1p = *a1 * *a1par * uglot + *b1 * yl11p + *c1 * yl12p;
	yl12p = yl11p;
	yl11p = y1p;
/*   nasal pole rn' (excited by first diff. of voicing source) */
	uglot1 = uglot - uglotl;
	uglotl = uglot;
	yn = *anp * *anpar * uglot1 + *bnp * ylnp1 + *cnp * ylnp2;
	ylnp2 = ylnp1;
	ylnp1 = yn;
/*   excite formants r2'-r4' with fric noise plus first-diff. voicing */
	y2p = *a2 * *a2par * (ufric + uglot1) + *b2 * yl21p + *c2 * yl22p;
	yl22p = yl21p;
	yl21p = y2p;
	y3p = *a3 * *a3par * (ufric + uglot1) + *b3 * yl31p + *c3 * yl32p;
	yl32p = yl31p;
	yl31p = y3p;
	y4p = *a4 * *a4par * (ufric + uglot1) + *b4 * yl41p + *c4 * yl42p;
	yl42p = yl41p;
	yl41p = y4p;
/*   excite formant resonators r5'-r6' with fric noise */
	y5p = *a5 * *a5par * ufric + *b5 * yl51p + *c5 * yl52p;
	yl52p = yl51p;
	yl51p = y5p;
	y6p = *a6 * *a6par * ufric + *b6 * yl61p + *c6 * yl62p;
	yl62p = yl61p;
	yl61p = y6p;
/*   add up outputs from an', r1' - r6' and bypass path */
	ulipsf = y1p - y2p + y3p - y4p + y5p - y6p + yn - *abpar * ufric;
/* L440: */
/*   add cascade and parallel vocal tract outputs */
/*   (scale by 170 to left justify in 16-bit word) */
/* L450: */
	ulips = (ulipsv + ulipsf + step) * 170.;
	step *= .995;
/*   find cumulative absol. max. of waveform since beginning of utt. */
/* L500: */
	if (ulips > *outma) {
	    *outma = ulips;
	}
/*   truncate waveform samples to abs[wavma] */
	if (ulips <= wavma) {
	    goto L510;
	}
	ulips = wavma;
L510:
	if (ulips >= wavmax) {
	    goto L520;
	}
	ulips = wavmax;
L520:
	iwave[ntime] = (integer) ulips;
/* L530: */
    }
/* L540: */
    return 0;
} /* coewav_ */

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
#undef impuls
#undef plstep
#undef sinamp
#undef africi
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
#undef anpar
#undef aaspi
#undef abpar
#undef a6par
#undef a5par
#undef a4par
#undef a3par
#undef a2par
#undef a1par

#include "mex.h"
#include "matrix.h"
#define NCOEFS 50
#define COEFS coefs_.c__

double *drand = NULL;
int index, count;

void mexFunction( int nlhs, mxArray *plhs[],
		  int nrhs, const mxArray *prhs[] )
{
	const char *names[NCOEFS] = {"impuls","sinamp","africi","aaspi",
		"a1par","a2par","a3par","a4par","a5par","a6par","abpar",
		"anpar","agp","bgp","cgp","agz","bgz","cgz","ags","bgs",
		"cgs","a1","b1","c1","a2","b2","c2","a3","b3","c3","a4",
		"b4","c4","a5","b5","c5","a6","b6","c6","anp","bnp","cnp",
		"anz","bnz","cnz","plstep","npulsn","nnxws","nxsw","nnxfc"};
	mxArray *field;
	register int i,j;
	int nchunks=0, nelements, nnxws, wsize;
	double *pr, *input[NCOEFS];
	integer *wavptr, *iwave;
	doublereal xmaxwa=-1.0;
	int gotrand;

	/* Check for proper number of arguments. */
	if (nrhs != 1) {
		mexErrMsgTxt("Must have at exactly one argument.");
	} else if (!mxIsStruct(prhs[0])) {
		mexErrMsgTxt("Argument must be a struct.");
	} else if (nlhs > 2) {
		mexErrMsgTxt("Too many output arguments.");
	}

	for (i=0; i<NCOEFS; ++i) {
		field = mxGetField(prhs[0], 0, names[i]);
		if (field == NULL) {
			mexPrintf("Field '%s' not present.", names[i]);
			mexErrMsgTxt("Invalid input structure.");
		}
		switch (i) {
			case 47:
			case 49:
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

	nnxws = (int) (*input[47]);
	wsize = nnxws*nchunks;
	
	if (nlhs == 2) {
		plhs[1] = mxCreateDoubleMatrix(wsize, 1, mxREAL);
		drand = mxGetPr(plhs[1]);
		index = 0;
		count = 0;
	} else {
		drand = NULL;
	}

	plhs[0] = mxCreateDoubleMatrix(wsize, 1, mxREAL);
	pr = mxGetPr(plhs[0]);
	wavptr = iwave = mxMalloc(wsize * sizeof(integer));

	for (i=0; i<nchunks; ++i, iwave+=nnxws) {
		for (j=0; j<NCOEFS; ++j) {
			switch (j) {
				case 47:
				case 49:
					COEFS[j] = (doublereal) (*input[j]);
					break;
				default:
					COEFS[j] = (doublereal) (input[j][i]);
			}
		}
		coewav_(iwave, &xmaxwa);
	}

	iwave = wavptr;
	for (i=0; i<wsize; ++i) {
		pr[i] = (double) (iwave[i]);
		pr[i] /= 32768.0;
	}
}

doublereal ran_(integer *iran1, integer *iran2)
{
	double r;
	doublereal ans;

	r = (double) random();
	ans = (doublereal) (r/(double) RAND_MAX);

	if (drand != NULL) {
		if (count == 0) {
			drand[index] = (double) ans;
		} else {
			drand[index] += (double) ans;
		}
		if (++count > 15) {
			count = 0;
			drand[index++] -= 8.0;
		}
	}
	return ans;
}
