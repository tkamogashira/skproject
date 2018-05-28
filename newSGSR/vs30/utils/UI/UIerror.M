function y= UIerror(mess, redEdits);

% UIerror- displays error message in red to current messagehandle
% syntax
% UIerror(mess, redEdits);
% redEdits is vector of Edit control handles whose text is to be colored RED
% empty string -> no error

if nargin<2, redEdits = []; end;
if nargin<1, mess=''; end;
if isempty(mess), y=0; return; end
y=1; % an error
textcolors;
mess = strvcat('Error:',mess);
hmess = messagehandle;
if ishandle(hmess),
   mess = deblank(cellstr(mess)); % compactify
   setstring(hmess, mess);
   set(hmess, 'foregroundcolor', textRED);
   % color flawed edits
   UItextColor(redEdits, RED);
   drawnow;
else, % write to MatLab screen
   disp(mess);
end;
beeps(2);
   
