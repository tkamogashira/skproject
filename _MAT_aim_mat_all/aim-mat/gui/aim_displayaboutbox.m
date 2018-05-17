% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function retfig=aim_displayaboutbox(handles)

% h = dialog('title','about');

if isfield(handles,'abouttexttodisplay')
	withtext=1;
	abtext=handles.abouttexttodisplay;
else
	withtext=0;
end	

logoname=sprintf('%s/logo.gif',handles.info.columnpath);
[logo,colmap]=imread(logoname);

retfig=figure('Visible','off');
h=image(logo);
colormap(colmap);
h2=get(h,'Parent');
retfig=get(h2,'Parent');

% set(win,'Visible','off');
set(h2,'YTick',[]);
set(h2,'XTick',[]);
set(h2,'Position',[0 0 1 1]);

if withtext==1
	a=axis;
	text(20,a(4)/2,abtext,'FontSize',18,'Color','r','Interpreter','none');
end

a=axis;
text(20,0.91.*a(4),release('ver'),'FontSize',12,'Color','b','Interpreter','none');
% text(20,0.95.*a(4),release('rev'),'FontSize',9,'Color','b','Interpreter','none');
text(20,0.98.*a(4),release('date'),'FontSize',12,'Color','b','Interpreter','none');

set(retfig,'Name','About aim-mat');
set(retfig,'NumberTitle','off');
set(retfig,'MenuBar','none');
movegui(retfig,'center');
pos=get(retfig,'Position');
sis=size(logo);
pos(3)=sis(2);
pos(4)=sis(1);
set(retfig,'Position',pos);
set(retfig,'Visible','on');
% but = uicontrol('Style', 'pushbutton', 'String', 'OK','Position', [390 0 70 60]);
% set(but,'Parent',win);
% set(but,'FontSize',20);
% set(but,'Callback', 'close');
% set(but,'FontWeight','bold');

a=0;

