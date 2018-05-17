% support file for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function cool_frame_plot_colors(fr,handle,options)
% changes the plot colors of a frame plot 



if isfield(options,'select_channel_center_frequency')
	color_center_frequency=options.select_channel_center_frequency;
	select_channel_frequency_above=options.select_channel_frequency_range_above;
	select_channel_frequency_below=options.select_channel_frequency_range_below;
% 	color_width_frequency=options.select_channel_frequency_range;
	stress_color='r';
	% calculate, which channels are wanted, and wich are not
	min_selected_frequency=color_center_frequency/power(2,select_channel_frequency_below);
	max_selected_frequency=color_center_frequency*power(2,select_channel_frequency_above);
else
	min_selected_frequency=0;
	max_selected_frequency=inf;
end

% do we have resolved harmonics additionally? If so, new color!
if isfield(options,'resolved_harmonic_minimum')
	has_resolved_harmonics=1;
	resolved_harmonics=options.resolved_harmonic_minimum;
% 	resolved_harmonics=20;;
else
	has_resolved_harmonics=0;
end


if has_resolved_harmonics==0 && min_selected_frequency==0 && max_selected_frequency==0
	return
end
if has_resolved_harmonics==0 && min_selected_frequency==0 && max_selected_frequency==inf
	return
end

cfs=getcf(fr);
sr=getsr(fr);


% Special Effect: Make Region cool!
cdat=get(handle,'cdata');
cdat=zeros(size(cdat));
nr_points=size(cdat,1);
nr_chan=getnrchannels(fr);
for channr=1:nr_chan
	current_cf=cfs(channr);
	if current_cf >min_selected_frequency && current_cf < max_selected_frequency
		cdat(:,channr)=1;
	else
		cdat(:,channr)=0;
	end
	if has_resolved_harmonics
		resolved_time=1/(current_cf/resolved_harmonics);
		resolved_bin=floor(resolved_time*sr);
		resolved_bin=min(resolved_bin,nr_points);
		% 			resolved_bin=200;
		cdat(1:resolved_bin,channr)=0.5;
	end
end

colm=prism;
colm(1,:)=0; % black for zero

colormap(colm);

% Trick, den ich nicht verstehe, wenn ich das nicht mache, werden
% unten Linien eingeblendet
cd=get(handle,'cdata');
nans=find(isnan(cd));
cdat(nans)=nan; %????????
set(handle,'cdata',cdat);
% set(handle,'CDataMapping','scaled');
% set(handle,'edgecolor','flat')
