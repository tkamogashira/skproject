function OK=RestoreMenuDefaults(MenuName, defFile, noRootProps, noVarMenuItems)

if nargin<4, noVarMenuItems=0; end;
textcolors;
OK = 0;
MSname = MenuStatusName(MenuName);
eval(['global ' MSname]);
eval(['MS =  ' MSname ';']); % copy of menustatus is now in MS

if (nargin<2) || isempty(defFile), % take standard Deffile
   if isfield(MS, 'defFile '),
      defFile = MS.defFile;
   else % default name for UI defaults
      global DEFDIRS
      defFile = [DEFDIRS.UIdef '\' MenuName 'Menu.def'];
      % put this name in global menu status
      eval([MSname '.defFile = defFile;']); % the menustatus is now in MS
   end
end

if nargin<3,
   noRootProps = (nargin>1); % a special file is usually meant for...
   noVarMenuItems = (nargin>1);  % ... param values only, not appearances
end
textcolors;
% return to controls their last-time values
hh = MS.handles;
if isequal(2,exist(defFile)),
%   try % don't crash if def file is corrupted
      % next line loads variable called 'MenuDefaults'
      load(defFile, '-mat');
      for ii = 1:length(MenuDefaults),
         % old-style vs new-style defaults format
         if iscell(MenuDefaults), 
            def = MenuDefaults{ii};
         else
            def = MenuDefaults(ii);
         end
         try % don't crash because of an obsolete default setting
            if isempty(def.value), error('Empty val field of retrieved default'); end;
            h = getfield(MS.handles, def.tag);
            % position is special property - handle with care
            if isequal(def.tag,'Root'),
               if ~noRootProps, local_setRootProp(h,def); end
            elseif localIgnore(def), % ignore but set color to purple if toggle or edit
               if localToggleOrEdit(h),
                  set(h, 'foregroundcolor', PURPLE);
               end
            elseif ~localIgnoreVMI(h, noVarMenuItems), 
               % default case; just set the property to the default value
               set(h, def.prop, def.value);
               UitextColor(h, BLACK, 1); % only set color to black if it's an edit control
            end
         end % try
      end % for
      OK = 1;
%   end % try
else % no def file; set fig position to MatLab default
   figh = hh.Root;
   oldPos = get(figh,'position');
   defPos = get(0,'defaultFigurePosition');
   Pos = [defPos(1:2) oldPos(3:4)]; % take size from old pos, offset from default fig pos
   set(figh,'position',Pos);
end % if isequal

% store current values in StimMenuStatus.defaults field
UpdateMenuDefaultValues(MenuName);

%----------------------
function local_setRootProp(h,def)
% position property of Root is special:
if isequal(def.prop,'position'),
   RES = isequal(get(h,'resize'),'on'); % resizeable?
   if RES, % its OK to resize according to defaults
      set(h, def.prop, def.value);
   else % window may NOT be resized. Don't change 3rd&4th component of pos
      oldPos = get(h, 'position');
      newPos = [def.value(1:2) oldPos(3:4)]; % pos from def; size from existing window
      set(h,'position', newPos);
   end
   RepositionFig(h); % make sure figure doesn't fall off the screen
else % other properties are harmless (we hope)
   set(h, def.prop, def.value);
end

function doIgnore = localIgnore(def)
% special values must be ignored
doIgnore = 0;
tag = lower(def.tag);
if StrEndsWith(tag,'edit'),
   doIgnore = isequal(trimspace(def.value),'?');
elseif StrEndsWith(tag,'button'),
   if isequal('string',lower(def.prop)),
      doIgnore = isequal(trimspace(def.value),'?');
   elseif isequal('userdata',lower(def.prop)),
      if isnumeric(def.value),
         doIgnore = isreal(1i*def.value); % purely imag values
      end
   end
end

function it = localToggleOrEdit(h)
% true for edits or toggles
TAG = lower(get(h,'tag'));
CB = lower(get(h,'callback'));
it = 0;
if StrEndsWith(TAG, 'edit'), it = 1;
elseif StrEndsWith(TAG, 'button'),
   it = ~isempty(findstr(CB,'toggle'));
end

function iv = localIgnoreVMI(h, noVarMenuItems)
iv = 0;
if ~noVarMenuItems, return; end;
TAG = lower(get(h,'tag'));
if strEndsWith(TAG,'varmenuitem'),
   iv = noVarMenuItems;
end
