%Additional data from G0904
%T.RecSide=1:Left;T.approach=1:Transbulla

D = struct([]);
%G08109
DF = 'G08109';

%clear T;
ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=732;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-168;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-56;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-123;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-264;
close;D = [D, T];

%G08110
DF = 'G08110';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=107;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=259;
close;D = [D, T];

%G08111
DF = 'G08111';

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=1173;
close;D = [D, T];

%G08113
DF = 'G08113';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=968;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=1007;
close;D = [D, T];

%G08117
DF = 'G08117';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=432;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=534;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=347;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=725;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=663;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=741;
close;D = [D, T];

clear T;ds = dataset(DF, '11-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=226;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=287;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=335;
close;D = [D, T];

clear T;ds = dataset(DF, '14-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=761;
close;D = [D, T];

%G08119
DF = 'G08119';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=0;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=82;
close;D = [D, T];

clear T;ds = dataset(DF, '6-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=364;
close;D = [D, T];

clear T;ds = dataset(DF, '7-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=413;
close;D = [D, T];

clear T;ds = dataset(DF, '8-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=478;
close;D = [D, T];

clear T;ds = dataset(DF, '9-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=28;
close;D = [D, T];

clear T;ds = dataset(DF, '10-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=450;
close;D = [D, T];

clear T;ds = dataset(DF, '12-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=317;
close;D = [D, T];

clear T;ds = dataset(DF, '13-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=319;
close;D = [D, T];

clear T;ds = dataset(DF, '14-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-108;
close;D = [D, T];

clear T;ds = dataset(DF, '15-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-4;
close;D = [D, T];

%G08120
DF = 'G08120';

clear T;ds = dataset(DF, '1-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=848;
close;D = [D, T];

clear T;ds = dataset(DF, '2-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=536;
close;D = [D, T];

clear T;ds = dataset(DF, '3-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=-130;
close;D = [D, T];

clear T;ds = dataset(DF, '4-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=67;
close;D = [D, T];

clear T;ds = dataset(DF, '5-1-THR');
T = EvalTHR(ds)
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;T.depth=1242;
close;D = [D, T];







