function ggmark(n,yn);
% mark text edit by odd background color
if nargin<2,
   yn = 1;
end
if yn, c=[1 1 0]; else, c = [1 1 1]; end;
ggset(n,'backgroundcolor',0.749*c);

figure(gcf);
