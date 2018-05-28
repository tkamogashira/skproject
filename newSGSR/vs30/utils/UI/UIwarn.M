function UIwarn(mess, noTitle);

% UIwarn- displays warning message in purple to current messagehandle
% syntax
% UIwarn(mess, noTitle);

textcolors;
if nargin<2, noTitle=0; end;
if ~noTitle,
   mess = strvcat('Warning:',mess);
end
hmess = messagehandle;
if ishandle(hmess),
   setstring(hmess, mess);
   set(hmess, 'foregroundcolor', PURPLE);
   drawnow;
else, % write to MatLab screen
   disp(mess);
end;
bell;
   
