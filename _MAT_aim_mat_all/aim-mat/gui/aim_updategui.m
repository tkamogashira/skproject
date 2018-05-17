% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function handles=aim_updategui(handles)

% enable / disable the buttons 
loadstatus(1)=handles.info.pcp_loaded;
loadstatus(2)=handles.info.bmm_loaded;
loadstatus(3)=handles.info.nap_loaded;
loadstatus(4)=handles.info.strobes_loaded;
loadstatus(5)=handles.info.sai_loaded;
loadstatus(6)=handles.info.usermodule_loaded;
loadstatus(7)=handles.info.movie_loaded;

for i=1:7
	but=getbuttonhandle(handles,i);
    frame_hand=getframehandle(handles,i);
	if loadstatus(i)==1
		set(but,'Enable','on');
		set(frame_hand,'BackgroundColor',handles.colors.green1);
	else
		set(but,'Enable','off');
		set(frame_hand,'BackgroundColor',handles.colors.background);
	end
end


% default settings for all but the sai 
set(handles.frame28,'BackgroundColor',handles.colors.green1);
set(handles.checkbox6,'Enable','on');
set(handles.checkbox7,'Enable','on');
set(handles.checkbox10,'Enable','on');
set(handles.edit3,'Enable','on');
set(handles.slider3,'Enable','on');
set(handles.edit3,'Visible','on'); %switch on duration
set(handles.slider3,'Visible','on');
set(handles.text7,'Visible','on'); 
set(handles.text10,'Visible','on'); 
set(handles.text9,'String','ms');
set(handles.text8,'String','start time');
set(handles.pushbutton24,'Enable','on');

sig=handles.data.signal;
len=getlength(sig);

handles=aim_set_current_slider(handles);

% the new one is now the old one:
handles.info.old_current_plot=handles.info.current_plot;

% calculate dependencies TCW AIM2006
% enumerate list boxes
for i=1:7
    listboxen(i)=getlisthandle(handles, i);
end
% if it was a list box that called
if (find(listboxen==handles.calling_object))
    current_listbox=handles.calling_object;
    current_listbox_number=find(listboxen==handles.calling_object);
    generating_module_string=get(current_listbox,'String');
    generating_module=generating_module_string(get(current_listbox,'Value'));
    generating_module=generating_module{1};
    generating_section=getsectionnames(current_listbox_number);
    generating_functionline=['handles.all_options.' generating_section '.' generating_module '.default_nextmodule'];
    try
        setdefault=1;
        eval(sprintf('default_gen=%s;',generating_functionline'));
    catch
        setdefault=0;
    end
    if setdefault==1 && current_listbox_number<7
        next_listbox=getlisthandle(handles,current_listbox_number+1);
        generating_module_string=get(next_listbox,'String');
        chosen_option=strmatch(default_gen,generating_module_string);
        try
            set(next_listbox,'Value', chosen_option);
        catch
            %   never mind, the necessary module doesn't exist
        end
    end
end
%

% set the colors according to the button setting
switch handles.info.current_plot
	case 1 % signal
		set(handles.checkbox6,'Value',0);	% switch off profiles
		set(handles.checkbox7,'Value',0);
		set(handles.checkbox6,'Enable','off');
		set(handles.checkbox7,'Enable','off');
		set(handles.pushbutton24,'Enable','off');
	case 2 % pcp
		set(handles.frame20,'BackgroundColor',handles.colors.green2);
		set(handles.checkbox6,'Value',0);
 		set(handles.checkbox7,'Value',0);
		set(handles.checkbox6,'Enable','off');
 		set(handles.checkbox7,'Enable','off');
		set(handles.pushbutton24,'Enable','off');
	case 3 %bmm
        %set(handles.checkbox10,'Value',0);
		set(handles.checkbox6,'Value',0);	% switch off profiles by default
 		set(handles.checkbox7,'Value',0);
		set(handles.checkbox6,'Enable','off');
 		set(handles.checkbox7,'Enable','off');
		set(handles.frame21,'BackgroundColor',handles.colors.green2);
	case 4 % nap
        %set(handles.checkbox10,'Value',0);
        set(handles.checkbox10, 'Enable', 'on');
        set(handles.checkbox7,'Value',0);
        set(handles.checkbox7,'Enable','off');
		set(handles.frame22,'BackgroundColor',handles.colors.green2);
	case 5 % strobes
        %set(handles.checkbox10,'Value',0);
        set(handles.checkbox7,'Value',0);
        set(handles.checkbox7,'Enable','off');
		set(handles.frame23,'BackgroundColor',handles.colors.green2);
	case 6 % sai
		set(handles.frame24,'BackgroundColor',handles.colors.green2);
		set(handles.slider3,'Visible','off');
		set(handles.text7,'Visible','off');
        set(handles.text9,'String','');
        set(handles.text8,'String','frame #');
        set(handles.checkbox10,'Value',0);
        set(handles.checkbox10, 'Enable', 'off');
	case 7 % user defined
		% special: if usermodule is "none", then ignore it and set 
		if strcmp(handles.info.current_usermodule_module,'none')
			set(handles.frame24,'BackgroundColor',handles.colors.green2);
			set(handles.slider3,'Visible','off');
			set(handles.text7,'Visible','off');
			set(handles.text9,'String','');
			set(handles.text8,'String','frame #');
            set(handles.checkbox10,'Value',0);
            set(handles.checkbox10, 'Enable', 'off');
			handles.info.current_plot=6;
			handles=aim_updategui(handles);
		else
			set(handles.frame25,'BackgroundColor',handles.colors.green2);
			set(handles.slider3,'Visible','off');
			set(handles.text7,'Visible','off');
			set(handles.text9,'String','frame #');
			set(handles.pushbutton24,'Enable','off');
            set(handles.checkbox10,'Value',0);
            set(handles.checkbox10, 'Enable', 'off');
		end
		if strcmp(handles.info.current_usermodule_module,'dualprofile')
			set(handles.checkbox6,'Value',0);	% switch of profiles
			set(handles.checkbox7,'Value',0);
			set(handles.checkbox6,'Enable','off');
			set(handles.checkbox7,'Enable','off');
			set(handles.pushbutton24,'Enable','off');
            set(handles.checkbox10,'Value',0);
            set(handles.checkbox10, 'Enable', 'off');
			
		end
	case 8 % movie
		set(handles.frame26,'BackgroundColor',handles.colors.green2);
end 


% indicate by a blue color, that these ones are to be regenerated or to be
% deleted
for i=1:7
	checkhand=getcheckboxhandle(handles,i);
	texthand=getbuttonhandle(handles,i);
    framehand=getframehandle(handles,i);
	if get(checkhand,'Value')==1
		set(framehand,'BackgroundColor',handles.colors.blue2);
		set(texthand,'Enable','on');
		for j=i+1:7
			checkhand=getcheckboxhandle(handles,j);
			texthand=getbuttonhandle(handles,j);
			if loadstatus(j)==1
				set(framehand,'BackgroundColor',handles.colors.blue1);
			end
			cd1=getcheckboxhandle(handles,j-1); % left of
			if get(cd1,'Value')==0
				% and uncheck
				cd=getcheckboxhandle(handles,j);
				set(cd,'Value',0);
			end
		end
	end
end



% set all commands accordingly, so that "calculate" can work with it
handles.info.calculate_pcp=0;
handles.info.calculate_bmm=0;
handles.info.calculate_nap=0;
handles.info.calculate_strobes=0;
handles.info.calculate_sai=0;
handles.info.calculate_usermodule=0;
handles.info.calculate_movie=0;
if 	get(handles.checkbox0,'Value')==1
	handles.info.calculate_pcp=1;
end 
if 	get(handles.checkbox1,'Value')==1
	handles.info.calculate_bmm=1;
end 
if 	get(handles.checkbox2,'Value')==1
	handles.info.calculate_nap=1;
end 
if 	get(handles.checkbox3,'Value')==1
	handles.info.calculate_strobes=1;
end 
if 	get(handles.checkbox4,'Value')==1
	handles.info.calculate_sai=1;
end 
if 	get(handles.checkbox8,'Value')==1
	handles.info.calculate_usermodule=1;
end 
if 	get(handles.checkbox5,'Value')==1
	handles.info.calculate_movie=1;
end 

% set the tooltip for each listbox:
settooltip(handles.all_options.pcp,handles.listbox0);
settooltip(handles.all_options.bmm,handles.listbox1);
settooltip(handles.all_options.nap,handles.listbox2);
settooltip(handles.all_options.strobes,handles.listbox3);
settooltip(handles.all_options.sai,handles.listbox4);
settooltip(handles.all_options.usermodule,handles.listbox6);
settooltip(handles.all_options.movie,handles.listbox5);

% set the current info in handles to the current values
generating_module_string=get(handles.listbox0,'String');
generating_module=generating_module_string(get(handles.listbox0,'Value'));
generating_module=generating_module{1};
handles.info.current_pcp_module=generating_module;
generating_module_string=get(handles.listbox1,'String');
generating_module=generating_module_string(get(handles.listbox1,'Value'));
generating_module=generating_module{1};
handles.info.current_bmm_module=generating_module;
generating_module_string=get(handles.listbox2,'String');
generating_module=generating_module_string(get(handles.listbox2,'Value'));
generating_module=generating_module{1};
handles.info.current_nap_module=generating_module;
generating_module_string=get(handles.listbox3,'String');
generating_module=generating_module_string(get(handles.listbox3,'Value'));
generating_module=generating_module{1};
handles.info.current_strobes_module=generating_module;
generating_module_string=get(handles.listbox4,'String');
generating_module=generating_module_string(get(handles.listbox4,'Value'));
generating_module=generating_module{1};
handles.info.current_sai_module=generating_module;
generating_module_string=get(handles.listbox6,'String');
generating_module=generating_module_string(get(handles.listbox6,'Value'));
generating_module=generating_module{1};
handles.info.current_usermodule_module=generating_module;
generating_module_string=get(handles.listbox5,'String');
generating_module=generating_module_string(get(handles.listbox5,'Value'));
generating_module=generating_module{1};
handles.info.current_movie_module=generating_module;

% special: if the sai-module is set to "ams" (auditory image model), then
% all buttons before that are set to disable and the settings are set to
% "none"
if strcmp(handles.info.current_sai_module,'ams') && handles.info.sai_loaded==1 && ~get(handles.checkbox0,'Value')==1
	set(handles.pushbutton0,'Enable','off');
	set(handles.frame20,'BackgroundColor',handles.colors.background);
% % 	set(handles.listbox0,'String','none');
	set(handles.pushbutton2,'Enable','off');
	set(handles.frame21,'BackgroundColor',handles.colors.background);
% % 	set(handles.listbox1,'String','none');
	set(handles.pushbutton3,'Enable','off');
	set(handles.frame22,'BackgroundColor',handles.colors.background);
% 	set(handles.listbox2,'String','none');
	set(handles.pushbutton4,'Enable','off');
	set(handles.frame23,'BackgroundColor',handles.colors.background);
% 	set(handles.listbox3,'String','none');
end



return


%%%%%%%%%%%%%%%%%%%%%%%% finished

function settooltip(options,hand)
generating_module_string=get(hand,'String');
generating_module=generating_module_string(get(hand,'Value'));
generating_module=generating_module{1};
generating_functionline=['options.' generating_module '.displayname'];
eval(sprintf('displayname=%s;',generating_functionline'));
set(hand,'Tooltip',displayname);

function hand=getcheckboxhandle(handles,nr)
switch nr
	case 1
		hand=handles.checkbox0;
	case 2
		hand=handles.checkbox1;
	case 3
		hand=handles.checkbox2;
	case 4
		hand=handles.checkbox3;
	case 5
		hand=handles.checkbox4;
	case 6
		hand=handles.checkbox8;
	case 7
		hand=handles.checkbox5;
end

function hand=getbuttonhandle(handles,nr)
switch nr
	case 1
		hand=handles.pushbutton0;
	case 2
		hand=handles.pushbutton2;
	case 3
		hand=handles.pushbutton3;
	case 4
		hand=handles.pushbutton4;
	case 5
		hand=handles.pushbutton5;
	case 6
		hand=handles.pushbutton21;
	case 7
		hand=handles.pushbutton6;
end


function hand=getlisthandle(handles,nr)
switch nr
	case 1
		hand=handles.listbox0;
	case 2
		hand=handles.listbox1;
	case 3
		hand=handles.listbox2;
	case 4
		hand=handles.listbox3;
	case 5
		hand=handles.listbox4;
	case 6
		hand=handles.listbox6;
	case 7
		hand=handles.listbox5;
end


function hand=getframehandle(handles,nr)
switch nr
	case 1
		hand=handles.frame20;
	case 2
		hand=handles.frame21;
	case 3
		hand=handles.frame22;
	case 4
		hand=handles.frame23;
	case 5
		hand=handles.frame24;
	case 6
		hand=handles.frame25;
	case 7
		hand=handles.frame26;
end

function name=getsectionnames(nr);
switch nr
	case 1
		name='pcp';
	case 2
		name='bmm';
	case 3
		name='nap';
	case 4
		name='strobes';
	case 5
		name='sai';
	case 6
		name='usermodule';
	case 7
		name='movie';
end
