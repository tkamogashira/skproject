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
%G0896
DF = 'G0896';

ds = dataset(DF, '1-5-NRHO');
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

ds = dataset(DF, '2-10-NRHO');
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

ds = dataset(DF, '3-10-NRHO');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];




