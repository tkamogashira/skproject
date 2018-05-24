%Additional data from G0904
%T.RecSide=1:Left;T.approach=1:Transbulla
echo on;


D = struct([]);
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
  
 
 
 
 
 
 
 
 
 
 
 
 