function ArgOut = ParseConstraints(varargin)
%PARSECONSTRAINTS   parse constraints.
%   PARSECONSTRAINTS(S)
%   PARSECONSTRAINTS(Fnc)
%   PARSECONSTRAINTS(Class, Dim, Range)
%
%   Attention! This function is an internal function belonging to the  
%   property bag object and should not be invoked from the MATLAB
%   command prompt.

%B. Van de Sande 17-05-2004

if (nargin == 1) & isempty(varargin{1}),
    ArgOut = [];
%PARSECONSTRAINTS(S)
elseif (nargin == 1) & isConstraintStruct(varargin{1}), 
    S = varargin{1}; N = length(S);
    for n = 1:N, 
        Constraint = ParseConstraints(S(n).class, S(n).dimensions, S(n).range); %Use recursion ...
        if isempty(Constraint), error('Constraint structure with all empty fieldvalues is not valid.'); 
        else, ArgOut(n) = Constraint; end
    end
    ArgOut = CombineConstraints(ArgOut);
%PARSECONSTRAINTS(Fnc)
elseif (nargin == 1) & (ischar(varargin{1}) | isa(varargin{1}, 'function_handle')), 
    Fnc = varargin{1};
    if ischar(Fnc) & (size(Fnc, 1) > 1),
        error('Character string must contain name of constraint function for property.');
    end
    if isa(varargin{1}, 'function_handle') & (length(Fnc) > 1),
        error('Only one constraint function can be supplied for a property.');
    end
    ArgOut = Fnc;
%PARSECONSTRAINTS(Class, Dim, Range)
elseif (nargin == 3),
    if iscell(varargin{1}), %Supplying multiple constraints by cell-arrays ...
        [Class, Dim, Range] = deal(varargin{:});
        N = length(Class);
        if isempty(Dim), Dim = repmat({[]}, 1, N); end
        if isempty(Range), Range = repmat({[]}, 1, N); end
        if ~iscell(Dim) | ~iscell(Range), error('Invalid constraints syntax.'); end
        if ~isequal(N, length(Dim), length(Range)),
            error('When supplying multiple constraints using cell-arrays, all arrays must have same length.');
        end
        
        for n = 1:N, 
            Constraint = ParseConstraints(Class{n}, Dim{n}, Range{n}); %Use recursion ...
            if isempty(Constraint), error('Cell-array entries with empty values is not valid.'); 
            else, ArgOut(n) = Constraint; end
        end 
        ArgOut = CombineConstraints(ArgOut);
        return;
    end

    if all(cellfun('isempty', varargin)), ArgOut = []; %No constraints ...
    else,
        Class = ParseClass(varargin{1});
        if strcmpi(Class, 'double'),
            Dim   = ParseDim(varargin{2});
            Range = ParseNumRange(varargin{3});
        elseif strcmpi(Class, 'char'),
            if ~isempty(varargin{2}) & ~isempty(varargin{3}),
                error('Constraints on dimension and range are not compatible for property value of class char.')
            else,
                Dim   = ParseDim(varargin{2});
                Range = ParseCharRange(varargin{3});
            end
        else,
            if ~isempty(varargin{3}),
                error(sprintf('Constraint on range of property value of class ''%s'' is not allowed.', Class));
            else,
                Dim   = ParseDim(varargin{2});
                Range = [];
            end    
        end
    end
    
    ArgOut = CreateStruct('class', Class, 'dimensions', Dim, 'range', Range);
else, error('Invalid constraint syntax.'); end    

%---------------------------locals-----------------------------
function boolean = isConstraintStruct(S)

if isstruct(S) & (isempty(S) | all(ismember({'class', 'dimensions', 'range'}, fieldnames(S)))),
    boolean = logical(1);
else, boolean = logical(0); end    

%--------------------------------------------------------------
function Class = ParseClass(Input)

if ~ischar(Input) | ~isvarname(Input),
    error(sprintf('''&s'' is not a valid MATLAB variable class.', Input)); 
else, Class = lower(Input); end

%--------------------------------------------------------------
function Dim = ParseDim(Input)

%Dim is always a scalar or a three-element rowvector ...

if isempty(Input), Dim = []; %No constraints ...
elseif ischar(Input),
    if strncmpi(Input, 'e', 1), Dim = 0; %Empty ...  
    elseif strncmpi(Input, 's', 1), Dim = 1; %Scalar ...
    elseif strncmpi(Input, 'r', 1), Dim = [1 Inf 1]; %Row vector ...
    elseif strncmpi(Input, 'c', 1), Dim = [Inf, 1, 1]; %Column vector ...  
    else, %@x@ or @x@x@ syntax ...   
        Nx = length(strfind(Input, 'x'));
        if (Nx == 0) | (Nx > 2), error('Dimensions must be specified with a character string of the form ''@x@'' or ''@x@x@''.');
        elseif (Nx == 1), [Dim, N, ErrMsg] = sscanf(Input, '%fx%f');
        elseif (Nx == 2), [Dim, N, ErrMsg] = sscanf(Input, '%fx%fx%f'); end
        
        if ~isequal(Nx+1, N) | ~isempty(ErrMsg), 
            error('Dimensions must be specified with a character string of the form ''@x@'' or ''@x@x@''.'); 
        elseif any(mod(Dim(find(~isinf(Dim))), 1)) | any(Dim < 0),
            error('Dimensions must be specified as postive integers.');
        else, 
            if (N == 2), Dim = [Dim(:); 1]; end
            if all(Dim == 1), Dim = 1;  %Scalar ...
            elseif any(Dim == 0), Dim = 0; %Empty ...
            else, Dim = reshape(Dim, 1, 3); end %Always rowvector ...
        end
    end
elseif isnumeric(Input),
    if any(isnan(Input)) | any(mod(Input(find(~isinf(Input))), 1)) | any(Input < 0),
        error('Dimensions must be specified as postive integers.');
    end
    
    if (length(Input) == 1), Dim = Input; %Empty, scalar or vector ...
    elseif isequal(sort(size(Input)), [1 2]),
        if all(Input == 1), Dim = 1; %Scalar ...
        elseif any(Input == 0), Dim = 0; %Empty ...
        else, Dim = reshape([Input(:); 1], 1, 3); end %Always rowvector ...
    elseif isequal(sort(size(Input)), [1 3]),    
        if all(Input == 1), Dim = 1; %Scalar ...
        elseif any(Input == 0), Dim = 0; %Empty ...
        else, Dim = reshape(Input, 1, 3); end %Always rowvector ...    
    else, error('Dimensions must be specified as a numerical scalar or a vector with 2 or 3 elements.'); end    
else, error('Invalid syntax for constraining dimensions of property value.'); end
        
%--------------------------------------------------------------
function Range = ParseNumRange(Input)

if isempty(Input), Range = []; %No range restrictions ...
elseif (length(Input) == 1), Range = Input; %Scalar ...
elseif isnumeric(Input) & isequal(sort(size(Input)), [1 2]) & ~(diff(Input) <= 0), %Closed interval ...
    Range = reshape(Input, 1, 2); %Always rowvector ...
else, error('Invalid constraint on range of numeric property value.'); end

%--------------------------------------------------------------
function Range = ParseCharRange(Input)

if isempty(Input), Range = []; %No range restrictions ...
elseif ~ischar(Input) & ~iscellstr(Input),
    error('Constraint on range of property value of type char must be given as string or cell-array of strings.');
else, 
    Range = cellstr(Input);
    Range = unique(reshape(Range, 1, prod(size(Range)))); %Always rowvector ...
end

%--------------------------------------------------------------