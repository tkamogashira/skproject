function [Tokens, ErrTxt] = TokenizeRAPStatement(Str)
%TokenizeRAPStatement    tokenize RAP statement
%   [Tokens, ErrTxt] = TokenizeRAPStatement(Str)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-03-2004

ErrTxt = '';

%Removing remarks ... In RAP remarks are given by starting a line with an
%asterisk or by using // at the end of a line ...
if ~isempty(Str) && isequal(Str(1), '*')
    Tokens = cell(0);
    return;
end
idx = min(strfind(Str, '//'));
if ~isempty(idx)
    Str = Str(1:idx-1);
end    

%Define character sets ...
Sets.Cipher     = '0123456789';
Sets.Letter     = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_';
Sets.AddChar    = '#\:.'; %These characters cannot be used at the beginning of an identifier ...
Sets.AlphaBet   = [Sets.Letter, Sets.AddChar];
Sets.AlphaNum   = [Sets.Cipher, Sets.AlphaBet];
Sets.Separators = '='; %Equal sign is not interpreted as an operator ...
Sets.Operators  = '+-*/^';
%Attention! Valid operators and separators are defined by the functions isRAPOperator.m
%and isRAPSeparator.m ...

%An alternative set for recognizing dataset IDs after the ID command ...
AltSets = Sets;
AltSets.AlphaNum = [Sets.AlphaNum, '+-*/^'];

%Tokenize statement ... In RAP the basic tokens are always separated by whitespaces,
%so these are separated first. Then each token, which can be a number, expression or 
%keyword, is further broken down in (sub)tokens. It is important to note that expressions 
%in RAP must be written without whitespaces ...
Tokens     = cell(0);
NTokens    = 1;
NSubTokens = 0;
InToken    = 0;

ParenCount = 0;
 
Pos = 1;
while Pos <= length(Str)
    if ismember(Str(Pos), Sets.Letter) %Word ...
        %For the RAP Commands DF, ID, EM, ED, OU DI, OU DS and OU ID the next argument may be a 
        %word containing an alternative set for alphanumerics, including the operators. This 
        %doesn't conflict with expression parsing because these commands do not except expressions ...
        if (~InToken && (NTokens >= 2) && (length(Tokens{end}) == 1) && any(strcmp(Tokens{end}{1}, {'df', 'id', 'em', 'ed'}))) || ...
           (~InToken && (NTokens >= 3) && all(cellfun('length', Tokens([end-1, end])) == 1) && strcmp(Tokens{end-1}{1}, 'ou') ...
           && any(strcmp(Tokens{end}{1}, {'di', 'ds', 'id'}))),
            NSubTokens = NSubTokens + 1; InToken = 1;
            [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseWord(AltSets, Str, Pos);
            if ~isempty(ErrTxt), return; end;
        else
            NSubTokens = NSubTokens + 1; InToken = 1;
            [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseWord(Sets, Str, Pos);
            if ~isempty(ErrTxt), return; end;
        end
    elseif ismember(Str(Pos), [Sets.Cipher '.']) %Number ...
        %The RAP command ID requires a dataset identifier as only argument. This ID
        %can begin with a number. So if previous token is 'ID' then always tokenize
        %the argument as an alphanumeric ...
        if ~InToken && (NTokens >= 2) && (length(Tokens{end}) == 1) && strcmp(Tokens{end}{1}, 'id'),
            NSubTokens = NSubTokens + 1; InToken = 1;
            [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseWord(AltSets, Str, Pos);
            if ~isempty(ErrTxt), return; end;
        %The RAP command OU DI, OU DS and OU ID require a dataset identifier or a number as
        %optional extra argument. This ID can begin with a number. The optional extra argument
        %is read as an alphanumeric, and afterwards checked if it was a number or an identifier ...
        elseif ~InToken && (NTokens >= 3) && all(cellfun('length', Tokens([end-1, end])) == 1) && ...
               strcmp(Tokens{end-1}{1}, 'ou') && any(strcmp(Tokens{end}{1}, {'di', 'id', 'ds'})),
            NSubTokens = NSubTokens + 1; InToken = 1;
            [Pos, TempToken, ErrTxt] = ParseWord(AltSets, Str, Pos);
            if ~isempty(ErrTxt), return; end;
            [Number, Count, ErrMsg] = sscanf(TempToken, '%d');
            if isempty(ErrMsg) && (Count == 1), TempToken = Number; end
            Tokens{NTokens}{NSubTokens} = TempToken;
        else
            NSubTokens = NSubTokens + 1; InToken = 1;
            [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseNumber(Sets, Str, Pos);
            if ~isempty(ErrTxt), return; end;
            %Unary negation followed by a number is not considered to be an expression. It
            %is replaced by the negative number ...
            if (NSubTokens ~= 1) && strcmp(Tokens{NTokens}{NSubTokens-1}, '~'),
                Tokens{NTokens}{NSubTokens-1} = -Tokens{NTokens}{NSubTokens};
                Tokens{NTokens}(NSubTokens) = [];
                NSubTokens = NSubTokens - 1;
            end
        end
    elseif strcmp(Str(Pos), '"') %Quoted string ...
        NSubTokens = NSubTokens + 1; InToken = 1;
        [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseQuotedString(Sets, Str, Pos);
        if ~isempty(ErrTxt), return; end;
    elseif ismember(Str(Pos), Sets.Operators) %Operators ...
        NSubTokens = NSubTokens + 1; InToken = 1;
        [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseOperator(Sets, Str, Pos);
        if ~isempty(ErrTxt), return; end;
        %Unary negation can be differentiated from binary negation by looking at the previous
        %token, if this token is again on operator or if there isn''t a prevoius token or 
        %if the previous token is a left parenthesis, then a minus sign can only be unary
        %negation ...
        if strcmp(Tokens{NTokens}{NSubTokens}, '-') && ...
           ((NSubTokens == 1) || isRAPOperator(Tokens{NTokens}{NSubTokens-1}) || strcmp(Tokens{NTokens}{NSubTokens-1},'(')),
            Tokens{NTokens}{NSubTokens} = '~'; %The tilde is the internal representation for unary minus ...
        end    
    elseif strcmp(Str(Pos), Sets.Separators) %Separators ...
        NSubTokens = NSubTokens + 1; InToken = 1;
        [Pos, Tokens{NTokens}{NSubTokens}, ErrTxt] = ParseSeparator(Sets, Str, Pos);
        if ~isempty(ErrTxt), return; end;
    elseif strcmp(Str(Pos), '(') %Parenthesis ...
        NSubTokens = NSubTokens + 1; InToken = 1;
        Tokens{NTokens}{NSubTokens} = '(';
        ParenCount = ParenCount + 1;
        Pos = Pos + 1;
    elseif strcmp(Str(Pos), ')')
        NSubTokens = NSubTokens + 1; InToken = 1;
        ParenCount = ParenCount - 1;
        if ParenCount < 0, 
            ErrTxt = 'Parenthesis in expression do not match'; 
            return;
        end
        Tokens{NTokens}{NSubTokens} = ')';
        Pos = Pos + 1;
    elseif isspace(Str(Pos)), %Whitespaces ...
        if InToken,
            NTokens = NTokens + 1;
            [NSubTokens, InToken] = deal(0);
        end    
        Pos = Pos + 1;
    else
        ErrTxt = sprintf('%s isn''t a valid character', Str(Pos));
        return;
    end    
end

%Tokens that have only one subtoken are not returned as a cell-array within a
%cell-array but are converted to an element of the first cell-array ...
if ~isempty(Tokens),
    idx = find(cellfun('length', Tokens) == 1);
    if ~isempty(idx), Tokens(idx) = eval(['[' sprintf('Tokens{%d} ', idx) ']']); end
end

%---------------------------------local functions-------------------------------------
function [Pos, Wrd, ErrTxt] = ParseWord(Sets, Str, Pos)

ErrTxt = '';

Wrd = '';
N = length(Str);
while (Pos <= N) && ismember(Str(Pos), [Sets.AlphaNum '.']) 
    Wrd = [ Wrd Str(Pos) ];
    Pos = Pos + 1;
end

Wrd = lower(Wrd); %Case-insensitive ...

%--------------------------------------------------------------------------------------
function [Pos, Nr, ErrTxt] = ParseNumber(Sets, Str, Pos)

ErrTxt = ''; Nr = [];

Wrd      = '';
DotCount = 0;
ExpCount = 0;
N = length(Str);
while (Pos <= N) && ismember(Str(Pos), [Sets.Cipher '.eE'])
    if isequal(Str(Pos), '.'), 
        DotCount = DotCount + 1;
        if ExpCount == 1, ErrTxt = 'Exponent must be integer'; return; end
        if DotCount > 1, ErrTxt = 'More then one dot in a number'; return; end
    elseif strcmpi(Str(Pos), 'e'),
        ExpCount = ExpCount + 1;
        if ExpCount > 1, ErrTxt = 'More then one exponent symbol in a number'; return; end
    end
    Wrd = [ Wrd Str(Pos) ]; Pos = Pos + 1;
end

%Conversion to double ...
if (length(Wrd) == 1) && any(strcmpi(Wrd, {'e', '.'})), ErrTxt = 'Invalid number notation'; return; end
Nr = str2num(Wrd); if isempty(Nr), ErrTxt = 'Couldn''t parse number'; return; end

%--------------------------------------------------------------------------------------
function [Pos, QStr, ErrTxt] = ParseQuotedString(Sets, Str, Pos)

ErrTxt = ''; 

QStr = '';
Pos = Pos + 1;
N = length(Str);
while ~strcmp(Str(Pos), '"') 
    QStr = [ QStr Str(Pos) ]; Pos = Pos + 1;
    if Pos > N, ErrTxt = 'Quotation marks in expression do not match'; return; end
end
Pos = Pos + 1;

%--------------------------------------------------------------------------------------
function [Pos, Op, ErrTxt] = ParseOperator(Sets, Str, Pos)

ErrTxt = '';

Op = '';
N = length(Str);
if (Pos <= N) && ismember(Str(Pos), Sets.Operators)
    Op = [Op Str(Pos)]; Pos = Pos + 1;
end

if ~isRAPOperator(Op), ErrTxt = 'Invalid operator'; return; end

%--------------------------------------------------------------------------------------
function [Pos, Sep, ErrTxt] = ParseSeparator(Sets, Str, Pos)

ErrTxt = '';

Sep = '';
N = length(Str);
if (Pos <= N) && ismember(Str(Pos), Sets.Separators)
    Sep = [Sep Str(Pos)]; Pos = Pos + 1;
end

if ~isRAPSeparator(Sep), ErrTxt = 'Invalid Separator'; return; end