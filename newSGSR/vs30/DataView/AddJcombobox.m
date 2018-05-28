function Clist = AddJcombobox(Parent, ItemList, Tag, callbackfnc, Clist);
% addJmenu - add java combo box item to menubar or parent menu
%  Clist = AddJcombobox(Container, ItemList, Tag, callbackfnc)
%  adds a JComboBox to existing Container and returns 
%  it as a field of a struct Clist; the fieldname is its Tag.
%  ItemList is a cell array of strings containing the items of the box.
%
%  Clist =  AddJcombobox(Container, Label, Tag, callbackfnc, Clist) 
%  adds the new combobox to the existing struct Clist.
%
%  See also AddJmenu, AddJbutton.

if nargin<1, h = gcf; end;
if nargin<2, Label = 'XXX'; end;
if nargin<3, Tag = 'XXX'; end;
if nargin<4, callbackfnc = nan; end;
if nargin<5, Clist = []; end;

% make sure ItemList is cell string
ItemList = cellstr(ItemList);
% conventional postfix of tags
TagpostFix = 'ComboBox';

tag = [Tag TagpostFix];
JJ = javaObject('javax.swing.JComboBox', ItemList);
set(JJ, 'tag', tag);
set(JJ, 'ActionPerformedCallback', callbackfnc);
Parent.add(JJ);
Clist = setfield(Clist, tag, JJ);



