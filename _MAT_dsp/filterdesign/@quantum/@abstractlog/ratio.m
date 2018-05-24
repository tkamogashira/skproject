function r = ratio(this,name)
%RATIO   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

n = this.NOperations;
if ~n,  percentage = 0; else  percentage = round(this.(name)/n*100);end
r = sprintf('%d%s%d%s%d%s',this.(name),'/',this.NOperations,' (',percentage,'%)');


% [EOF]
