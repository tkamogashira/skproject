
D = struct([]);
%G08109
DF = 'G08109';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G08110
DF = 'G08110';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-6-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-7-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G08111
DF = 'G08111';

ds = dataset(DF, '3-6-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-7-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G08113
DF = 'G08113';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G08117
DF = 'G08117';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G08119
DF = 'G08119';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='C';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-5-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-6-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-4-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-7-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-8-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G08120
DF = 'G08120';

ds = dataset(DF, '3-7-NRHO');
T = EvalNRHO(ds);T.Evalisi='A';
%T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];











