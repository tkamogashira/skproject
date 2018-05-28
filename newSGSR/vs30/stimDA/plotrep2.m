function plotrep2(isub,offs);
if nargin<2, offs=0; end;
global PRPinstr
plL = PRPinstr.PLAY(isub).playList(1,:);
plR = PRPinstr.PLAY(isub).playList(2,:);

plL = plL(:); plL(end) = [];
plR = plR(:); plR(end) = [];
N = length(plL)/2;

plL = reshape(plL,[2 N]);
plR = reshape(plR,[2 N]);

L = [];
R = [];

for ii=1:N,
   dbnL = plL(1,ii);
   repL = plL(2,ii);
   dbnR = plR(1,ii);
   repR = plR(2,ii);
   L = [L repmat(dama2ml(dbnL),1,repL)];
   if (dbnR~=0), R = [R repmat(dama2ml(dbnR),1,repR)]; end
end
plot([L', offs+R'])

