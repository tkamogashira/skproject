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



function handles=do_aim_autoscale(handles)

hand_scaling=handles.hand_scaling;

maxscalenumber=1; % this is the value to which the highest point is scaled to -> should look ok
multiplier=1;

start_time=slidereditcontrol_get_value(handles.currentslidereditcombi);
% start_time=start_time+getminimumtime(handles.data.signal);
duration=slidereditcontrol_get_value(handles.slideredit_duration);
stop_time=start_time+duration;
scale=slidereditcontrol_get_value(handles.slideredit_scale);

% TCW - in preparing aim-2006 I decided that this multiplier stuff is
% near-pointless
switch handles.info.current_plot
    case {-1,0,1}
        return
    case 2 % pcp
        data=handles.data.pcp;
%         data=getpart(data,start_time,stop_time);
		%TCW AIM2006
        %multiplier=0.01;

        multiplier=0.8;

	case 3	% bmm
        data=handles.data.bmm;
        data=getpart(data,start_time,stop_time);
        nr_channels=getnrchannels(data);

        %TCW AIM2006
        if hand_scaling==1
            multiplier=1./max(data);
        else
            if nr_channels==1
                multiplier=0.8;
            else
                multiplier=30/nr_channels;
            end
        end
        %%

    case {4,5}
        data=handles.data.nap;
%         data=getpart(data,start_time,stop_time);
        nr_channels=getnrchannels(data);
        nr_channels=getnrchannels(data);

        %TCW AIM2006
        if hand_scaling==1
            multiplier=1./max(data);
        else
            if nr_channels==1
                multiplier=0.8;
            else
                multiplier=30/nr_channels;
            end
        end
        %%

% 		if nr_channels==1
% 	        multiplier=0.8;
% 		else
%   			multiplier=30/nr_channels;
% 		end
    case 6
        sai=handles.data.sai;
        nr_frames=length(sai);
        current_frame_number=round(slidereditcontrol_get_value(handles.currentslidereditcombi));
        current_frame=sai{current_frame_number};
        nr_channels=getnrchannels(current_frame);
        data=current_frame;

        % TCW AIM 2006
        if hand_scaling==1
           m=max(data);
           if m>0
               multiplier=1./max(data);
           else
               multiplier=1;
           end
        else
            if nr_channels>1
                multiplier=50/nr_channels;
                multiplier=multiplier*max(data)/getallmaxvalue(data);
            else
                multiplier=1;
            end
        end

% 		if nr_channels>1
% 	        multiplier=50/nr_channels;
% %  			multiplier=multiplier*max(data)/getallmaxvalue(data);
% 		else
% 			multiplier=1;
% 		end
    case 7
		return;
    case 8
		return;
end

%multiplier=1;

if handles.info.current_plot < 6
	%TCW AIM2006
    %maxdata=max(data);
    maxdata=1;
	if maxdata>0
		newscale=maxscalenumber*multiplier/maxdata;
	    newscale=min(newscale,handles.slideredit_scale.maxvalue);
	    newscale=max(newscale,handles.slideredit_scale.minvalue);
	else
	    newscale=1;
	end
else
    %TCW AIM2006
	%maxdata=getallmaxvalue(data);
    maxdata=1;
	if maxdata>0
		newscale=maxscalenumber*multiplier/maxdata;
	    newscale=min(newscale,handles.slideredit_scale.maxvalue);
	    newscale=max(newscale,handles.slideredit_scale.minvalue);
	else
	    newscale=1;
	end
end
%newscale=1;
handles.slideredit_scale=slidereditcontrol_set_value(handles.slideredit_scale,newscale);
