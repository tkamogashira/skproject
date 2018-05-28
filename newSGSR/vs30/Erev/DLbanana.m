function DLbanana(d,md, mconf);
% XLbanana(XL) - set comp. delay of bananaplot
%   optional second arg: max best delay
%   optional third  arg: min conf to plot

global SavePrevBNfigs
if ~isempty(SavePrevBNfigs),
   saveBanana;
   aa;
end


banana('setdelay',d);
orange('setdelay',d);
if nargin>1,
   banana('maxdelay',md);
end
if nargin>2,
   banana('minconf',mconf);
end

