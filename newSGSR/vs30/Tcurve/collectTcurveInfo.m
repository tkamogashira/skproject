function tci = collectTcurveInfo;
% collectTcurveInfo - return results of tcurve measurement in struct
global SPIKES  TcurvePlotMenuStatus TcurveThreshold TcurveFreq SMS

tci = collectSpikeTimes(SMS,SPIKES); % the header is OK ..
tci.SpikeTimes.SubSeq = tci.SpikeTimes.SubSeq{1}; % ... but only first subseq has true spike times
[freq, ii] = sort(TcurveFreq); 
threshold = TcurveThreshold(ii);
threshold = threshold(:).';
tci.thrCurve = collectInStruct(freq, threshold);









