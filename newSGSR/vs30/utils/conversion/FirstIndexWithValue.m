function [fi, isfirst]=FirstIndexWithValue(x);
% returns array fi(i) of indices of x indicating that 
% x(i) = x(fi(i)) where fi(i)<=i
% more precise, fi(i) = min{j; x(j)=x(i)}
x = x(:);
fi = zeros(1,length(x));
for ii=1:length(x),
   fi(ii) = min(find(x(ii)==x));
end
isfirst = (fi==(1:length(x)));
