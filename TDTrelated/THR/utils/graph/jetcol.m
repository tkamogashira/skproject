function C = jetcol(X, CMfun);
%  jetcol - color spec from jet colormap
%      jetcol(X) returns a struct having fields 'Color' and 
%      'MarkerFaceColor', both of which have values taken from the jet
%      colormap in such a way that jetcol(0) and jetcol(1) are the first
%      and the last row of that colormap. Arrays X result in struct array
%      output.
%
%      jetcol(X, @fun) uses colormap returned my function @fun.
%
%      See also fenceplot.

Ncol = 64;
CMfun = arginDefaults('CMfun', @jet);
CM = CMfun(Ncol);
%Ncol = size(CM,1);

iX = 1 + round(X*(Ncol-1));
for ii=1:numel(X),
    c = CM(iX(ii),:);
    C(ii) = struct('Color', c, 'MarkerFaceColor', c);
end





