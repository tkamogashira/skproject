function [sf, cu] = sys3loadCOF(Cname, Dev, Fsam);  
% sys3loadCOF - load COF circuit to RP2_1 or RV8_1  
%   sys3loadCOF('foo') loads the circuit named "foo.rco" to the RP2_1.  
%   sys3loadCOF('') clears the device (TDT ClearCOF)  
%   The default folder of RCO files is COFdir.  
%  
%   sys3loadCOF('foo', Dev) loads the circuit to the device Dev. Dev  
%   can be 'RP2_1', 'RV8_1'. Empty values default to 'RP2_1'.  
%  
%   sys3loadCOF('foo', Dev, SF) loads the circuit and sets the sample freq  
%   to the predefined sample rate that is closest to SF kHz.   
%  
%   [FS, CU] = sys3loadCOF(...) returns the exact sample frequency of the loaded circuit   
%   in Hz and the cycle usage in %.  
%     
%   See also COFdir, SYS3DEV  
  
if nargin<2, Dev = ''; end; % default device  
if isempty(Dev), Dev='RP2_1'; end;  
%disp(Dev)
d = sys3dev(Dev); % obtain actxcontrol for device  
invoke(d, 'ClearCOF'); % clear device  
  
if isempty(Cname), return; end; % no cicuit to load: quit  
  
FCname = FullFileName(Cname, sys3COFdir, 'rco', 'RCO file'); % error if non-existent  
if nargin<3, % regular call, no setting of sample rate  
    invoke(d, 'LoadCOF', FCname); % load circuit  
else, % set approx sample rate and return true rate  
    fixedSF = [6 12 25 50 100 200 400];  
    [dum ifreq] = min(abs(Fsam-fixedSF));   
    invoke(d, 'LoadCOFsf', FCname, ifreq-1); % load circuit and set sample rate  
end  
  
% return true sample rate in Hz  
sf = double(invoke(d, 'GetSFreq'));  
if nargout>1,  
    cu = double(invoke(d,'GetCycUse'));  
end  
  
      
      
      
