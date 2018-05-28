function x = vcolon(K);
% vcolon - colon operator accepting vector input
%    vcolon(K), with K a numerical vector, is the same as 
%    K(1):K(2) when length(K)==2, and is equal to
%    K(1):K(2):K(3) when length(K)==3.
%    
%    See also COLON.

args = num2cell(K);
try,
    x = colon(args{:});
catch,
    error(lasterr);
end

