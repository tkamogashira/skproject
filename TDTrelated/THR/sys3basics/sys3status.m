function St = sys3status(Dev, F);  
% sys3status - get status of sys3 device  
%   Sys3status(Dev) with no output arguments lists the the status sys3 
%   device Dev. Default device (i.e. Dev arg omiited or Dev=='') is
%   sys3defaultdev.  
%
%   S = Sys3status(dev) also returns a struct S with fields
%          Device: device name
%       Connected: 1 if device is connected, 0 otherwise
%          Loaded: 1 if a circuit was loaded to the device, 0 otherwise
%         Running: 1 if circuit is running on the device
%
%   Sys3status(dev, F) returns a selected feature F, which can be one of 
%   the char strings: Connected, Loaded, Running.
%   These keywords are case INsensitive and may be abbreviated.
%
%   Note: this function uses internal bookkeeping of sys3XXX functions,
%   and involves no communication with TDT devices.
%
%   See also sys3circuitInfo, sys3TagInfo, sys3Fsam.
 
if nargin<1, Dev=''; end;  % default device; see sys3dev

if isempty(Dev), 
    Dev = sys3defaultdev;
end
% defaults
St.Device = Dev;
St.Connected = 0;
St.Loaded = 0;
St.Running = 0;
if ~isempty(private_circuitInfo), % connected - check the status
    St.Connected = 1;
    St.Device = private_devicename(Dev); % uniquify name
    CtInfo = sys3circuitInfo(Dev);
    St.Loaded = ~isempty(CtInfo);
    if St.Loaded,
        St.Running = CtInfo.Running;
    end
end

if nargin>1, % select requested feature
    [F, Mess] = keywordMatch(F, fieldnames(St), 'device status feature');
    error(Mess);
    St = St.(F);
end

if nargout<1 & nargin<2,
    disp(St)
    clear St
end


