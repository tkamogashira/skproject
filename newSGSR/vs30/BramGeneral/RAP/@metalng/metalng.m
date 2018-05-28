function ML = metalng(varargin)
%METALNG - constructor for metalng object, an object that represents a metalanguage
%   METALNG creates an empty metalng object, i.e. an object with only one element. 
%   This element is source and sink at the same time.
%
%   METALNG(<metalng object>) returns the object. This is the copy constructor.
%
%   METALNG('literal', <char>) makes a metalanguage object with only one element
%   different from the source and the sink. This element contains a literal string.
%
%   METALNG('func', <char>) creates an object with again only one element different
%   from the source and the sink, and this element contains a reference to a MATLAB
%   function. This function should return a scalar logical and must accept one input
%   argument, the element of the text that is being evaluated as a character string.
%
%   The following operators are defined on a metalng object:
%       &  : concatenation of two metalanguage objects (AND.M)
%       |  : union of two objects (OR.M)
%       ~  : include the metalng object zero or one time in the resulting object (NOT.M)
%       .' : include one or more times (TRANSPOSE.M)
%       '  : include zero or more times (CTRANSPOSE.M)
%   The standard MATLAB precedence applies to these operators.
%
%   Functions that are overloaded:
%       ISEMPTY.M : returns 1 of metalng object has only one element (and can therefore
%                   be considered empty), else returns 0.
%       LENGTH.M  : returns the number of elements in an object, including source, sink
%                   and possible empty elements.
%       SQUEEZE.M : returns a metalng object with all empty elements removed.
%       EVAL.M    : evaluates of tekst given by a cell-array of strings belongs to the
%                   language specified by a metalng object.
%
%   See also the aformentioned overloaded M-files.

%B. Van de Sande 09-10-2003

%-----------------------------------Implementation details--------------------------------- 
%   Each metalng object contains three fields:
%   Vertices : a cell-array containing the contents of the vertices (or elements) of the 
%              language. This content is always a character string, differentiating a
%              literal string from a function name by enclosing the latter between < and >.
%   Edges    : a cell-array with a rowvector for each vertex. This rowvector contains the
%              number of all the other vertices to which the vertex has connections (or
%              edges).
%   Status   : 'compact', meaning that all empty elements are removed, or 'composed' 
%              denoting a language being formed, thus still containing empty vertices.
%-------------------------------------------------------------------------------------------

%Creation of empty metalng object ...
if nargin == 0
    ML.Vertices   = cell(1); 
    ML.Edges      = cell(1);
    ML.Status     = 'composed';
%Copy constructor ...    
elseif nargin == 1 && isa(varargin{1}, 'metalng')
    ML = varargin{1};
    return
%Creation of singleton metalanguage with literal content ...    
elseif nargin == 2 && strncmpi(varargin{1}, 'l', 1) && ischar(varargin{2})
    if isempty(varargin{2})
        error('Literal language elements cannot be the empty string.');
    end
    ML.Vertices = {'', varargin{2}, ''};
    ML.Edges    = { 2, 3, [] };
    ML.Status   = 'composed';
%Creation of singleton metalanguage with function reference as content ...    
elseif nargin == 2 && strncmpi(varargin{1}, 'f', 1) && ischar(varargin{2})
    if ~exist(varargin{2}, 'file')
        error('Evaluation function for language element doesn''t exist.'); 
    end
    ML.Vertices = {'', ['<' varargin{2} '>'], ''};
    ML.Edges    = { 2, 3, [] };
    ML.Status   = 'composed';
%Defining metalng object with structure ... Internal purpose ...
elseif nargin == 2 && strncmpi(varargin{1}, 'c', 1) && isstruct(varargin{2})
    S = varargin{2};
    if ~all(ismember({'Vertices', 'Edges', 'Status'}, fieldnames(S))) && ...
       ~isequal(size(S.Vertices), size(S.Edges)) && (size(S.Vertices, 1) ~= 1) && ...
       ~ismember(S.Status, {'compact', 'composed'})
         error('Metalng object cannot be defined by given structure.');
    end
    ML.Vertices = S.Vertices;
    ML.Edges    = S.Edges;
    ML.Status   = S.Status;
else
    error('Invalid creation of metalng object.');
end

ML = class(ML, 'metalng');
