function [Fsam, CycleUsage, Recycled] = sys3loadCircuit(Cname, Dev, Fsam, Recycle);
% sys3loadCircuit - load COF circuit to sys3 device  
%   sys3loadCircuit('Foo', Dev) loads the circuit named "foo.rcx" to sys3 
%   device Dev. The circuit file is located using the path which may be
%   set using RPvdSpath. Default extension for circuit files is .rcx,
%   but this can be overruled by specifying a different file extension.
%   If Dev is not specified, or Dev=='', the default sys3 device is used 
%   (see sys3defaultDev).
%
%   sys3loadCircuit('', Dev) clears the device (TDT ClearCOF)  
%  
%   sys3loadCircuit('foo', Dev, SF) loads the circuit and sets the sample 
%   frequency to that valid sample rate that is closest to SF kHz.  
%   NOTE: the set of predefined sample rates depends on the device type.
%  
%   sys3loadCircuit('foo', Dev, SF, 1) first checks whether the requested 
%   circuit has already been loaded. If it is already loaded using the same
%   sample rate as requested, the circuit is not loaded again, but is
%   stopped using sys3halt. Fsam is "rounded" toward the nearest available
%   sample rate for sys3 device Dev.
%
%   [FS, CU, Recycled] = sys3loadCircuit(...) also returns 
%   the exact sample frequency FS of the loaded circuit in kHz, the cycle 
%   usage CU in %, and a logical value Recycled indicating whether an
%   already loaded circuit was re-used.
%
%   Use sys3CircuitInfo for info on the circuit.
%     
%   See also sys3dev, RPvdSpath, sys3editcircuit, sys3CircuitInfo, sys3devicelist, sys3partag. 

if nargin<1, Cname = ''; end; % means no sample rate specified
if nargin<2, Dev = ''; end; % default device  
if nargin<3, Fsam = nan; end; % means no sample rate specified
if nargin<4, Recycle = 0; end; % no circuit recycling - always load

[actx, Dev] = sys3dev(Dev); % obtain actxcontrol for device
if Recycle, % test if circuit is already running; if so just sys3shalt & go
    [Recycled, CycleUsage] = local_test_current_circuit(Cname, Dev, Fsam);
    if Recycled, sys3halt(Dev); return; end
end
% disp('-----------------')
% Cname
% dbstack
% disp('-----------------')
% not recycled - do it
Recycled = 0;
invoke(actx, 'ClearCOF'); % clear device  ..
private_circuitInfo(Dev, '-reset'); % .. & its bookkeeping

if isempty(Cname), return; end; % no circuit to load; clear call done: quit  

% locate file
FCname = FullFileName(Cname,'','.rcx'); % provide extension if needed
D = fileparts(FCname); % extract directory spec if any
if isempty(D), % look in sys3COFdir and subdirs
    FCname = SearchInPath(FCname, RPvdSpath, 'file');
end
if ~exist(FCname,'file') || isempty(FCname),
    error(['cannot find RCX file ''' Cname ''' in RPvdS path.']);
end

%get date of last save of FCname
qq = dir(FCname);
FileDate = getfieldOrDefault(qq, 'datenum', nan); clear qq; 

if isnan(Fsam), % regular call, no setting of sample rate  
   stat = invoke(actx, 'LoadCOF', FCname); % load circuit  
else, % set approx sample rate and return true rate  
   if ~isempty(strmatch('RX6',Dev)),
      sfArg = 1e3*rx6sampleRate(Fsam);  % make sure to use only the sample rates at which the DAC will work.   
   else, % standard standard rates: pass the index (see ActiveEx help)
      fixedSF = [6 12 25 50 100 200 400];
      [dum ifreq] = min(abs(Fsam-fixedSF));
      sfArg = ifreq-1;
   end
   stat = invoke(actx, 'LoadCOFsf', FCname, sfArg); % load circuit and set sample rate  
end  

if ~stat, 
    disp('...reconnecting to TDT devices...')
    sys3dev force; % need reset or otherwise all subsequent sys3 calls will fail
    error(['Error loading circuit ''' FCname ''' to device ''' Dev '''.']); 
end

% return true sample rate in Hz, etc
Fsam = double(invoke(actx, 'GetSFreq'))/1e3;   % Hz->kHz
CycleUsage = double(invoke(actx,'GetCycUse'));
% bookkeeping
Device = Dev;
CircuitFile = FCname;
unique_id = randomInt(1e9);
private_circuitInfo(Dev, CollectInStruct(Device, CircuitFile, FileDate, Fsam, CycleUsage, unique_id)); 
%private_circuitInfo(Dev, CollectInStruct(Device, CircuitFile, Fsam, CycleUsage)); 
CircuitItems = private_CircuitItems(actx); % details of circuit components
private_circuitInfo(Dev,CircuitItems); % store component info 
private_circuitInfo(Dev,'Running', 0); % Running state is further controled by sys3run & sys3halt
%========================
% RX6 DAC sample rates according to table in TDT help:
% [ 6103.52  6975.45  8138.025  9765.63  12207.03  13950.89  16276.04  19531.25  24414.06  27901.79  32552.08  39062.50  48828.13  55803.57  65104.17  78125.00  97656.25  111607.14  130208.33  156250.00  195312.50  223214.29  260416.67])
% The master clock runs at 50 MHz, so the exact rates are 50e6/d, where d is one of
% [8192  7168  6144  5120  4096  3584  3072  2560  2048  1792  1536  1280  1024   896   768   640   512   448   384   320   256   224   192]

%===============================================================
function [okay, CycleUsage] = local_test_current_circuit(Cname, Dev, Fsam);
% test if the requested circuit is already loaded with the correct Fsam
Fsam = sys3trueFsam(Fsam,Dev);
[okay,  CycleUsage] = deal(0);
CI=sys3circuitInfo(Dev);
if isempty(CI), return; end % nothing loaded
FCname = FullFileName(Cname,'','.rcx'); % provide extension if needed
[DD NN EE] = fileparts(FCname); FCname = [NN EE]; % strip off directory
loadedFN = getFieldOrDefault(CI, 'CircuitFile', '');
[DD NN EE] = fileparts(loadedFN); loadedFN = [NN EE]; % strip off directory
if ~isequal(lower(loadedFN), lower(FCname)), return; end % wrong file
loadedFsam = getFieldOrDefault(CI, 'Fsam', nan);
if ~isequal(loadedFsam, Fsam), return; end % wrong
okay = 1; % survived: okay



