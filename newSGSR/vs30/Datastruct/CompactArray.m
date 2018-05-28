function cy = CompactArray(y,Nbit);
% cy = CompactArray(y,Nbit)
if nargin<2, Nbit=8; end;

siz = size(y);
y = y(:).';

% remove poly trend
N = length(y);
x = linspace(0,1,N);
PP = polyfit(x,y,20);
dy = y-polyval(PP,x);

% normalize into [0 1]
mind = min(dy);
dy = dy-mind;
scale = max(dy);
if scale==0, scale=1; end;
dy = dy/scale;
if Nbit==8,
   dy = uint8(0.5+dy*255);
else
   dy = uint16(0.5+dy*(2^16-1));
end
createdby = mfilename;
cy = collectInStruct(Nbit, siz, PP, mind, scale, dy, createdby);
