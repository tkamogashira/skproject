function Clist = AddJmenu(Parent, Label, Tag, callbackfnc, Clist);
% addJmenu - add java menu item to menubar or parent menu
%  Clist = AddJmenu(Container, Label, Tag, callbackfnc)
%  adds java Jmenus to existing Container (a menubar or jmenu) 
%  and returns them as fields of a struct Clist; the fieldnames 
%  are the Tags of the respective components.
%
%  Clist =  AddJmenu(Container, Label, Tag, callbackfnc, Clist) 
%  adds the new components to the existing struct Clist.
%
%  Labels starting with '-' get a separator; the '-'  does
%  not show up in the label.
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

% swing or awt/mwt?
IsSwing = ~isempty(findstr('javax.swing', class(Parent)));
% menus to be added to menubar? This effects tag naming.
IsMenu = ~isempty(findstr('menubar', lower(class(Parent))));
if IsMenu, TagpostFix = 'Menu';
else, TagpostFix = 'MenuItem';
end

Nmenu = length(Label);
if IsMenu & (Nmenu>1),
   error('Jmenu objects may only added once at a time.');
end
for ii=1:Nmenu,
   label = Label{ii};
   tag = [Tag{ii} TagpostFix];
   MnemChar = ''; % mnemonic character - see below
   if isequal('-', label(1)), % prepend a separator
      if IsSwing, 
         Sep = javaObject('javax.swing.JSeparator');
         Parent.add(Sep);
      else, Sep = Parent.addSeparator;
      end
      label = label(2:end); % remove prepending space
   end
   if ~isempty(strfind(label, '&')),% &Label means that L is mnemonic (MatLab convention)
      iamp = strfind(label, '&');  % location of ampersand
      MnemChar = label(iamp+1);
      label(iamp) = ''; % remove ampersand
   end
   if IsMenu, % add a Jmenu components to the menubar
      if IsSwing,
         JJ = javaObject('javax.swing.JMenu', label);
      else,
         JJ = javaObject('java.awt.Menu', label);
         SC = java.awt.MenuShortcut(64+double(label(1)));
      end
   else, % add a JmenuItem to the Jmenu
      if IsSwing,
         JJ = javaObject('javax.swing.JMenuItem', label);
      else,
         JJ = javaObject('java.awt.MenuItem', label);
      end
   end
   set(JJ, 'tag', tag);
   set(JJ, 'ActionPerformedCallBack', callbackfnc);
   if ~isempty(MnemChar) & IsSwing, JJ.setMnemonic(MnemChar); end;
   Parent.add(JJ);
   Clist = setfield(Clist, tag, JJ);
   % jget(JJ);
end


