% generating function for 'aim-mat'
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


function displaypitchstrength(sai,options,frame_number,ax)
if nargin<4
    ax=gca;
end


% ?????? per Definition ????
% minimum_time_interval=0.1;  % in ms
% maximum_time_interval=35;


ti_result=options.handles.data.usermodule{frame_number}.ti_result;
% f_result=options.handles.data.usermodule{frame_number}.f_result;
if ~isfield(ti_result,'peaks')
    return;
end

% fq_sum = f_result.smoothed_signal;
int_sum = ti_result.smoothed_signal;
cla;
hold on

% TIP
% tip=getvalues(int_sum);
% the tip is in the form of a logarithmic signal, it must therfore be
% transformed back to linear:

% tip_x = bin2time(int_sum, 1:length(tip));  % Get the times
% tip_x = tip_x((tip_x>=(minimum_time_interval/1000)) & tip_x<=(maximum_time_interval/1000));  
% tip = tip(time2bin(int_sum,tip_x(1)):time2bin(int_sum,tip_x(end)));
% % tip_x is in ms. Change to Hz
% tip_x = 1./tip_x;
% plot(tip_x, tip, 'b');

% plot the smoothed interval profile, from which the pitch was derived
smoothed_signal=ti_result.smoothed_signal;
% if ~isempty(smoothed_signal)
% 	smoothed_signal=linsigx(smoothed_signal); % change the logarithmic signal back to linear
% 	% smoothed_signal=reverse(smoothed_signal);
% 	smoothval=getvalues(smoothed_signal);
% 	s_x = bin2time(smoothed_signal, 1:length(smoothval));  % Get the times
% 	s_x = s_x((s_x>=(minimum_time_interval/1000)) & s_x<=(maximum_time_interval/1000));  
% 	
% 	smoothval=smoothval(time2bin(smoothed_signal,s_x(1)):time2bin(smoothed_signal,s_x(end)));
% %     s_x=f2f(s_x,0,0.035,0.0001,0.035);
% %     s_x=(s_x+0.0001); %??????????
% %  	s_x=s_x*1.01; %??????????
% 	s_x=1./s_x;
% 	plot(ax,s_x,smoothval,'b');
% end

% set(gca,'XScale','log');    
plot(smoothed_signal);
hold on

% xlabel('Frequency [Hz]');
set(gca, 'YAxisLocation','right');
% pks = [];

% nr_labels = 8;
% ti=50*power(2,[0:nr_labels]);
% for i=1:length(pks)
%     ti = ti((ti>(pks(i)+pks(i)*0.1))|(ti<pks(i)-pks(i)*0.1));
% end
% ti = [ti round(pks)];
% ti = sort(ti);
% set(gca,'XTick', ti);
% set(gca, 'XLim',[1000/maximum_time_interval sai{frame_number}.channel_center_fq(end)])
set(options.handles.checkbox6, 'Value',0);
set(options.handles.checkbox7, 'Value',0);


% if there is a target frequency, then plot this one also!
target_frequency=options.target_frequency;
% at least three possibilities: take the hight:
% pitchstrength=ti_result.free.highest_peak_hight;
% dominant_frequency_found= ti_result.free.highest_peak_frequency;


% three different pitch strengths
% select the one with the highest peak rate

peaks=ti_result.peaks;
% select the one with the highest neigbouring_ratio
peaks2=sortstruct(peaks,'v2012_height_base_width_ratio');
% peaks2=sortstruct(peaks,'peak_base_height_y');
% peaks2=sortstruct(peaks,'y');


if length(peaks2)>1
% 	for ii=1:length(peaks)
	for i=1:min(3,length(peaks))
		t=peaks2{i}.t;
		ypeak=peaks2{i}.y;
% 		ps=peaks{ii}.pitchstrength;
		ps=peaks2{i}.v2012_height_base_width_ratio;
        
       
		if i==1
			plot(t,ypeak,'Marker','o','Markerfacecolor','b','MarkeredgeColor','b','MarkerSize',10);
 			text(t,ypeak*1.05,sprintf('%3.0f Hz: %4.2f ',1/t,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','b','Fontsize',12);
		else
			plot(t,ypeak,'Marker','o','Markerfacecolor','g','MarkeredgeColor','w','MarkerSize',5);
			text(t,ypeak*1.05,sprintf('%3.0f Hz: %4.2f ',1/t,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','g','Fontsize',12);
        end
        plot(peaks2{i}.left.t,peaks2{i}.left.y,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',5);
        plot(peaks2{i}.right.t,peaks2{i}.right.y,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',5);
        
        
        ybase=peaks2{i}.v2012_base_where_widths;
		line([t t],[ybase ypeak],'color','m');
		line([peaks2{i}.left.t peaks2{i}.right.t],[ybase ybase],'color','m');
        
    end
    
     set(gca,'xscale','log')
    set(gca,'xlim',[0.001 0.03])
    
    fres=[500 300 200 150 100 70 50 20];
    set(gca,'xtick',1./fres);
    set(gca,'xticklabel',fres);
    xlabel('Frequency (Hz)')
    ylabel('arbitrary normalized units')
end

if target_frequency>0 % search only at one special frequency
	found_fre=ti_result.fixed.highest_peak_frequency;
	if found_fre>0
		yval=gettimevalue(smoothed_signal,1/found_fre);
	else 
		yval=0;
	end
	plot(found_fre,yval,'Marker','o','Markerfacecolor','y','MarkeredgeColor','w','MarkerSize',5);
	
	found_ps=ti_result.fixed.highest_peak_hight;
	plot(found_fre,yval,'Marker','o','Markerfacecolor','g','MarkeredgeColor','w','MarkerSize',10);
	text(found_fre/1.1,yval*1.01, ['Pitchstrength at fixed ' num2str(round(found_fre)) 'Hz: ' num2str(fround(found_ps,2)) ],'VerticalAlignment','bottom','HorizontalAlignment','right','color','g','Fontsize',12);
	bordery=get(gca,'Ylim');
	line([target_frequency target_frequency],[bordery(1) bordery(2)],'color','g')
    min_fre=target_frequency/options.allowed_frequency_deviation;
    max_fre=target_frequency*options.allowed_frequency_deviation;
	line([min_fre min_fre],[bordery(1) bordery(2)],'color','g')
	line([max_fre max_fre],[bordery(1) bordery(2)],'color','g')
end

% maxy=sai{end}.ti_resultlt.peaks{1}.y;
maxy=max(int_sum); 
if maxy==0
    maxy=1;
end
set(ax,'Ylim',[0,maxy*1.1]);


% plot the frequency profile
plot_frequency_profile=0;
if plot_frequency_profile
%Plot both profiles into one figure
% FQP
fqp = getvalues(fq_sum)';
% fqp = fqp /1000;
plot(sai{frame_number}.channel_center_fq, fqp,'r');

peaks=f_result.peaks;
if length(peaks)>1
% 	for ii=1:length(peaks)
	for ii=1:1
		fre=1/peaks{ii}.t;
		yval=peaks{ii}.y;
% 		ps=peaks{ii}.pitchstrength;
		ps=peaks{ii}.y;
		if ii==1
			plot(fre,yval,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',10);
			text(fre,yval*1.03,sprintf('%3.0f Hz: %4.2f ',fre,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','r','Fontsize',12);
		else
			plot(fre,yval,'Marker','o','Markerfacecolor','g','MarkeredgeColor','w','MarkerSize',5);
			text(fre,yval*1.03,sprintf('%3.0f Hz: %4.2f ',fre,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','g','Fontsize',12);
		end
	end
end
hold off
end


return

function fre=x2fre(sig,x)
	t_log = bin2time(sig,x);
	t=f2f(t_log,0,0.035,0.001,0.035,'linlog');
	fre=1/t;
