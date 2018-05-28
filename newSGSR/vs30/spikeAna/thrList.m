function [L, Iseq, IDstr] = thrlist(DF);
% THRLIST - compile list of all thr curve in given datafile
%   thrlist('A0304') displays a list of all thr measurements 
%   in datafile A0304.
%
%   L = thrlist('A0304') suppresses the display and returns 
%   the information in character cell string L.
%
%   [L, Iseq, ID] = thrlist('A0304') also returns the seq 
%   numbers and dataset IDs of the datafile in vector Iseq 
%   and cell string ID. For example:
%   thrplot('A0304', Iseq) will plot all THR curves on top
%   of each other.
%
%   see also THRCURVE, LOG2LUT.

DL = log2lut(DF); % list of all datasets in datafile
ithr  = strfindcell({DL.IDstr}, 'THR'); % indices of THR ones
Iseq = [DL(ithr).iSeq]; % seq numbers of THR datasets in vecor
IDstr = {DL(ithr).IDstr}; % ID strings of THR datasets in cell array of strings
LL = thrplot(DF, Iseq, 'noplot'); % vectorized thrplot w/o plot
if nargout<1, % display list
   disp(char(LL));
else, % return list in output arg
   L = LL;
end


