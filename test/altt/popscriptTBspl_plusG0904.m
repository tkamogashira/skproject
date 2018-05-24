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
%%G0819B
DF = 'G0819B';

clear T;ds=dataset(DF, '1-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-15-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B-';
%T.ds1.icell=2;%T.ds.seqid='2-15-SPL';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-16-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B-';
%T.ds1.icell=2;%T.ds.seqid='2-16-SPL';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-21-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
%T.ds1.icell=2;%T.ds.seqid='3-21-SPL';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-26-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 40db:C';
%T.ds1.icell=2;%T.ds.seqid='4-26-SPL';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A- 40dB,50dB:C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0826
DF = 'G0826';

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0843
DF = 'G0843';

clear T;ds=dataset(DF, '1-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-6-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A+ better than the previous one';%ds = dataset(DF, '2-3-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '3-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0845
DF = 'G0845';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan; close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '3-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '5-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0847
DF = 'G0847';

clear T;ds=dataset(DF, '1-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-3-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '3-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 70dB,80dB:C';%ds = dataset(DF, '9-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '10-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '11-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 70dB,80dB:C';%ds = dataset(DF, '12-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0856
DF = 'G0856';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A+';%ds = dataset(DF, '1-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '1-9-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '10-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '11-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '12-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 80dB:C';%ds = dataset(DF, '13-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '14-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '15-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '15-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '17-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '17-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '18-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '18-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '19-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '19-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0857
DF = 'G0857';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 80dB:C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '3-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-8-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%clear T;ds=dataset(DF, '5-6-SPL');
%T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '5-6-SPL');
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 %close;D = [D, T];


%G0859
DF = 'G0859';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '1-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '3-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '5-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '7-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0865
DF = 'G0865';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0868
DF = 'G0868';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-3-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 but duration=100ms';%ds = dataset(DF, '2-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '2-3-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '3-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '5-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '7-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '8-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '9-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '10-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '11-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '12-3-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '13-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '14-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '15-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '15-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '16-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '16-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '17-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '17-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '18-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '18-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '19-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '19-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '20-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '20-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '21-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '21-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '22-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '22-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '23-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '23-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '24-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '24-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '25-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '25-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '26-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '26-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '27-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '27-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '28-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '28-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '29-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '29-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '30-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '30-2-SPL');
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%S0883
DF = 'S0883';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%S0884
DF = 'S0884';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0885
DF = 'G0885';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0886
DF = 'G0886';

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '5-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '9-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '10-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0887
DF = 'G0887';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '2-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '3-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '4-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '9-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '10-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0889
DF = 'G0889';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '5-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A remove 90dB';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '9-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A remove 85dB & 90dB';%ds = dataset(DF, '10-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0890
DF = 'G0890';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '3-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '5-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '5-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-20-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '5-20-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-21-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '5-21-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C??A??';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '6-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '6-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '6-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C??A??';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '7-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '7-4-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '8-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '8-4-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '9-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '9-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '9-4-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 1000Hz';%ds = dataset(DF, '9-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '10-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '10-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '11-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '12-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '13-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '13-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '13-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '14-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0891
DF = 'G0891';

clear T;ds=dataset(DF, '1-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '3-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 500Hz';%ds = dataset(DF, '3-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '3-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '4-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '4-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-13-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '4-13-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-14-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '4-14-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '5-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '6-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '6-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '6-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '7-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-13-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '7-13-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-14-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '7-14-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0894
DF = 'G0894';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '1-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '1-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';%ds = dataset(DF, '1-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '2-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '2-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '2-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-16-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '2-16-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-17-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '2-17-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;

 close;D = [D, T];clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '3-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '3-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '3-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '3-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '4-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '4-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 750Hz';%ds = dataset(DF, '4-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 1000Hz';%ds = dataset(DF, '4-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '5-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 500Hz';%ds = dataset(DF, '5-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-13-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '5-13-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-14-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 1000Hz';%ds = dataset(DF, '5-14-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-4-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 500Hz';%ds = dataset(DF, '6-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 750Hz';%ds = dataset(DF, '6-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '6-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '7-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 750Hz';%ds = dataset(DF, '7-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '7-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '8-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '8-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '8-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '9-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '9-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '9-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '9-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 250Hz';%ds = dataset(DF, '9-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];


%G0896
DF = 'G0896';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '1-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '1-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';%ds = dataset(DF, '1-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '2-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 500Hz';%ds = dataset(DF, '2-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 750Hz';%ds = dataset(DF, '2-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-13-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 1000Hz';%ds = dataset(DF, '2-13-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '3-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 500Hz';%ds = dataset(DF, '3-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '3-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-13-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '3-13-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '4-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '4-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 750Hz';%ds = dataset(DF, '4-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '4-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '5-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '5-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '5-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '5-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '7-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '7-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '7-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '7-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '8-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '8-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 1000Hz';%ds = dataset(DF, '8-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '9-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '9-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 250Hz';%ds = dataset(DF, '9-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '10-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '10-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '10-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '10-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '11-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '11-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '11-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '11-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '12-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '12-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '12-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 1000Hz';%ds = dataset(DF, '12-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '13-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '13-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '13-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '13-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5';%ds = dataset(DF, '14-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '14-9-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '14-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '14-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '14-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '15-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '15-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '15-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '15-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '15-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '15-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '15-13-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '15-13-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '16-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '16-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '16-10-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '16-10-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '16-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B remove0.5 750Hz';%ds = dataset(DF, '16-11-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '16-12-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';%ds = dataset(DF, '16-12-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '17-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '17-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '17-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '17-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '17-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '17-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '17-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 1000Hz';%ds = dataset(DF, '17-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0897
DF = 'G0897';

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '4-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '4-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '4-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '6-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '6-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';%ds = dataset(DF, '6-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';%ds = dataset(DF, '6-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '8-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '9-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '9-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '9-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 250Hz';%ds = dataset(DF, '9-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '10-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';%ds = dataset(DF, '11-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 500Hz';%ds = dataset(DF, '11-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '11-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';%ds = dataset(DF, '12-3-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';%ds = dataset(DF, '12-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';%ds = dataset(DF, '12-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '12-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 750Hz';%ds = dataset(DF, '12-8-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';%ds = dataset(DF, '13-2-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 500Hz';%ds = dataset(DF, '13-5-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C 250Hz';%ds = dataset(DF, '13-6-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '13-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B 750Hz';%ds = dataset(DF, '13-7-SPL');
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan; 
 close;D = [D, T];

%G0899
DF = 'G0899';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '11-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0901
DF = 'G0901';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '3-11-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '5-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '6-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '7-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 1000Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '8-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 250Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '9-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 500Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

%G0902
DF = 'G0902';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '4-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '5-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A 750Hz';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
%G0903
DF = 'G0903';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
 
%Additional data from G0904
%T.RecSide=1:Left;T.approach=1:Transbulla

%G08109
DF = 'G08109';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '1-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '1-7-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 

clear T;ds=dataset(DF, '1-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 

clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '4-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '5-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 

clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '6-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
%G08110
DF = 'G08110';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
  
clear T;ds=dataset(DF, '2-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
  
clear T;ds=dataset(DF, '2-9-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
  
%G08111
DF = 'G08111';

clear T;ds=dataset(DF, '3-8-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '3-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];   
 
clear T;ds=dataset(DF, '3-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];   
 
%G08113
DF = 'G08113';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 

clear T;ds=dataset(DF, '1-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '2-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
%G08117
DF = 'G08117';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '4-6-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '5-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 

clear T;ds=dataset(DF, '14-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
%G08119
DF = 'G08119';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '1-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '2-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  

clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '8-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '9-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '10-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '12-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '12-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '13-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '13-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '13-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '14-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '14-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '14-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '14-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
clear T;ds=dataset(DF, '15-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];  
 
%G08120
DF = 'G08120';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
  
clear T;ds=dataset(DF, '3-3-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
  
clear T;ds=dataset(DF, '3-4-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '3-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
  
clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
   
 
 
