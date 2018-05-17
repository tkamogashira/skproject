% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Written by Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function plot_sai(input, current_frame_number, current_scale, titlestr)
%hand_scaling=1;


sai=input.data.sai;
current_frame=sai{current_frame_number};
allmax=getallmaxvalue(current_frame);
str=get_graphics_options(input,input.info.current_sai_module);
str.extra_options=getfield(input.all_options.sai,input.info.current_sai_module);
nrchan=getnrchannels(current_frame);
% if do_single_channel || nrchan==1
%     current_frame=current_frame;
%     sig=getsinglechannel(current_frame,options.display_single_channel);
%     h=plot(sig,str);set(gca,'YAxisLocation','right');
%     set(gca,'YLim',[0 allmax*1.1]);
% else
    hand=plot(current_frame,str);
    %%% TCW - AIM2006
    %zmin=0;zmax=50/current_scale;
    zmin=0;zmax=(max(current_frame)+eps*1000)/current_scale;
    %%%

    %TCW AIM 2006
%    if hand_scaling == 1
        set(gca,'Zlim',[zmin,1/current_scale]);
%    else
%        set(gca,'Zlim',[zmin,zmax]);
%    end

    %set(gca,'Zlim',[zmin,zmax]);
    %if strcmp(handles.screen_modus,'paper')
    %    par=get(hand,'parent');
    %    set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
    %end
% end
xlabel('time interval (ms)');ylabel('Frequency (kHz)');title(titlestr);
