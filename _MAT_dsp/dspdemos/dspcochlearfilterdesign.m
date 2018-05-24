% Load speech data
% y = speech data
% fs = speech sampling freq

% Copyright 2004-2010 The MathWorks, Inc.

load speech_dft.mat

% DC Blocking Filter on Input Signal
[cochleardemo_inputFilter.b, cochleardemo_inputFilter.a] = ...
    butter(3,0.015,'high');

% Cascaded FIR Filter Bank Design
%
% Filter Bank Frequency Specification
% normalized band edges [-1 1]
% ch 0: [0   .04]
% ch 1: [.04 .08]
% ch 2: [.08 .12]
% ch 3: [.12 .16]
% ch 4: [.16 .24]
% ch 5: [.24 .32]
% ch 6: [.32 .48]
% ch 7: [.48 1.0]

cochleardemo_dec_hpf = mfilt.firdecim(2,firls(64,[0 .46 .50 1], [0 0 1 1]));
cochleardemo_dec_lpf = mfilt.firdecim(2,firls(64,[0 .46 .50 1], [1 1 0 0]));

cochleardemo_fir_lo = dfilt.dffir(firls(32,[0 .62 .82 1], [1 1 0 0]));
cochleardemo_fir_hi = dfilt.dffir(firls(32,[0 .62 .82 1], [0 0 1 1]));

cochleardemo_h7 = cochleardemo_dec_hpf;
cochleardemo_h6 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_hpf, cochleardemo_fir_lo);
cochleardemo_h5 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_hpf, cochleardemo_fir_hi);
cochleardemo_h4 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_dec_hpf, cochleardemo_fir_lo);
cochleardemo_h3 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_dec_hpf, cochleardemo_fir_hi);

cochleardemo_hpf = dfilt.dffir(firls(32,[0 .54 .74 1], [0 0 1 1]));
cochleardemo_bpf = dfilt.dffir(firls(32,[0 .22 .42 .54 .74 1], [0 0 1 1 0 0]));
cochleardemo_lpf = dfilt.dffir(firls(32,[0 .22 .42  1], [1 1 0 0]));

cochleardemo_h2 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_hpf);
cochleardemo_h1 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_bpf);
cochleardemo_h0 = cascade(cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_dec_lpf, cochleardemo_lpf);


% IIR (SOS implementation) Filter Bank Design
%
% Filter Bank Frequency Specification
% normalized band edges [-1 1]
% ch 0: [0   .04]
% ch 1: [.04 .08]
% ch 2: [.08 .12]
% ch 3: [.12 .16]
% ch 4: [.16 .24]
% ch 5: [.24 .32]
% ch 6: [.32 .48]
% ch 7: [.48 1.0]

d=0.008;
N=6;
As=50;
Ap=0.1;

cochleardemo_f0 = fdesign.lowpass('n,fc',N, 0.04);
cochleardemo_f0 = butter(cochleardemo_f0);
scale(cochleardemo_f0,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

fp1=0.04+d; fp2=0.08-d;
cochleardemo_f1 = fdesign.bandpass('n,fp1,fp2,ast1,ap,ast2', N, fp1, fp2, As, Ap, As);
cochleardemo_f1 = ellip(cochleardemo_f1);
scale(cochleardemo_f1,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

fp1=0.08+d; fp2=0.12-d;
cochleardemo_f2 = fdesign.bandpass('n,fp1,fp2,ast1,ap,ast2', N, fp1, fp2, As, Ap, As);
cochleardemo_f2 = ellip(cochleardemo_f2);
scale(cochleardemo_f2,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

fp1=0.12+d; fp2=0.16-d;
cochleardemo_f3 = fdesign.bandpass('n,fp1,fp2,ast1,ap,ast2', N, fp1, fp2, As, Ap, As);
cochleardemo_f3 = ellip(cochleardemo_f3);
scale(cochleardemo_f3,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

fp1=0.16+2*d; fp2=0.24-2*d;
cochleardemo_f4 = fdesign.bandpass('n,fp1,fp2,ast1,ap,ast2', N, fp1, fp2, As, Ap, As);
cochleardemo_f4 = ellip(cochleardemo_f4);
scale(cochleardemo_f4,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

fp1=0.24+2*d; fp2=0.32-2*d;
cochleardemo_f5 = fdesign.bandpass('n,fp1,fp2,ast1,ap,ast2', N, fp1, fp2, As, Ap, As);
cochleardemo_f5 = ellip(cochleardemo_f5);
scale(cochleardemo_f5,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

fp1=0.32+4*d; fp2=0.48-4*d;
cochleardemo_f6 = fdesign.bandpass('n,fp1,fp2,ast1,ap,ast2', N, fp1, fp2, As, Ap, As);
cochleardemo_f6 = ellip(cochleardemo_f6);
scale(cochleardemo_f6,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

cochleardemo_f7 = fdesign.highpass('n,fc',N, 0.48);
cochleardemo_f7 = butter(cochleardemo_f7);
scale(cochleardemo_f7,'Linf','ScaleValueConstraint','none','MaxScaleValue',1);

% Synthesis Filters For Normal Hearing People
% Same as IIR Filter Bank Design
