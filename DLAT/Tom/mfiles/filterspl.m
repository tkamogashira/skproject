function ou = filterspl(D,ref)

% filterspl(struct array D, ref)
% Filters the x-val and y-val-values associated with the spl defined by the number ref (= the rank if spls are
% sorted from high to low) out of struct array D and returns the resulting struct array
%
% TF 01/09/2005

if ref==1, right=2;
elseif ref==2, right=1;
end

xval=D.xval; 
D.xval=xval(right);
yval=D.yval; 
D.yval=yval(right);
ou=D;