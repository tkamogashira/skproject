function y = UItwoButtons(keyword, varargin);
% UItwoButtons - two toggles, one dependents on the other

varargin = [varargin cell(1,50)]; % see usage of "deal" below

switch keyword,
case 'init', % initialize the buttons
   [handles, opt1, opt2, str1, str2, edith, editmask] = deal(varargin{1:7});
   TBdef = collectInStruct(handles, opt1, opt2, str1, str2, edith, editmask);
   h1 =handles(1); h2 =handles(2);
   % store settings in userdata of buttons; also store rank (first vs 2nd)
   set(h1, 'userdata', setfield(TBdef, 'ibutton', 1)); 
   set(h2, 'userdata', setfield(TBdef, 'ibutton', 2)); 
   set(h1, 'callback', [mfilename '(''callback'', 1);']); 
   set(h2, 'callback', [mfilename '(''callback'', 2);']); 
case 'set',
   [handles, str1, str2] = deal(varargin{1:3});
   uu = get(handles, 'userdata');
   [TBdef1, TBdef2] = deal(uu{:}); % retieve button settings
   % check if known strings were passed and if their combination is valid
   m1 = find(strcmp(TBdef1.str1, str1)); 
   m2 = find(strcmp(TBdef2.str2, str2));
   if isempty(m1) | isempty(m2), error('Unkown button string'); end;
   okSTR1 = TBdef1.opt1(m1);
   okSTR2 = TBdef2.opt2(m2, m1);
   if ~okSTR1 | ~okSTR2, error('Invalid buttonstring combination'); end;
   % set the button strings
   setstring(handles(1), str1);
   setstring(handles(2), str2);
   if ~isempty(TBdef1.editmask), % enable/disable associated edits
      eh1 = TBdef1.edith{1}; eh2 = TBdef1.edith{2};
      localEnable(eh1, TBdef1.editmask{1}, m1);
      localEnable(eh2, TBdef1.editmask{2}, m2);
   end
case 'callback',
   ibutt = varargin{1};
   TBdef = get(gcbo, 'userdata');   
   curStr1 = getstring(TBdef.handles(1)); Nstr1 = length(TBdef.str1);
   m1 = find(strcmp(TBdef.str1, curStr1)); % index of current string
   curStr2 = getstring(TBdef.handles(2)); Nstr2 = length(TBdef.str2);
   m2 = find(strcmp(TBdef.str2, curStr2)); % index of current string
   if ibutt==1,
      for dum=1:Nstr1, % search for next valid string for button 1
         m1 = 1 + rem(m1, Nstr1);
         if TBdef.opt1(m1), break; end;
      end
      newStr1 = TBdef.str1{m1};
   else, newStr1 = curStr1;
   end
   if ibutt~=2, m2 = m2-1; end % undo hopping to next button, if allowed
   for dum = 1:Nstr2, % search for next valid string for button 2
      m2 = 1 + rem(m2, Nstr2);
      if TBdef.opt2(m2, m1), break; end;
   end
   newStr2 = TBdef.str2{m2};
   UItwoButtons('set', TBdef.handles, newStr1, newStr2);
otherwise,
   error(['Invalid keyword "' keyword '"']);
end

%============================================
function localEnable(eh, enab, m);
try, enab = enab(m);
catch, return; % mask does not include setting - don't bother
end
if isempty(eh), return; end;
if ~ishandle(eh), return; end;
if enab, 
   set(eh, 'visible', 'on');
else,
   set(eh, 'visible', 'off');
end



