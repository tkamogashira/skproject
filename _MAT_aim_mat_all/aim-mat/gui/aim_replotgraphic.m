% procedure for 'aim-mat'
%function handles=replotgraphic(handles,options)
% 
%   INPUT VALUES:
%		handles
% 		options: fields indicate, which graphic is to plot:
% 		withtime=options.withtime;
% 		withfre=options.withfre;
% 		withsignal=options.withsignal;
% 		figure_handle=options.figure_handle;
%   RETURN VALUE:
%	updated handles
%
% plots the current graphic in the GUI or in the current windowhandle
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function handles=aim_replotgraphic(handles,options)

withtime=options.withtime;
withfre=options.withfre;
withsignal=options.withsignal;
figure_handle=options.figure_handle;

%TCW AIM2006 - added hand scaling so that when on the slider scale value is absolutely
%absolute. This is set in init_aim_gui (can we find anywhere better to do
%this?)
hand_scaling=handles.hand_scaling;

if isfield(options,'display_single_channel')
	do_single_channel=1;
else
	do_single_channel=0;
	options.display_single_channel=1; % in case, the frame has only one channel
end	

% where 
current_plot=handles.info.current_plot;	
if ~ishandle(figure_handle)
	new_fig=figure;
	handles.info.current_figure=new_fig;
end

figure(figure_handle);
clf
set(gca,'Position',[0 0.1 0.92 0.89]);
cur_axis=gca;

win=get(cur_axis,'Parent');
set(win,'NumberTitle','off');
namestr=aim_getwindowtitle(handles); % get the title of the current window
set(win,'Name',namestr);

relative_axis=get(gca,'Position'); % the relative axis for the plot. Everything is plotted inside
% define up to four graphic areas for the different plots inside the axis
% given in 'relative_axis'
[myaxes1,myaxes2,myaxes3,myaxes4]=aim_define_plot_areas(handles,relative_axis,options);
% 1: signal window at top
% 2: main window in middle
% 3: temporal profile
% 4: frequency profile

% find out about the signal, length and duration
sig=handles.data.signal;
% len=getlength(sig);


if current_plot>=6
	sai=handles.data.sai;
	if handles.with_graphic==0
		current_frame_number=handles.current_frame_nr;
	else
		current_frame_number=round(slidereditcontrol_get_value(handles.currentslidereditcombi));
	end
	if current_frame_number<=length(sai) && current_frame_number>0
		start_time=getcurrentframestarttime(sai{current_frame_number});
	else
		start_time=getminimumtime(sig);
		current_frame_number=1; % error!
		handles.currentslidereditcombi=slidereditcontrol_set_value(handles.currentslidereditcombi,length(sai));
	end
	duration=getlength(sai{current_frame_number});
else
	start_time=slidereditcontrol_get_value(handles.currentslidereditcombi);
	duration=slidereditcontrol_get_value(handles.slideredit_duration);
end
stop_time=start_time+duration;

% in case of auditory image, we simply want the last part of the signal:
if stop_time>getmaximumtime(sig);
	start_time=getmaximumtime(sig)-duration;
	stop_time=getmaximumtime(sig);
end
if start_time < getminimumtime(sig)
	start_time =getminimumtime(sig);
end
% sig=getpart(sig,start_time,stop_time);


% The signal window 
if withsignal
	set(myaxes1,'Visible','on');
% 	axes(myaxes1);
	% 	sig=getpart(sig,start_time,stop_time);
	if strcmp(handles.screen_modus,'paper')
		h=plot(sig,[start_time stop_time],myaxes1);
		set(h,'Color','k');
		set(h,'LineWidth',1.5);
	else
		plot(sig,[start_time stop_time],myaxes1);
	end		
	if min(sig)==0	% for niceness: Clicktrains are cut away otherwise
		ax=axis;
		ax(3)=-0.1;
		axis(ax);
	end
	title('');set(gca,'XTick',[]);set(gca,'YTick',[]);xlabel('');ylabel('');
end



% from here: plot in axes2:
% axes(myaxes2);
set(myaxes2,'XDir','normal')
set(myaxes2,'XScale','lin');
if handles.with_graphic==1
	current_scale=slidereditcontrol_get_value(handles.slideredit_scale);
else
	current_scale=options.data_scale;
end

switch current_plot
	case {-1,0,1}	% signal
		set(myaxes2,'Visible','off');
	case 2% pcp
		sig=handles.data.pcp;
% 		current_frame=getpart(sig,start_time,stop_time);
		ca=plot(sig,[start_time stop_time]);
		set(gca,'YTick',[]);
		ax=axis;
		ax(3)=ax(3)/current_scale;
		ax(4)=ax(4)/current_scale;
		axis(ax);
		title('');xlabel('');ylabel('');
	case 3% bmm
		current_frame=handles.data.bmm;
		str=get_graphics_options(handles,handles.info.current_bmm_module);
		str.minimum_time_interval=start_time;
		str.maximum_time_interval=stop_time;
		nrchan=getnrchannels(handles.data.bmm);
		if do_single_channel || nrchan==1
			sig=getsinglechannel(current_frame,options.display_single_channel);
% 			sig=getpart(sig,start_time,stop_time);
			ymin=min(current_frame)*1.1;ymax=max(current_frame)*1.1;
			plot(sig,[start_time stop_time ymin ymax]);
			set(gca,'Ylim',[ymin,ymax]);set(gca,'YAxisLocation','right');
			xlabel('time (ms)');ylabel('amplitude');title('');
		else
			hand=plot(current_frame,str,myaxes2);
			zmin=min(current_frame)/current_scale;zmax=max(current_frame)/current_scale;
			
            %set(gca,'Zlim',[zmin,zmax]);
			
            %TCW AIM 2006
            if hand_scaling == 1
                set(gca,'Zlim',[0,1/current_scale]);
            else
                %TCW AIM 2006 to get this frequency axis correct, this lower
                %limit of the z axis really needs to be zero
                set(gca,'Zlim',[0,zmax]);
            end
            
            xlabel('time (ms)');ylabel('Frequency (kHz)');title('');
			if strcmp(handles.screen_modus,'paper')
				par=get(hand,'parent');
				set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
			end	
		end
	case 4% nap
		current_frame=handles.data.nap;
		str=get_graphics_options(handles,handles.info.current_nap_module);
		str.minimum_time_interval=start_time;
		str.maximum_time_interval=stop_time;
		nrchan=getnrchannels(current_frame);
		if do_single_channel || nrchan==1
			sig=getsinglechannel(current_frame,options.display_single_channel);
% 			sig=getpart(sig,start_time,stop_time);
			ymin=0;
			ymax=max(current_frame)*1.1;
			plot(sig,[start_time stop_time]);
			set(gca,'Ylim',[ymin,ymax]);set(gca,'YAxisLocation','right');
			xlabel('time (ms)');ylabel('amplitude');title('');
		else
			hand=plot(current_frame,str);
			zmin=0;zmax=max(current_frame)/current_scale;
			
            %TCW AIM 2006
            if hand_scaling == 1
                set(gca,'Zlim',[zmin,1/current_scale]);
            else
                set(gca,'Zlim',[zmin,zmax]);
            end
            
            %set(gca,'Zlim',[zmin,zmax]);
			
            
            xlabel('time (ms)');ylabel('Frequency (kHz)');title('');
			
            if strcmp(handles.screen_modus,'paper')
				par=get(hand,'parent');
				set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
			end	
		end
	case 5% strobes
		current_frame=handles.data.nap;
		strobes=handles.data.strobes;
		str=get_graphics_options(handles,handles.info.current_strobes_module);
		str.minimum_time_interval=start_time;
		str.maximum_time_interval=stop_time;
		nrchan=getnrchannels(current_frame);
        temp_scale=1;   % for debugging
        % make the dots of a size of constant ratio to the window size 
        axpos=get(gcf,'Position');
        marker_dot_size=axpos(3)/168;
		if do_single_channel || nrchan==1  % only one channel
			
			chan_nr=options.display_single_channel;
% 			chan_nr = [chan_nr-2 chan_nr-1 chan_nr chan_nr+1];
% 			chan_nr = [chan_nr-1 chan_nr];
			chan_nr = chan_nr;
			chan_nr=chan_nr(chan_nr>0 & chan_nr < getnrchannels(current_frame));
			options.display_single_channel=chan_nr;
			
            plot_single_channel_strobes(current_frame,options,handles,str,strobes,current_scale,duration);
        else  %several channels
            hand=plot(current_frame/temp_scale,str,myaxes2);hold on
            xlabel('time (ms)');ylabel('Frequency (kHz)');title('');
            colscale=length(hsv)/nrchan;
            for i=1:nrchan
                if isfield(strobes,'grouped')
                    nr_sources=size(strobes.cross_strobes{1}.source_cross_channel_value,2);
                    cols=hsv;
                    % first plot the originals 
%                     herestrobes=strobes.original{i};
%                     nr_here=length(herestrobes.strobes);
%                     col=cols(round(i*colscale),:);
%                     xoffs=-0.001;
%                     for j=1:nr_here
%                         time=herestrobes.strobes(j);
%                         if time>start_time & time<start_time+duration
%                             val=herestrobes.strobe_vals(j);%/current_scale*max(current_frame);
%                             plot3(time2bin(sig,time+xoffs),i,val,'Marker','o','MarkerFaceColor',col,'MarkerEdgeColor',col,'MarkerSize',3);
%                         end
%                     end

                    % then plot all the different connections
                    herestrobesproces=strobes.cross_strobes{i};
                    herestrobes=herestrobesproces.strobe_times;
                    col=cols(round(i*colscale),:);
                    cursize=1;
                    nr_here=length(herestrobes);
                    for j=1:nr_here
                        count=0;
                        for k=1:nr_sources
                            target_chan_act=herestrobesproces.source_cross_channel_value(j,k);
                            if target_chan_act>1
                                colnr=round(k*length(hsv)/nr_sources);
                                colnr=min(colnr,length(hsv));
                                colnr=max(colnr,1);
                                col=cols(colnr,:);
                                cursize=target_chan_act/100;
                            else
                                continue
                            end
                            time=herestrobes(j);
                            if time>start_time && time<start_time+duration
                                offx=(stop_time-start_time)/80*count;
                                count=count+1;
                                val=herestrobesproces.strobe_vals(j)/temp_scale;%/current_scale*max(current_frame);
                                if strcmp(handles.screen_modus,'paper')
                                    p=plot3(time2bin(sig,time+offx),i,val,'Marker','o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth',1);
                                else
                                    plot3(time2bin(sig,time+offx),i,val,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',cursize);
                                end
                            end
                        end
                    end
                else    % only one set of strobes
                    herestrobes=strobes{i};
                    nr_here=length(herestrobes.strobes);
%                     marker_dot_size=4;
                    for j=1:nr_here
                        time=herestrobes.strobes(j);
                        if time>start_time && time<start_time+duration
                            % 						if j<=length(herestrobes.strobe_vals)
                            val=herestrobes.strobe_vals(j);%/current_scale*max(current_frame);
                            if strcmp(handles.screen_modus,'paper')
                                p=plot3(time2bin(sig,time-start_time),i,val/temp_scale,'Marker','o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth',1);
                            else
                                plot3(time2bin(sig,time-start_time),i,val,'Marker','o','MarkerSize',marker_dot_size,'MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',1);
                            end
                            % 						end
                        end
                    end
                end % one or two strobe sources
            end        
            zmin=0;zmax=max(current_frame)/current_scale;
            
            % TCW AIM 2006
            if hand_scaling == 1
                set(gca,'Zlim',[zmin,1/current_scale]);
            else
                set(gca,'Zlim',[zmin,zmax]);
            end
            
            %set(gca,'Zlim',[zmin,zmax]);
            if strcmp(handles.screen_modus,'paper')
				par=get(hand,'parent');
				set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
			end	
		end
		hold off
	case 6% sai
		sai=handles.data.sai;
		current_frame=sai{current_frame_number};
		allmax=getallmaxvalue(current_frame);
		str=get_graphics_options(handles,handles.info.current_sai_module);
		str.extra_options=getfield(handles.all_options.sai,handles.info.current_sai_module);
		nrchan=getnrchannels(current_frame);
		if do_single_channel || nrchan==1
			current_frame=current_frame;
			sig=getsinglechannel(current_frame,options.display_single_channel);
			h=plot(sig,str);set(gca,'YAxisLocation','right');
			set(gca,'YLim',[0 allmax*1.1]);
		else
			hand=plot(current_frame,str,myaxes2);
			%%% TCW - AIM2006
            %zmin=0;zmax=50/current_scale;
			zmin=0;zmax=(max(current_frame)+eps*1000)/current_scale;
            %%%
            
            %TCW AIM 2006
            if hand_scaling == 1
                set(gca,'Zlim',[zmin,1/current_scale]);
            else
                set(gca,'Zlim',[zmin,zmax]);
            end
            
            %set(gca,'Zlim',[zmin,zmax]);
			if strcmp(handles.screen_modus,'paper')
				par=get(hand,'parent');
				set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
			end	
		end
		xlabel('time interval (ms)');ylabel('Frequency (kHz)');title('');
	case 7% user module
		usermodule=handles.data.usermodule;
		nr_frames=length(usermodule);
		current_frame_number=round(slidereditcontrol_get_value(handles.currentslidereditcombi));
		
		current_data=handles.data.usermodule;
		first_data=current_data{1};
		if isobject(first_data) && isoftype(first_data,'frame')
			current_frame=current_data{current_frame_number};
		else
			current_frame=sai{current_frame_number};
		end
		plotting_frame=current_frame*current_scale;
		
		generating_module_string=get(handles.listbox6,'String');
		generating_module=generating_module_string(get(handles.listbox6,'Value'));
		generating_module=generating_module{1};
		generating_functionline=['handles.all_options.usermodule.' generating_module '.displayfunction'];
		eval(sprintf('display_function=%s;',generating_functionline'));
		if strcmp(display_function,'')
			str=get_graphics_options(handles,handles.info.calculated_usermodule_module);
			plot(plotting_frame,str,myaxes2);
			xlabel('time interval (ms)');ylabel('Frequency (kHz)');title('');
		else
			generating_options_line=['options=handles.all_options.usermodule.' generating_module ';'];
			eval(generating_options_line);
			options.handles=handles;
			plotstr=sprintf('%s(usermodule,options,%d,myaxes2)',display_function,current_frame_number);
			eval(plotstr);
		end
end

% now do the axes 3 and 4 (the two profiles)
if current_plot>1 && withtime
% 	axes(myaxes2);
	set(myaxes2,'XTick',[]);
    set(get(myaxes2,'xlabel'),'string','');
	
	if current_plot<6
		str.minimum_time_interval=start_time;
		str.maximum_time_interval=start_time+duration;
		str.is_log=0;
		str.time_reversed=0;
		str.time_profile_scale=-1; % decide on your own!
	else
		if current_plot==6
			str=get_graphics_options(handles,handles.info.calculated_sai_module);
			str.time_profile_scale=-1; %variable scaling
            % TCW AIM2006 WAS:
            %str.time_profile_scale=1; %fixed scaling
		else
			str=get_graphics_options(handles,handles.info.calculated_usermodule_module);
		end
	end
	hand=plottemporalprofile(current_frame,str,myaxes3);
	if current_plot<6
        set(get(myaxes3,'xlabel'),'string','time (ms)');
% 		xlabel('time (ms)')
	elseif getxaxis(current_frame)=='0'
        set(get(myaxes3,'xlabel'),'string','Time-Interval, Peak-Frequency product, \ith');
% 		xlabel('Time-Interval, Peak-Frequency product, \ith') %brute force method change by Rich 
    elseif strcmp(getxaxis(current_frame),'harmonic ratio')
        set(get(myaxes3,'xlabel'),'string','harmonic ratio');
% 		xlabel('harmonic ratio') %brute force method change by Stefan we must do something about this!!
    else
        set(get(myaxes3,'xlabel'),'string','time interval (ms)');
% 		xlabel('time interval (ms)')
	end
	title('');
    set(gca,'XMinorTick','off');
	if strcmp(handles.screen_modus,'paper')
		set(hand,'Color','k');
		set(hand,'LineWidth',1.5);
		par=get(hand,'parent');
		set(par,'FontSize',12);
		xlab=get(par,'xlabel');
		set(xlab,'FontSize',12);
	end
	
else
	set(myaxes2,'TickLength',[0.01,0.01]);
end

if current_plot>1 && withfre
	set(myaxes2,'YTick',[]);
    set(get(myaxes2,'ylabel'),'string','');
% 	ylabel('');
% 	axes(myaxes4);
% 	cla
	
	
	if current_plot<6
		str.minimum_time_interval=start_time;
		str.maximum_time_interval=start_time+duration;
		str.frequency_profile_scale=-1; % decide on your own according to momentan state
	else
		str.frequency_profile_scale=1; % fixed scaling
		
	end    
	
	if getxaxis(current_frame)=='0'
		hand=plotfrequencyprofile(current_frame,str,myaxes4);
        set(get(myaxes4,'xlabel'),'string','Mellin variable c');
%         set(get(myaxes4,'xlabel'),'string','Mellin variable, \it{c/2\pi');
% 		xlabel('Mellin variable, \it{c/2\pi}'); %brute force change by Rich
		str.shrink_range=-1;
    elseif strcmp(getxaxis(current_frame),'harmonic ratio')
        str.frequency_profile_scale=-1;
        hand=plotfrequencyprofile(current_frame,str,myaxes4);
        set(get(myaxes4,'xlabel'),'string','scale variable');
% 		xlabel('scale variable'); %
	else
% 		str.shrink_range=1/0.85;
		str.shrink_range=1;
		hand=plotfrequencyprofile(current_frame,str,myaxes4);
        set(get(myaxes4,'xlabel'),'string','Frequency (kHz)');
% 		xlabel('Frequency (kHz)');
	end
	if strcmp(handles.screen_modus,'paper')
		set(hand,'Color','k');
		set(hand,'LineWidth',1.5);
		par=get(hand,'parent');
		set(par,'FontSize',12);
		xlab=get(par,'xlabel');
		set(xlab,'FontSize',12);
		% 		set(get(hand,
	end
	
else
	set(myaxes2,'TickLength',[0.01,0.01]);
end

if isfield(handles.info,'domovie') % no more actions!
	return
end


% handles potential other windows
if isfield(handles.info,'children') && ~isfield(handles.info,'iscallfromchild') && current_plot <7
	% first check, whether the child is still there:
	if ~ishandle(handles.info.children.single_channel.windowhandle)
		rmfield(handles.info,'children');
		return	
	end
	channr=single_channel_gui('getchannelnumber');
	handles.info.children.single_channel.channelnumber=channr;
	single_channel_gui(handles);
	
end




function str=get_graphics_options(handles,module_name)
% returns the graphic options, if they exist

str=[];
if isfield(handles.all_options.graphics,module_name)
	str=getfield(handles.all_options.graphics,module_name);
else
	% 	disp(sprintf('graphics part for module %s not found. Check version',module_name));
	switch handles.info.current_plot
		case {1,2,3,4,5}
			opstr.is_log=0;
			opstr.time_reversed=0;
			opstr.plotstyle='waterfall';
			opstr.plotcolor='k';
			opstr.display_time=0;
		case {6}
			opstr.is_log=1;
			opstr.time_reversed=1;
			opstr.plotstyle='waterfall';
			opstr.plotcolor='k';
			opstr.minimum_time=0.001;
			opstr.maximum_time=0.032;
			opstr.display_time=0;
	end
end


function plot_single_channel_strobes(current_frame,options,handles,str,strobes,current_scale,duration)
start_time=str.minimum_time_interval;
stop_time=str.maximum_time_interval;

nr_channels=length(options.display_single_channel);

count=0;
for channr=options.display_single_channel
	count=count+1;
	sig=getsinglechannel(current_frame,channr);
 	sigpart=getpart(sig,start_time,stop_time);
	ymin=0;ymax=max(current_frame)*1.2;
	if strcmp(handles.screen_modus,'paper')
% 		hand=plot(sigpart,[getminimumtime(sigpart),getminimumtime(sigpart)+getlength(sigpart)]);
		hand=plot(sig,[start_time stop_time]);
		set(hand,'Color','k');
		set(hand,'LineWidth',1.5);
		ylabel('NAP amplitude');
		par=get(hand,'parent');
		set(par,'FontSize',12);
		xlab=get(par,'xlabel');
		set(xlab,'FontSize',12);
		set(gca,'Ytick',[]);
		set(gca,'YAxisLocation','right');
	else
		switch count
			case 1
				color='b';
			case 2 
				color='m';
		end
		plot(sigpart,[getminimumtime(sigpart),getminimumtime(sigpart)+getlength(sigpart)],color);
	end
	hold on
	
	athres=handles.data.thresholds;%*current_scale/getallmaxvalue(current_frame);
	thres=getsinglechannel(athres,channr);
 	thres=getpart(thres,start_time,stop_time);
	hand=plot(thres,[start_time stop_time 0 max(current_frame)/current_scale],'g');
	if strcmp(handles.screen_modus,'paper')
		set(hand,'Color','k');
		set(hand,'LineWidth',1.5);
		par=get(hand,'parent');
		set(par,'FontSize',12);
		xlab=get(par,'xlabel');
		ylabel('NAP amplitude');
		set(xlab,'FontSize',12);
	else
		xlabel('time (ms)');ylabel('amplitude');title('');set(gca,'YAxisLocation','right');
	end
	herestrobes=strobes{channr};
	nr_here=length(herestrobes.strobes);
	for j=1:nr_here
		time=herestrobes.strobes(j);
		if time>start_time & time<start_time+duration
			val=herestrobes.strobe_vals(j);%*current_scale/max(current_frame);
			if strcmp(handles.screen_modus,'paper')
				p=plot(time2bin(thres,time),val,'Marker','o','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth',1);
			else
				%plot(time2bin(thres,time),val,'.r');
                plot(time.*1000, val, 'r.');
			end
		end
	end
	set(gca,'Ylim',[ymin,ymax]);
end