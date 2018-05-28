function boolean = eval(ML, List)
%EVAL   check of given list of 'words' belongs to the language defined by metalng object
%   boolean = EVAL(<metalng object>, <list of words>) checks of the list of words, given
%   by a cell-array of strings, belongs to the language defined by the metalanguage object

%B. Van de Sande 14-10-2003

%-----------------------------------Implementation details----------------------------------
%   This algorithm only works on compact and non empty metalng objects. If these conditions
%   are met, then the list of words and the elements of the metalanguage object are traversed
%   independently. 
%-------------------------------------------------------------------------------------------

if ~isa(ML, 'metalng') | ~iscell(List), error('Invalid syntax for metalng object evaluation.'); end
if ~strcmpi(ML.Status, 'compact'), ML = squeeze(ML); end

NVtx   = length(ML);
CurVtx = 1;

NLst   = length(List);
CurLst = 1;

Aborted = 0;
while CurLst <= NLst, 
    Edges   = ML.Edges{CurVtx};
    RefVtx  = ML.Vertices(Edges);
    LstElem = List{CurLst};
    
    idx = checkVtx(RefVtx, LstElem);
    if isempty(idx), 
        Aborted = 1; break;
    else,    
        CurVtx = Edges(idx);
        CurLst = CurLst + 1;
    end
end

Edges = ML.Edges{CurVtx};
if ~Aborted & ismember(NVtx, Edges), boolean = logical(1); 
else, boolean = logical(0); end

%---------------------------------------local functions------------------------------------
function idx = checkVtx(Vertices, ListElem)

N = length(Vertices); idx = [];
for n = 1:N, 
    Vertex = Vertices{n};
    [isFR, EvalFunc] = isFuncRef(Vertex);
    if isFR & feval(EvalFunc, ListElem), idx = n; break;
    elseif ~isFR & isequal(Vertex, ListElem), idx = n; break; end
end

function [boolean, EvalFunc] = isFuncRef(Vertex)

if ~isempty(Vertex) & isequal(Vertex(1), '<') & isequal(Vertex(end), '>'),
    boolean  = logical(1);
    EvalFunc = Vertex(2:end-1);
else,
    boolean  = logical(0);
    EvalFunc = '';
end