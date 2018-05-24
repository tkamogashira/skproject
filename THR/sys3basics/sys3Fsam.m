function fsamp = sys3Fsamp(Dev)
% sys3Fsam - get sample frequency [kHz] from TDT device
%
%   sys3Fsam(Dev) returns the sample frequency (in kHz) of the circuit
%   that is loaded on the device Dev.Dev defaults to SYS3DEFAULTDEV.
%   An error results if no circuit was loaded to the device.
%
%   Examples:
%      fs = sys3Fsam; % default device
%      fs = sys3Fsam('RP2_1');
%
%   See also sys3defaultdev, sys3status.

if nargin<1, Dev = ''; end

error(sys3unloadedError(Dev));

fsamp = sys3circuitinfo(Dev, 'Fsam');


