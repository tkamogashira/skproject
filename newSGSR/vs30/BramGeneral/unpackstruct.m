function varargout = unpackstruct(S)
%UNPACKSTRUCT   unpack scalar structure
%   UNPACKSTRUCT(S) unpacks the scalar structure S in the caller workspace. If a variable with the same
%   name as one of the fieldnames exist in the caller workspace, this variable is reassigned.
%
%   [A, B, ...] = UNPACKSTRUCT(S) unpacks the scalar structure S in the variables A, B, ...
%
%   See also PACKSTRUCT

if ~isstruct(S) | (ndims(S) ~= 2) | (length(S) ~= 1), 
    error('Single argument should be scalar struct'); 
end

FNames  = fieldnames(S);
NFields = length(FNames);

if (nargout == 0), 
    for n = 1:NFields
        assignin('caller', FNames{n}, getfield(S, FNames{n})); 
    end
else
    for n = 1:nargout
        varargout{n} = getfield(S, FNames{n}); 
    end
end    