function Tree = ParseLogicExpr(Str)
%PARSELOGICEXPR    parse a logical expression.
%   T = PARSELOGICEXPR(Str) parses the logical expression supplied as a character
%   string Str and returns the parse tree T. The logical expression must have the 
%   MATLAB syntax, and allows for an extra lexical element, namely the fieldname
%   which must be enclosed between dollar signs.

%B. Van de Sande 09-07-2004

%-------------------------implementation details------------------------------
%Recursive descent parser for the following context-free grammar (which
%represents the MATLAB style of expressions):
%ST -> LO <End>                                       Start symbol ...
%LO -> LA [ "|" LA ]*                                 Logical expression (OR) ...
%LA -> RE [ "&" RE ]*                                 Logical expression (AND) ...
%RE -> CO [ ["=="|"<="|">="|"~="|">"|"<"] CO]*        Relational expressions ...
%CO -> AE ~[":" AE ~[":" AE]]                         Colon operator ...
%AE -> AM [ ["+"|"-"] AM ]*                           Arithmetic expression (+,-) ...
%AM -> AU [ [".*"|"./"|".\"|"*"|"/"|"\"] AU ]*        Arithmetic expression (*,/) ...
%AU -> ~["+"|"-"|"~"] AP                              Arithmetic and logical unary operators ...
%AP -> [ PA [ [".^"|"^"]  PA ]* ] | [ PA [".'"|"'"] ] Arithmetic expression (^,') ...
%PA -> ["(" LO ")"] | OP                              Parenthesis ...
%OP -> FC | FN | CA | MA | CL | SC                    Operand ...
%FC -> <ID> ~["(" LE [","  LE ]* ")"]                 Function call ...
%FN -> "$" <ID> "$"                                   Fieldname ...
%CA -> "'" <String> "'"                               Character string ...
%MA -> "[" LO [ [","|";"] LO ]* "]"                   Matrix ...
%CL -> "{" LO [ [","|";"] LO ]* "}"                   Cell array ...
%SC -> <Number>                                       Scalar ...  
%----------------------------------------------------------------------------- 

try, Tree = ParseST(Str);
catch, 
    %Errors are catched to avoid the presence of the function call stack in the
    %error message. Extra newlines are also removed from the message ...
    ErrMsg = lasterr; idx = find(ErrMsg == char(10)); %ASCII character NewLine ...
    Eidx = idx(min(find(diff(idx) == 1)))-1;
    error(ErrMsg(1:Eidx));
end

%-----------------------------local functions---------------------------------
function [Token, idx] = GetNextToken(Str, idx)
%Simple tokenizer ...

%Special characters which are recognized ...
Operators  = {'|', '&', '~', '==', '<=', '>=', '~=', '>', '<', ':', '+', '-', '.*', './', '.\', ...
        '*', '/', '\', '.''', '.^', '''', '^'};
Separators = {'(', ')', '[', ']', '{', '}', ',', ';', '$'};

%Remove leading white spaces ...
idx = idx + min(find(~isspace(Str(idx:end)))) - 1;

%Retrieve next token ...
OpChar      = char(Operators); 
FirstOpChar = unique(OpChar(:, 1));
SecOpChar   = unique(OpChar(:, 2)); 
SecOpChar(find(isspace(SecOpChar))) = [];

AllSpecChars = char([Operators, Separators, {' '}]);
AllSpecChars = unique(AllSpecChars(:));

if ismember(Str(idx), FirstOpChar),
    if (idx < length(Str)) & ismember(Str(idx+1), SecOpChar), Token = Str(idx+[0,1]); idx = idx + 2;
    else, Token = Str(idx); idx = idx + 1; end
    if ~ismember(Token, Operators), error(sprintf('''%s'' is an invalid operator.', Token)); end
elseif ismember(Str(idx), Separators),
    Token = Str(idx);
    idx = idx + 1;
else,    
    idx2 = idx + min(find(ismember(Str(idx:end), AllSpecChars))) - 2;
    if isempty(idx2), idx2 = length(Str); end
    Token = deblank(Str(idx:idx2)); %Remove trailing white spaces ...
    idx = idx2 + 1;
end

%----------------------------------------------------------------------------- 
function Tree = ParseST(Str)
%Recursive function for production rule:
%ST -> LO <End>

if ~ischar(Str), error('Expression should be a character string.'); end
if (size(Str, 1) ~= 1) | all(Str == blanks(1)), error('No expression supplied.'); end

if ~isempty(Str),
    [Tree, idx] = ParseLO(Str, 1);
    if ~isequal(idx, length(Str)+1), error('Invalid syntax for expression.'); end
else, Tree = struct([]); end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseLO(Str, idx)
%Recursive function for production rule:
%LO -> LA [ "|" LA ]*

%Attention! The logical operator OR is commutative so multiple OR's in a sequence
%are stored as only one node in the parse tree ...
n = 1;
while 1,
    [OperandTree(n), idx] = ParseLA(Str, idx);
    [Token, nidx] = GetNextToken(Str, idx);
    if ~strcmpi(Token, '|'), break; 
    else, n = n + 1; idx = nidx; end
end    

if (length(OperandTree) == 1), Tree = OperandTree;
else,    
    Tree.value = '|';
    Tree.type  = 'operator';
    Tree.edges = OperandTree(:);
end    

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseLA(Str, idx)
%Recursive function for production rule:
%LA -> RE [ "&" RE ]*

%Attention! The logical operator AND is commutative so multiple AND's in a sequence
%are stored as only one node in the parse tree ...
n = 1;
while 1,
    [OperandTree(n), idx] = ParseRE(Str, idx);
    [Token, nidx] = GetNextToken(Str, idx);
    if ~strcmpi(Token, '&'), break;
    else, n = n + 1; idx = nidx; end
end    

if (length(OperandTree) == 1), Tree = OperandTree;
else,    
    Tree.value = '&';
    Tree.type  = 'operator';
    Tree.edges = OperandTree(:);
end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseRE(Str, idx)
%Recursive function for production rule:
%RE -> CO [ ["=="|"<="|">="|"~="|">"|"<"] CO]*

%Attention! The relational operators ==, ~= are commutative so multiple operators's
%in a sequence are stored as only one node in the parse tree ...
[Tree, idx] = ParseCO(Str, idx);
while 1,
    [Token, nidx] = GetNextToken(Str, idx);
    switch Token
    case {'==', '~='}, [Tree, idx] = ParseComOp(Token, @ParseCO, Tree, Str, nidx);
    case {'<=', '>=', '>', '<'},
        LOperandTree = Tree;
        [ROperandTree, idx] = ParseCO(Str, nidx);
        
        Tree.value = Token;
        Tree.type  = 'operator';
        Tree.edges = [LOperandTree; ROperandTree];
    otherwise, break; end
end    

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseCO(Str, idx)
%Recursive function for production rule:
%CO -> AE ~[":" AE ~[":" AE]]

[Tree, idx] = ParseAE(Str, idx);
[Token, nidx] = GetNextToken(Str, idx);
if strcmpi(Token, ':'),
    LOperandTree = Tree; [ROperandTree, idx] = ParseAE(Str, nidx);
    
    [Token, nidx] = GetNextToken(Str, idx);
    if strcmpi(Token, ':'),
        MOperandTree = ROperandTree; [ROperandTree, idx] = ParseAE(Str, nidx);
    else, MOperandTree = []; end
    
    Tree.value = ':';
    Tree.type  = 'operator';
    Tree.edges = [LOperandTree; MOperandTree; ROperandTree];
end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseAE(Str, idx)
%Recursive function for production rule:
%AE -> AM [ ["+"|"-"] AM ]* 

%Attention! The arithmetic operator + is commutative so multiple plusses
%in a sequence are stored as only one node in the parse tree ...
[Tree, idx] = ParseAM(Str, idx);
while 1,
    [Token, nidx] = GetNextToken(Str, idx);
    if strcmpi(Token, '+'), [Tree, idx] = ParseComOp('+', @ParseAM, Tree, Str, nidx);
    elseif strcmpi(Token, '-'),    
        LOperandTree = Tree; [ROperandTree, idx] = ParseAM(Str, nidx);
        
        Tree.value = Token;
        Tree.type  = 'operator';
        Tree.edges = [LOperandTree; ROperandTree];
    else, break; end
end    

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseAM(Str, idx)
%Recursive function for production rule:
%AM -> AU [ [".*"|"./"|".\"|"*"|"/"|"\"] AU ]*

%Attention! The arithmetic operators .* and * are commutative ...
[Tree, idx] = ParseAU(Str, idx);
while 1,
    [Token, nidx] = GetNextToken(Str, idx);
    switch Token
    case {'.*', '*'}, [Tree, idx] = ParseComOp(Token, @ParseAU, Tree, Str, nidx);
    case {'./', '.\', '/', '\'},
        LOperandTree = Tree; [ROperandTree, idx] = ParseAU(Str, nidx);
        
        Tree.value = Token;
        Tree.type  = 'operator';
        Tree.edges = [LOperandTree; ROperandTree];
    otherwise, break; end    
end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseComOp(Op, OpFnc, OperandTree, Str, idx)
%Recursive function used to parse a commutative operator ...

n = 2;
while 1,
    [OperandTree(n), idx] = feval(OpFnc, Str, idx);
    [Token, nidx] = GetNextToken(Str, idx);
    if ~strcmpi(Token, Op), break; 
    else, n = n + 1; idx = nidx; end
end    

Tree.value = Op;
Tree.type  = 'operator';
Tree.edges = OperandTree(:);

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseAU(Str, idx)
%Recursive function for production rule:
%AU -> ~["+"|"-"|"~"] AP 

%Attention! The unary plus is a meaningless operator so no node is created in
%the parse tree for this operator ...
[Token, nidx] = GetNextToken(Str, idx);
if any(strcmpi(Token, {'-', '~'})),
    [OperandTree, idx] = ParseAP(Str, nidx);
    
    Tree.value = Token;
    Tree.type  = 'operator';
    Tree.edges = OperandTree;
elseif strcmpi(Token, '+'), idx = nidx;
else, [Tree, idx] = ParseAP(Str, idx); end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseAP(Str, idx)
%Recursive function for production rule:
%AP -> [ PA [ [".^"|"^"]  PA ]* ] | [ PA [".'"|"'"] ]

[Tree, idx] = ParsePA(Str, idx);
[Token, nidx] = GetNextToken(Str, idx); 
if any(strcmpi(Token, {'.''', ''''})),
    OperandTree = Tree; idx = nidx;
    Tree.value = Token;
    Tree.type  = 'operator';
    Tree.edges = OperandTree;
else,    
    while any(strcmpi(Token, {'.^', '^'})),
        LOperandTree = Tree; [ROperandTree, idx] = ParsePA(Str, nidx);
        
        Tree.value = Token;
        Tree.type  = 'operator';
        Tree.edges = [LOperandTree; ROperandTree];
        [Token, nidx] = GetNextToken(Str, idx); 
    end
end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParsePA(Str, idx)
%Recursive function for production rule:
%PA -> ["(" LO ")"] | OP

[Token, nidx] = GetNextToken(Str, idx);
if strcmpi(Token, '('),
    [Tree, idx] = ParseLO(Str, nidx);
    [Token, idx] = GetNextToken(Str, idx);
    if ~strcmpi(Token, ')'), error('Parenthesis should match up.'); end
else, [Tree, idx] = ParseOP(Str, idx); end

%-----------------------------------------------------------------------------    
function [Tree, idx] = ParseOP(Str, idx)
%Recursive function for production rules:
%OP -> FC | FN | CA | MA | CL | SC
%FC -> <ID> ~["(" LE [","  LE ]* ")"]
%FN -> "$" <ID> "$"
%CA -> "'" <String> "'"
%MA -> "[" LO [ [","|";"] LO ]* "]"
%CL -> "{" LO [ [","|";"] LO ]* "}"
%SC -> <Number>

[Token, idx] = GetNextToken(Str, idx);
if isvarname(Token), %Function call or memory variable...
    Tree.value = Token;
    Tree.type  = 'fnc/var';
    [Token, nidx] = GetNextToken(Str, idx);
    if strcmpi(Token, '('),
        [Tree.edges(1), idx] = ParseLO(Str, nidx); n = 2;
        while 1,
            if (idx > length(Str)), error(sprintf('Invalid argument list for function ''%s''.', Tree.value));
            else, [Token, nidx] = GetNextToken(Str, idx); end
            
            if strcmpi(Token, ')'), idx = nidx; break;
            elseif strcmpi(Token, ','), [Tree.edges(n), idx] = ParseLO(Str, nidx); n = n + 1;
            else, error(sprintf('Invalid argument list for function ''%s''.', Tree.value)); end
        end
    else, Tree.edges = struct([]); end
elseif strcmpi(Token, '['), %Matrix ...
    Tree.value = [];
    Tree.type  = 'matrix';
    [Tree.edges, idx] = ParseMatEntries(']', Str, idx, 'Square brackets');
elseif strcmpi(Token, '{'), %Cell ...
    Tree.value = [];
    Tree.type  = 'cell';
    [Tree.edges, idx] = ParseMatEntries('}', Str, idx, 'Curly braces');
elseif strcmpi(Token, ''''), %Character string ...
    idx2 = idx + min(find(Str(idx+1:end) == '''')) - 1;
    if ~isempty(idx2), String = Str(idx:idx2);
    else, error('Single quotes should match up.'); end
    idx = idx2 + 2;
    
    Tree.value = String;
    Tree.type  = 'string';
    Tree.edges = struct([]);
elseif strcmpi(Token, '$'), %Fieldname ...
    idx2 = idx + min(find(Str(idx+1:end) == '$')) - 1;
    if ~isempty(idx2), FieldName = Str(idx:idx2);
    else, error('Dollar signs should match up.'); end
    idx = idx2 + 2;
    
    Tree.value = FieldName;
    Tree.type  = 'fieldname';
    Tree.edges = struct([]);
else, %Scalar ...
    Nr = str2num(Token);
    if ~isempty(Nr), 
        Tree.value = Nr;
        Tree.type  = 'scalar';
        Tree.edges = struct([]);
    else, error(sprintf('Invalid syntax for scalar: ''%s''.', Token)); end
end

%-----------------------------------------------------------------------------
function [Edges, idx] = ParseMatEntries(EndSep, Str, idx, ErrStr)

[Token, nidx] = GetNextToken(Str, idx);
if strcmpi(Token, EndSep), Edges = struct([]); idx = nidx;
else,   
    [Edges(1, 1), idx] = ParseLO(Str, idx); r = 1; c = 1; cDef = 0;        
    while 1,
        if (idx > length(Str)), error(sprintf('%s should match up.', ErrStr));
        else, [Token, nidx] = GetNextToken(Str, idx); end
        
        switch Token,
        case EndSep, 
            if (cDef > 0) & (c < cDef), 
                error('All rows in the bracketed expression must have the same number of columns.'); 
            end
            idx = nidx;
            break;    
        case ',', 
            c = c + 1;
            if (cDef > 0) & (c > cDef), 
                error('All rows in the bracketed expression must have the same number of columns.'); 
            end    
        case ';', 
            r = r + 1; 
            if (cDef > 0) & (c < cDef), 
                error('All rows in the bracketed expression must have the same number of columns.');
            end;
            cDef = c; c = 1;
        otherwise, %No separator used ...
            c = c + 1;
            if (cDef > 0) & (c > cDef), 
                error('All rows in the bracketed expression must have the same number of columns.'); 
            end
            nidx = idx;
        end
        [Edges(r, c), idx] = ParseLO(Str, nidx);
    end    
end

%-----------------------------------------------------------------------------