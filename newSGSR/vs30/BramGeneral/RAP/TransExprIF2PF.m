function [PFExpr, ErrTxt] = TransExprIF2PF(IFExpr)
%TransExprIF2PF     translate expression from infix to postfix format
%   PFExpr = TransExprIF2PF(IFExpr) translate expression in infix format, given by
%   cell-array IFExpr, to expression in postfix format.
%   
%   [PFExpr, ErrTxt] = TransExprIF2PF(IFExpr), errors can be handled by the calling
%   program by analyzing the character string ErrTxt.
%
%   See also EvalPFExpr

%B. Van de Sande 14-10-2003

%An expression of one element is not returned as a cell-array by the
%tokenizer ...
if ~iscell(IFExpr), IFExpr = {IFExpr}; end

ErrTxt = '';

%----------------------------------implementation details----------------------------
%   The key to the algoritm is delaying the operators until all its right operand is 
%   fully defined.
%------------------------------------------------------------------------------------

DelOpStk = deal(stack); %Delayed operator stack ...
PFExpr   = cell(0);

NTokens = length(IFExpr);
for TokenNr = 1:NTokens
    Token = IFExpr{TokenNr};
    if isRAPoperand(Token), %Operand ...
        PFExpr = cat(2, PFExpr, {Token});
    elseif strcmp(Token, '('), %Parenthesis ...
        DelOpStk = push(DelOpStk, Token);
    elseif strcmp(Token, ')'),
        try, [DelOpStk, Operator] = pop(DelOpStk); 
        catch, ErrTxt = 'Invalid infix expression'; return; end
        while ~strcmp(Operator, '(')
            PFExpr = cat(2, PFExpr, {Operator});
            try, [DelOpStk, Operator]   = pop(DelOpStk);
            catch, ErrTxt = 'Invalid infix expression'; return; end
        end 
    elseif isRAPoperator(Token), %Operator ... Taking unary and binary operators together ...
        EndRightOperand = 0;
        while ~EndRightOperand
            if isempty(DelOpStk), EndRightOperand = 1;
            elseif strcmp(showtop(DelOpStk), '('), EndRightOperand = 1;
            elseif GetRAPOpPrecedence(showtop(DelOpStk)) < GetRAPOpPrecedence(Token), EndRightOperand = 1;
            elseif (GetRAPOpPrecedence(showtop(DelOpStk)) == GetRAPOpPrecedence(Token)) & ...
                   (GetRAPOpPrecedence(Token) == 3), EndRightOperand = 1;
            else    
                EndRightOperand = 0;
                try, [DelOpStk, Operator] = pop(DelOpStk);
                catch, ErrTxt = 'Invalid infix expression'; return; end
                PFExpr = cat(2, PFExpr, {Operator});
            end
        end
        DelOpStk = push(DelOpStk, Token);
    else, 
        ErrTxt = 'Invalid infix expression'; 
        return;
    end
end

while ~isempty(DelOpStk)
    [DelOpStk, Operator] = pop(DelOpStk);
    PFExpr = cat(2, PFExpr, {Operator});
end