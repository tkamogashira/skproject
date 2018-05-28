echo on;
%---------------------------------------------------------------------------------------------
% psFSCC.m                       POPSCRIPT for TONE SAC ANALYSIS
%---------------------------------------------------------------------------------------------
% popscript to construct composite curves from SACs of AN responses to tones

% tag 1: identifies "primary" dataset of FS responses for a given fiber
% tag 4: identifies "duplicate" datasets of FS responses for a given fiber
% tag 5: fibers for which tone data exist at multiple SPLs 

D = struct([]);

%-------%
% A0241 %
%-------%
DF = 'A0241';

%--------
% 70 dB
% 3-4: lost

%--------
% 70 dB
% 5-2: lost

%--------
% 70 dB
% not in NVT
dst = dataset(DF, '6-2'); %Tone dataset
T = EvalCC(dst,'plot','no'); %%pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
%Merge datasets 10-4 and 10-5 (interleaved)
%dsn = dataset(DF, '10-2'); %Noise dataset ...
dst1 = dataset(DF, '10-4'); %Tone dataset 100 - 900 Hz...
dst2 = dataset(DF, '10-5'); %Tone dataset 150 - 950 Hz...
dst = mergeds(dst1, dst2,'iseq', 1);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
%dsn = dataset(DF, '14-2'); %Noise dataset ...
dst = dataset(DF, '14-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% 15-5 incomplete

%--------
% 70 dB
% incomplete
%dsn = dataset(DF, '16-2'); %Noise dataset ...
dst = dataset(DF, '16-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% incomplete on low freq side
%dsn = dataset(DF, '17-2'); %Noise dataset ...
dst = dataset(DF, '17-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% somewhat incomplete on low freq side
%dsn = dataset(DF, '18-2'); %Noise dataset ...
dst = dataset(DF, '18-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
%dsn = dataset(DF, '19-4'); %Noise dataset ...
dst = dataset(DF, '19-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U20: not in NVT
%dsn = dataset(DF, '20-2'); %Noise dataset ...
dst = dataset(DF, '20-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

% 70 dB
%Merge together: 20-10, 20-11, 20-12
dst1 = dataset(DF, '20-10'); %Tone dataset 100:50:450...
dst2 = dataset(DF, '20-11'); %Tone dataset 550:100:1550...
dst3 = dataset(DF, '20-12'); %Tone dataset 1650:100:3350...
dst = mergeds(dst1, 150:100:450, dst2, 550:100:1550, dst3, 1650:100:3350, 'iseq', 2);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 4]; D = [D, T];

%--------
% 70 dB
%dsn = dataset(DF, '21-2'); %Noise dataset ...
dst = dataset(DF, '21-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% 50 Hz hum?
%dsn = dataset(DF, '22-2'); %Noise dataset ...
dst = dataset(DF, '22-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U23: not in NVT
%dsn = dataset(DF, '23-2'); %Noise dataset ...
dst = dataset(DF, '23-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U24: not in NVT
%dsn = dataset(DF, '24-2'); %Noise dataset ...
dst = dataset(DF, '24-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% incomplete on low-freq side
%dsn = dataset(DF, '25-2'); %Noise dataset ...
dst = dataset(DF, '25-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U26: not in NVT, incomplete on high-freq side
%dsn = dataset(DF, '26-2'); %Noise dataset ...
%dst = dataset(DF, '26-3'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U33: not in NVT, incomplete on both sides
% CHECK MERGE: problem at 1000 - 1050 Hz
%dsn = dataset(DF, '33-2'); %Noise dataset ...
dst1 = dataset(DF, '33-3'); %Tone dataset ...
dst2 = dataset(DF, '33-4'); %Tone dataset ...
dst = mergeds(dst1, 150:50:1400, dst2, 1450:50:1800, 'iseq', 3);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
%dsn = dataset(DF, '35-2'); %Noise dataset ...
dst = dataset(DF, '35-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U37: not in NVT
%dsn = dataset(DF, '37-3'); %Noise dataset ...
%dst = dataset(DF, '37-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 4]; D = [D, T];

% 70 dB
% 37-8 is more complete than 37-4
%dsn = dataset(DF, '37-3'); %Noise dataset ...
dst = dataset(DF, '37-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% not in NVT
dst = dataset(DF, '42-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U45: not in NVT - watch for 50 Hz hum (missed spikes)
%dsn = dataset(DF, '45-2'); %Noise dataset ...
dst = dataset(DF, '45-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U47: not in NVT
%dsn = dataset(DF, '47-2'); %Noise dataset ...
dst = dataset(DF, '47-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% U48-3: not in NVT 
%dsn = dataset(DF, '48-2'); %Noise dataset ...
dst = dataset(DF, '48-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 4]; D = [D, T];

% 48-16: not in NVT, same settings as 48-3 but more reps
%dsn = dataset(DF, '48-2'); %Noise dataset ...
dst = dataset(DF, '48-16'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% weird shape
%dsn = dataset(DF, '55-5'); %Noise dataset ...
%dst = dataset(DF, '55-6'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% 56-3 lost

%--------
% 70 dB
% 62-3 lost

%--------
% 70 dB
% 64-4 lost

%--------
% 70 dB
% 65-4 lost

%--------
% 70 dB
% 66-2 lost

%--------
% 70 dB
% incomplete on both sides
%dsn = dataset(DF, '67-9'); %Noise dataset ...
dst = dataset(DF, '67-2'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% not in NVT, incomplete on both sides, CF > 3.5 kHz
%dsn = dataset(DF, '70-2'); %Noise dataset ...
%dst = dataset(DF, '70-7'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% not in NVT. incomplete on both sides
%dsn = dataset(DF, '72-2'); %Noise dataset ...
%dst = dataset(DF, '72-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% 73-7 lost

%--------
% 70 dB CF = 6400 Hz! Only tail sampled
%dst = dataset(DF, '75-10'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 70 dB
% 78-3 lost

%--------
% 70 dB
% 80-3 lost


%-------%
% A0242 %
%-------%
DF = 'A0242';

%--------
% 70 dB
% not in NVT, incomplete on low-freq side
%dsn = dataset(DF, '1-6'); %Noise dataset ...
dst = dataset(DF, '1-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 50 dB
dst1 = dataset(DF, '1-5'); %Tone dataset ...
dst2 = dataset(DF, '1-13'); %Tone dataset ... 
dst = mergeds(dst1, [200:100:1800], dst2, [1900:100:2200], 'iseq', 1);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1 5]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '2-5'); %Noise dataset ...
dst = dataset(DF, '2-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% 3-3: lost at 300 Hz

%--------
% 50 dB
%dsn = dataset(DF, '4-2'); %Noise dataset ...
dst = dataset(DF, '4-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '7-2'); %Noise dataset ...
dst = dataset(DF, '7-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '8-2'); %Noise dataset ...
dst = dataset(DF, '8-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '9-2'); %Noise dataset ...
dst = dataset(DF, '9-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '10-2'); %Noise dataset ...
dst = dataset(DF, '10-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '11-2'); %Noise dataset ...
dst = dataset(DF, '11-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% check? weird difcor
%dsn = dataset(DF, '12-2'); %Noise dataset ...
dst = dataset(DF, '12-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '13-2'); %Noise dataset ...
dst = dataset(DF, '13-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '14-2'); %Noise dataset ...
dst = dataset(DF, '14-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '15-2'); %Noise dataset ...
dst = dataset(DF, '15-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '16-2'); %Noise dataset ...
dst = dataset(DF, '16-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '17-2'); %Noise dataset ...
dst = dataset(DF, '17-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '18-2'); %Noise dataset ...
dst = dataset(DF, '18-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '19-2'); %Noise dataset ...
dst = dataset(DF, '19-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '20-2'); %Noise dataset ...
dst = dataset(DF, '20-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '22-2'); %Noise dataset ...
dst = dataset(DF, '22-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '25-2'); %Noise dataset ...
dst = dataset(DF, '25-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '26-2'); %Noise dataset ...
dst = dataset(DF, '26-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% merge: spike temporarily smaller at 550 and 600 Hz: replace with 38-5 
%dsn = dataset(DF, '28-2'); %Noise dataset ...
dst1 = dataset(DF, '28-4'); %Tone dataset ...
dst2 = dataset(DF, '28-5'); %Tone dataset ... 
dst = mergeds(dst1, [50:50:500, 650:50:1500], dst2, [550, 600], 'iseq', 2);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];
%dst = dataset(DF, '28-5'); %Tone dataset ...

%--------
% 50 dB
% 30-3 = short tones, then lost

%--------
% 50 dB
%dsn = dataset(DF, '31-3'); %Noise dataset ...
dst = dataset(DF, '31-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '32-2'); %Noise dataset ...
dst = dataset(DF, '32-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '33-2'); %Noise dataset ...
dst = dataset(DF, '33-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '34-2'); %Noise dataset ...
dst = dataset(DF, '34-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '36-2'); %Noise dataset ...
dst = dataset(DF, '36-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '37-2'); %Noise dataset ...
dst = dataset(DF, '37-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% incomplete, barely driven
%dsn = dataset(DF, '38-2'); %Noise dataset ...
%dst = dataset(DF, '38-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% 43-3: lost

%--------
% 50 dB
%dsn = dataset(DF, '44-2'); %Noise dataset ...
dst = dataset(DF, '44-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '45-2'); %Noise dataset ...
dst = dataset(DF, '45-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '47-2'); %Noise dataset ...
dst = dataset(DF, '47-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '48-3'); %Noise dataset ...
dst = dataset(DF, '48-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% merge: 49-3 temporarily lost: combine with 49-6
%dsn = dataset(DF, '49-2'); %Noise dataset ...
dst1 = dataset(DF, '49-3'); %Tone dataset ...
dst2 = dataset(DF, '49-6'); %Tone dataset ...
dst = mergeds(dst1, [350:50:1500], dst2, [1550:50:2000], 'iseq', 3)
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '51-12'); %Noise dataset ...
dst = dataset(DF, '51-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '52-2'); %Noise dataset ...
dst = dataset(DF, '52-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '53-2'); %Noise dataset ...
dst = dataset(DF, '53-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% 54-4: lost it

%--------
% 50 dB
% poorly sampled
%dsn = dataset(DF, '60-2'); %Noise dataset ...
dst = dataset(DF, '60-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '61-2'); %Noise dataset ...
dst = dataset(DF, '61-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '63-2'); %Noise dataset ...
dst = dataset(DF, '63-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% 64-3: lost

%--------
% 50 dB
% 67-3: lost

%--------
% 50 dB
% incomplete on high-freq side
%dsn = dataset(DF, '70-2'); %Noise dataset ...
%dst = dataset(DF, '70-3'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% 74-5: lost

%--------
% 50 dB
% 82-7: lost

%--------
% 50 dB 
%dsn = dataset(DF, '85-2'); %Noise dataset ...
dst = dataset(DF, '85-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 60 dB
dst = dataset(DF, '85-11'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '86-2'); %Noise dataset ...
dst = dataset(DF, '86-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
%dsn = dataset(DF, '88-2'); %Noise dataset ...
dst = dataset(DF, '88-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT
%dsn = dataset(DF, '89-3'); %Noise dataset ...
dst = dataset(DF, '89-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT, undersampled
%dsn = dataset(DF, '90-2'); %Noise dataset ...
dst = dataset(DF, '90-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT, rate too low (< SR)
%dsn = dataset(DF, '92-4'); %Noise dataset ...
%dst = dataset(DF, '92-6'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
% not in NVT, rate too low (< SR)
%dsn = dataset(DF, '94-2'); %Noise dataset ...
%dst = dataset(DF, '94-3'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];


%-------%
% A0428 %
%-------%
DF = 'A0428';

%--------
% 50 dB
% Incomplete: lost at 550 Hz
%dst = dataset(DF, '1-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%D = [D, T];

%--------
% 50 dB (2-3 is continuation but fiber lost)
dst = dataset(DF, '2-2'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB combine 3-3 and 3-4
dst1 = dataset(DF, '3-3'); %Tone dataset 1000:100:3000...
dst2 = dataset(DF, '3-4'); %Tone dataset 3000:100:4000...
dst = mergeds(dst1, 1000:100:3000, dst2, 3100:100:4000, 'iseq', 1);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

%--------
% 40 dB combine 35-6 35-8 35-9 35-11
dst1 = dataset(DF, '35-8'); %Tone dataset 100:25:300...
dst2 = dataset(DF, '35-6'); %Tone dataset 300:25:1000...
dst3 = dataset(DF, '35-9'); %Tone dataset 1000:25:1300...
dst4 = dataset(DF, '35-11'); %Tone dataset 1300:25:1500...
dst = mergeds(dst1, 100:25:300, dst2, 325:25:1000, dst3, 1025:25:1300, dst4, 1325:25:1500, 'iseq', 2);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 5]; D = [D, T];

% 30 dB combine 35-7 35-10 35-12
dst1 = dataset(DF, '35-10'); %Tone dataset 200:25:400...
dst2 = dataset(DF, '35-7'); %Tone dataset 400:25:900...
dst3 = dataset(DF, '35-12'); %Tone dataset 900:25:1200...
dst = mergeds(dst1, 200:25:400, dst2, 425:25:900, dst3, 925:25:1200, 'iseq', 3);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 5]; D = [D, T];


%--------
% 40 dB Lost it halfway
%dst = dataset(DF, '40-10'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB combine 42-3 42-4
dst1 = dataset(DF, '42-3'); %Tone dataset 50:50:1500...
dst2 = dataset(DF, '42-4'); %Tone dataset 1500:50:1800...
dst = mergeds(dst1, 50:50:1500, dst2, 1550:50:1800, 'iseq', 4);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1 5]; D = [D, T];

% 30 dB 
dst = dataset(DF, '42-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB 
dst = dataset(DF, '42-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 10 dB Lost it 
%dst = dataset(DF, '42-10'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% Nice example
% 50 dB combine 43-2 43-4
dst1 = dataset(DF, '43-2'); %Tone dataset 50:50:1500...
dst2 = dataset(DF, '43-4'); %Tone dataset 1350:50:1600...
dst = mergeds(dst1, 50:50:1350, dst2, 1400:50:1600, 'iseq', 5);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

% 70 dB lost halfway
%dst = dataset(DF, '43-6'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB Too coarse (50 Hz steps), redone as 44-3
%dst = dataset(DF, '44-2'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

% 50 dB Now 25 Hz steps
dst = dataset(DF, '44-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

% 70 dB lost halfway
%dst = dataset(DF, '44-6'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '46-2'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '48-2'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '48-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB Lost 
%dst = dataset(DF, '48-7'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB Lost
%dst = dataset(DF, '49-5'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB Lost
%dst = dataset(DF, '50-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '51-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '51-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '51-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 10 dB No response
%dst = dataset(DF, '51-8'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

% 20 dB
dst = dataset(DF, '51-9'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '53-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '53-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 30 dB Lost, no response
%dst = dataset(DF, '53-5'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB (Lost near end)
dst = dataset(DF, '55-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '57-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '57-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 40 dB 
dst = dataset(DF, '57-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 30 dB (no response)
%dst = dataset(DF, '57-8'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 5]; D = [D, T];

% 60 dB
dst = dataset(DF, '57-9'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 80 dB 
%dst = dataset(DF, '57-10'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '59-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '60-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '60-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '62-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '62-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 10 dB lost, no response
%dst = dataset(DF, '62-8'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB (Lost towards end)
dst = dataset(DF, '64-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB combine 66-5 and 66-7
dst1 = dataset(DF, '66-5'); %Tone dataset 100:100:1400...
dst2 = dataset(DF, '66-7'); %Tone dataset 1400:100:1700...
dst = mergeds(dst1, 100:100:1400, dst2, 1500:100:1700, 'iseq', 6);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1 5]; D = [D, T];

% 40 dB combine 66-6 and 66-8
dst1 = dataset(DF, '66-6'); %Tone dataset 100:50:1200...
dst2 = dataset(DF, '66-8'); %Tone dataset 1250:50:1450...
dst = mergeds(dst1, 100:50:1200, dst2, 1250:50:1450, 'iseq', 7);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '66-9'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '66-10'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '68-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '68-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 40 dB (combine 68-7 and 68-8, but lost during 68-8)
%dst = dataset(DF, '68-7'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB Lost it
%dst = dataset(DF, '70-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];

%--------
% 50 dB combine 71-5 and 71-6
dst1 = dataset(DF, '71-6'); %Tone dataset 100:100:300...
dst2 = dataset(DF, '71-5'); %Tone dataset 300:100:2100...
dst = mergeds(dst1, 100:100:300, dst2, 400:100:2100, 'iseq', 8);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB 
dst = dataset(DF, '73-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB 
dst = dataset(DF, '74-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 70 dB 
dst = dataset(DF, '74-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 70 dB combine 75-4 and 75-6
dst1 = dataset(DF, '75-6'); %Tone dataset 25:25:75...
dst2 = dataset(DF, '75-4'); %Tone dataset 50:25:1025...
dst = mergeds(dst1, 25:25:75, dst2, 100:25:1025, 'iseq', 9);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1]; D = [D, T];

% 50 dB (no response)
%dst = dataset(DF, '75-5'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
%T.tag = [0 1]; D = [D, T];


%-------%
% A0454 %
%-------%

DF = 'A0454';

%--------
% 60 dB
dst = dataset(DF, '11-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 40 dB
dst = dataset(DF, '11-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 20 dB
dst = dataset(DF, '11-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 30 dB: lost cell
%dst = dataset(DF, '11-6'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;

%--------
% 50 dB
dst = dataset(DF, '13-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 40 dB
dst = dataset(DF, '13-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 60 dB
dst = dataset(DF, '13-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '13-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 35 dB
dst = dataset(DF, '13-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 80 dB
dst = dataset(DF, '13-14'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 30 dB (low level!)
dst = dataset(DF, '28-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 60 dB
dst = dataset(DF, '32-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 4]; D = [D, T];

% Nice example
% also at 60 dB: combine 32-5 and 32-6
dst1 = dataset(DF, '32-5'); %Tone dataset 100:25:350...
dst2 = dataset(DF, '32-6'); %Tone dataset 350:25:450...
dst = mergeds(dst1, 100:25:350, dst2, 375:25:450, 'iseq', 1);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1 5]; D = [D, T];

% 50 dB
dst = dataset(DF, '32-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 45 dB
dst = dataset(DF, '32-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '32-9'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 4]; D = [D, T];

% also at 70 dB but finer steps (25 Hz)
dst = dataset(DF, '32-10'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 80 dB
dst = dataset(DF, '32-13'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 75 dB
dst = dataset(DF, '32-14'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% CHECK DIP IN CH ABOVE 300 Hz
% 60 dB: combine 40-10 and 40-11
dst1 = dataset(DF, '40-10'); %Tone dataset 25:25:800...
dst2 = dataset(DF, '40-11'); %Tone dataset 800:25:1200...
dst = mergeds(dst1, 25:25:800, dst2, 825:25:1200, 'iseq', 2);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 1 5]; D = [D, T];

% CHECK DIP IN CH ABOVE 300 Hz
% 40 dB: combine 40-12 and 40-13 and 40-14
dst1 = dataset(DF, '40-12'); %Tone dataset 100:25:400...
dst2 = dataset(DF, '40-13'); %Tone dataset 400:25:700...
dst3 = dataset(DF, '40-14'); %Tone dataset 700:25:800...
dst = mergeds(dst1, 100:25:400, dst2, 425:25:700, dst3, 725:25:800, 'iseq', 3);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 5]; D = [D, T];

%--------
% CHECK DIP IN CH ABOVE 300 Hz
% 20 dB: combine 40-9 and 40-10
dst1 = dataset(DF, '41-9'); %Tone dataset ...
dst2 = dataset(DF, '41-10'); %Tone dataset ...
dst = mergeds(dst1, 100:25:700, dst2, 725:25:900, 'iseq', 4);
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T = EvalCC(dst,'plot','no'); %pause; %print; close;
UD = getuserdata(dst1); dsTHR = dataset(DF, UD.CellInfo.THRSeq);
[T.thr.cf, T.thr.sr, T.thr.thr, T.thr.q10, T.thr.bw] = evalTHR(dsTHR, 'plot', 'no');
T.tag = [0 5]; D = [D, T];

% 40 dB - incomplete
%dst = dataset(DF, '41-11'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;

%--------
% 40 dB
dst = dataset(DF, '45-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '45-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 25 dB
dst = dataset(DF, '45-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 50 dB
dst = dataset(DF, '45-9'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 60 dB
dst = dataset(DF, '45-10'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 30 dB
dst = dataset(DF, '46-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '48-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '48-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '48-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 25 dB
dst = dataset(DF, '48-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '49-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '49-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '49-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '49-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB - recording unclean
%dst = dataset(DF, '54-3'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;

%--------
% 50 dB
dst = dataset(DF, '55-2'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '55-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '57-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '57-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 60 dB
dst = dataset(DF, '57-10'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 70 dB
dst = dataset(DF, '57-13'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%--------
% 50 dB
dst = dataset(DF, '58-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

%--------
% 50 dB - lost it halfway
%dst = dataset(DF, '61-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
    
%--------
% 50 dB - lost near end
dst = dataset(DF, '62-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];
    
%--------
% 50 dB - lost soon
%dst = dataset(DF, '64-3'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
    
%--------
% 50 dB
dst = dataset(DF, '66-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];
   
%--------
% 50 dB
dst = dataset(DF, '67-3'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];

% 30 dB - lost
%dst = dataset(DF, '67-4'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;
    
%--------
% 50 dB
dst = dataset(DF, '68-5'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '68-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 15 dB
dst = dataset(DF, '68-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];
    
%--------
% 50 dB
dst = dataset(DF, '71-4'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '71-6'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];
    
%--------
% 50 dB - lost at 580 Hz
dst = dataset(DF, '72-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];
    
%--------
% 50 dB
dst = dataset(DF, '74-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1]; D = [D, T];
    
%--------
% 50 dB
dst = dataset(DF, '75-7'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 1 5]; D = [D, T];

% 30 dB
dst = dataset(DF, '75-8'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

% 20 dB - subtreshold
%dst = dataset(DF, '75-9'); %Tone dataset ...
%T = EvalCC(dst,'plot','no'); %pause; %print; close;

% 40 dB
dst = dataset(DF, '75-12'); %Tone dataset ...
T = EvalCC(dst,'plot','no'); %pause; %print; close;
T.tag = [0 5]; D = [D, T];

%---------------------------------------------------------------------------------------------
DFSCC = D; clear D;
save psFSCC.mat DFSCC
%---------------------------------------------------------------------------------------------
echo off;