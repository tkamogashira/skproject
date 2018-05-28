function y=DecompactArray(cy);
% y=DecompactArray(cy);

dy = double(cy.dy)/(2^cy.Nbit-1);
dy = dy*cy.scale;
dy = dy+cy.mind;
N = length(dy);
x = linspace(0,1,N);
y = polyval(cy.PP,x)+dy;
y = reshape(y,cy.siz);

function cy = CompactArray(y,Nbit);
% cy = CompactArray(y,Nbit)
if nargin<2, Nbit=8; end;

siz = size(y);
y = y(:).';

% remove poly trend
N = length(y)
x = linspace(0,1,N);
PP = polyfit(x,y,1);
dy = y-polyval(PP,x);

% normalize into [0 1]
mind = min(dy);
dy = dy-mind;
scale = max(dy);
dy = dy/scale;
if Nbit==8,
   dy = uint8(dy*255);
else
   dy = uint16(dy*(2^16-1));
end
createdby = mfilename
cy = collectInStruct(Nbit, siz, PP, mind, scale, dy, createdby);
