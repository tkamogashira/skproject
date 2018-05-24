function A = sys3isactive;  
% Sys3isactive - true when TDT equipment has been initialized
%    Sys3isactive returns 1 when TDT devices are connected, 0 otherwise.
%    Note that connection of TDT devices is often done implicitly, e.g.,
%    when loading a circuit to a device.
%
%    See also sys3dev, sys3status.

A = ~isempty(sys3dev('get'));