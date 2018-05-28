function Str = Constraints2Str(Constraints)
%CONSTRAINTS2STR   convert constraints to character string.
%   Str = CONSTRAINTS2STR(Constraints)
%
%   Attention! This function is an internal function belonging to the  
%   property bag object and should not be invoked from the MATLAB
%   command prompt.

%B. Van de Sande 17-05-2004

if isempty(Constraints), Str = 'no constraints';
elseif ischar(Constraints), Str = sprintf('<%s>', Constraints);
elseif isa(Constraints, 'function_handle'), Str = sprintf('<%s>', func2str(Constraints));
elseif isstruct(Constraints) & all(ismember({'class', 'dimensions', 'range'}, fieldnames(Constraints))),
    N = length(Constraints);
    if (N == 1), Str = Constraint2Str(Constraints);
    else,
        Str = Constraint2Str(Constraints(1));
        for n = 2:N-1, Str = [Str, ', ', Constraint2Str(Constraints(n))]; end
        Str = [Str, ' or ' Constraint2Str(Constraints(N))];
    end
else, error('Wrong input argument.'); end   

%---------------------------locals-----------------------------
function Str = Constraint2Str(Constraint)

Str = '';
if strcmpi(Constraint.class, 'double'),
    Str = strvcat(Str, [Dim2Str(Constraint.dimensions), 'double', Range2Str(Constraint.range)]);
elseif strcmpi(Constraint.class, 'char'),    
    if ~isempty(Constraint.dimensions),
        Str = strvcat(Str, sprintf('%schar', Dim2Str(Constraint.dimensions)));
    elseif ~isempty(Constraint.range),
        Str = strvcat(Str, List2Str(Constraint.range));
    else, Str = strvcat(Str, 'char'); end
else,
    Str = strvcat(Str, [Dim2Str(Constraint.dimensions), lower(Constraint.class)]);
end    

%--------------------------------------------------------------
function Str = Dim2Str(Dim)

if isempty(Dim), Str = '';
elseif (length(Dim) == 1),
    if (Dim == 0), Str = 'empty ';
    elseif (Dim == 1), Str = 'scalar ';
    elseif isinf(Dim), Str = 'vector ';
    else, Str = sprintf('%d-vector ', Dim); end
else, 
    if isequal(Dim, [1 Inf 1]), Str = 'rowvector ';
    elseif isequal(Dim, [Inf 1 1]), Str = 'columnvector ';  
    elseif (Dim(3) == 1), Str = sprintf('%dx%d ', Dim(1:2));
    else, Str = sprintf('%dx%dx%d ', Dim); end
end

%--------------------------------------------------------------
function Str = Range2Str(Rng)

if isempty(Rng), Str = '';
elseif (length(Rng) == 1), Str = sprintf(' (%g)', Rng);
else Str = sprintf(' [%g %g]', Rng); end

%--------------------------------------------------------------
function Str = List2Str(List)

if length(List) == 1, Str = sprintf('''%s''', List{1});
else,
    List = vectorzip(List, repmat({''','''}, size(List))); List(end) = [];
    Str = cat(2, '{''', List{:}, '''}');
end

%--------------------------------------------------------------