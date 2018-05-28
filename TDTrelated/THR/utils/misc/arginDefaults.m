function varargout = arginDefaults(ArgNames, varargin);
% arginDefaults - provide default values for missing inputs to a function
%    [Foo, Faa, Fee] = arginDefaults('Foo/Faa/Fee'), when called from a 
%    function whose header contains input arguments named Foo, Faa, and Fee,
%    checks whether these input arguments were actually passed to the
%    calling function. If they were not, arginDefaults returns the default
%    value [] for them.
%
%    [Foo, Faa, Fee] = arginDefaults('Foo/Faa/Fee', 1, 2, 3) uses default
%    values 1,2,3, for Foo,Faa,Fee, respectively.
%
%    Example code.
%       function myfunc(A,B)
%       [A,B] = arginDefaults('A/B')
%
%   When calling myfunc from the commandline, it produces the following
%   output:
%      >> myfunc
%      A =
%         []
%      B =
%         []
%      >> myfunc(31)
%      A =
%         31
%      B =
%         []
%      >> myfunc(31, 524288)
%      A =
%         31
%      B =
%         524288
%
%     See also replaceEmpty.


if ~iscell(ArgNames),
    ArgNames = strrep(ArgNames, ' ', '');
    ArgNames = strrep(ArgNames, ',', '/');
    ArgNames = words2cell(ArgNames, '/');
end
if ~isequal(nargout, numel(ArgNames)),
    error('Mismatch in # arguments.');
end
for ii=1:nargout,
    varnam = ArgNames{ii};
    if evalin('caller', ['exist(''' varnam  ''', ''var''   );']), % whether var named varnam  exists in caller
        varargout{ii} = evalin('caller', [varnam ';']); % copy its value into output arg
    elseif ii<=numel(varargin), % explicit default provided
        varargout{ii} = varargin{ii};
    else, 
        varargout{ii} = [];
    end
    
end





