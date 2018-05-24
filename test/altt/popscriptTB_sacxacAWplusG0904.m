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

%single indepval
%clear T;ds = dataset(DF, '1-4-NRHO');
%T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
%T.Evalisi='C';
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%T.burstDur=ds.stim.StimParam.burstDur;
%T.lowFreq=ds.stim.StimParam.lowFreq;
%T.highFreq=ds.stim.StimParam.highFreq;
%T.rho=ds.stim.StimParam.rho;
%close;D = [D, T];display([ds.filename ds.seqID])

%single indepval
%clear T;ds = dataset(DF, '1-5-NRHO');
%T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
%T.Evalisi='C';
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%T.burstDur=ds.stim.StimParam.burstDur;
%T.lowFreq=ds.stim.StimParam.lowFreq;
%T.highFreq=ds.stim.StimParam.highFreq;
%T.rho=ds.stim.StimParam.rho;
%close;D = [D, T];display([ds.filename ds.seqID])

%single indepval
%clear T;ds = dataset(DF, '1-6-NRHO');
%T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
%T.Evalisi='C';
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%T.burstDur=ds.stim.StimParam.burstDur;
%T.lowFreq=ds.stim.StimParam.lowFreq;
%T.highFreq=ds.stim.StimParam.highFreq;
%T.rho=ds.stim.StimParam.rho;
%close;D = [D, T];display([ds.filename ds.seqID])

%single indepval
%clear T;ds = dataset(DF, '1-7-NRHO');
%T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
%T.Evalisi='A';
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%T.burstDur=ds.stim.StimParam.burstDur;
%T.lowFreq=ds.stim.StimParam.lowFreq;
%T.highFreq=ds.stim.StimParam.highFreq;
%T.rho=ds.stim.StimParam.rho;
%close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-17-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-18-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-19-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-22-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-23-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-24-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-27-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-28-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0843
DF = 'G0843';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0845
DF = 'G0845';

clear T;ds = dataset(DF, '1-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-3-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0847
DF = 'G0847';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0856
DF = 'G0856';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%clear T;ds = dataset(DF, '19-4-NRHO');
%T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
%T.Evalisi='C';
%T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
%T.burstDur=ds.stim.StimParam.burstDur;
%T.lowFreq=ds.stim.StimParam.lowFreq;
%T.highFreq=ds.stim.StimParam.highFreq;
%T.rho=ds.stim.StimParam.rho;
%close;D = [D, T];display([ds.filename ds.seqID])

%G0857
DF = 'G0857';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0859
DF = 'G0859';

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0865
DF = 'G0865';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0868
DF = 'G0868';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '18-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '19-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '19-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '19-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '19-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '19-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '20-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '20-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '20-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '20-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '20-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '21-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '21-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '21-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '21-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '21-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '22-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '22-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '22-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '22-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '22-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '23-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '23-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '23-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '23-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '23-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '24-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '24-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '24-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '24-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '24-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '25-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '25-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '25-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '25-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '25-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '26-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '26-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '26-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '26-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '26-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '27-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '27-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '27-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '27-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '27-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '28-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '28-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '28-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '28-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '28-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '29-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '29-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '29-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '29-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '29-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '30-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '30-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '30-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '30-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '30-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=2;T.approach=2;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%S0884
DF = 'S0884';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0885
DF = 'G0885';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0886
DF = 'G0886';

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0887
DF = 'G0887';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0889
DF = 'G0889';

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0890
DF = 'G0890';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-13-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-14-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-15-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-16-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-13-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-14-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-15-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-16-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-13-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0891
DF = 'G0891';

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0894
DF = 'G0894';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-14-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-15-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0896
DF = 'G0896';

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '15-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '16-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '17-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0897
DF = 'G0897';

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '12-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '13-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0899
DF = 'G0899';

clear T;ds = dataset(DF, '1-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-11-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-12-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%single indepval
%clear T;ds = dataset(DF, '2-13-NRHO');
%T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
%T.Evalisi='A';
%T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
%T.burstDur=ds.stim.StimParam.burstDur;
%T.lowFreq=ds.stim.StimParam.lowFreq;
%T.highFreq=ds.stim.StimParam.highFreq;
%T.rho=ds.stim.StimParam.rho;
%close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-10-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '11-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0901
DF = 'G0901';

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-9-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '10-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='B';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G0903
DF = 'G0903';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%%%%%New data since G0904

%G08109
DF = 'G08109';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '6-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G08110
DF = 'G08110';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '1-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G08111
DF = 'G08111';

clear T;ds = dataset(DF, '3-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G08113
DF = 'G08113';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G08117
DF = 'G08117';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '4-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '5-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '9-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G08119
DF = 'G08119';

clear T;ds = dataset(DF, '1-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '2-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='C';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-5-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '7-6-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '8-4-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

clear T;ds = dataset(DF, '14-8-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])

%G08120
DF = 'G08120';

clear T;ds = dataset(DF, '3-7-NRHO');
T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','no');%ds.stim.StimParam
T.Evalisi='A';
T.RecSide=1;T.approach=1;T.StimSide=ds.Stimulus.Special.ActiveChan;
T.burstDur=ds.stim.StimParam.burstDur;
T.lowFreq=ds.stim.StimParam.lowFreq;
T.highFreq=ds.stim.StimParam.highFreq;
T.rho=ds.stim.StimParam.rho;
close;D = [D, T];display([ds.filename ds.seqID])









