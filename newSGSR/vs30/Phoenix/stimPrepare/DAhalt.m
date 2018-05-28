function Y = DAhalt(keyword)
% DAhalt - immediately stop ongoing D/A
%   DAhalt stops any ongoing D/A conversion. The device to
%   be interrupted depends on TDTsystem.
%
%   DAhalt('status') returns one if D/A has been interrupted,
%   zero otherwise.
%   
%   DAhalt('clear') resets the status flag, so that DAhalt('status')
%   will now return zero.
%  
%   Note: stimulus/play calls DAhalt('clear') once.
%
%   see also stimulus/play, TDTsystem, DAwait.

persistent HalteD
if isempty(HalteD), HalteD=0; end;

if nargin<1, keyword = 'halt'; end

switch lower(keyword),
case 'status', 
   Y = HalteD;
   return
case 'clear'
   HalteD = 0;
   return
end

switch TDTsystem,
case 'sys2',
   s232('PD1clear', 1);
   s232('PD1stop', 1);
   pause(0.05); % for some reason this pause plus following calls prevent clicks @ next play
   s232('PD1clear', 1);
   s232('PD1stop', 1);
   HalteD = 1;
case 'sys3',
   error NYI;
otherwise,
   error(['DAwait for TDTsystem = ''' TDTsystem ''' not implemented.']);
end


