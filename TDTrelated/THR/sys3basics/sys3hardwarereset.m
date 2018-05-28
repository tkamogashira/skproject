function sys3hardwarereset(zB);
% sys3hardwarereset - hardware reset of all connected TDT system3 equipment
%   Sys3hardwarereset issues a hardware reset to racks 1 to 10 (assuming
%   this is enough). The connection is made using sys3dev.
%
%   Sys3hardwarereset(ZBUS) does not call sys3dev for the connection, but
%   uses the address from the input argument ZBUS. This enables sys3dev to
%   use it without recursion problems.
%
%   Note that, depending on the 'resethardware' property of sys3setup, a
%   hardware reset is done at initialization time, i.e., the first call
%   that connects to a sys3 device.
%
%   See also sys3setup, sys3dev.

zB = arginDefaults('zB', []);
if isempty(zB), zB = sys3dev('zbus'); end % replaceEmpty cannot be used here because: default value has side effect

%Little cheat to reset racks. The hardware reset should return 0 when reset
%was unsucessfull (e.g. rack not present). However, 0 is always returned,
%even if reset was successful. So, it is not possible to use this value to
%determine when all racks have reset.
%Here, just reset the first 10 racks, and hope there are not more racks in
%the setup

maxracknum = 10;

tic
for ii = 1:10,
    invoke(zB,'HardwareReset',ii);
end
while toc<10, pause(0.1); end



