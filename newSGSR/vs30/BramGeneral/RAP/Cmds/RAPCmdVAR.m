function [RAPStat, LineNr, ErrTxt] = RAPCmdVAR(RAPStat, LineNr, Var1, Op, Var2)
%RAPCmdVAR  code for interpretation of arithmetic operations on memory variables
%   [RAPStat, LineNr, ErrTxt] = RAPCmdVAR(RAPStat, LineNr, Var1, Op, Var2)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

ErrTxt = '';

%-------------------------------------RAP Syntax------------------------------------
%   V# = @@..@@               Set value of variable
%   V#1 @ V#2		          Replace V#1 using arithmetic opert. 
%                             (@ can be any one of +, -, *, /)
%   V#1 GCF V#2		          Compute Greatest Common Factor
%   C# = @@@...@@@		      Set value of character variable
%   C#1 + C#2	              Append C#2 to C#1 and store back in C#1
%-----------------------------------------------------------------------------------

if (nargin == 4), %The assignment operator can be omitted ...
    Var2 = Op;
    Op = '=';
end

if isRAPMemVar(Var1, 'double'),
    if strcmp(Op, '='),
        if isRAPSubstVar(Var2, 'char'), %Character substitution variable ...
            ErrTxt = 'Substitution variable cannot be assigned to numeric memory variable';
            return;
        else, %Valid numeric expression ...
            [PFExpr, ErrTxt] = TransExprIF2PF(Var2); if ~isempty(ErrTxt), return; end
            Value = EvalPFExpr(RAPStat, PFExpr); if isempty(Value), ErrTxt = 'Could not evaluate expression'; return; end
            RAPStat = SetRAPMemVar(RAPStat, Var1, Value);
        end    
    else,
        LHOp = GetRAPMemVar(RAPStat, Var1); 
        RHOp = GetRAPMemVar(RAPStat, Var2); 
        if isempty(LHOp) | isempty(RHOp), 
            ErrTxt = 'Memory variable is not yet assigned a value';
            return;
        end
        
        switch Op,    
        case '+', RAPStat = SetRAPMemVar(RAPStat, Var1, LHOp + RHOp);
        case '-', RAPStat = SetRAPMemVar(RAPStat, Var1, LHOp - RHOp);
        case '*', RAPStat = SetRAPMemVar(RAPStat, Var1, LHOp .* RHOp);
        case '/', RAPStat = SetRAPMemVar(RAPStat, Var1, LHOp ./ RHOp);
        %Greatest Common Factor ...    
        case 'gcf', RAPStat = SetRAPMemVar(RAPStat, Var1, gcd(LHOp,RHOp)); end
    end
elseif isRAPMemVar(Var1, 'char'),
    switch Op
    case '=', 
        [Var2, ErrTxt] = GetRAPChar(RAPStat, Var2); if ~isempty(ErrTxt), return; end
        RAPStat = SetRAPMemVar(RAPStat, Var1, Var2);
    case '+',
        LHOp = GetRAPMemVar(RAPStat, Var1);
        RHOp = GetRAPMemVar(RAPStat, Var2);
        if isempty(LHOp) | isempty(RHOp), 
            ErrTxt = 'Memory variable is not yet assigned a value';
            return;
        end
        RAPStat = SetRAPMemVar(RAPStat, Var1, [LHOp, RHOp]);
    end
end

LineNr = LineNr + 1;