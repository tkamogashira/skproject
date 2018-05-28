function Clist = AddJbutton(Parent, Label, Tag, callbackfnc, Clist);
% addJmenu - add java button to menubar or parent menu
%  Clist = AddJmenu(Container, Label, Tag, callbackfnc)
%  adds java Jbuttons to existing Container and returns 
%  them as fields of a struct Clist; the fieldnames are the Tags 
%  of the respective components.
%
%  Clist =  AddJmenu(Container, Label, Tag, callbackfnc, Clist) 
%  adds the new components to the existing struct Clist.
%
%  The MatLab convention of ampersands in labels is implemented,
%  for example AddJmenu(JMenubar , '&File', ..) will result in the 'F' 
%  of the 'File' label to be underscored and usable as a mnemonic.
%
%  See also AddUImenu.

if nargin<1, h = gcf; end;
if nargin<2, Label = 'XXX'; end;
if nargin<3, Tag = 'XXX'; end;
if nargin<4, callbackfnc = nan; end;
if nargin<5, Clist = []; end;

% make sure Label & Tag are cellstrings
Label = cellstr(Label);
Tag = cellstr(Tag);
% conventional postfix of tags
TagpostFix = 'Button';

Nbutton = length(Label);
for ii=1:Nbutton,
   label = Label{ii};
   tag = [Tag{ii} TagpostFix];
   MnemChar = ''; % mnemonic character - see below
   if ~isempty(strfind(label, '&')),% &Label means that L is mnemonic (MatLab convention)
      iamp = strfind(label, '&');  % location of ampersand
      MnemChar = label(iamp+1);
      label(iamp) = ''; % remove ampersand
   end
   JJ = javaObject('javax.swing.JButton', label);
   set(JJ, 'tag', tag);
   set(JJ, 'MouseClickedCallBack', callbackfnc);
   if ~isempty(MnemChar), JJ.setMnemonic(MnemChar); end;
   Parent.add(JJ);
   Clist = setfield(Clist, tag, JJ);
end


