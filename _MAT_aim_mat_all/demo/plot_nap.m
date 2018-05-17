% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Written by Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function plot_nap(handles, options, current_scale, titlestr)

start_time=options.minimum_time;
stop_time=options.maximum_time;

current_frame=handles.data.nap;
str=get_graphics_options(handles,handles.info.current_nap_module);
str.minimum_time_interval=start_time;
str.maximum_time_interval=stop_time;
nrchan=getnrchannels(current_frame);
% if do_single_channel || nrchan==1
%     sig=getsinglechannel(current_frame,options.display_single_channel);
%     % 			sig=getpart(sig,start_time,stop_time);
%     ymin=0;
%     ymax=max(current_frame)*1.1;
%     plot(sig,[start_time stop_time]);
%     set(gca,'Ylim',[ymin,ymax]);set(gca,'YAxisLocation','right');
%     xlabel('time (ms)');ylabel('amplitude');title('');
% else
    hand=plot(current_frame,str);
    zmin=0;zmax=max(current_frame)/current_scale;

    %TCW AIM 2006
%     if hand_scaling == 1
         set(gca,'Zlim',[zmin,1/current_scale]);
%     else
%         set(gca,'Zlim',[zmin,zmax]);
%     end

    %set(gca,'Zlim',[zmin,zmax]);


    xlabel('time (ms)');ylabel('Frequency (kHz)');title(titlestr);

%     if strcmp(handles.screen_modus,'paper')
%         par=get(hand,'parent');
%         set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
%     end
% end
