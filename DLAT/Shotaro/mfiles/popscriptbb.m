echo on;
%---------------------------------------------------------------------------------------------
%                           POPSCRIPT for BINAURAL BEAT DATA
%---------------------------------------------------------------------------------------------

% to view data without printing issue command: replace %pause by pause and 'plot', 'no' by 'plot', 'yes'
% to print data without viewing issue command: print

% adjustment of averaging of Hilbert envelope:
% evalbb(ds,'EnvRunAvUnit','#','EnvRunav',0.1) % to specify in fraction of dominant period, e.g. 0.1 for DF of 1k would mean 0.1 * 1 ms
% evalbb(ds,'EnvRunAvUnit','ms','EnvRunav',2)  % to specify in ms

% adjustment of averaging of ITD curves:
%T = EvalBB(ds, 'AnWin',[500 3500],'itdrunavunit', 'ms', 'itdrunav', 0.5,'itdxrange',[-10 10], 'CalcDF','DF','plot', 'no')

% tag 1: identifies "primary" dataset of BB responses for a given cell
% tag 2: identifies "secondary" sets of NTD responses for a given cell, i.e. sets that are not the "best"
% tag 3: nice examples
% tag 4: duplicate BB data (equivalent to tag 1 data, but e.g. negative beat sign or slightly different parameters except SPL)
% tag 5: cells for which BB data exist at multiple SPLs 

D = struct([]);

%if 0
%end    

%--------%
% R95057 %
%--------%
DF = 'R95057';

% barely response 
%ds = dataset(DF, '1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close; 
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-PIP');
T = EvalBB(ds,'anwin',[50 4000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close; 
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '4-PIP');% incomplete on low freq side
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '5-1-PIP');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-1-PIP');% CF = 3084 Hz
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-3-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-5-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-6-BBAM');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-8-BBAM');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-PIP');% CF = 2828
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-3-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-4-BBAM');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '9-1-PIP');% trougher
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '10-1-PIP');% poor phase-sensitivity, borderline
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/- (looks unusual)

%ds = dataset(DF, '11-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '12-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '13-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '14-1-PIP');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '16-1-PIP');% low response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '17-1-PIP');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '19-1-PIP');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '20-1-PIP');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '21-1-PIP');
T = EvalBB(ds, 'AnWin',[1000 3000],'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/- % not spindle-shaped

%ds = dataset(DF, '22-1-PIP');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '23-1-PIP');% poor phase-sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '24-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%--------%
% R95060 %
%--------%
DF = 'R95060';

%ds = dataset(DF, '4-1-PIP');% different shape
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '4-29-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '5-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-2-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-4-BB');% poor response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-2-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-3-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '8-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '8-2-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '8-4-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '9-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '9-3-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '9-4-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '10-1-PIP');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '11-1-PIP'); % envelope cell, CF unknown
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '11-2-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '13-1-PIP');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '13-1-BB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '13-2-BB'); % actually cell 14;% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '15-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '15-2-BB');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '16-1-PIP');% 60 dB
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '16-2-BB');% 60 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '24-4-BB');% low response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];



%--------%
% R95096 %
%--------%
DF = 'R95096';

%ds = dataset(DF, '9-2-BBFC');% low rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '10-2-BBFC');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '12-2-BBFC');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-


%--------%
% I95101 %
%--------%
DF = 'I95101';

%ds = dataset(DF, '3-7-BBFC');% CF = 2900 (envelope cell)
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '5-1-BB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];


%--------%
% R95106 %
%--------%
DF = 'R95106';

ds = dataset(DF, '4-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/- % NITD too restricted?

%ds = dataset(DF, '7-1-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '7-23-BBFC');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '10-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '11-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '12-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '16-1-SERBB');% poor response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '18-1-SERBB');% poor phase sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%--------%
% R95110 %
%--------%
DF = 'R95110';

%ds = dataset(DF, '2-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-20-BB');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '3-1-SERBB');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '4-1-SERBB');% poor response, borderline
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '5-1-SERBB');% envelope cell! poor response, borderline
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '6-1-SERBB');% envelope cell!
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '6-3-BB');% envelope cell!
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '7-1-SERBB'); % 60 dB
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '7-20-BBFC'); %restrict to 60 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32, 'indep2val', 60); pause; close; close;
T.tag = [0,2];
D = [D, T];

%NITD+/-

ds = dataset(DF, '7-20-BBFC'); %restrict to 70 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32, 'indep2val', 70); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '8-2-SERBB'); % envelope cell, poor response
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '10-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '15-1-SERBB');% incomplete low freq
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '20-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '21-2-SERBB');
T = EvalBB(ds, 'CalcDF','CF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
T.fft.df = NaN
D = [D, T];

%NITD+/-

%ds = dataset(DF, '22-1-SERBB');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%--------%
% R96077 %
%--------%
DF = 'R96077';

%ds = dataset(DF, '3-1-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '5-1-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '5-2-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '5-3-BB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '5-4-BB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

% 60 dB
%ds = dataset(DF, '9-1-BB'); %false triggers at 2nd freq
%T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% 50 dB
ds = dataset(DF, '9-2-BB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '10-1-BB'); 
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '11-2-BB'); 
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '12-1-BB'); % undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '13-1-BB');% poor phase sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%--------%
% R96078 %
%--------%
DF = 'R96078';

ds = dataset(DF, '3-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '4-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '4-2-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '5-3-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '6-1-BBSER');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '7-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '7-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '7-3-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '8-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '11-1-SERBB');% Cf = 2691
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '11-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '12-1-SERBB');% CF = 2468
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '22-3-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '23-9-BBFC');% poor phase sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '24-1-SERBB');% undersampled;% CF = 2263 Hz
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '31-3-SERBB');% poor phase-sensitivity
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '32-2-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '32-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '32-4-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '35-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '38-1-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '38-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '39-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '39-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '39-17-BBFC');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '41-2-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '43-1-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '43-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%--------%
% R97047 %
%--------%
DF = 'R97047';

%ds = dataset(DF, '1-1-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '1-2-PIP');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '1-3-PIP');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '8-1-SERBB'); %70 dB
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '8-2-SERBB');% 60 dB, incomplete at low freq
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

ds = dataset(DF, '10-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '11-1SERBB');% poor response, poor phase-locking
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%--------%
% R98076 %
%--------%
DF = 'R98076';

ds = dataset(DF, '2-4-BB');% trougher
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '6-1-PIP');% poor response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '6-10-BBFC'); % trougher; %split up in different SPLs;% ex!!
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 30); pause; close; close;% poor response
%T.tag = [0];
%D = [D, T];
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 40); pause; close; close;% small response
%T.tag = [0];
%D = [D, T];
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 50); pause; close; close;% small response
%T.tag = [0];
%D = [D, T];
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 60); pause; close; close;% small response
%T.tag = [0];
%D = [D, T];
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 70); pause; close; close;% small response
%T.tag = [0];
%D = [D, T];
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 80); pause; close; close;% small response
%T.tag = [0];
%D = [D, T];
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32,'indep2val', 90); pause; close; close;% small response
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '16-1-PIP');% CF 3031 Hz
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '23-3-SERBB');% undersampled low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '23-4-SERBB');% undersampled low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '29-1-SERBB');% undersampled low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '30-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '31-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '32-1-SERBB');% incomplete
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '32-2-SERBB');% trougher; %poor phase sensitivity, borderline case
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '33-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '34-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '34-2-SERBB');% poor ITD sensitivity to noise
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '40-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '41-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];




%--------%
% R98077 %
%--------%
DF = 'R98077';

% low rate, low sampling
%ds = dataset(DF, '2-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% CF = 2089 Hz
%ds = dataset(DF, '3-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% low rate
%ds = dataset(DF, '5-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%undersampled
%ds = dataset(DF, '11-4-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '15-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%correspondence with NITD unclear (different cell?)

%undersampling
%ds = dataset(DF, '17-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '18-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '19-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '19-9-BBFC'); % 70 dB
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '19-10-BBFC');% 50 dB
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

%NITD+/-

% nice example of tweener
%ds = dataset(DF, '20-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '20-9-BBFC'); % 70 dB
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '20-10-BBFC');% 50 dB
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '20-11-BBFC');% 30 dB no Response
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '21-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '21-10-BBFC');% 70 dB
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '21-11-BBFC'); % 90 dB can be merged with 21-12 (but little benefit - only very tail end)
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

%ds = dataset(DF, '21-12-BBFC');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '21-13-BBFC');% poor response
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '22-1-SERBB');% CF = 2089 Hz
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '26-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '27-10-BBFC'); % 70 dB, trougher
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '27-11-BBFC');% 60 dB - barely phase sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '27-12-BBFC');% 50 dB - barely phase sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '27-13-BBFC');% 40 dB
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '28-1-SERBB');% incomplete on low freq side, borderline case
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '30-2-SERBB');% 90 dB
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '30-9-BBFC');% 100 dB! UNDERSAMPLED
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '34-2-SERBB'); % low rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


ds = dataset(DF, '36-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '39-2-SERBB');% 70 dB
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '39-8-BBFC');% 70 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '41-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '42-1-SERBB'); % 60 dB
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

%NITD+/-

ds = dataset(DF, '42-5-BBFC');% 70 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '42-6-BBFC');% 60 dB, better response than 41-2
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '42-7-BBFC');% 50 dB poor response, onset response
%T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '48-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '50-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '50-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '53-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '53-4-BBFC');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '54-4-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '57-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-


%--------%
% R98086 %
%--------%
DF = 'R98086';

ds = dataset(DF, '2-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '3-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '3-3-SERBB');% poor response
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '3-4-SERBB');
T = EvalBB(ds, 'AnWin',[50 2500], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

%NITD+/-

ds = dataset(DF, '4-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '8-1-SERBB');% CF = 2757
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '11-1-SERBB');% CF = 3167
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '15-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '16-2-SERBB'); %low rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '21-16-BBFC');% change in beat freq
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '22-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '23-1-SERBB');% CF = 2425 Hz
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '27-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '32-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '36-1-SERBB');% poor sampling
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '37-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '37-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '39-1-SERBB');% CF = 2089
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '43-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '44-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '46-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '56-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%--------%
% R99005 %
%--------%
DF = 'R99005';

%ds = dataset(DF, '4-1-SERBB'); % CF = 2617
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '5-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.fft.df = NaN;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '7-7-SERBB');% poor response
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '9-1-SERBB');% incomplete on low-CF side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '9-3-SERBB');% incomplete on low-CF side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '9-4-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '10-2-SERBB'); % undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '11-1-SERBB');% poor phase-sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '13-1-SERBB');% CF = 2201
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '15-1-SERBB');% CF = 3112
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '20-1-SERBB');% envelope cell, undersampled
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '22-2-SERBB');% CF = 4525
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '22-3-SERBB');% high CF
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '23-1-SERBB');%high CF; % FALSE TRIGGERS
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '24-3-SERBB');%high CF; % FALSE TRIGGERS
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%--------%
% R99009 %
%--------%
DF = 'R99009';

ds = dataset(DF, '7-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '10-1-SERBB');% incomplete on low freq side
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '11-1-SERBB');% low response
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '13-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '13-2-SERBB');
T = EvalBB(ds, 'AnWin',[1100 2100], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '14-1-SERBB');% poor phase-sensitivity
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%complex response
%ds = dataset(DF, '15-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '15-10-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '15-11-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '16-1-SERBB'); % noisy response
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '17-2-SERBB');% complex response
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '18-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '20-1-SERBB');% undersampled
T = EvalBB(ds, 'AnWin',[50 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '21-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '24-1-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '27-1-SERBB');% CF = 2691 !!!! nice example
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '27-11-RAM');% CF = 2691 !!!! nice example; % 90 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,3,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '27-12-RAM');% CF = 2691 !!!! nice example; % 70 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,3,5];
D = [D, T];

%NITD+/-

ds = dataset(DF, '27-13-RAM');% CF = 2691 !!!! nice example; % 50 dB
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3,5];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '28-1-SERBB');% undersampled
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '29-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '30-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '37-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '38-1-SERBB');% CF = 6979
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '42-1-SERBB');% CF = 2691
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '42-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '46-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '47-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 2000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '47-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '48-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '49-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 2050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '50-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '50-2-SERBB'); % cannot be merged with 50-3 (different increment)
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '50-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%--------%
% R99039 %
%--------%
DF = 'R99039';

%ds = dataset(DF, '2-1-SERBB');% poor sampling & response
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '2-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '3-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '7-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '7-3-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '9-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '10-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '11-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '12-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '12-2-SERBB-');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '13-1-SERBB');% 60 dB
%T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '13-3-SERBB-');% 60 dB, negative beat
%T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '13-9-BBFC');% nice example!
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '14-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '14-12-BBFC');% nice example!
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3];
D = [D, T];

%NITD+/-

ds = dataset(DF, '14-17-BBFC-');% nice example, BF = -1
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,3,4];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '15-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '15-11-BBFC');% ex of trougher
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '15-12-BBFC-');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '16-3-BBFC');% low response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '16-4-BBFC-');% low response rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '18-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '19-1-SERBB');% undersampled
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '19-2-SERBB-');% undersampled
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '20-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat? CHECK change tag if necessary
ds = dataset(DF, '20-2-SERBB-');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '21-1-SERBB');% envelope cell?, trougher
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '21-2-SERBB-');% envelope cell?, trougher
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '22-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '23-1-SERBB');% envelope cell?
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '28-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%--------%
% R00001 %
%--------%
DF = 'R00001';

ds = dataset(DF, '9-1-bb'); %trougher
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% CHECK: masterdss = 2, to have negative beat? Adjust tag
ds = dataset(DF, '9-2-bb'); 
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '10-1-bb');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-
% CHECK: assume that 10-2 has the right master/slave polarity
% same stimulus as 10-1-BB but master/slave switched => different slope CD
ds = dataset(DF, '10-2-bb'); %
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%poor beating
%ds = dataset(DF, '11-21-bb'); %RA DATASET
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% 14-2 and 14-3 CHECK WHICH master setting is correct, and adjust tags
% MDSS = 2
ds = dataset(DF, '14-2-bb');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

% MDSS = 2
ds = dataset(DF, '14-3-bb'); %same stimulus as 14-2?
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '15-1-bb1');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '15-2-bb2'); % trougher
T = EvalBB(ds, 'AnWin',[800 2800], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat? CHECK and change tag if necessary
ds = dataset(DF, '17-1-bb1');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '17-2-bb2');%same as 17-1?
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '18-1-bb2');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% CHECK mdss = 2: negative beat? adjust tag
ds = dataset(DF, '18-2-bb2');%same as 18-1?
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '20-1-bb1');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '20-2-bb-1');%BF -1
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

% poor response
%ds = dataset(DF, '30-1-bb-1');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% has envelope component
%ds = dataset(DF, '32-1-bb-1');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% has envelope component
%ds = dataset(DF, '33-1-bb-1');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '37-1-BB1');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '37-2-BB-1'); %BF -1
T = EvalBB(ds, 'AnWin',[1000 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%poor modulation of cc
%ds = dataset(DF, '38-1-BB-1');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '38-2-BB1');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '41-4-BB1');
T = EvalBB(ds, 'AnWin',[1000 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '41-5-BB-1');
T = EvalBB(ds, 'AnWin',[1000 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '43-2-BB1');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '44-1-BB1');
T = EvalBB(ds, 'AnWin',[1000 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '44-2-BB-1'); %BF -1
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%--------%
% R00015 %
%--------%
DF = 'R00015';

%ds = dataset(DF, '1-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '7-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3500], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '8-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '9-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3500], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '10-2-SERBB'); %HHW not useable
%T = EvalBB(ds, 'AnWin',[500 3500], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

%ds = dataset(DF, '11-6-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% CF 2263 Hz
%ds = dataset(DF, '13-12-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '18-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3500], 'itdxrange',[-10 10],'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '20-1-SERBB');%HHW not useable
T = EvalBB(ds, 'AnWin',[500 3500], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '21-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '21-13-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32, 'itdrunavunit', 'ms', 'itdrunav', 0.5,'itdxrange',[-10 10]); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

% WATCH HHW!
ds = dataset(DF, '21-14-SERBB-');
T = EvalBB(ds, 'AnWin',[500 3500],'CalcDF','DF','plot', 'yes','histnbin', 32,'itdrunavunit', 'ms', 'itdrunav', 0.5,'itdxrange',[-10 10]); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

% WATCH HHW!
ds = dataset(DF, '21-15-SERBB-');
T = EvalBB(ds, 'AnWin',[500 3500], 'itdxrange',[-10 10],'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

% WATCH HHW!
ds = dataset(DF, '21-16-SERBB');
T = EvalBB(ds, 'AnWin',[500 3500], 'itdxrange',[-10 10],'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,4];
D = [D, T];

ds = dataset(DF, '24-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3550], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%WATCH HWW!
ds = dataset(DF, '26-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '34-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '34-17-SERBB+');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat
ds = dataset(DF, '34-18-SERBB-');
T = EvalBB(ds, 'AnWin',[50 3550], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '35-1-SERBB'); %Asymmetrical cc curve
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '35-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '35-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '36-1-SERBB');%BF -2
T = EvalBB(ds, 'AnWin',[50 3550], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '36-2-SERBB'); 
T = EvalBB(ds, 'AnWin',[50 3550], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '40-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 3550], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '41-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD incomplete

% CHECK negative beat? adjust tag if necessary
ds = dataset(DF, '41-3-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];


%--------%
% R01016 %
%--------%
DF = 'R01016';

ds = dataset(DF, '6-3-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% negative beat? CHECK and adjust tag if necessary
ds = dataset(DF, '6-4-SERBB-1');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

ds = dataset(DF, '9-3-SERBB');%high SR
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '10-1-SERBB'); % noisy
T = EvalBB(ds, 'AnWin',[50 3550], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '11-1-SERBB'); %LOW RATE
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '11-2-SERBB');% poorer than 11-7
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

%NITD+/-

ds = dataset(DF, '11-7-SERBB');% poor
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% mdss = 2 CHECK negative beat? adjust tag if necessary
ds = dataset(DF, '14-3-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

ds = dataset(DF, '14-4-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '17-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '17-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '18-1-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '18-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '18-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '18-4-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '19-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '19-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '20-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '20-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ds = dataset(DF, '20-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% negative beat? CHECK adjust tag if necessary
ds = dataset(DF, '21-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '21-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%CF = 2111 Hz
%ds = dataset(DF, '22-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

%ds = dataset(DF, '22-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%NITD+/-

ds = dataset(DF, '22-9-BBFC');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0];
D = [D, T];

%NITD+/-

ds = dataset(DF, '24-1-SERBB');% trougher
T = EvalBB(ds, 'AnWin',[500 3000], 'itdxrange',[-10 10],'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% opposite beat: CHECK which one is positive and adjust tag
ds = dataset(DF, '24-2-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '26-1-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '26-2-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% 60 dB
ds = dataset(DF, '27-1-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/- (ugly)

ds = dataset(DF, '27-2-SERBB');
T = EvalBB(ds, 'AnWin',[50 3050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-
% negative beat? CHECK sign of beat, adjust tag if necessary
ds = dataset(DF, '29-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

ds = dataset(DF, '29-2-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

%WATCH HHW
ds = dataset(DF, '30-2-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '30-3-SERBB');
T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '32-2-SERBB'); %low rate
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '32-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%WATCH HHW
% CHECK sign of beat, adjust tag if necessary
ds = dataset(DF, '34-1-SERBB');
T = EvalBB(ds, 'AnWin',[250 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%WATCH HHW
% CHECK sign of beat, adjust tag if necessary
ds = dataset(DF, '34-2-SERBB');
T = EvalBB(ds, 'AnWin',[250 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

ds = dataset(DF, '35-1-SERBB');% poor phase sensitivity, WATCH HHW
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

ds = dataset(DF, '37-1-SERBB'); %mdss = 2
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% CHECK negative beat? check and adjust tag if necessary
ds = dataset(DF, '37-2-SERBB'); %mdss = 1
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '38-3-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%ds = dataset(DF, '38-4-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '39-1-SERBB');
T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0];
D = [D, T];

%NITD+/-

%ds = dataset(DF, '39-2-SERBB');
%T = EvalBB(ds, 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '40-1-SERBB'); %mdss = 2
T = EvalBB(ds, 'AnWin',[500 3000], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%NITD+/-

% negative beat? CHECK and adjust tag if necessary
ds = dataset(DF, '40-2-SERBB'); %mdss = 1 
T = EvalBB(ds, 'AnWin',[500 3000], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

%NITD+/-



%--------%
% R02011 %
%--------%
DF = 'R02011'

ds = dataset(DF, '2-2-SERBB');
T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '7-1-SERBB')
T = EvalBB(ds, 'AnWin',[1000 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no response
%ds = dataset(DF, '8-1-SERBB')
%T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '9-1-SERBB')
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '10-1-SERBB')
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '11-1-SERBB')
%T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '12-1-SERBB')
T = EvalBB(ds, 'AnWin',[10 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% low response rate, inadequate sampling
%ds = dataset(DF, '13-1-SERBB')
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '13-2-SERBB')
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '14-1-SERBB')
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '15-1-SERBB')
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '16-1-SERBB')
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled on low freq side
%ds = dataset(DF, '17-1-SERBB')
%T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% undersampled
%ds = dataset(DF, '18-1-SERBB')
%T = EvalBB(ds, 'AnWin',[10 5010], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '18-2-SERBB')
T = EvalBB(ds, 'AnWin',[20 5020], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.diff.max           = nan;
T.diff.bestitd       = nan;
T.diff.ratio         = nan;
T.diff.hhw           = nan;
T.tag = [0,1];
D = [D, T];

%--------%
% R02012 %
%--------%

DF = 'R02012'

% undersampled
%ds = dataset(DF, '1-1-SERBB')
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '1-2-SERBB')
T = EvalBB(ds, 'AnWin',[100 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '2-1-SERBB')
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-2-SERBB')
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '4-1-SERBB')
%T = EvalBB(ds, 'AnWin',[500 3000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '4-2-SERBB')
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%ex trougher
ds = dataset(DF, '5-1-SERBB')
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '6-1-SERBB')
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];


%------------------------------------------------------------------------------------------------------------------
%                                                   LEUVEN DATA
%------------------------------------------------------------------------------------------------------------------
%-------%
% C0129 %
%-------%
DF = 'C0129'; %

ds = dataset(DF, '1-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '2-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%poor response
%ds = dataset(DF, '3-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '3-2');
T = EvalBB(ds, 'AnWin',[0 1000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '4-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '5-1');
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds1 = dataset(DF, '6-1');
ds2 = dataset(DF, '6-2');
ds = mergeds(ds1, 600:100:1400, ds2, 1500:100:2000);
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.thr.cf = 1414;
T.thr.sr = 0;
T.thr.thr = 31;
T.thr.q10 = 4.34;
T.thr.bw = 326;
T.tag = [0,1];
D = [D, T];

% monaural dataset!
%ds = dataset(DF, '7-2');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%-------%
% C0211 %
%-------%
DF = 'C0211'; %

% no response
%ds = dataset(DF, '2-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% incomplete
%ds = dataset(DF, '2-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% not binaural
%ds = dataset(DF, '3-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% not binaural
%ds = dataset(DF, '3-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% poor response, no phase-sensitivity;
%ds = dataset(DF, '6-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '8-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% upper flank
%ds = dataset(DF, '8-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds1 = dataset(DF, '9-1');
ds2 = dataset(DF, '9-2');
ds = mergeds(ds1, 200:100:1000, ds2, 1100:100:2000);
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.thr.cf = NaN;
T.thr.sr = NaN;
T.thr.thr = NaN;
T.thr.q10 = NaN;
T.thr.bw = NaN;
T.tag = [0,1];
D = [D, T];

% too low response rate
%ds = dataset(DF, '10-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

%ds = dataset(DF, '11-4');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];


%--------%
% C0211B %
%--------%
DF = 'C0211B'; %

% poor response
%ds = dataset(DF, '1-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '1-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% peak-splitting in tail!
ds = dataset(DF, '1-5');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '2-1');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '2-10'); % poor response
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '3-7');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '6-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '8-1');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%--------%
% C0211C %
%--------%
DF = 'C0211C';

% undersampled on high freq side
ds = dataset(DF, '9-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled on high freq side
%ds = dataset(DF, '9-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '10-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '11-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled on high freq side
ds = dataset(DF, '12-6');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0];
D = [D, T];

ds = dataset(DF, '14-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '15-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '16-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '16-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '21-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled
%ds = dataset(DF, '22-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% incomplete
%ds = dataset(DF, '22-7');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '23-4');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '24-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no response
%ds = dataset(DF, '24-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '24-5');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor phase-sensitivity
%ds = dataset(DF, '26-1');
%T = EvalBB(ds, 'AnWin',[1000 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '28-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% tail phase-sensitivity
ds = dataset(DF, '31-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '32-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity.
%ds = dataset(DF, '34-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '35-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '36-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '37-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% undersampled
%ds = dataset(DF, '40-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '40-3');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% low response rate
%ds = dataset(DF, '41-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% low response rate
ds = dataset(DF, '41-2');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% low response rate
ds = dataset(DF, '42-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled on low freq side
ds = dataset(DF, '43-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% low response rate
%ds = dataset(DF, '44-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% low response rate
%ds = dataset(DF, '44-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '45-2');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% tail phase-sensitivity
ds = dataset(DF, '46-1');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% low freq side for completion of 46-1
%ds = dataset(DF, '46-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '52-1');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '53-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% incomplete
%ds = dataset(DF, '57-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '57-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%-------%
% C0214 %
%-------%
DF = 'C0214'; %

% wrong side for definition secondary peak?
ds = dataset(DF, '1-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response, undersampled
%ds = dataset(DF, '2-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '3-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poorly sampled
ds = dataset(DF, '4-1');
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poorly sampled
ds = dataset(DF, '5-1');
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poorly sampled
ds = dataset(DF, '6-1');
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

% compare with 6-1
ds = dataset(DF, '6-15');
T = EvalBB(ds, 'AnWin',[50 5050], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '7-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% incomplete sampled: only low freq side
%ds = dataset(DF, '8-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% weak response
ds = dataset(DF, '9-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '11-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% high freq side: no phase-sensitivity
%ds = dataset(DF, '11-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no response
%ds = dataset(DF, '12-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no response
%ds = dataset(DF, '12-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no response
%ds = dataset(DF, '12-4');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '13-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '14-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% incomplete
%ds = dataset(DF, '14-4');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '15-1');
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% response rate low
ds = dataset(DF, '16-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds1 = dataset(DF, '17-1');
ds2 = dataset(DF, '17-2');
ds = mergeds(ds1, 400:100:1400, ds2, 1500:100:2000)
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.thr.cf = 1741;
T.thr.sr = 0;
T.thr.thr = 29;
T.thr.q10 = 1.85;
T.thr.bw = 941;
T.tag = [0,1];
D = [D, T];

% only high freq side
%ds = dataset(DF, '17-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds1 = dataset(DF, '18-3');
ds2 = dataset(DF, '18-2');
ds3 = dataset(DF, '18-1');
ds4 = dataset(DF, '18-4');
ds = mergeds(ds1, 100:100:600, ds2, 700:100:1100, ds3, 1200:100:2000, ds4, 2100:100:2500)
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.thr.cf = 2378;
T.thr.sr = .07;
T.thr.thr = 16;
T.thr.q10 = 2.67;
T.thr.bw = 890;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '20-6');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '21-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '22-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '23-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '24-2');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '25-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled
%ds = dataset(DF, '26-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '27-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor phase-sensitivity
%ds = dataset(DF, '29-1');
%T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '30-1');
%T = EvalBB(ds, 'AnWin',[0 1000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '30-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no response
%ds = dataset(DF, '31-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no response
%ds = dataset(DF, '35-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];


ds = dataset(DF, '36-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '37-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%no phase-sensitivity
%ds = dataset(DF, '39-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%--------%
% C0214B %
%--------%
DF = 'C0214B'; %

% 60 dB
ds = dataset(DF, '40-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

ds = dataset(DF, '40-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

ds = dataset(DF, '40-3');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '41-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no response
%ds = dataset(DF, '43-9');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no sustained response
%ds = dataset(DF, '43-10');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% high CF: no phase-sensitivity
%ds = dataset(DF, '45-7');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '46-16');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '46-17');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];


%-------%
% C0220 %
%-------%
DF = 'C0220'; %

ds = dataset(DF, '1-1'); % 60 dB
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% peakratio taken on "wrong" side
ds = dataset(DF, '1-25'); % 80 dB
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

% irregular phase behavior, peakratio not relevant
%ds = dataset(DF, '1-26');% 90 dB
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,2];
%D = [D, T];

ds = dataset(DF, '1-27');% 70 dB
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes', 'EnvRunAv', 2, 'histnbin',32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

ds = dataset(DF, '1-28');% 60 dB, response rate lower than in 1-1
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4,5];
D = [D, T];

ds = dataset(DF, '1-29');% 50 dB
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

ds = dataset(DF, '1-30');% 40 dB
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

ds = dataset(DF, '1-31');% 30 dB
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

% no response
%ds = dataset(DF, '1-32');% 20 dB
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor phase-sensitivity
ds = dataset(DF, '2-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

ds = dataset(DF, '2-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '3-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '3-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '3-13');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% poor phase-sensitivity
ds = dataset(DF, '3-21');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];


%-------%
% C0222 %
%-------%
DF = 'C0222'; %

% poor phase-sensitivity, poor response
%ds = dataset(DF, '3-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor phase-sensitivity, poor response
%ds = dataset(DF, '3-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '4-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '4-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no response
%ds = dataset(DF, '5-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '6-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled
%ds = dataset(DF, '6-14');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% only high-freq side, no phase-sensitivity
%ds = dataset(DF, '7-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% poor phase-sensitivity
ds = dataset(DF, '8-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor phase-sensitivity, poor response
ds = dataset(DF, '11-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2];
D = [D, T];

ds = dataset(DF, '11-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '14-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '15-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% poor response
%ds = dataset(DF, '16-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '16-2');
%T = EvalBB(ds, 'AnWin',[0 1000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% weak response and phase-sensitivity
ds = dataset(DF, '17-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '18-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '19-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '20-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% incomplete sampling
%ds = dataset(DF, '21-1');
%T = EvalBB(ds, 'AnWin',[500 1000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% incomplete sampling
%ds = dataset(DF, '21-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '21-5');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '22-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3];
D = [D, T];

% bad triggers
%ds = dataset(DF, '23-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% weird response - peak-splitting?
%ds = dataset(DF, '23-2');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% undersampled
%ds = dataset(DF, '24-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '24-37');% 60 dB
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

ds = dataset(DF, '24-38');% 80 dB
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,5];
D = [D, T];

% low response rate
ds = dataset(DF, '24-39');% 40 dB
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

ds = dataset(DF, '24-40');% 35 dB
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,5];
D = [D, T];

% poor sampling
%ds = dataset(DF, '26-1');
%T = EvalBB(ds, 'AnWin',[20 1020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '26-2');
%T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%-------%
% C0229 %
%-------%

    
DF = 'C0229'; %

% no phase-sensitivity
%ds = dataset(DF, '1-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '2-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '3-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '3-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '14-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '14-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '14-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% tail phase-sensitivity
ds = dataset(DF, '15-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '16-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor phase-sensitivity
ds = dataset(DF, '16-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '17-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '18-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '18-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '19-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '20-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled
%ds = dataset(DF, '22-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

%undersampled
%ds = dataset(DF, '22-2');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

ds = dataset(DF, '24-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

ds1 = dataset(DF, '24-2');
ds2 = dataset(DF, '24-3');
ds = mergeds(ds1, 300:100:1700, ds2, 1800:100:2000);
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.thr.cf = NaN;
T.thr.sr = NaN;
T.thr.thr = NaN;
T.thr.q10 = NaN;
T.thr.bw = NaN;
T.tag = [0,1];
D = [D, T];

% undersampled: limited tail phase-sensitivity
%ds = dataset(DF, '25-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% undersampled: limited tail phase-sensitivity
%ds = dataset(DF, '25-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '27-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '28-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

ds = dataset(DF, '28-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '32-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '32-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '33-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% little phase-sensitivity
%ds = dataset(DF, '33-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '34-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '34-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '35-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% weird and poor response, mainly in tail
%ds = dataset(DF, '35-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '36-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '38-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '39-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%-------%
% S0231 %
%-------%
DF = 'S0231'; %

% poorly sampled
ds = dataset(DF, '1-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response, undersampled
ds = dataset(DF, '2-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '3-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor response
%ds = dataset(DF, '4-9');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%-------%
% L0232 %
%-------%
DF = 'L0232'; %

ds = dataset(DF, '1-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% nice!
ds = dataset(DF, '3-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '6-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% very peaky response
ds = dataset(DF, '8-1');
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% no spikes
%ds = dataset(DF, '8-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '10-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% tail phase-sensitivity
ds = dataset(DF, '13-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% upper freq incomplete
ds = dataset(DF, '14-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% 40 dB, little response
%ds = dataset(DF, '14-26');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% 30 dB, little response
%ds = dataset(DF, '14-27');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% little response
%ds = dataset(DF, '39-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% little response
%ds = dataset(DF, '40-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% small response
ds = dataset(DF, '41-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '42-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% small response, tail phase-sensitivity
%ds = dataset(DF, '48-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% little response
%ds = dataset(DF, '49-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% no response
%ds = dataset(DF, '49-2');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% little response, undersampled
%ds = dataset(DF, '49-3');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% bad triggers
%ds = dataset(DF, '49-4');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];


%-------%
% C0301 %
%-------%
DF = 'C0301'; %

ds = dataset(DF, '1-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'itdxrange', [-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled
%ds = dataset(DF, '2-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '4-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor rate
%ds = dataset(DF, '7-3');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];


%-------%
% C0302 %
%-------%
DF = 'C0302'; %

% undersampled
%ds = dataset(DF, '1-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% undersampled
%ds = dataset(DF, '2-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-2');
T = EvalBB(ds, 'AnWin',[500 5000], 'itdxrange', [-10 +10], 'CalcDF', 375, 'plot', 'yes','histnbin', 32); pause; close; close;
T.fft.df = NaN;
T.tag = [0,1];
D = [D, T];

% watch definition of peakratio
ds = dataset(DF, '3-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor phase-sensitivity
%ds = dataset(DF, '6-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% undersampled
%ds = dataset(DF, '7-1');
%T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '8-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '9-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '10-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '11-1');
T = EvalBB(ds, 'AnWin',[200 4200], 'itdxrange',[-10 10], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '12-1');
T = EvalBB(ds, 'AnWin',[10 5010], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];


%-------%
% C0305 %
%-------%
DF = 'C0305'; %

% poor response
%ds = dataset(DF, '1-4');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '2-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% undersampled
%ds = dataset(DF, '4-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '5-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '6-1'); % 60 dB
T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,4];
D = [D, T];

% nice!
ds = dataset(DF, '6-110'); % 60 dB
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3,5];
D = [D, T];

% undersampled
%ds = dataset(DF, '6-111');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% nice! 5 Hz beat
ds = dataset(DF, '6-120'); % 50 dB
T = EvalBB(ds, 'AnWin',[200 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,2,3,5];
D = [D, T];

% only 1 datapoint
%ds = dataset(DF, '6-121');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% only high-freq side
%ds = dataset(DF, '6-122');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% short duration
%ds = dataset(DF, '8-1');
%T = EvalBB(ds, 'AnWin',[500 1000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% nice!
ds = dataset(DF, '8-13');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3];
D = [D, T];

% (repeat of high freq side as in 8-13)
%ds = dataset(DF, '8-14');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0,1];
%D = [D, T];

% nice example of trougher
% peak ratio not correct peak
ds1 = dataset(DF, '9-1');
ds2 = dataset(DF, '9-2');
ds = mergeds(ds1, 500:100:2500, ds2, 2600:100:2800);
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF', 'DF' ,'plot', 'yes','histnbin', 32); pause; close; close;
T.thr.cf = 2374;
T.thr.sr = 0;
T.thr.thr = 31;
T.thr.q10 = 11.25;
T.thr.bw = 211;
T.tag = [0,1,3];
D = [D, T];

% nice example trougher
ds = dataset(DF, '10-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% poor phase-sensitivity, undersampled
%ds = dataset(DF, '18-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '19-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

% nice example of trougher
ds = dataset(DF, '20-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3];
D = [D, T];

% no phase-sensitivity
%ds = dataset(DF, '21-1');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% nice example of tweener
ds = dataset(DF, '22-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1,3];
D = [D, T];

% poor response
%ds = dataset(DF, '23-8');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

% poor response
%ds = dataset(DF, '23-9');
%T = EvalBB(ds, 'AnWin',[0 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
%T.tag = [0];
%D = [D, T];

ds = dataset(DF, '24-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '25-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '26-1');
T = EvalBB(ds, 'AnWin',[500 5000], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '27-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

ds = dataset(DF, '29-1');
T = EvalBB(ds, 'AnWin',[20 5020], 'CalcDF','DF','plot', 'yes','histnbin', 32); pause; close; close;
T.tag = [0,1];
D = [D, T];

%---------------------------------------------------------------------------------------------
DBB = D; clear D;
save popscriptbb.mat DBB
%---------------------------------------------------------------------------------------------
echo off;

