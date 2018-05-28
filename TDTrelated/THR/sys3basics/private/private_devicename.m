function [d, Mess] = private_devicename(d);
% private_devicename - unique, full name of a device extracted from 
% sys3devicelist

[d, Mess] = keywordMatch(d, sys3devicelist, 'TDT device');
if nargout<1, error(Mess); end;






