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

%ISI B
ds = dataset(DF, '1-3-SPL');
T = evalsync(ds);
T.RecSide=2;T.approach=2;
T.StimSide=ds.Stimulus.Special.ActiveChan;
T.EvalISI='B';
pause;
close;
D = [D, T];

%ISI B-
ds = dataset(DF, '1-15-SPL');
T = evalsync(ds);T.ds.icell=2;T.ds.seqid='2-15-SPL';
T.RecSide=2;T.approach=2;
T.StimSide=ds.Stimulus.Special.ActiveChan;
T.EvalISI='B-';
pause;
close;
D = [D, T];

%ISI B-
ds = dataset(DF, '1-16-SPL');
T = evalsync(ds);T.ds.icell=2;T.ds.seqid='2-16-SPL';
T.RecSide=2;T.approach=2;
T.StimSide=ds.Stimulus.Special.ActiveChan;
T.EvalISI='B-';
pause;
close;
D = [D, T];

%ISI A
ds = dataset(DF, '1-21-SPL');
T = evalsync(ds);T.ds.icell=2;T.ds.seqid='3-21-SPL';
T.RecSide=2;T.approach=2;
T.StimSide=ds.Stimulus.Special.ActiveChan;
T.EvalISI='A-';
pause;
close;
D = [D, T];

%ISI A 40db:C
ds = dataset(DF, '1-26-SPL');
T = evalsync(ds);T.ds.icell=2;T.ds.seqid='4-26-SPL';
T.RecSide=2;T.approach=2;
T.StimSide=ds.Stimulus.Special.ActiveChan;
T.EvalISI='';
pause;
ds.stim.StimParam
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A- 40dB,50dB:C
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0826
DF = 'G0826';

%ISI C no spikes
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0843
DF = 'G0843';

%ISI C
ds = dataset(DF, '1-4-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '1-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A+ better than the previous one
ds = dataset(DF, '2-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0845
DF = 'G0845';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0847
DF = 'G0847';

%ISI C
ds = dataset(DF, '1-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 70dB,80dB:C
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '11-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 70dB,80dB:C
ds = dataset(DF, '12-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0856
DF = 'G0856';

%ISI A+
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '1-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '11-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '12-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 80dB:C
ds = dataset(DF, '13-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '14-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '15-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '17-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '18-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '19-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0857
DF = 'G0857';

%ISI B 80dB:C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '5-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0859
DF = 'G0859';

%ISI B remove0.5
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0865
DF = 'G0865';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0868
DF = 'G0868';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '1-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 but duration=100ms
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '2-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '11-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '12-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '13-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '14-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '15-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '16-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '17-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '18-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '19-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '20-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '21-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '22-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '23-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '24-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '25-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '26-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '27-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '28-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '29-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '30-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%S0883
DF = 'S0883';

%ISI A
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '1-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%S0884
DF = 'S0884';

%ISI B
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0885
DF = 'G0885';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0886
DF = 'G0886';

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '9-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0887
DF = 'G0887';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0889
DF = 'G0889';

%ISI B
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
s = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A remove 90dB
s = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A remove 85dB & 90dB
s = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0890
DF = 'G0890';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '5-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '5-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '5-20-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '5-21-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C??A??
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '6-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '6-7-SPL');
T ;
T.burst= evalsync(ds);%
T.tag = input('Input Tag.');
close;
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '6-8-SPL');
T ;
T.burst= evalsync(ds);%
T.tag = input('Input Tag.');
closeDur;
%;
%;
%
D = [D, T];

%ISI C??A??
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '7-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '7-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '8-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '8-4-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '9-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '9-4-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 1000Hz
ds = dataset(DF, '9-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '10-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '11-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '12-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '13-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '13-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '13-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '14-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0891
DF = 'G0891';

%ISI C
ds = dataset(DF, '1-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 500Hz
ds = dataset(DF, '3-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '3-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '4-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '4-13-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '4-14-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '6-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '6-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '6-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '7-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '7-13-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '7-14-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0894
DF = 'G0894';

%ISI C
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '1-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '1-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI 250Hz
ds = dataset(DF, '1-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '2-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '2-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '2-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '2-16-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '2-17-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '3-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '3-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '3-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '4-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 750Hz
ds = dataset(DF, '4-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 1000Hz
ds = dataset(DF, '4-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 500Hz
ds = dataset(DF, '5-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '5-13-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 1000Hz
ds = dataset(DF, '5-14-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-4-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 500Hz
ds = dataset(DF, '6-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 750Hz
ds = dataset(DF, '6-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '6-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '7-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 750Hz
ds = dataset(DF, '7-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '7-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '8-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '8-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '8-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '9-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '9-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '9-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 250Hz
ds = dataset(DF, '9-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0896
DF = 'G0896';

%ISI A
ds = dataset(DF, '1-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '1-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 250Hz
ds = dataset(DF, '1-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '2-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 500Hz
ds = dataset(DF, '2-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 750Hz
ds = dataset(DF, '2-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 1000Hz
ds = dataset(DF, '2-13-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '3-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 500Hz
ds = dataset(DF, '3-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '3-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '3-13-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '4-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 750Hz
ds = dataset(DF, '4-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '4-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '5-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '5-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '5-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '5-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '7-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '7-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '7-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '7-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '8-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '8-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 1000Hz
ds = dataset(DF, '8-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '9-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 250Hz
ds = dataset(DF, '9-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '10-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '10-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '10-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '11-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '11-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '11-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '11-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '12-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '12-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '12-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 1000Hz
ds = dataset(DF, '12-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '13-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '13-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '13-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '13-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5
ds = dataset(DF, '14-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '14-9-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '14-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '14-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '15-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '15-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '15-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '15-13-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '16-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '16-10-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B remove0.5 750Hz
ds = dataset(DF, '16-11-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 1000Hz
ds = dataset(DF, '16-12-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '17-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '17-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '17-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 1000Hz
ds = dataset(DF, '17-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%G0897
DF = 'G0897';

%ISI B
ds = dataset(DF, '4-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '4-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '4-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '6-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '6-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 750Hz
ds = dataset(DF, '6-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 250Hz
ds = dataset(DF, '6-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '8-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '9-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '9-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '9-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 250Hz
ds = dataset(DF, '9-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '10-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B
ds = dataset(DF, '11-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 500Hz
ds = dataset(DF, '11-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '11-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A
ds = dataset(DF, '12-3-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 500Hz
ds = dataset(DF, '12-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI A 250Hz
ds = dataset(DF, '12-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 750Hz
ds = dataset(DF, '12-8-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C
ds = dataset(DF, '13-2-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 500Hz
ds = dataset(DF, '13-5-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI C 250Hz
ds = dataset(DF, '13-6-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%;
%
D = [D, T];

%ISI B 750Hz
ds = dataset(DF, '13-7-SPL');
T = evalsync(ds);%
T.tag = input('Input Tag.');
close;
%
%;
%
%
D = [D, T];






