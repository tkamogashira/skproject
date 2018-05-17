% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Written by Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function plot_strobes(input, options, current_scale, titlestr)

start_time=options.minimum_time;
stop_time=options.maximum_time;

sig=input.data.signal;
current_frame=input.data.nap;
strobes=input.data.strobes;
input.info.current_plot=4;
str=get_graphics_options(input,input.info.current_strobes_module);
str.minimum_time_interval=start_time;
str.maximum_time_interval=stop_time;
duration=stop_time-start_time;
sig=getpart(sig,start_time,stop_time);
nrchan=getnrchannels(current_frame);
temp_scale=1;   % for debugging
% make the dots of a size of constant ratio to the window size
axpos=get(gcf,'Position');
marker_dot_size=axpos(3)/168;

  %several channels
    hand=plot(current_frame/temp_scale,str);hold on
    xlabel('time (ms)');ylabel('Frequency (kHz)');title(titlestr);
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
                    if time>start_time & time<start_time+duration
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
                if time>start_time & time<stop_time
                    % 						if j<=length(herestrobes.strobe_vals)
                    val=herestrobes.strobe_vals(j);%/current_scale*max(current_frame);
                    %if strcmp(handles.screen_modus,'paper')
                    %    p=plot3(time2bin(sig,time),i,val/temp_scale,'Marker','o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth',1);
                    %else
                        plot3(time2bin(sig,time),i,val,'Marker','o','MarkerSize',marker_dot_size,'MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',1);
                    %end
                    % 						end
                end
            end
        end % one or two strobe sources
    end
    zmin=0;zmax=max(current_frame)/current_scale;

    % TCW AIM 2006
%    if hand_scaling == 1
        set(gca,'Zlim',[zmin,1/current_scale]);
%    else
%        set(gca,'Zlim',[zmin,zmax]);
%    end

    %set(gca,'Zlim',[zmin,zmax]);
 %   if strcmp(handles.screen_modus,'paper')
 %       par=get(hand,'parent');
 %       set(par,'FontSize',12);xlab=get(par,'xlabel');set(xlab,'FontSize',12);ylab=get(par,'ylabel');set(ylab,'FontSize',12);
 %   end

hold off

