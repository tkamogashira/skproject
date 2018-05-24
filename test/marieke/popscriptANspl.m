%We need reevaluation of isi
%T.RecSide=1:Left;T.approach=1:Transbulla
echo on;


D = struct([]);
%G08116
DF = 'G08116';

clear T;ds=dataset(DF, '1-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];

clear T;ds=dataset(DF, '2-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '3-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T];
 
clear T;ds=dataset(DF, '3-5-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '4-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '5-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '6-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '7-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
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
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '11-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
 close;D = [D, T]; 
 
clear T;ds=dataset(DF, '12-2-SPL');
T=evalsync2(ds, 'anwin', [10 25]);T.Evalisi='A';
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
 
 
 
 
 
 
 
 
 
 
 