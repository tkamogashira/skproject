function y=STIMMENUchannelSelect(N);

if nargin<1, N=3; end;

h= gcbo;
selexions = {'Both' 'Left' 'Right'};
currentSel = get(h,'string');
currentSel = currentSel{1}; % tricky: 'get' returns cell array
csel = 3;
if isequal(currentSel,selexions{1}), csel = 1; end;
if isequal(currentSel,selexions{2}), csel = 2; end;
nsel = 1+rem(csel, 3);
if (N==2) & (nsel==1), nsel=2; end;
set(h,'string',selexions(nsel));
drawnow;