function Str = disp(S);
% struct/disp - DISP for structs with optional output arg
%   disp(S) displays struct S using builtin DISP.
%   Str = disp(S) returns a cell string contaning an approximation of the
%   DISP output.

if nargout<1,
    builtin('disp', S);
    return;
end

FNS = fieldnames(S);
N = numel(FNS);
iFNS = cellfun(@fliplr, FNS, 'uniformoutput', false);
Names = fliplr(strvcat(iFNS));
Names = [repmat(' ',N,4), Names];
SzS = sizeString(size(S));
if isempty(FNS),
    Str = [SzS ' struct array with no fields.'];
    return;
elseif ~isequal(1, numel(S)),
    Str = strvcat([SzS ' struct array with fields:'], Names);
    return;
end
Names = [Names, repmat(':',N,1), repmat(' ',N,1)];
for ii=1:N,
    X = S.(FNS{ii}); % value of this field
    s = local_shortdescr(X); % the default
    CL = class(X); if isnumeric(X), CL = 'numeric'; end
    switch CL,
        case 'numeric',
            if isequal([], X),
                s = '[]';
            elseif local_okaysize(X,25),
                s = trimspace(num2str(X));
                if numel(X)>1, s = ['[' s ']']; end
            end
        case 'char',
            if local_okaysize(X,48),
                s = ['''' X ''''];
            end
        case 'cell',
            if isequal({},X),
                s = '{}',
            elseif local_okaysize(X,25),
                s = localcell(X);
            end
        case 'function_handle',
            s = ['@' char(X)];
        otherwise,
    end % switch/case
    if numel(s)<=50 && (size(s,1)<2),
        ValStr{ii} = s;
    else,
        ValStr{ii} = local_shortdescr(X);
    end
end
Content = strvcat(ValStr{:});
Str = [Names, Content];

%=============
function Str = local_shortdescr(X);
Sz = sizestring(size(X));
if iscell(X), 
    Str = [ '{'  Sz ' ' class(X) '}' ];
else,
    Str = [ '['  Sz ' ' class(X) ']' ];
end

function ok = local_okaysize(X,N);
ok = (ndims(X)<3 && size(X,1)==1 && numel(X)<=N);

function  s = localcell(X);
s = '{';
for ii=1:numel(X),
    x = X{ii};
    a = local_shortdescr(x);
    if isnumeric(x),
        if isequal([],x), a = '[]';
        elseif local_okaysize(x,10), a = ['[' trimspace(num2str(x)) ']'];
        end
    elseif isequal({},x), a = '{}';
    elseif ischar(x),
        if isequal('',x), a = '''''';
        elseif local_okaysize(x,10), a = ['''' x ''''];
        end
    elseif isa(x, 'function_handle'),
        a = ['@' char(x)];
    end
    s = [s, a '  '];
end
s = s(1:end-1);
s(end) = '}';


