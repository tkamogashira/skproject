function UImessage(mess, hmess, sev, Title, TextColor);

if nargin<2, hmess=NaN; end;
if nargin<3, sev = 1; end;
snames= {'Error:' 'Warning:' 'Info:' ''};
if nargin<4, Title = snames{sev}; end;
scolors=[0.8 0 0; 0.6 0 0.6; 0 0 0; 0 0 0];
if nargin<5, TextColor = scolors(sev,:); end;
ww = strvcat(Title, mess);
if ~ishandle(hmess) , % try to find standard message handle
   hmess = MessageHandle;
end
if ishandle(hmess),
   ww = deblank(cellstr(ww)); % compactify
   set(hmess, 'string', ww);
   set(hmess, 'foregroundcolor', TextColor);
   drawnow;
else, % write to MatLab screen
   disp(ww)
end;

   
