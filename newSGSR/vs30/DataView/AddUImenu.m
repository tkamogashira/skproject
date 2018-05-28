function mh = AddUImenu(h, Label, Tag, callbackfnc);
% addUImenu - add uimenu control to current figure
%  AddUImenu(h, Label, Tag, callbackfnc)
%  adds uimenus to existing figure or uimenu and returns 
%  their handles. 
%  Default callback function of the new menus is the one stored 
%  in UIprop.
%
%  If UIproperties are present, the new uimenus are
%  "checked in", i.e., added to the list of handles
%  composed by openDialog.
%  
%  See openDialog, getUIprop.

if nargin<1, h = gcf; end;
if nargin<2, Label = 'XXX'; end;
if nargin<3, Tag = 'XXX'; end;
if nargin<4, callbackfnc = nan; end;

% menus to be added to figure?
figh = parentFigureHandle(h);
isFigure = isequal(h, figh);

if isnan(callbackfnc), 
   callbackfnc = ''; % nan value is anyhow unacceptable
   if hasUIprop(figh ,'Iam'), % retrieve from figure UIprop (see opendialog)
      callbackfnc = getUIprop(figh, 'Iam.callback');
   end
end

% make sure Label and Tag are cell array of strings
Label = cellstr(Label);
Tag = cellstr(Tag);

if isFigure,
   tagPostfix = 'Menu'; % item on menu bar of figure
else,
   tagPostfix = 'MenuItem'; % sub-item of other menu
end

% add items
Nmenu = length(Label);
mh = [];
for ii=1:Nmenu,
   lab = Label{ii};
   tag = [Tag{ii} tagPostfix];
   ih = uimenu(h, 'label', lab, 'tag', tag, 'callback', callbackfnc);
   mh = [mh; ih];
end

% update UIprops if any (see opendialog and dataplotrefresh)
if hasUIprop(figh ,'Iam'),
   % "check in" the new controls
   EHAA = getUIprop(figh,'Iam.EveryHandleAndAll');
   EHAA(end+1:end+Nmenu) = mh;
   setUIprop(figh,'Iam.EveryHandleAndAll', EHAA);
   % add new menus in the handle structure
   HandleStruct = getUIprop(figh,'Iam.handles', collectmenuhandles('',figh)); 
   for ii=1:Nmenu,
      curtag = [Tag{ii} tagPostfix];
      curhandle = mh(ii);
      eval(['HandleStruct.' curtag ' = curhandle;']);
   end
   setUIprop(figh,'Iam.handles', HandleStruct);
end




