function S = CollectInStruct(varargin);
% CollectInStruct - collect variables in struct
%    CollectInStruct(X,Y,...) is s struct with field names 
%    'X', 'Y', ... and respective field values X,Y,...
%    All arguments must be variables, not anonymous values, except 
%    a single minus sign character  '-', which inserts a dummy "separator"
%    for display clarity. A maximum of 26 separators may be inserted.
%    '-foo' produces a titled separator.
%
%    See also STRUCT, FIELDNAMES, GETFIELD, SETFIELD.

Nvar = length(varargin);
S = [];
isep = 0; 
for ivar=1:Nvar,
    FN = inputname(ivar);
    if isempty(FN),
        if isequal('-', varargin{ivar}), % separator
            isep = isep+1; 
            if isep>26, error('Too many separators.'); end
            FN = [char('a'-1+isep) '___________________'];
            varargin{ivar} = '________________';
        elseif isequal('-', varargin{ivar}(1)), % titled separator
            FN = [varargin{ivar}(2:end) '___________________'];
            varargin{ivar} = '________________';
            
        else, error(['Input argument #' num2str(ivar) ' has no name'])
        end
    end
    S.(FN) = varargin{ivar};
end


