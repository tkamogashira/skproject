function S = structcat(varargin)
%STRUCTCAT  concatenate structures
%   S = STRUCTCAT(S1, S2, ..., Sn) makes new structures S with
%       fieldnames of S1, S2, ... and Sn.

%B. Van de Sande 06-08-2003

if nargin < 2
    error('Wrong number of input parameters.');
elseif nargin > 2 %Iteratie ...
    S = varargin{1};
    for n = 2:nargin
        S = structcat(S, varargin{n});
    end
    return;
else
    [S1, S2] = deal(varargin{1:2});
end
if ~isa(S1, 'struct') || ~isa(S2, 'struct')
    error('Arguments should be structures.');
end

if isempty(S1)
    S = S2;
    return
end
if isempty(S2)
    S = S1;
    return
end

sizS1 = size(S1);
sizS2 = size(S2);
if any(sizS1 ~= sizS2) %Potential dimension mismatch
    if (min(sizS1) == 1) && (min(sizS2) == 1)
        S1 = reshape(S1, 1, prod(sizS1));
        S2 = reshape(S2, 1, prod(sizS2));
    else
        error('Structures must have same dimensions.');
    end
end

F1 = fieldnames(S1);
C1 = struct2cell(S1);

F2 = fieldnames(S2);
C2 = struct2cell(S2);

F = cat(1, F1, F2);
C = cat(1, C1, C2);

try
    S = cell2struct(C, F);
catch
    error('Fieldnames of structures are not unique.');
end
