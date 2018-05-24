function X=private_StorePointIDs(X);
% store points ID info associated with line object
%   private helper of IDpoints and GrabPoints.

% NOTE: saving this mfile in a /private directory screws up the functioning of
% the PERSISENT variable. This is a Matlab bug.

persistent STORED
% debug call
if isequal('debug',X)
    X = STORED;
    return
end

% clear info of non-existing handles
if ~isempty(STORED),
    iok = ishandle([STORED.h]);
    STORED = STORED(iok);
end

% either store or retrieve element, depending on # out args
if nargout<1, % add element
    % append new info
    STORED = [STORED, X];
elseif isempty(STORED), 
    X = [];
else, % retrieve
    ihit = X==[STORED.h];
    X = STORED(ihit);
end


