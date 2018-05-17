% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Written by Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function plot_bmm(input, options, current_scale,titlestr)

start_time=options.minimum_time;
stop_time=options.maximum_time;

current_frame=input.data.bmm;
str=get_graphics_options(input,input.info.current_bmm_module);
str.minimum_time_interval=start_time;
str.maximum_time_interval=stop_time;
nrchan=getnrchannels(input.data.bmm);
% if do_single_channel || nrchan==1
%     sig=getsinglechannel(current_frame,options.display_single_channel);
%     % 			sig=getpart(sig,start_time,stop_time);
%     ymin=min(current_frame)*1.1;ymax=max(current_frame)*1.1;
%     plot(sig,[start_time stop_time ymin ymax]);
%     set(gca,'Ylim',[ymin,ymax]);set(gca,'YAxisLocation','right');
%     xlabel('time (ms)');ylabel('amplitude');title('');
% else
    hand=plot(current_frame,str);
    zmin=min(current_frame)/current_scale;zmax=max(current_frame)/current_scale;

    %set(gca,'Zlim',[zmin,zmax]);

%     %TCW AIM 2006
%     if hand_scaling == 1
         set(gca,'Zlim',[0,1/current_scale]);
%     else
%         %TCW AIM 2006 to get this frequency axis correct, this lower
%         %limit of the z axis really needs to be zero
%         set(gca,'Zlim',[0,zmax]);
%     end

    xlabel('time (ms)');ylabel('Frequency (kHz)');title(titlestr);
%     if strcmp(handles.screen_modus,'paper')
%         par=get(hand,'parent');
%         set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
%     end
%end
