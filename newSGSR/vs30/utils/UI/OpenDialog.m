function handles=OpenDialog(DialogName, callback, defaults);
% OpenDialog - open a dialog from fig file and deal wit hsome bookkeeping

if nargin<2, callback = ''; end;
if nargin<3, defaults = ''; end;

if isempty(callback), callback = DialogName; end;


fixedOpenFig([DialogName '.fig']); % bug fix of MatLab's openfig
figh = gcf;
% overwrite filename property - users should not save to SGSR fig files
set(gcf, 'filename', [exportdir '\*.fig']);

if inleuven | inutrecht, % avoid flashing of the screen
   set(figh,'renderermode','auto');
   % set(figh,'doubleBuffer','on'); % doesn't work under ML6
end
localRemoveDeveloperUIs(figh);
more off;

% visibity
repositionFig(figh);

% enable line copying from fig to fig
LineCutandPaste init

handles = CollectMenuHandles('', figh); % get all handles of children
defaults = localParse(defaults, handles); % put defaults in struct array
defaultsFile = callback; % filename where to store ui defaults
% compile a simple list of *all* handles, hidden or not
% store info in invisible uicontrol on the figure; incluse "Iam" itself in info
Iam = CollectInStruct(handles, defaults, defaultsFile);
Iam.handles.Iam = uicontrol(figh, 'visible', 'off', 'tag', 'Iam');
set(Iam.handles.Iam, 'userdata', Iam);

% default closereq, resizefnc and keypress
if ~isequal('nop', callback),
   if isequal(lower(get(0,'defaultfigurecloserequest')), lower(get(figh, 'closereq'))),
      set(figh, 'closereq', [callback ' close;']); 
   end
   if isempty(get(figh, 'keypressfcn')),
      set(figh, 'keypressfcn', [callback ' keypress;']); 
   end
   if isempty(get(figh, 'ResizeFcn')),
      set(figh, 'ResizeFcn', [callback ' resize;']); 
   end
end

% visit UIcontrols and replace occurrences of "testcallback" for callbckfcn
hhh = dealstruct2cell(handles); hhh = [hhh{:}]; % handles in simple vector
hhcb = findobj(hhh, 'callback', 'testcallback');
set(hhcb, 'callback', [callback ';']);

% compile a simple list of *all* handles, hidden or not, and store in IAm
setUIprop(figh,'Iam.EveryHandleAndAll', allObjectsInFigure(figh));

% store the default callback function
setUIprop(figh,'Iam.callback', callback);

% retrieve last used-defaults
dialogdefaults(figh, 'retrieve');

set(figh, 'visible', 'on');


%=============================================================================
function localRemoveDeveloperUIs(figh);
% remove developer controls if user is not a developer
if ~isdeveloper,
   % remove uicontrols with substring 'developer' in their tags
   ch = get(figh,'children');
   Tags = get(ch,'tag'); 
   % get only returns a cell in the case of multiple handles
   if ~iscell(Tags), Tags={Tags}; end; % force to cell format
   N = length(Tags);
   for ii=1:N,
      if ~isempty(findstr('developer',lower(Tags{ii}))),
         if ishandle(ch(ii)), delete(ch(ii)); end;
      end
   end
end

function sa = localParse(str, hh); 
% put defaults in struct array
sa = emptystruct('tag', 'prop', 'value');
if ischar(str), str = words2cell(str); end; % now str is cell array
alltags = fieldnames(hh);
for ii=1:length(str),
   [Tag, Prop] = strtok(str{ii},':'); Prop = Prop(2:end);
   if ~isequal('*', Tag(1)), % single value
      mustmatchexactly = 1;
   else, % wildcards
      mustmatchexactly = 0;
      Tag = Tag(2:end); % remove '*'
   end; 
   for jj=1:length(alltags), % collect existing tags with 
      candidate = alltags{jj}; Lc = length(candidate);
      hit = strEndsWith(lower(candidate), lower(Tag));
      if mustmatchexactly, hit= hit & isequal(Lc, length(Tag)); end;
      if hit, % add tag/prop pair to sa
         sa = [sa, struct('tag', candidate, 'prop', Prop, 'value', nan)];
      end;
   end
end




