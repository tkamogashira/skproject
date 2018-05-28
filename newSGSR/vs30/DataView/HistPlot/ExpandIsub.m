function iSub = ExpandIsub(iSub, ds);
% ExpandIsub - convert Isub specification to vector containing the Isub

if isequal(0,iSub), 
   iSub=1:ds.Nrec; 
elseif isequal('up',iSub), 
   [x iSub] = sort(ds.xval(:).'); % row vector
elseif isequal('down',iSub), 
   [x iSub] = sort(ds.xval(:).'); % row vector
   iSub = iSub(end:-1:1);
elseif ~isnumeric(iSub), error('Invalid iSub specification');
end;
