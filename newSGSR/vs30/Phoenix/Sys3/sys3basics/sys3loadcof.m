function [sf, cu] = sys3loadcof(Cname, Dev, Fsam);  
% sys3loadCOF - load COF circuit to sys3 device  
%   sys3loadCOF('foo') loads the circuit named "foo.rco" to the RX6.  
%   sys3loadCOF('') clears the device (TDT ClearCOF)  
%   The default folder of RCO files is COFdir.  
%  
%   sys3loadCOF('foo', Dev) loads the circuit to the device Dev. Dev  
%   can be any device initialized by sys3dev.  
%  
%   sys3loadCOF('foo', Dev, SF) loads the circuit and sets the sample freq  
%   to the predefined sample rate that is closest to SF kHz.   
%   Note: the set of predefined sample rates depends on the device type.
%  
%   [FS, CU] = sys3loadCOF(...) returns the exact sample frequency of the loaded circuit   
%   in Hz and the cycle usage in %.  
%     
%   See also sys3COFdir, SYS3DEV  

if nargin<2
    Dev = ''; 
end % default device  

if isempty(Dev)
    Dev='RX6'; 
end  

d = sys3dev(Dev); % obtain actxcontrol for device  
invoke(d, 'ClearCOF'); % clear device  

if isempty(Cname)
    return; 
end % no cicuit to load: quit  

FCname = FullFileName(Cname, sys3COFdir, 'rco', 'RCO file'); % error if non-existent  
if nargin<3 % regular call, no setting of sample rate  
   stat = invoke(d, 'LoadCOF', FCname); % load circuit  
else % set approx sample rate and return true rate  
   if ~isempty(strmatch('RX6',Dev))
      % make sure to use only the sample rates at which the DAC will work. The valid set of divisors of the 50-MHz mater clock is:
      divisor = [8192  7168  6144  5120  4096  3584  3072  2560  2048  1792  1536  1280  1024   896   768   640   512   448   384   320   256   224   192];
      fixedSF = 50e6./divisor;
      % find the nearest one in that list
      [dum ifreq] = min(abs(1e3*Fsam-fixedSF));   
      sfArg = fixedSF(ifreq);
   else % standard standard rates: pass the index (see ActiveEx help)
      fixedSF = [6 12 25 50 100 200 400];
      [dum ifreq] = min(abs(Fsam-fixedSF));
      sfArg = ifreq-1;
   end
   stat = invoke(d, 'LoadCOFsf', FCname, sfArg); % load circuit and set sample rate  
end  

if ~stat
    error(['Error loading circuit to ' Dev '.']); 
end

% return true sample rate in Hz  
sf = double(invoke(d, 'GetSFreq'));  
if nargout>1
   cu = double(invoke(d,'GetCycUse'));  
end  



%========================
% RX6 DAC sample rates according to table in TDT help:
% [ 6103.52  6975.45  8138.025  9765.63  12207.03  13950.89  16276.04  19531.25  24414.06  27901.79  32552.08  39062.50  48828.13  55803.57  65104.17  78125.00  97656.25  111607.14  130208.33  156250.00  195312.50  223214.29  260416.67])
% The master clock runs at 50 MHz, so the exact rates are 50e6/d, where d is one of
% [8192  7168  6144  5120  4096  3584  3072  2560  2048  1792  1536  1280  1024   896   768   640   512   448   384   320   256   224   192]
 
