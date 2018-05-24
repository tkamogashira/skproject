echo on;
%---------------------------------------------------------------------------------------------
%                           POPSCRIPT for AN NOISE DIFCOR ANALYSIS, different SPLs
%---------------------------------------------------------------------------------------------

% This script contains ALL datasets in A0241 A0242 A0428 with responses to noise,
% for which difcor data can be computed.
% Main purpose is to plot difcor halfheight as a function of SPL

% tag 1: identifies "primary" dataset for a given fiber
% tag 4: identifies "duplicate" datasets for a given fiber

% NSPL.thr.man =  "manually" determined threshold from NSPL curve
% this is actually not used in analyses m files, where thr is obtained from user data 
D = struct([]);
    
if 1


%-------%
% A0241 %
%-------%

DF = 'A0241';

ds1 = dataset(DF, '8-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '9-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '10-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '10-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '10-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '14-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '15-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '16-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '17-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;


ds1 = dataset(DF, '18-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '19-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '19-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '19-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '19-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;


ds1 = dataset(DF, '20-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-13');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '21-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '22-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '23-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '23-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '23-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '24-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '25-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '25-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '25-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '26-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '27-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '29-3');% NSPL A+
%ds2 = dataset(DF, '29-4');% NSPL A-
%T = EvalSACXAC(ds1, [60 70 80], ds2, [60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;
%ds1 = dataset(DF, '29-5');% NSPL A+
%ds2 = dataset(DF, '29-4');% NSPL A-
%T = EvalSACXAC(ds1, [40 50], ds2, [40 50],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;
 
% high CF
%ds1 = dataset(DF, '31-2');% NSPL A+
%ds2 = dataset(DF, '31-3');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(NaN); D = [D, T];%pause; close;

%ds1 = dataset(DF, '33-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
%ds1 = dataset(DF, '33-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
%ds1 = dataset(DF, '33-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
%ds1 = dataset(DF, '33-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
% fluid in ear during collection of last datasets: poor responses in 33-7 and 33-8

ds1 = dataset(DF, '35-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '35-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '35-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '35-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '37-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  65; D = [D, T];%pause; close;
ds1 = dataset(DF, '37-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  65; D = [D, T];%pause; close;

% 42-2: only A+
ds1 = dataset(DF, '42-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '42-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '42-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '45-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '47-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '48-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data available

% high CF
%ds1 = dataset(DF, '49-3');% NSPL A+
%ds2 = dataset(DF, '49-4');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(NaN); D = [D, T];%pause; close;
% zwuis data available

% high CF
%ds1 = dataset(DF, '50-3');% NSPL A+
%ds2 = dataset(DF, '50-4');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(NaN); D = [D, T];%pause; close;
%ds1 = dataset(DF, '50-5');% NSPL A+
%ds2 = dataset(DF, '50-6');% NSPL A-
%T = EvalSACXAC(ds1, [20 30 40], ds2, [20 30 40],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man] = deal(NaN); D = [D, T];%pause; close;
% zwuis data available

% high CF
%ds1 = dataset(DF, '51-3');% NSPL A+
%ds2 = dataset(DF, '51-4');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;
%ds1 = dataset(DF, '51-5');% NSPL A+
%ds2 = dataset(DF, '51-6');% NSPL A-
%T = EvalSACXAC(ds1, [30 40], ds2, [30 40],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '52-2');% NSPL A+
%ds2 = dataset(DF, '52-3');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;

ds1 = dataset(DF, '55-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '55-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '55-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data available

ds1 = dataset(DF, '56-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '62-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '64-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '64-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '65-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '65-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '67-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '67-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '67-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data available

ds1 = dataset(DF, '69-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% no fine-structure at highest SPL (70 dB)
%ds1 = dataset(DF, '70-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;
ds1 = dataset(DF, '70-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;
ds1 = dataset(DF, '70-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;
ds1 = dataset(DF, '70-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;
% zwuis data available

% mid-CF: not fine-structure
%ds1 = dataset(DF, '71-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
%ds1 = dataset(DF, '71-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80 
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;

% unit 72: 72-1 to 72-4 are one unit; 72-5 to 72-10 are different unit! 
% => printout will have wrong THR values, but table is OK
ds1 = dataset(DF, '72-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no', 'Effsplcf', 2732); % dB SPL = 70
T.thr.cf = 2732;
T.thr.sr = 41.89;
T.thr.thr = 18;
T.thr.q10 = 3.96;
T.thr.bw = 691;
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '72-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.thr.cf = 2732;
T.thr.sr = 41.89;
T.thr.thr = 18;
T.thr.q10 = 3.96;
T.thr.bw = 691;
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;

% no fine-structure
%ds1 = dataset(DF, '72-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
%ds1 = dataset(DF, '72-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80 only +1 finished
%T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;

% no fine-structure
%ds1 = dataset(DF, '73-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '73-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '73-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '73-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

%fiber 74: pipper

% no fine-structure
%ds1 = dataset(DF, '75-3');% NSPL A+
%ds2 = dataset(DF, '75-4');% NSPL A-
%T = EvalSACXAC(ds1, [30 40 50 60 70], ds2, [30 40 50 60 70],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%T(5).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man, T(5).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;
% zwuis data available

% no fine-structure
%ds1 = dataset(DF, '76-3');% NSPL A+
%ds2 = dataset(DF, '76-4');% NSPL A-
%T = EvalSACXAC(ds1, [30 50 70], ds2, [30 50 70],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;
%ds1 = dataset(DF, '76-5');% NSPL A+
%ds2 = dataset(DF, '76-6');% NSPL A-
%T = EvalSACXAC(ds1, [20 40 60 80], ds2, [20 40 60 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '77-3');% NSPL A+
%ds2 = dataset(DF, '77-4');% NSPL A-
%T = EvalSACXAC(ds1, [40 50 60 70 80], ds2, [40 50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%T(5).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man, T(5).NSPL.thr.man] = deal(40); D = [D, T];%pause; close;

ds1 = dataset(DF, '78-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '80-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% no fine-structure
%ds1 = dataset(DF, '81-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '81-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '82-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '82-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '82-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '83-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '83-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '90-3');% NSPL A+
%ds2 = dataset(DF, '90-4');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;

% high CF!
%ds1 = dataset(DF, '93-3');% NSPL A+
%ds2 = dataset(DF, '93-4');% NSPL A-
%T = EvalSACXAC(ds1, [60 70 80], ds2, [60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;
%ds1 = dataset(DF, '93-3');% NSPL A+
%ds2 = dataset(DF, '93-5');% NSPL A-
%T = EvalSACXAC(ds1, [50], ds2, [50],'plot', 'no');
%T(1).tag = [0 1];
%[T(1).NSPL.thr.man] = deal(35); D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '94-3');% NSPL A+
%ds2 = dataset(DF, '94-4');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;
%ds1 = dataset(DF, '94-5');% NSPL A+
%ds2 = dataset(DF, '94-6');% NSPL A-
%T = EvalSACXAC(ds1, [30 40], ds2, [30 40],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;


%-------%
% A0242 %
%-------%
DF = 'A0242';

ds1 = dataset(DF, '1-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '1-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '1-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '2-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '2-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '2-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '2-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '4-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;

ds1 = dataset(DF, '7-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '8-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '8-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '8-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '8-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
% zwuis available

ds1 = dataset(DF, '9-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '9-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '9-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '10-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '10-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '10-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
% zwuis available

ds1 = dataset(DF, '11-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '11-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '11-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '12-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '12-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '12-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '12-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '12-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;

ds1 = dataset(DF, '13-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '14-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '14-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '14-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '15-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '16-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '17-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-15');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '18-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '19-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '19-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '20-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '21-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '22-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '22-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '23-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '24-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '25-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '25-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '25-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
% zwuis

ds1 = dataset(DF, '26-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '26-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '26-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '28-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '28-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '28-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;

ds1 = dataset(DF, '29-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '30-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '31-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '31-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '31-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '32-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '32-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '33-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '33-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '33-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '34-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '35-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '36-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '37-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '37-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '37-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '37-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '38-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '40-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% cell lost
% ds1 = dataset(DF, '42-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70

ds1 = dataset(DF, '43-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '44-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '44-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '44-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '45-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '47-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%spike poor
%ds1 = dataset(DF, '47-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '47-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
%0T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '48-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '49-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '49-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '49-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '51-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-13');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-14');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-15');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  40; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '52-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
ds1 = dataset(DF, '52-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
ds1 = dataset(DF, '52-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '53-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '54-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '55-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% featureless
%ds1 = dataset(DF, '56-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  70; D = [D, T];%pause; close;

ds1 = dataset(DF, '59-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '60-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '61-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;

ds1 = dataset(DF, '62-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '63-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '63-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '63-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '63-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '64-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '67-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '70-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '71-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '71-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% below thr?
%ds1 = dataset(DF, '71-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '71-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '72-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '72-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '72-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '72-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '73-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '74-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% no fine-structure
%ds1 = dataset(DF, '75-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '76-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '76-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '77-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;
%ds1 = dataset(DF, '77-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;

ds1 = dataset(DF, '78-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
 
% high CF
%ds1 = dataset(DF, '79-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;
%ds1 = dataset(DF, '79-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
%T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '80-4');% NSPL A+
%ds2 = dataset(DF, '80-5');% NSPL A-
%T = EvalSACXAC(ds1, [50 60 70 80], ds2, [50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;
%ds1 = dataset(DF, '80-6');% NSPL A+
%ds2 = dataset(DF, '80-7');% NSPL A-
%T = EvalSACXAC(ds1, [30], ds2, [30],'plot', 'no');
%T(1).tag = [0 1];
%[T(1).NSPL.thr.man] = deal(25); D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '81-3');% NSPL A+
%ds2 = dataset(DF, '81-4');% NSPL A-
%T = EvalSACXAC(ds1, [40 50 60 70 80], ds2, [40 50 60 70 80],'plot', 'no');
%T(1).tag = [0 1];
%T(2).tag = [0 1];
%T(3).tag = [0 1];
%T(4).tag = [0 1];
%T(5).tag = [0 1];
%[T(1).NSPL.thr.man, T(2).NSPL.thr.man, T(3).NSPL.thr.man, T(4).NSPL.thr.man, T(5).NSPL.thr.man] = deal(NaN); D = [D, T];%pause; close;

ds1 = dataset(DF, '82-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '82-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '84-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  25; D = [D, T];%pause; close;

ds1 = dataset(DF, '85-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '85-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60 low outpur rate
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '85-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% zwuis data

ds1 = dataset(DF, '86-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '86-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '86-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '87-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '88-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '88-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% 88-5 (80 dB): no response

% DF dominated by tail at 70 and 80 dB!
ds1 = dataset(DF, '89-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '89-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '89-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '90-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% ds1 = dataset(DF, '90-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 60 no response
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '90-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '91-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '92-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

%different cell (93)! relevant TH = dataset 377 (92-7-THR)
ds1 = dataset(DF, '92-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
dsTHR = dataset(DF, 377); [T.thr.cf, T.thr.sr, T.thr.thr, T.thr.bw, T.thr.q10] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '93-1');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '93-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '94-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; T.diff.fft.df = NaN;
D = [D, T];%pause; close;


%-------%
% A0428 %
%-------%

DF = 'A0428';

ds1 = dataset(DF, '1-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '3-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '5-36');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '6-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '6-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '7-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '7-13');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '7-14');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '9-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '10-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '11-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '11-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '11-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '12-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '12-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '12-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '13-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '17-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '17-13');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '18-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '18-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '19-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '19-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '20-36');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-37');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '20-38');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '21-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '21-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '22-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '22-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '22-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '23-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '23-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF (8800 Hz)
%ds1 = dataset(DF, '32-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% narrowband
%ds1 = dataset(DF, '32-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF (7890 Hz)
%ds1 = dataset(DF, '34-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '34-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '34-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% narrowband
%ds1 = dataset(DF, '34-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '34-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '35-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '36-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '36-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '36-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '36-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '40-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '42-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '42-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '42-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%no response
%ds1 = dataset(DF, '42-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
    
ds1 = dataset(DF, '43-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '43-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '44-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '44-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '45-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '46-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '46-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '46-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '48-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '49-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '49-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '49-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '50-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '50-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '51-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% no response
%ds1 = dataset(DF, '51-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '51-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '52-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '52-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '52-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '53-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% Lost it: only +1 available
%ds1 = dataset(DF, '53-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '54-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% Lost it: only +1 available
%ds1 = dataset(DF, '54-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '55-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '55-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '56-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '57-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '57-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '57-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '57-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '57-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '59-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '59-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '59-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '60-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '60-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '60-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '61-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '61-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '62-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '62-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '62-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% CHECK: XAC NOT USEABLE
ds1 = dataset(DF, '62-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '64-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '64-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '65-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '66-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '66-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '66-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '68-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '68-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '68-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '70-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '70-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '71-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '71-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '71-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '73-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '73-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '74-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '74-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '74-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '75-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '75-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;


%-------%
% A0454 %
%-------%

DF = 'A0454';

ds1 = dataset(DF, '2-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '3-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '5-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '5-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '6-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '6-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '6-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '6-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '7-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '8-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '9-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% incomplete but plots looks good? BRAM?
ds1 = dataset(DF, '9-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '10-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% gradually lost but plots looks good? BRAM?
ds1 = dataset(DF, '10-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '11-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '13-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;
ds1 = dataset(DF, '13-13');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 55
T.tag = [0 1];T.NSPL.thr.man =  55; D = [D, T];%pause; close;

ds1 = dataset(DF, '14-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '16-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  30; D = [D, T];%pause; close;

ds1 = dataset(DF, '17-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '18-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '18-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '18-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '18-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% no response
%ds1 = dataset(DF, '19-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF, different noise bandwidth
%ds1 = dataset(DF, '20-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 78
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% presumably high CF
%ds1 = dataset(DF, '21-1');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
%ds1 = dataset(DF, '21-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 95
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% high CF
%ds1 = dataset(DF, '22-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 78
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '25-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% cell lost halfway
%ds1 = dataset(DF, '26-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '28-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '29-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '30-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% gradually lost but plots looks good? BRAM?
ds1 = dataset(DF, '31-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '32-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '32-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '32-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '32-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 65
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '33-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% spikes missed?
%ds1 = dataset(DF, '34-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '34-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% very low CF: make maxlag longer!
ds1 = dataset(DF, '35-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '35-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '35-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '35-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '36-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '36-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 80
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '36-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '37-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '38-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '39-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '40-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '40-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '40-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '40-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;

ds1 = dataset(DF, '41-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 60
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '41-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '41-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '41-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '41-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '41-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

% very low CF: make maxlag longer!
ds1 = dataset(DF, '42-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% cell lost
%ds1 = dataset(DF, '43-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '44-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '44-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '44-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '45-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '45-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '46-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;

ds1 = dataset(DF, '47-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
% 47-9 and 10: Nrho"Rhoarc" stimuli: full correlation functions
ds1 = dataset(DF, '47-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 4];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
ds1 = dataset(DF, '47-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 4];T.NSPL.thr.man =  35; D = [D, T];%pause; close;
% 47-11 and 47-12 are correlation functions

ds1 = dataset(DF, '48-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-10');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-11');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '48-12');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 45
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '49-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '51-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% cell lost towards end
ds1 = dataset(DF, '52-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '53-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
% full correlation function
ds1 = dataset(DF, '53-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 4];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '57-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '58-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;
ds1 = dataset(DF, '58-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;
% 58-4: better spike than 58-2
ds1 = dataset(DF, '58-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;
% 58-5: full correlation function
ds1 = dataset(DF, '58-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;

% very low CF: make maxlag longer!
ds1 = dataset(DF, '59-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '59-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% cell lost
%ds1 = dataset(DF, '60-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '61-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '62-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '64-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '66-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '67-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '68-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '68-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '68-8');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '68-9');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% very low CF: make maxlag longer!
ds1 = dataset(DF, '69-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '70-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  32; D = [D, T];%pause; close;

ds1 = dataset(DF, '71-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;
ds1 = dataset(DF, '71-7');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

ds1 = dataset(DF, '72-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;
ds1 = dataset(DF, '72-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;
% near threshold
ds1 = dataset(DF, '72-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 40
T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;
% below threshold
%ds1 = dataset(DF, '72-6');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 30
%T.tag = [0 1];T.NSPL.thr.man =  50; D = [D, T];%pause; close;

% double triggers
%ds1 = dataset(DF, '73-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no'); % dB SPL = 70
%T.tag = [0 1];T.NSPL.thr.man =  NaN; D = [D, T];%pause; close;

% very low CF: make maxlag longer!
ds1 = dataset(DF, '74-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  47; D = [D, T];%pause; close;
ds1 = dataset(DF, '74-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  47; D = [D, T];%pause; close;
% XAC not in antiphase?
ds1 = dataset(DF, '74-5');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  47; D = [D, T];%pause; close;

% very low CF: make maxlag longer!
ds1 = dataset(DF, '75-2');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 4];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '75-3');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 4];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '75-4');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 50
T.tag = [0 4];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
% next datasets with bandwidth 50-30 kHz 
ds1 = dataset(DF, '75-13');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 70
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '75-14');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 90
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
ds1 = dataset(DF, '75-15');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 50
T.tag = [0 1];T.NSPL.thr.man =  45; D = [D, T];%pause; close;
% threshold
%ds1 = dataset(DF, '75-16');T = EvalSACXAC(ds1, [+1 -1], 'plot', 'no','cormaxlag',10,'corxrange',[-10 10]); % dB SPL = 40
%T.tag = [0 1];D = [D, T];%pause; close;

%---------------------------------------------------------------------------------------------
DSACXAC = D; clear D;
save psSACXAC.mat DSACXAC
%---------------------------------------------------------------------------------------------
echo off;

end