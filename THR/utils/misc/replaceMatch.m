function X = replaceMatch(X, Old, New);
% replaceMatch - replace a scalar value by something else
%    replaceMatch(X, Old, Y) returns Y if X exactly matches Old, X
%    otherwise. 
%
%    If Old is a cell array, X is replaced whenever X matches any of Old's
%    elements. 
%
%    See also arginDefaults, replaceEmpty.

Old = cellify(Old);

for ii=1:numel(Old),
    if isequalwithequalnans(X, Old{ii}),
        X = New;
        return;
    end
end


