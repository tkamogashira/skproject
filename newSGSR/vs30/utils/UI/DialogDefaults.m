function DialogDefaults(figh, action, defFile);
% DialogDefaults - save, update or retrieve defaults for UIcontrols of dialog

% dialogs carry their own info - get it
Dinfo = getUIhandle(gcf, 'Iam','userdata');
hh = Dinfo.handles;

if nargin<3, defFile = Dinfo.defaultsFile; end; % default defaultsFilename
defFile = fullFileName(defFile, uidefdir, 'def');

switch action
case 'retrieve',
   if ~exist(defFile,'file'), return; end;
   qq = load(defFile, '-mat');
   mds = qq.MenuDefaults;
   for ii=1:length(mds),
      md = mds(ii);
      %try, 
         h = getfield(hh, md.tag); % the handle of the uicontrol
         if ~localDealtWithExceptions(h, md), % don't resize if resize=off, etc
            set(h, md.prop, md.value); 
         end;
      %end  % try
   end
case 'update',
   for ii=1:length(Dinfo.defaults), 
      md = Dinfo.defaults(ii);
      try, 
         h = getfield(hh, md.tag);
         Dinfo.defaults(ii).value  = get(h, md.prop);
         if ~isnan(md.val), set(h, md.prop, md.value); end;
      end
   end
   set(hh.Iam, 'userdata', Dinfo); % upload updated Dinfo
case 'savecurrent',
   DialogDefaults(figh, 'update');
   DialogDefaults(figh, 'save');
case 'save',
   MenuDefaults = Dinfo.defaults;
   if isempty(MenuDefaults), return; end % no defaults to save
   if isnan(MenuDefaults(1).value), return; end % never assigned
   save(defFile, 'MenuDefaults');
otherwise,
   error(['unkown keyword ''' keyword '''']);
end

%===========================================================
function d = localDealtWithExceptions(h, md);
% deal with exceptions when restoring default UIcontrol properties
d = 1;
if isnan(md.value), % do nothing
elseif isequal('figure', get(h,'type')) & isequal('position', lower(md.prop)),
   figresize = get(h,'ResizeFcn'); set(h,'ResizeFcn', '');
   if isequal('off', get(h,'resize')),
      % only restore offsets, keep size
      oldpos = get(h,'position');
      set(h, 'position', [md.value(1:2) oldpos(3:4)]);
   else, % do it but, even so, check afterwards 
      set(h, md.prop, md.value);
   end
   repositionFig(h);
   set(h,'ResizeFcn', figresize);
else, d = 0; % no exception
end
