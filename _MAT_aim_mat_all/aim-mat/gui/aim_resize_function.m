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


function aim_resize_function(obj,eventdata,handles)

fig = gcbo;%returns the handle of the graphics object whose callback is executing.
old_units = get(fig,'Units');
set(fig,'Units','pixels');
global figpos
figpos = get(fig,'Position');

% if figpos(3) < 640 & figpos(3) >0
% 	figpos(3)=640;
% 	set(fig,'Position',figpos);
% end
% 
% if figpos(4) < 400
% 	figpos(4)=400;
% 	set(fig,'Position',figpos);
% end

	cur_axis=gca;	% this is the full size axis with the full size area
	set(cur_axis,'units','pixel');
	fax=get(gcf,'Position');	% the size of the figure
	relative_axis(1)=10/fax(3); % bottom fixed
	relative_axis(2)=111/fax(4); % bottom right fixed
	relative_axis(3)=(fax(3)-40)/fax(3);	% height
	relative_axis(4)=(fax(4)-220)/fax(4);	% height

[myaxes1,myaxes2,myaxes3,myaxes4]=aim_define_plot_areas(handles,relative_axis);

% screens=get(0,'ScreenSize');
% if figpos(1)+figpos(3)>screens(3)
% 	figpos(1)=screens(3)-figpos(3)-5;
% 	set(fig,'Position',figpos);
% end
% if figpos(2)+figpos(4)>screens(4)
% 	figpos(2)=screens(4)-figpos(4)-30;
% 	set(fig,'Position',figpos);
% end

% keep everything on top
dist1=46;
dist3=74;
dist4=104;
dist5=110;

distr1=107;
keepontop('frame7',dist5);
keepontop('frame10',dist5);
% keepontopright('frame10',dist5,distr1+10);

% keepontop('pushbutton10',dist1-1);
keepontop('pushbutton0',dist1);
keepontop('pushbutton2',dist1);
keepontop('pushbutton3',dist1);
keepontop('pushbutton4',dist1);
keepontop('pushbutton5',dist1);
keepontop('pushbutton6',dist1);
% keepontopright('pushbutton6',dist1,distr1);
keepontop('pushbutton21',dist1);

% keepontop('pushbutton11',dist3+2);
% keepontop('pushbutton8',dist4+3);
% keepontopright('pushbutton9',179,distr1-6);

keepontop('listbox1',dist3);
keepontop('listbox2',dist3);
keepontop('listbox0',dist3);
keepontop('listbox3',dist3);
keepontop('listbox4',dist3);
keepontop('listbox5',dist3);
% keepontopright('listbox5',dist3,distr1-1);
keepontop('listbox6',dist3);

keepontop('checkbox0',dist4-5);
keepontop('checkbox1',dist4-5);
keepontop('checkbox2',dist4-5);
keepontop('checkbox3',dist4-5);
keepontop('checkbox4',dist4-5);
keepontop('checkbox8',dist4-5);
keepontop('checkbox5',dist4-5);
% keepontopright('checkbox5',dist4-5,distr1-38);


distr2=101;
distr3=85;
distr4=95;

% keeponbottomright('text13',distr2);
% keeponbottomright('edit1',distr2);
% keeponbottomright('pushbuttonautoscale',distr2);
% keeponbottomright('slider1',distr3);
% keeponbottomright('frame5',distr4);


% set the axes to nice sizes:
hoben=107;  % soviel muss oben freibleiben
hunten=110; % soviel muss unten freibleiben
hv=figpos(4)-hunten-hoben; % soviel ist verfügbar in der Mitte
% davon bekommen das Profile und das signal je 14% und das SAI 72%:
h1=hv*0.14;
h2=hv*0.72;
h3=hv*0.14;


b1=20; % soweit weg vom linken Rand
b2=38;% soweit weg vom rechten Rand
bv=figpos(3)-b1-b2; % soviel Breite ist verfügbar
% davon bekommen die linken 89% und das Profile 11%
b3=bv*0.11;
b4=bv*0.89;

ax1 = findobj('Tag','axes1');
ax2 = findobj('Tag','axes2');
ax3 = findobj('Tag','axes3');
ax4 = findobj('Tag','axes4');
set(ax1,'Position',[b1-1 hunten+h1+h2+2 b4 h1]);
set(ax2,'Position',[b1 hunten+h1+1 b4 h2]);
set(ax3,'Position',[b1 hunten b4 h3]);
set(ax4,'Position',[b1+b4+1 hunten+h1+1 b3 h2]);



set(fig,'Units',old_units);

aim_savecurrentstate(handles);% save the state of the project and the window to a file
% handles=replotgraphic(handles);


function keepontop(name,dist)
global figpos
u = findobj('Tag',name);
correct=+9;
upos=get(u,'Position');
upos = [upos(1), figpos(4) - dist+correct, upos(3), upos(4)];
set(u,'Position',upos);

function keepontopright(name,disttop,distright)
global figpos
u = findobj('Tag',name);
correct=+9;
upos=get(u,'Position');
upos = [figpos(3)-distright, figpos(4) - disttop+correct, upos(3), upos(4)];
set(u,'Position',upos);

function keeponbottomright(name,distright)
global figpos
u = findobj('Tag',name);
upos=get(u,'Position');
upos = [figpos(3)-distright, upos(2), upos(3), upos(4)];
set(u,'Position',upos);
