function Val = AdjustParam(Val, Nsub, Nrec)
%ADJUSTPARAM   adjust values of independent variable.
%   P = ADJUSTPARAM(P, Nsub, Nrec) makes sure that for unrecorded subsequences
%   the value of the independent variable stored in P is set to NaN or ''.

%B. Van de Sande 27-07-2004

%Checking input parameters ...
if (nargin ~= 3), error('Wrong number of input arguments.'); end
if ~isnumeric(Val) & ~iscellstr(Val) & ~ischar(Val),
    error('First argument should be stimulus parameter represented by a numerical matrix or a cell-array of strings.');
end
if ~(isnumeric(Nsub) & (length(Nsub) == 1) & ~mod(Nsub, 1)) | ~(isnumeric(Nrec) & (length(Nrec) == 1) & ~mod(Nrec, 1)),
    error('The second and third arguments must be scalar integers denoting number of requested and recorded subsequences respectively.');
end

if ischar(Val), return;
elseif iscellstr(Val),
    Nrow = size(Val, 1);
    if ~any(Nrow == [1, Nsub]), Val = '';
    elseif (Nrow ~= 1), Val((Nrec+1):Nsub, :) = {''}; end
else,
    Nrow = size(Val, 1);
    if ~any(Nrow == [1, Nsub]), Val = NaN;
    elseif (Nrow ~= 1), Val((Nrec+1):Nsub, :) = NaN; end
end