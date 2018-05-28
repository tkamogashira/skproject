h0=figure('Position',[150 150 500 400]);
h1=axes('Parent',h0,'Units','Pixels','Position',[60 100 400 280]);
h2=uicontrol('Parent',h0,'Style','Pushbutton','Position',[60 20 100 40],'String','Helix','Callback',['sub10801(''helix'')']);
h3=uicontrol('Parent',h0,'Style','Pushbutton','Position',[210 20 100 40],'String','Sinc','Callback',['sub10801(''sinc'')']);
h4=uicontrol('Parent',h0,'Style','Pushbutton','Position',[360 20 100 40],'String','Exit','Callback',['sub10801(''exit'')']);
