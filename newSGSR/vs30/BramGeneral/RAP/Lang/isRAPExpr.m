function boolean = isRAPExpr(Token)
%isRAPXXX  code for evaluation of complex RAP tokens
%   boolean = isRAPXXX(Token)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-11-2003

boolean = logical(0); %Pessimistic approach ...

%Translation of expression in infix form to postfix form, only if
%expression is not a character substitution string ...
if isRAPSubstVar(Token, 'char'), boolean = logical(1);
else, 
    [PFExpr, ErrTxt] = TransExprIF2PF(Token);
    if ~isempty(ErrTxt), return; end

    %Checking the running sum of the postfix expression. The running sum
    %starts with 0 at the first token and according to the type of token
    %a value as added to the running sum:
    %   1.For a binary operator, decrease the running sum by one
    %   2.Unary operators do not change the running sum
    %   3.Augment the running sum with one for each operand
    %During this process the running sum may never drop below 1, and at
    %the end, the running sum must be one.
    NTokens = length(PFExpr); RunSum = 0;
    for n = 1:NTokens,
        Token = PFExpr{n};
        if isRAPBinOperator(Token), RunSum = RunSum - 1;
        elseif isRAPOperand(Token), RunSum = RunSum + 1;
        elseif isRAPUnOperator(Token),
        else, return; end
        
        if RunSum < 1, return; end
    end
    
    if RunSum ==1, boolean = logical(1); end
end