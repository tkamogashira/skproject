function ma = qlegend(x,y, Styles, Strings, fontSize);
% QLEGEND - Quick quasi-automatic legend.

if nargin<5,
   FZ = {};
else,
   FZ  ={'fontsize', fontSize};
end

% frame
xplot([x(1) x(2)  x(2)  x(1)  x(1) ], [y(1) y(1) y(2) y(2) y(1) ],...
   'color', [0 0 0 ]);

NN = length(Strings);
Xmark = x(1)+0.15*(diff(x));
Xtext = x(1)+0.25*(diff(x));
DYmark = diff(y)/(NN+1);
Ymark = y(1)+0.5+((1:NN))*DYmark;
Ymark = Ymark(end:-1:1);
for ii=1:NN,
   styl = Styles{ii};
   styl = {styl{:} 'linestyle' 'none'};
   str = Strings{ii};
   xplot(Xmark, Ymark(ii), styl{:});
   text(Xtext, Ymark(ii), str, FZ{:})
end






