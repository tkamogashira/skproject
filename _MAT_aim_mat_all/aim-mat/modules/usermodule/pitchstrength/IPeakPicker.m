% function out = PeakPicker(sig_in, params)
%
%   Find the peaks of a signal and their neighbours
%
%   INPUT VALUES:
%       sig_in                  Input signal
%         threshold     dynamic threshold. Off if not used
%                               
%
%   RETURN VALUE:
%       out is an array of a struct
%       out.x                    x position of the Peak
%       out.t                    according time value
%		out.y                    y value of the peak
%       out.left.[x,t,y]         left Minumum
%       out.right.[x,t,y]        right Minumum
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function out = PeakPicker(sig_in,threshold)
% threshold is the percentage of the maximum value of the signal,
% under which a peak is not counted

if nargin <2
	threshold=0;
end

plot_switch = 0;

% the original values befor filtering
orig_values = getdata(sig_in)';
values=getdata(sig_in)';

% ------------------- Find the local maxima ------------------------------
% find x positions of ALL local maxima, incl. zero!!
max_x = find((values >= [0 values(1:end-1)]) & (values > [values(2:end) 0]));
max_y = orig_values(max_x);
orig_max_y = orig_values(max_x);

% ------------------- Find the local minima -----------------------------
min_x = find((values < [inf values(1:end-1)]) & (values <= [values(2:end) inf]));
min_y = values(min_x);


peakpos_x=[];
for i=1:length(max_x),
    % only take the highest peak 
    my = [max_y==max(max_y)];  % find the highest peak
%     peakpos_x(i) = max_x(my);   % x pos of highest peak
    peakpos_x = [peakpos_x max_x(my)]; 
    max_y = max_y([max_y<max(max_y)]);   % del max value in y domain
    max_x = max_x([max_x ~= peakpos_x(end)]); % and in x domain
end
peakpos_y = orig_values(peakpos_x);  % extract the y vector 

% maxima = cell(1, length(peakpos_x));
maxima = [];

if plot_switch
	figure(123);
	clf
	plot(sig_in,'k');
	hold on;
end

threshold_val=threshold*max(sig_in);
counter=1;

% find the left end right minima that belong to a maximum
for i=1:length(peakpos_x)
	y_val= orig_values(peakpos_x(i));
	
	if y_val< threshold_val
		continue
	end

	maxima{counter}.y =y_val;
	maxima{counter}.x = peakpos_x(i);
	maxima{counter}.t = bin2time(sig_in, maxima{i}.x);
	maxima{counter}.fre = 1/maxima{counter}.t;
	
	if plot_switch
		plot(maxima{counter}.x,maxima{counter}.y,'go');
	end    
	% find left and right minimum for this maximum
	maxima{counter}.left.x = max(min_x([min_x < maxima{counter}.x]));
	if isempty(maxima{counter}.left.x)
		maxima{counter}.left.x = 1;
		maxima{counter}.left.t = 0;
		maxima{counter}.left.y = orig_values(maxima{counter}.left.x);
	else
		maxima{counter}.left.y = orig_values(maxima{counter}.left.x);
		maxima{counter}.left.t = bin2time(sig_in, maxima{counter}.left.x);
	end
	maxima{counter}.right.x = min(min_x([min_x > maxima{counter}.x]));
	if isempty(maxima{counter}.right.x)
		maxima{counter}.right.x = length(orig_values);
		maxima{counter}.right.t = 0;
		maxima{counter}.right.y = orig_values(maxima{counter}.right.x);
	else
		maxima{counter}.right.y = orig_values(maxima{counter}.right.x);
		maxima{counter}.right.t = bin2time(sig_in, maxima{counter}.right.x);
	end
	
	if plot_switch
		plot(maxima{counter}.right.x,maxima{counter}.right.y,'ro');
		plot(maxima{counter}.left.x,maxima{counter}.left.y,'ro');
	end
	counter=counter+1;
end


% umrechnung in die Darstellung, die wir brauchen:
for i=1:counter-1
	logtime=maxima{i}.t;
	time=logtime2time(logtime);
	maxima{i}.t=time;
	maxima{i}.fre=1/time;
	maxima{i}.y=gettimevalue(sig_in,logtime);

	left=maxima{i}.left;
	lefttime=logtime2time(left.t);
	maxima{i}.left.t=lefttime;
	maxima{i}.left.fre=1/lefttime;
	maxima{i}.left.y=gettimevalue(sig_in,left.t);

	right=maxima{i}.right;
	righttime=logtime2time(right.t);
	maxima{i}.right.t=righttime;
	maxima{i}.right.fre=1/righttime;
	maxima{i}.right.y=gettimevalue(sig_in,right.t);
end


out = maxima;



function time=logtime2time(logtime)
	time=f2f(logtime,0,0.035,0.001,0.035,'linlog');

