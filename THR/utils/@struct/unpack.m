function unpack(S);
% struct/unpack - trun fields of struct into variables 
%   L unpack(S) creates variables in the caller space that represent the
%   fields of S. This is useful when using SAVE.
%   
%   Example
%     S = struct('A', 1, 'BB', 2);
%     unpack(S);
%     who
%        Your variables are:
%
%         S   A   BB
%
% See also SAVE, structSave.

Sname = inputname(1);
FNS = fieldnames(S);
for ii=1:numel(FNS),
    fn = FNS{ii};
    ASG = [fn '= ' Sname '.' fn ';'];
    evalin('caller', ASG);
end






