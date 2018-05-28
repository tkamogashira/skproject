function [c, fn]= dealStruct2cell(s);
% dealStruct2cell - deal fields of struct into cell array
%   second optional argout gives fieldnames in cell array.
%
%   See also fieldnames

fn = fieldnames(s);
for ii=1:length(fn),
   eval(['c{ii} = s.' fn{ii} ';']);
end




