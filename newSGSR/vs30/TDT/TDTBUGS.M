function tdtbugs;
% 1. after initial s2init, aplock, xblock, 
%    ADstatus reports 'no AD device ID-ed.'
%    ADclear, however, works, and it also makes
%    subsequent calls to ADstatus work.
%
% 2. uicontrol windows in matlab examples suck
%    (window sizes/positions are specified in device-dependent units)

help tdtbugs

