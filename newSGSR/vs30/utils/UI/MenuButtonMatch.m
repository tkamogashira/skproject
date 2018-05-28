function MenuButtonMatch(h);
% MenuButtonMatch - force a button's userdata and string to be consistent with button callback
h = UIhandle(h);
CB = get(h,'callback');
ud = get(h,'userdata');

if isempty(CB), return; end; % could be emptied toggle - don't bother

if isstruct(get(h,'userdata')), % dual toggle?
   try,
      setstring(h, ud.ButString{ud.i});
      set(h,'foregroundcolor',[0 0 0]);
   end
   return;
end

cb = lower(CB);
keyword = 'menubuttontoggle';
qq = findstr(keyword,cb);
qq = min(qq);
if isempty(qq),
   error('not a toggle button');
end
CB(qq-1+(1:length(keyword))) = '';
eval(['ButtonStr = ' CB ';']);
if ~isreal(ud),
   ud = imag(ud);
   set(h,'userdata',ud);
end
if isempty(ud),
   ud =1;
end
%ButtonStr{:}, ud
set(h,'string',ButtonStr{ud});
set(h,'foregroundcolor',[0 0 0]);
menubuttontoggle('ResetPersistentQuestion');

