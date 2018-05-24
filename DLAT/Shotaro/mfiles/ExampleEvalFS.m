
% examples for "stereausis" analysis of responses of pairs of AN fibers to tones

if 0
% use of EvalFS, different plotmodes
ds1 = dataset('a0242', '22-3');
ds2 = dataset('a0242', '12-4');
EvalFS(ds1,ds2, 'plotmode', 'ALL');
EvalFS(ds1,ds2, 'plotmode', 'IPC');
EvalFS(ds1,ds2, 'plotmode', 'CC', 'corcutoff', 0, 'display',3);
EvalFS(ds1,ds2, 'plotmode', 'PRA');
end



% building up popscript
D = struct([]);

ds1 = dataset('a0242', '22-3');
ds2 = dataset('a0242', '12-4');
T = EvalFS(ds1,ds2, 'plot', 'yes'); pause; close all;
T.tag = [0,1];
D = [D, T];

ds1 = dataset('a0242', '88-3');
ds2 = dataset('a0242', '86-4');
T = EvalFS(ds1,ds2, 'plot', 'yes'); pause; close all;
T.tag = [0,1];
D = [D, T];

ds1 = dataset('a0242', '22-3');
ds2 = dataset('a0242', '86-4');
T = EvalFS(ds1,ds2, 'plot', 'yes'); pause; close all;
T.tag = [0,1];
D = [D, T];


structview(D);

% making groupplots

D_3rd = structfilter(D, '$DeltaCF$ < 0.333');
D_3rd = structfilter(D_3rd, '$thr1.cf$ >= 500 & $thr1.cf$ < 1000 ');
structview(D_3rd);

groupplot(D_3rd, 'BinFreq','Phase','colors',{'k','b'}, 'markers',{'+','o'},'linestyles',{'-','--'},...
    'animalidfield', 'ds1.filename', 'cellidfield', {'ds1.seqid','ds2.seqid'}, 'dispstats', 'yes', 'infofields', {'ds1.filename','ds1.seqid','ds2.seqid'},...
    'indexexpr', '($RaySig$ <= 0.001)',...
    'execevalfnc', 'EvalFS(dataset($ds1.filename$, $ds1.iseq$),dataset($ds2.filename$, $ds2.iseq$));');
