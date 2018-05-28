function [Status, Message]=getS2err

% function [status, mess]=getS2err
% checks for an AP2 or XBUS error, etc (see TDT's SISU guide)
%    Status: 0 if no error; 1 if APOS error; 2 if XBUS error
%    Message: string containing error message

[Status Message] = s232('getS2err');
if (Status==0), Message=''; end; % ignore garbage strings

