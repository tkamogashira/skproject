function sys3reset;
% Sys3reset -  - reinitialize sys3 hardware
%    Sys3reset first disconnects then reconnect sys3 hardware.
%    NOTE: sys3 devices are implictly connected when loading circuits, etc.
%    Resetting is only needed when communication errrors occur. Usually it is
%    safer to restart Matlab in such cases and/or switch the devices off
%    and on.
%  
%    See also Sys3dev.

sys3dev FORCE;





