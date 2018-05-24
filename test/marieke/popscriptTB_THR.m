%echo on;
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

%clear T;
ds = dataset(DF, '1-2-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '1-14-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '1-20-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '1-25-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0843
DF = 'G0843';

clear T;ds = dataset(DF, '1-2-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0845
DF = 'G0845';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0847
DF = 'G0847';

clear T;ds = dataset(DF, '1-2-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0856
DF = 'G0856';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '14-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '15-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '16-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '17-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '18-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '19-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0857
DF = 'G0857';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%data missing for 4-1-THR
%data missing for 4-7-THR


clear T;ds = dataset(DF, '5-3-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0859
DF = 'G0859';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0865
DF = 'G0865';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0868
DF = 'G0868';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%clear T;ds = dataset(DF, '4-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%clear T;ds = dataset(DF, '9-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

%clear T;ds = dataset(DF, '10-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

%clear T;ds = dataset(DF, '11-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

clear T;ds = dataset(DF, '12-2-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '14-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '15-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '16-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '17-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '18-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%clear T;ds = dataset(DF, '19-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

clear T;ds = dataset(DF, '20-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '21-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '22-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%clear T;ds = dataset(DF, '23-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

%clear T;ds = dataset(DF, '24-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

%clear T;ds = dataset(DF, '25-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

%clear T;ds = dataset(DF, '26-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

%clear T;ds = dataset(DF, '27-1-THR');
%T = EvalTHR(ds)
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%close;D = [D, T];

clear T;ds = dataset(DF, '28-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '29-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '30-1-THR');
T = EvalTHR(ds)
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%S0883
DF = 'S0883';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%S0884
DF = 'S0884';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0885
DF = 'G0885';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0886
DF = 'G0886';

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-7-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0887
DF = 'G0887';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0889
DF = 'G0889';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0890
DF = 'G0890';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-5-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '14-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0891
DF = 'G0891';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0894
DF = 'G0894';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-2-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-11-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-3-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0896
DF = 'G0896';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '14-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '15-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '16-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '17-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



%G0897
DF = 'G0897';

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0899
DF = 'G0899';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];


%G0901
DF = 'G0901';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%G0902
DF = 'G0902';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];

%G0903
DF = 'G0903';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
close;D = [D, T];



