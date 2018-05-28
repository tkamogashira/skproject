function test

%Create signal to play
RP2Fs=ActualSampleRate(50000);
n=2*RP2Fs;
DataIn=randn(1,ceil(n));
DataIn=DataIn/max(DataIn);

%Initialize RP2
RP2=actxcontrol('RPco.x',[5 5 26 26]);% starts the RP activeX control in MATLAB
invoke(RP2,'ConnectRP2','GB',1); %connects an RP2 to a USB or Xbus
e2=invoke(RP2,'ClearCOF'); %Clears the Buffers and COF files on that RP
invoke(RP2,'LoadCOF','C:\expt\tdt\PlayAndRecord.rco'); % Loads circuit('c:\example')
invoke(RP2,'Run'); %Starts Circuit
Status=(invoke(RP2,'GetStatus'));% returns a value (7=circuit loaded and running) 
if invoke(RP2,'GetStatus')~=7
   error('Error when initializing RP2');
end

%Play and record

DataOut=PlayAndRecord(RP2,DataIn,1,1,n,RP2Fs);

%Check if the recorded output is clipped
MaxAmp=max(abs(DataOut));
if MaxAmp>=10
   disp('Clipping')
end

%RMS=sqrt(mean(DataOut.^2));