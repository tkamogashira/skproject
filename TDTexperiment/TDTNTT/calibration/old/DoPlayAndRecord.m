%Create signal to play
RP2Fs=ActualSampleRate(50000);
[A,B]=MakeGolay(12);
DataIn=[A zeros(size(A)) B zeros(size(B))];
DataIn=DataIn/max(abs(DataIn))*9;

%Initialize RP2
RP2=actxcontrol('RPco.x',[5 5 26 26]);% starts the RP activeX control in MATLAB
%invoke(RP2,'ConnectRP2','USB',1); %connects an RP2 to a USB or Xbus
invoke(RP2,'ConnectRP2',TDTInterface,1); %connects an RP2 to a USB or Xbus
e2=invoke(RP2,'ClearCOF'); %Clears the Buffers and COF files on that RP
invoke(RP2,'LoadCOF','C:\MATLABR11\work\PlayAndRecord.rco'); % Loads circuit('c:\example')
invoke(RP2,'Run'); %Starts Circuit
Status=(invoke(RP2,'GetStatus'));% returns a value (7=circuit loaded and running) 
if invoke(RP2,'GetStatus')~=7
   error('Error when initializing RP2');
end

%Play and record
DataOut=PlayAndRecord(RP2,DataIn);

%Check if the recorded output is clipped
MaxAmp=max(abs(DataOut));
if MaxAmp>=10
   disp('Clipping')
end

%RMS=sqrt(mean(DataOut.^2));