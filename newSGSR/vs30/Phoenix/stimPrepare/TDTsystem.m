function ts = TDTsystem;
% TDTsystem - TDT hardware system of current setup
%   TDTsystem retuns a string 'sys2' or 'sys3' or 'none' depending
%   on the TDT hardware system hooked up to the PC.
%   No attempt is made to check initialization, etc.
%
%   see also TDTinit, XXX.

persistent TS

if ~isempty(TS), ts = TS; return; end

switch lower(CompuName),
case {'bigscreen', '3rdfloor'}, 
   ts = 'sys2';
case 'sikio', 
   ts = 'sys3';
otherwise,
   ts = 'none';
end
TS = ts; % store in persistent for faster performance   
   
