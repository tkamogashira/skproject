function y = SeqplayInit(Fsam, Dev, Value);
% SeqplayInit - initialize TDT device for sequenced play
%   Y = SeqplayInit(Fsam) initializes the Sys3 device for sequenced play by
%   loading the circuit. Fsam is the (approx) sample rate in kHz.
%   SeqplayInit returns a struct containing the exact sample frequency
%   in kHz and other details of the sequenced play setup. 
%   
%   SeqplayInit(Fsam, Dev) uses device Dev. Dev can be either RX6 (default)
%   or RP2. 
%   
%   Type 'help Seqplay' to get more detailed instructions on sequenced playback.
%
%   See also SeqplayList, SeqplayGO, SeqplayHalt, SeqplayStatus.



% SPinfo: persistent structure containing Seqplay information
persistent SPinfo

% default device
if nargin<2, Dev = 'RX6'; end  


if isequal(Fsam,'status'), % query, no action
elseif isequal(Fsam,'storeNrep'), % store rep counts, no action
   SPinfo.Nrep = Dev;
elseif isequal(Fsam,'setfield'), % set field(s) of SPinfo
   if isstruct(Dev),
      SPinfo = CombineStruct(SPinfo,Dev);
   else, % set value of single field 
      eval(['SPinfo.' Dev '=Value;']);
   end
else,  % regular call - load circuit 
   % different device types need different circuits
   DoesStamping = 0;
   if isequal('RX6', upper(Dev(1:3))),
      Circuitname = 'RX6seqPlay';
      DoesStamping = 1; % RX6 can do time stamping
   elseif isequal('RP2', upper(Dev(1:3))),
      Circuitname = 'RP2seqPlay';
   else,
      error(['No SeqPlay circuit available for device ''' Dev '''.']);
   end
   [Fsam, CycUse] = sys3loadCOF(Circuitname, Dev, Fsam); % actual sample rate
   
   % store info in persistent SPinfo
   Status = 'initialized';  
   Fsam = Fsam/1e3;     % in kHz
   sepa0 = '--------------------';
   CircuitID = rem(setrandstate, 1000000); 
   % this assignment overwrites any previous ones   
   SPinfo = collectInStruct(Dev, Circuitname, CircuitID, Status, Fsam, CycUse, sepa0);
   % Initialize circuit
   sys3setpar(CircuitID, 'CircuitIDIn', Dev);
   sys3zero('EndSample', Dev);
   if DoesStamping, % time-stamp-related buffers
      sys3zero('SubStamp', Dev);
      sys3zero('SamStamp', Dev);
      sys3zero('CalibRelay', Dev);
   end
   sys3zero('OffsetsL', Dev);
   sys3zero('OffsetsR', Dev);
   % the following "impossible" switch times prevent the circuit to ...
   % ... run away due to a 0==0 comparison at the output of the switch time buffers
   sys3write(-ones(1,13), 'SwitchListL', Dev);
   sys3write(-ones(1,13), 'SwitchListR', Dev);
   sys3zero('SamplesL', Dev);
   sys3zero('SamplesR', Dev);
   
   % let it run, but make sure the circuit is in an innocent state, i.e., does not start playing garbage, etc
   sys3run(Dev);
   SeqplayHalt(1); % 1: skip check as it leads to recursive calls 
end

y = SPinfo;





