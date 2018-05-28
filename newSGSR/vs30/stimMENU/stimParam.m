function StimParam(paramName, paramVal);
%  StimParam - commandline control over individual params of stim menu
%   

global StimMenuStatus
persistent CMenu mh Buttons Nbut Edits Ned

if isempty(mh), mh.Root=inf; end;

if isempty(CMenu) | ~ishandle(mh.PRPframe),
   CMenu = StimMenuStatus.MenuName;
   mh = StimMenuStatus.handles;
   Buttons = []; Edits = []; % make sure they will be initialized
end
if ~ishandle(mh.Root),
   error('Cannot find stim menu');
end

[Buttons, Nbut, Edits, Ned] = local_initControls(mh);

%-------------------

if nargin<1,
   disp(get(mh.Root,'name'));
   stimparam('edits');
   stimparam('buttons');
   return
elseif isequal(paramName, 'DEBUG'),
   keyboard;
   return;
end

pn = lower(paramName);

if nargin==1, % provide a list
   localListControls(Buttons, Edits, pn);
   return;
end

pv = paramVal;
if ischar(pv),
   pv = lower(pv);
   if ~isempty(str2num(pv)),
      pv = str2num(pv);
   end
end

%try % avoid mess error messages due to local functions
   if ischar(pv), % must be a button setting
      OK = local_SetButton(Buttons, pn, pv);
   else,
      OK = local_SetEdit(Edits, pn, pv);
   end
%catch
%   error(stripError(lasterr));
%   return;
%end

if ~OK, 
   EE = (get(messagehandle,'string'));
   set(messagehandle, 'foregroundcolor', [0 0 0])
   setstring(messagehandle, '...')
   error(strmat2nstr(EE));
end




%----------LOCALS--------------------------------------------------

function localListControls(Buttons, Edits, pn);
Nbut = length(Buttons);
Ned = length(Edits);
if findstr('buttons',lower(pn)),
   for ii=1:Nbut,
      BB = Buttons{ii};
      VA{2*ii-1} = BB.name;
      VA{2*ii} = BB.StrVal{BB.Val};
   end
   BUTTONS = struct(VA{:});
   disp(' ');
   display(BUTTONS);
   disp(' ');
elseif findstr('edits',lower(pn)),
   for ii=1:Ned,
      EE = Edits{ii};
      VA{2*ii-1} = EE.name;
      VA{2*ii} = str2num(EE.StrVal);
   end
   EDITS = struct(VA{:});
   disp(' ');
   display(EDITS);
   disp(' ');
else,
   bmatch = local_FindControl(Buttons, pn);
   ematch = local_FindControl(Edits, pn);
   if isempty([bmatch ematch]),
      error(['Cannot list ''' pn '''']);
   else,
      VA = {};
      for ii=bmatch,
         BB = Buttons{ii};
         VA = {VA{:} BB.name BB.StrVal{BB.Val}};
      end
      disp('BUTTONS:')
      if isempty(VA), disp('   (none)');else, disp(struct(VA{:})); end;
      VA = {};
      for ii=ematch,
         EE = Edits{ii};
         VA = {VA{:} EE.name str2num(EE.StrVal)};
      end
      disp('EDITS:')
      if isempty(VA), disp('   (none)');else, disp(struct(VA{:})); end;
   end
end


function match = local_FindControl(Cs, name, ErNam);
N = length(Cs);
match = []; matching = '';
for ii=1:N,
   if ~isempty(findstr(Cs{ii}.name, name)),
      match = [match ii];
      matching = [matching, char(10) '   ' Cs{ii}.name];
   end
end
if nargin>2,
   if isempty(match),
      error(['Cannot find ' ErNam ' ''' name '''']);
   elseif length(match)>1,
      error(['Multiple match of ' ErNam 's: ' matching]);
   end
end


function OK = local_SetButton(Buttons, pn, pv);
match = local_FindControl(Buttons, pn, 'button');
BB = Buttons{match};
match = []; matching = '';
for ii=1:length(BB.StrVal),
   if ~isempty(findstr(lower(BB.StrVal{ii}), pv)),
      match = [match ii];
      matching = [matching, char(10) '   ' BB.StrVal{ii}];
   end
end
if isempty(match),
   error(['Illegal value ''' pv ''' for ''' BB.name  ''' button ']);
elseif length(match)>1,
   error(['Ambiguous value: ' matching]);
end
set(BB.handle, 'userdata', match);
set(BB.handle, 'string', BB.StrVal{match});
OK = stimmenucheck;

function OK = local_SetEdit(Edits, pn, pv);
match = local_FindControl(Edits, pn, 'edit');
EE = Edits{match};
oldVal = get(EE.handle, 'string');
set(EE.handle, 'string', num2str(pv));
OK = stimmenucheck;
if ~OK, % undo
   set(EE.handle, 'string', oldVal); 
   set(EE.handle, 'foregroundcolor', [0 0 0]); 
end;


function [Buttons, Nbut, Edits, Ned]= local_initControls(mh);
Nbut = 0;
fns = fieldnames(mh);
for ii=1:length(fns),
   % find out if last part of tag equals 'button'
   fn = lower(fns{ii});
   if isequal(1,min(findstr('nottub', fn(end:-1:1)))),
      h = getfield(mh, fns{ii});
      cb = get(h,'callback');
      if ~isempty(findstr('menubuttontoggle', lower(cb))),
         % it's a toggle - get it
         p1 = findstr(cb,'{');
         p2 = findstr(cb,'}');
         cb = cb(p1:p2);
         eval(['CV = ' cb ';']);
         Nbut = Nbut+1;
         Buttons{Nbut}.handle = h;
         Buttons{Nbut}.name = fn(1:end-6); % everything save 'button' postfix
         Buttons{Nbut}.StrVal = CV;
         Buttons{Nbut}.Val = get(h,'userdata');
      end
   end
end

Ned = 0;
fns = fieldnames(mh);
for ii=1:length(fns),
   % find out if last part of tag equals 'button'
   fn = lower(fns{ii});
   if isequal(1,min(findstr('tide', fn(end:-1:1)))),
      Ned = Ned+1;
      h = getfield(mh, fns{ii});
      Edits{Ned}.handle = h;
      Edits{Ned}.name = fn(1:end-4); % everything save 'edit' postfix
      Edits{Ned}.StrVal = get(h,'string');
   end
end


