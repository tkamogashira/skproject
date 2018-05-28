function UIcounter(TAG);
% update counter edit control

bh = gcbo;

% the tag of the calling object determines the action   
if nargin<1,
   TAG = get(gcbo,'tag');
end

% parse the tag and determine the action
bpu = max(findstr('Up', TAG));
bpd = max(findstr('Down', TAG));
bpr = max(findstr('Reset', TAG));
if ~isempty(bpu),
   prefix = TAG(1:bpu-1);
   step = 1;
elseif ~isempty(bpd),
   prefix = TAG(1:bpd-1);
   step = -1;
elseif ~isempty(bpr),
   prefix = TAG(1:bpr-1);
   step = 'reset'; 
end

% find the edit control to be updated
hEdit = findobj(gcbf,'tag',[prefix 'ValEdit']);
if isempty(hEdit), hEdit = findobj(gcbf,'tag',[prefix 'Edit']); end

if ishandle(hEdit),
   ud  = get(hEdit,'userdata');
   val = str2num(getstring(hEdit)); % current value
   if isequal('reset', step),
      % get reset string value and impose it
      Rstr = getfieldOrDef(ud, 'resetVal', '1');
      setstring(hEdit, Rstr);
   elseif isnumeric(val) & ~isempty(val),
      newval = num2str(val + step);
      setstring(hEdit, newval);
   end
   % reset any dependent edits
   ch = getfieldOrDef(ud, 'children', {});
   for ii=1:length(ch), 
      UIcounter([ch{ii} 'Reset']); 
   end
end



