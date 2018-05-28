function Txt = indepVar2Str(IndepVar)
%indepVar2Str   converts dataset IndepVar structure to character string
%   Str = indepVar2Str(IndepVar)

Tol = 1e-3; %Numerical tolerance ...

IndepVal = unique(IndepVar.Values(~isnan(IndepVar.Values))); %For multiple independent variables ...
DiffVal  = unique(roundoff(diff(IndepVal), Tol));
if (length(DiffVal) == 1)
    Step = DiffVal;
    StepMode = 'LIN'; %Linear ...
elseif (length(IndepVal) > 1) && all(IndepVal > 0)
    Step = log2(IndepVal(2)/IndepVal(1));
    StepMode = 'LOG'; %Logaritmic ...
elseif (length(IndepVal) > 1)
    Step = NaN;
    StepMode = 'NONE';
else %Only one value for independent variable ...
    Step = NaN;
    StepMode = 'SINGLETON';
end

if ~isempty(IndepVar.Unit) && strcmp(StepMode, 'NONE')
    Txt = sprintf('[%.0f..%.0f] (%s)', min(IndepVal), max(IndepVal), IndepVar.Unit);
elseif strcmp(StepMode, 'NONE')
    Txt = sprintf('[%.0f..%.0f]', min(IndepVal), max(IndepVal));
elseif ~isempty(IndepVar.Unit) && strcmp(StepMode, 'SINGLETON'),
    Txt = sprintf('%.0f(%s)', IndepVal, IndepVar.Unit);
elseif strcmp(StepMode, 'SINGLETON')
    Txt = sprintf('%.0f', IndepVal);
elseif ~isempty(IndepVar.Unit) && strcmp(StepMode, 'LIN')
    Txt = sprintf('[%.0f..%.0f@%s] (%s)', min(IndepVal), max(IndepVal), Val2Str(Step), IndepVar.Unit);
elseif ~isempty(IndepVar.Unit)
    Txt = sprintf('[%.0f..%.0f@%s(Oct)] (%s)', min(IndepVal), max(IndepVal), Val2Str(Step), IndepVar.Unit);
elseif strcmp(StepMode, 'LIN')
    Txt = sprintf('[%.0f..%.0f@%s]', min(IndepVal), max(IndepVal), Val2Str(Step));
else
    Txt = sprintf('[%.0f..%.0f@%s(Oct)]', min(IndepVal), max(IndepVal), Val2Str(Step));
end

%-------------------------------------------------------------------------------
function V = roundoff(V, Tol)

V = round(V/Tol)*Tol;

%-------------------------------------------------------------------------------
function Str = Val2Str(Val)

if mod(Val, 1)
    Str = sprintf('%.2f', Val);
else
    Str = sprintf('%.0f', Val);
end
