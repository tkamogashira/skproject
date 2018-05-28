function OK = HardwareInit;
% HardwareInit - initialization of SGSR realated hardware.
% For TDT System 2, initialization consists of following steps:
%  1. "claiming" the AP2 and XBDRV, and ZBUS (if any) as primary application
%     (see TDT manual of 32-bit drivers)
%     and initializing various TDT devices
%  2. preparing special D/A buffers XXX
%  3. testing & clock calibration

OK = 0;

% 1. claim the AP2 and initialize devices; start zbus if any
tdtOK = TDTinit;
if ~tdtOK, return; end;
PD1constants;
% 2. preparing special D/A buffers
ap2OK = cleanAP2(-1); % -1: include full test
if ~ap2OK, return; end
% 3. testing & clock calibration
OK = testET1andPD1(1,0); % device=1, 0 means full calib
% if ~et1OK, return; end;

OK = 1;
