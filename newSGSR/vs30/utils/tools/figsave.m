function y=figsave(h, visible);

if nargin<1, h=gcf; end;
if nargin<2, visible=0; end;

if visible, set(h,'visible','on');
else, set(h,'visible','off');
end

global VERSIONDIR
fname = get(h, 'filename');

if isempty(fname),
   [fn fp] = uiputfile('*.fig');
   if isequal(0,fn), disp('NOT SAVED'); return; end;
   fname = [fp fn];
   [fp fn ext] = fileparts(fname);
   if isempty(ext),
      fname = [fname '.fig'];
   end
   set(h, 'filename', fname);
end

if atbigscreen, fname(1) = 'C';
elseif inutrecht, fname(1) = 'D';
end
if ~isequal(1,findstr( fname ,VERSIONDIR)),
   warning('obsolete figure filename');
end

saveas(h,fname);

set(h,'visible','on');

% look if SU definition is present
SU = uigetSU(h);
if ~isempty(SU),
   for ii=1:length(SU),
      if isfield(SU{ii},'anchor'), % update anchor positions
         ah = findobj(h,'tag', SU{ii}.anchor);
         SU{ii}.anchorPos = get(ah,'position');
      elseif isfield(SU{ii},'Props'), % refresh figure properties
         SU{ii}.Props = getMenuProps(h);
      end
   end
   global VERSIONDIR
   [fp fn ext] = fileparts(fname);
   fname = [VERSIONDIR '\stimmenu\construction\' fn '.org']
   save(fname,'SU');
end


