function Str = Param2Str(V, Unit, Prec)
%PARAM2STR				Translate unit and value to formatted string
%                      
% DESCRIPTION
%                       Renders a string from a value and unit which can be
%						which may be used in header, plot titles,.. etc.
%
% INPUT     
%        V:				Value 
%        U:             Unit
%        Prec;			Precision
%           
% OUTPUT
%        Str:			Formatted string
%
% EXAMPLES
%		 A frequency (integer):
%		 V = 80; Unit = 'Hz'; Precision = 0
%        Str = Param2Str(V, Unit, Precision)

%% ---------------- CHANGELOG -----------------------
%  Tue Jan 18 2011  Abel   
%   - initial creation (stolen from EvalCLTR)

%% ---------------- Default parameters --------------
C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

%% ---------------- Main program --------------------
if (N == 1) || all(isequal(C{:}))
    Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2)
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1)
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end