echo on;
%---------------------------------------------------------------------------------------------
%                           POPSCRIPT for TB DATA
%---------------------------------------------------------------------------------------------

% tag 1: identifies "primary" dataset of BB responses for a given cell
% tag 2: identifies "secondary" sets of NTD responses for a given cell, i.e. sets that are not the "best"
% tag 3: nice examples
% tag 4: duplicate BB data (equivalent to tag 1 data, but e.g. negative beat sign or slightly different parameters except SPL)
% tag 5: cells for which BB data exist at multiple SPLs 

D = struct([]);
%G0819B
DF = 'G0819B';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-10-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-17-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='2-17-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-18-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='2-18-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-19-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='2-19-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-22-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='3-22-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-23-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='3-23-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-24-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='3-24-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-27-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='4-27-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-28-NRHO');
T = EvalNRHO(ds);T.ds1.icell=2;T.ds1.seqid='4-28-NRHO';
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0843
DF = 'G0843';

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0845
DF = 'G0845';

ds = dataset(DF, '1-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-3-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0847
DF = 'G0847';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0856
DF = 'G0856';

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0857
DF = 'G0857';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-10-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-10-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0859
DF = 'G0859';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0865
DF = 'G0865';

ds = dataset(DF, '1-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

%G0868
DF = 'G0868';

ds = dataset(DF, '1-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-10-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-11-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-12-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-9-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '16-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '16-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '16-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '16-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '16-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '20-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '20-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '20-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '20-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '20-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '21-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '21-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '21-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '21-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '21-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '22-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '22-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '22-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '22-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '22-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '23-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '23-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '23-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '23-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '23-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '24-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '24-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '24-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '24-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '24-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '25-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '25-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '25-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '25-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '25-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '26-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '26-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '26-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '26-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '26-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '27-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '27-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '27-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '27-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '27-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '29-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '29-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '29-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '29-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '29-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '30-4-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '30-5-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '30-6-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '30-7-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '30-8-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];




