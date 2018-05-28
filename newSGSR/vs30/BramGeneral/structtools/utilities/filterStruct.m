function out = filterStruct(S, field, value, varargin)
% FILTERSTRUCT filter structs out of a struct array by comparing a field to
% a given value by a given comparison function.
%
% filterStruct(S, field, value) returns the elements of S for which
%   isequal(S.(field), value) returns true
%
% filterStruct(S, field, value, fun) returns the elements of S for which
%   fun(S.(field), value) returns true. Be careful when defining the function
%   handle fun, it must be a total function on the set of possible values of
%   S.(field) and return a boolean in any case.
%
% example:
%   a.first = 3;
%   b.first = 4;
%   S = [a b];
%   filterStruct(S, 'first', 3) % returns a
%   filterstruct(S, 'first', 3, @(x,y) x>=y) % returns [a b]

% RdN

if ~isa(S, 'struct')
    error('First input argument must be a struct or struct array');
end

if ~isa(field, 'char')
    error('Second input argument must be a string');
end

if isequal(nargin,4) && isa(varargin{1}, 'function_handle')
    fun = varargin{1};
else
    if isequal(nargin,4)
        warning(['The given argument for the comparison function is not a ' ...
            'function handle, using @isequal as default']); %#ok<WNTAG>
    end
    fun = @isequal;
end

if length(S) > 1
    out = cell(1,length(S(1)));
    for n=1:length(S)
        out{n} = filterStruct(S(n), field, value, fun);
    end
    % convert to struct array
    while isa(out,'cell')
        out = [out{:}];
    end
    return
end

if isequal(length(S), 0)
    out = S;
    return
end

[C, F] = destruct(S);
idx = find(ismember(F,field), 1);
if isempty(idx)
    error('The specified field does not occur in the given struct.');
end

if ~isempty(find(cellfun( @(x) fun(x,value), num2cell(C{idx})'), 1))
    out = S;
else
    out = {};
end
