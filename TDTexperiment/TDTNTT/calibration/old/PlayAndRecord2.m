%function DataOut=PlayAndRecord(DataIn,NPtsOut)

%Create signal to play
RP2Fs=25000;
load chirp
DataIn=resample(y,RP2Fs,Fs);
DataIn=DataIn(:)';
NPtsIn=length(DataIn);

%Recording
NPtsOut=NPtsIn;

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

%Feed the signal and parameters
e=invoke(RP2, 'WriteTagV', 'DataIn', 0, DataIn);
if ~e, error('Error in sending signal');, end
invoke(RP2, 'WriteTagV', 'NPtsIn', 0, NPtsIn);
if ~e, error('Error in specifying NPts for input');, end
invoke(RP2, 'WriteTagV', 'NPtsOut', 0, NPtsOut);
if ~e, error('Error in specifying NPts for output');, end

%Play and record
invoke(RP2, 'SoftTrg', 1); %Trigger

a=zeros(1,NPtsIn);
for i=1:NPtsIn
   a(i)=invoke(RP2,'GetTagVal','RunFlagIn');
end
%Wait until the recording is done
%while(1)
%   if ~invoke(RP2,'GetTagVal','RunFlagIn') & ~invoke(RP2,'GetTagVal','RunFlagOut')
%      break;
%   end
%   pause(0.01);
%end

pause(1)

%Get the recorded data
DataOut=invoke(RP2,'ReadTagV','DataOut',0,NPtsOut+1);
DataOut(1)=[]; %Remove the first element, which is the Tag by BlockAcc.




