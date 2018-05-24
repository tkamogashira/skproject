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

%G0847
DF = 'G0847';

ds = dataset(DF, '1-6-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-3-NSPL');
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

ds = dataset(DF, '1-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '1-4-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-3-NSPL');
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

ds = dataset(DF, '1-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-7-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-8-NSPL');
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

ds = dataset(DF, '1-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-3-NSPL');
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

ds = dataset(DF, '1-3-NSPL');
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

ds = dataset(DF, '1-4-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '2-4-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '3-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '4-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '5-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '6-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '7-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '8-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '9-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '10-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '11-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '12-4-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '13-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '14-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '15-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '16-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '17-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '18-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '19-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '20-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '21-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '22-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '23-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '24-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '25-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '26-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '27-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '28-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '29-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];

ds = dataset(DF, '30-3-NSPL');
T = EvalNRHO(ds);ds.stim.StimParam
T.tag = input('Input Tag.');
close;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
D = [D, T];





