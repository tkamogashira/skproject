%  
% function out = PeakPicker(sig_in, params)
%
%   Find the peaks of a signal
%
%   INPUT VALUES:
%       sig_in                  Input signal
%       params.dyn_thresh       dynamic threshold. Off if not used
%       params.smooth_sigma     sigma for smoothing
%                               
%       
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
% (c) 2003, University of Cambridge, Medical Research Council 
% Christoph Lindner 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function out = PeakPicker(sig_in, params)


% ----- Other Parameters -----
% Lowpass param for the higpassfilter
LP_sigma_for_HP_filter = getnrpoints(sig_in)/7;
LP_sigma_for_smooth = 3;
% min width of a peak: upper_threshold+lower_thresh
upper_thresh =  0.02*getnrpoints(sig_in);
lower_thresh =  0.03*getnrpoints(sig_in);

% x is index or position in vector
% y is value of the
% t is the time domain wich is assigned to the x dimension

% the original values befor filtering
orig_values = getdata(sig_in)';

if isfield(params,'smooth_sigma') 
    if (params.smooth_sigma~=0)
        % smooth the curve to kill small side peaks 
        sig_in = smooth(sig_in, params.smooth_sigma);
    end
end

values=getdata(sig_in)';

% ------------------- Find the local maxima ------------------------------
% find x positions of ALL local maxima, incl. zero!!
max_x = find((values >= [0 values(1:end-1)]) & (values > [values(2:end) 0]));
if isfield(params,'smooth_sigma') 
    if (params.smooth_sigma~=0)
        % smoothing might have shifted the positions of maxima.
        % Therefore the maximum is the highest of the neighbours in
        % distance +- smooth_sigma
        for i=1:length(max_x)
            start = max_x(i)-params.smooth_sigma;
            if start<1
                start=1;
            end
            stop = max_x(i)+params.smooth_sigma;
            if stop>length(orig_values)
                stop=length(orig_values);
            end
            m = find(orig_values(start:stop) == max(orig_values(start:stop)));
            m=m(1);
            max_x(i)=start-1+m;
        end
    end
end
max_y = orig_values(max_x);
orig_max_y = orig_values(max_x);

% ------------------- Find the local minima -----------------------------
min_x = find((values < [inf values(1:end-1)]) & (values <= [values(2:end) inf]));
min_y = values(min_x);


% peakpos_x=zeros(1,length(max_x));
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

% --------------- Dynamic Threshold ---------------------
% works relativ to the mean
if isfield(params,'dyn_thresh') 
    if (params.dyn_thresh~=0)
        % dynamic thresholding 
        m = mean(orig_values);  
        dthr = params.dyn_thresh.*m;
        peakpos_x = peakpos_x([peakpos_y>=dthr]);
        peakpos_y = peakpos_y([peakpos_y>=dthr]);
    end
end

maxima = cell(1, length(peakpos_x));
% find the left end right minima that belong to a maximum
for i=1:length(peakpos_x)
    maxima{i}.x = peakpos_x(i);
    maxima{i}.t = bin2time(sig_in, maxima{i}.x);
    maxima{i}.y = orig_values(peakpos_x(i));
    
    % find left and right minimum for this maximum
    maxima{i}.left.x = max(min_x([min_x < maxima{i}.x]));
    if isempty(maxima{i}.left.x)
        maxima{i}.left.x = 1;
        maxima{i}.left.t = 0;
        maxima{i}.left.y = orig_values(maxima{i}.left.x);
    else
        maxima{i}.left.y = orig_values(maxima{i}.left.x);
        maxima{i}.left.t = bin2time(sig_in, maxima{i}.left.x);
    end
    maxima{i}.right.x = min(min_x([min_x > maxima{i}.x]));
    if isempty(maxima{i}.right.x)
        maxima{i}.right.x = length(orig_values);
        maxima{i}.right.t = 0;
        maxima{i}.right.y = orig_values(maxima{i}.right.x);
    else
        maxima{i}.right.y = orig_values(maxima{i}.right.x);
        maxima{i}.right.t = bin2time(sig_in, maxima{i}.right.x);
    end
end


out = maxima;


