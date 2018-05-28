function R = EvalPFExpr(RAPStat, PFExpr)
%EvalPFExpr evaluates expression in postfix format
%   R = EvalPFExpr(RAPStat, PFExpr) evaluates postfix expression, given by
%   cell-array PFExpr, and returns result as double R.
%
%   See also TransExprIF2PF
%

%B. Van de Sande 20-02-2004

Stk = stack;

NTokens = length(PFExpr);
for n = 1:NTokens,
    Token = PFExpr{n};
    if isRAPBinOperator(Token), 
        %Binary operators take two elements from the stack and push one element
        %back ...
        try, [Stk, ROp] = pop(Stk); catch, R = []; return; end;
        try, [Stk, LOp] = pop(Stk); catch, R = []; return; end;
        
        %Use array operations, cause operands can be vectors ...
        if ~any([length(ROp), length(LOp)] == 1) & ~isequal(size(ROp), size(LOp)), R = []; return; end;
        if any(strcmpi(Token, {'*', '/', '^'})), R = eval(['LOp.' Token 'ROp']);
        else, R = eval(['LOp' Token 'ROp']); end     
        
        Stk = push(Stk, R);
    elseif isRAPUnOperator(Token),
        %Unary operators only take one element from the stack, change it, and
        %put it back on the stack ...
        try, [Stk, Op] = pop(Stk); catch, R = []; return; end;
        
        if strcmp(Token, '~'), Token = '-'; end %Unary minus ...
        
        R = eval([Token 'Op']);
        
        Stk = push(Stk, R);
    elseif isnumeric(Token), %Operands are simply pushed onto the stack ...
        Stk = push(Stk, Token);
    elseif isRAPMemVar(Token, 'double'),
        Value = GetRAPMemVar(RAPStat, Token);
        if isempty(Value), R = []; return;
        else, Stk = push(Stk, Value); end
    elseif isRAPSubstVar(Token, 'double'),
        Value = GetRAPSubstVar(RAPStat, Token);
        if isempty(Value), R = []; return;
        else, Stk = push(Stk, Value); end
    else, R = []; return; end
end

if (length(Stk) == 1), [Stk, R] = pop(Stk); 
else, R = []; end