function new_ext = reject_ext(this,new_ext,newidx)
%REJECT_EXT   

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

% Reject superfluous potential extremals
fext = this.fext;
errgrid = this.errgrid;

% Retain extremals from previous iterations
% Find indices of extremals to retain
retain_idx = ismember(new_ext,fext);

% Make sure we always retain the first two extremals since they correspond
% to the band edges.
retain_idx(1:2) = true;

% Compute new error at new extremals
errext = errgrid(newidx);

% Compute max error
maxerr = norm(errext,inf);

% Artificially increase error at extremals to retain so they are not
% deleted
alterrext = errext;
alterrext(retain_idx) = maxerr+eps;

while (length(new_ext) > length(fext)),
    [minval,minidx] = min(abs(alterrext)); % Don't include band-edge    
    new_ext = [new_ext(1:minidx-1), new_ext(minidx+1:end)];
    alterrext = [alterrext(1:minidx-1), alterrext(minidx+1:end)];
end

% [EOF]
