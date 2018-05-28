function [h, rf, xName, vchan] = RAPheader(datasetName, dataFileName, Nrep, Dur, Interval, ActChan, xName, xVal, yName, yVal, Awin, MinIS, trialWin)

if nargin==2, % IDF sequence - delegate to IDF2rapheader
   [h, rf, xName, vchan] = IDF2rapheader(datasetName, dataFileName);
   return;
end

if nargin<11, Awin = [0 Interval]; end;
if nargin<12, MinIS = 0; end;
if nargin<13, trialWin  = [1 Nrep]; end;


% Spike Time values for data set : 12-1-SERBB     Data File : R99039                                                      
% Stimulus :    1 X  3000.0/  3500.0 msecs      DSS-1:Y   DSS-2:Y                                                         
% freq    :   400.0/  2000.0/   177.8            
% Analysis window : 0.-3500. millisecs       Min IS: 0.300 ms Trials : 1-1 
% Spike Chan :   0 
 
 
LF = char(10);

strNrep = [num2str(Nrep) ' X   '];
strStimulus = [' Stimulus :  ' strNrep num2str(Dur) '/' num2str(Interval) ' msecs  '];
strActChan = ['DSS-1:' ActChan(1) '  ' 'DSS-2:' ActChan(2) '  ' ];

strx =  [' ' xName '     :  ' num2str(xVal(1)) '/'  num2str(xVal(2)) '/'  num2str(xVal(3))];
stry =  [' ' yName '     :  ' num2str(yVal(1)) '/'  num2str(yVal(2)) '/'  num2str(yVal(3))];
strAwin = [' Analysis window : ' num2str(Awin)];
strMinIS = ['Min IS: ' num2str(MinIS) ' ms   '];
strTrial = ['Trials : ' num2str(trialWin(1)) '-' num2str(trialWin(2))];

Spikestr = ' Spike Chan :   0 ';


h = [...
      ' Spike Time values for data set : ' datasetName     '  Data File : ' dataFileName LF, ...
      strStimulus, strActChan, LF, ...
      strx, '     ', stry,  LF, ...
      strAwin,  '     ',  strMinIS, strTrial, LF, ...
      Spikestr, LF, ...
   ];