function DataOut=PlayAndRecord(hRP2,DataIn,DAChanNo,ADChanNo,NPtsOut,Fs)
%PlayAndRecord -- Play the signal and record the output of the system using RP2
% Assume that the RCO file (PlayAndRecord.rco) has been loaded and run as following:
%  hRP2=actxcontrol('RPco.x',[5 5 26 26]);% starts the RP activeX control in MATLAB
%  invoke(hRP2,'ConnectRP2','USB',1); %connects an RP2 to a USB or Xbus
%  invoke(hRP2,'ClearCOF'); %Clears the Buffers and COF files on that RP
%  invoke(hRP2,'LoadCOF','C:\MATLABR11\work\PlayAndRecord.rco'); % Loads circuit('c:\example')
%  invoke(hRP2,'Run'); %Starts Circuit
%
% <Input>
% hRP2 : Handle for the ActiveX object
% DataIn : Vector for signal to play
% DAChanNo : Channel number of DAC (Default 1)
% ADChanNo : Channel number of ADC (Default 1)
% NPtsOut : Number of points of the output to record (Default: =length(DataIn))
% Fs : Sampling Rate (Dafault : 48828.1 Hz (=ActualSampleRate(50000)));
% <Output>
% DataOut : Vector of recorded signal
% 
% Usage: DataOut=PlayAndRecord(hRP2,DataIn,NPtsOut,Fs)
% By SF, 7/23/01

%Chennel numbers of DAC and ADC
if nargin <3
   DAChanNo=1;
end
if nargin <4
   ADChanNo=1;
end

%Determine the number of points for the input and ouput
NPtsIn=length(DataIn);
if nargin<5 %By default, the output has the same length as the input
   NPtsOut=NPtsIn;
end

%Determine the sampling rate
if nargin<6
   Fs=ActualSampleRate(50000);
end


%Dead period of ADC
NPtsADCDead=65; 

%Durations of the input and output
MilliSecIn=NPtsIn/Fs*1000; %Input
MilliSecOut=NPtsOut/Fs*1000; %Output

%Check the status of RP2
Status=(invoke(hRP2,'GetStatus'));% returns a value (7=circuit loaded and running) 
if invoke(hRP2,'GetStatus')~=7
   error('Error when initializing RP2');
end

%Feed the signal and parameters
e=invoke(hRP2, 'WriteTagV', 'DataIn', 0, DataIn);
if ~e, error('Error in sending signal');, end
e=invoke(hRP2, 'SetTagVal', 'MilliSecIn', MilliSecIn);
if ~e, error('Error in specifying ms for input');, end
e=invoke(hRP2, 'SetTagVal', 'MilliSecOut', MilliSecOut);
if ~e, error('Error in specifying ms for output');, end
e=invoke(hRP2, 'SetTagVal', 'DAChanNo', DAChanNo);
if ~e, error('Error in specifying DAC channel No.');, end
e=invoke(hRP2, 'SetTagVal', 'ADChanNo', ADChanNo);
if ~e, error('Error in specifying ADC channel No.');, end

%Play and record
invoke(hRP2, 'SoftTrg', 1); %Trigger

%Wait until the recording is done
while(1)
   pause(0.01); %wait 10 ms before polling the status again
   if ~invoke(hRP2,'GetTagVal','RunFlagIn') & ~invoke(hRP2,'GetTagVal','RunFlagOut')
      break;
   end
end

%Get the recorded data
DataOut=invoke(hRP2,'ReadTagV','DataOut',0,NPtsOut);
DataOut=DataOut((NPtsADCDead+1):end);
DataOut=DataOut-mean(DataOut);
DataOut=[DataOut zeros(1,NPtsADCDead)];

%Reset the circuit so as to accept next trigger
invoke(hRP2,'ZeroTag','DataOut'); %Set the output buffer zeros
%Reset the index of the buffer
e=invoke(hRP2, 'SetTagVal', 'BuffIndexIn', 0); 
e=invoke(hRP2, 'SetTagVal', 'BuffIndexOut', 0);


