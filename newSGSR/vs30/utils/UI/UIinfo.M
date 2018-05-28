function UIinfo(mess, Append, Color, NoDrawNow);

% UIinfo- writes message to current messagehandle
% syntax
% UIinfo(mess, Append);
% default is Append = 0 (i.e. overwrite existing text)
% special value Append = -1 -> horizontal Append
% other nonzero values 

if nargin<2, Append=[]; end;
if nargin<3, Color=[]; end;
if nargin<4, NoDrawNow=0; end;

textcolors;
if isempty(Append), Append=0; end;
if isempty(Color), Color=BLACK; end;

hmess = messagehandle;

if ishandle(hmess),
   mess = local_append(getstring(hmess), mess, Append);
   setstring(hmess, mess);
   % only change color when a new message is issued or when asked explicitly
   if (~Append) | (nargin>2), set(hmess, 'foregroundcolor', Color); end;
else, % write to MatLab screen
   disp(mess);
end;
if ~NoDrawNow, drawnow; end;

%---------locals---------------------   
function str = local_append(str1, str2, Append);
if isequal(Append,-1), % attempt horizontal concatenation of str1 and str2
   % don't go through great pains - fall back to vertical concat if problematic
   Nline1 = size(str1,1); % # lines in str1
   Nline2 = size(str2,1); % # lines in str2
   if isequal(Nline1,Nline2), str = [str1, str2];
   elseif Nline1==0, str = str2;
   elseif Nline2==0, str = str1;
   elseif (Nline1>1) & (Nline2==1), % append to last line
      str = strvcat(str1(1:(Nline1-1),:),[str1(Nline1,:) str2]);
   else, % give up just do vetrical cat
      str = strvcat(str1, str2);
   end
elseif Append, % vertical concatenation
   str = strvcat(str1,str2);
else, % ignore str1
   str = str2;
end

