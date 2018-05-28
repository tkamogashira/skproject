function y=MENUyesNoSelect;

h= gcbo;
selexions = {'Yes' 'No' };
currentSel = get(h,'string');
if iscell(currentSel),
   currentSel = currentSel{1}; % tricky: 'get' returns cell array??
end
csel = 2;
if isequal(currentSel,selexions{1}), csel = 1; end;
nsel = 1+rem(csel, 2);
set(h,'string',selexions(nsel));
drawnow;