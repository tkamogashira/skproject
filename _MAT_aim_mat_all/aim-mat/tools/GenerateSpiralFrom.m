% tool
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


function sp=GenerateSpiralFrom(input,spiral_struct)

global threshold;

if ~isfield(spiral_struct,'threshold');
    threshold=20; % all pitches below this value are cut off
else
    threshold=spiral_struct.threshold;
end

if ~isfield(spiral_struct,'tilt_amount');
    tilt_amount=0;    % bedeutet fall of 2500% per second, eg 100% in 40 ms
else
    tilt_amount=spiral_struct.tilt_amount;
end

if ~isfield(spiral_struct,'max_frequency');
    max_frequency=5000; % the outer end of the pitch spiral
else
    max_frequency=spiral_struct.max_frequency;
    max_time=-1/max_frequency;
end

if ~isfield(spiral_struct,'overlap');
    overlap=0; % the outer end of the pitch spiral
else
    overlap=spiral_struct.overlap;
end

if ~isfield(spiral_struct,'tilt');
    tilt=0; % the outer end of the pitch spiral
else
    tilt=spiral_struct.tilt;
end

if ~isfield(spiral_struct,'start_radius');
    start_radius=3; % the outer end of the pitch spiral
else
    start_radius=spiral_struct.start_radius;
end

if ~isfield(spiral_struct,'biggest_dot');
    biggest_dot=10; % points
else
    biggest_dot=spiral_struct.biggest_dot;
end


if ~isfield(spiral_struct,'min_frequency');
    fr=input;
    max_time=getmaximumtime(fr);
    min_time=getminimumtime(fr);
    
    absmax_time=getmaximumtime(fr);
    absmin_time=getminimumtime(fr);
    
    if min_time < 0 & max_time > 0  % normalfall: -35 bis 5
        absmin_time=abs(min_time); % die ist normalerweise -35 ms
        absmax_time=1/max_frequency;   % Standartwert, entspricht 5 kHz
        max_time=-absmax_time;
    end
    
    if absmin_time<0
        error('generatefrom(frame): minimum time must be greater 0!');
    end
    if absmax_time<0
        error('generatefrom(frame): maximum time must be greater 0!');
    end
    
    min_frequency=1/absmin_time;
    max_frequency=1/absmax_time;
else
     min_frequency=spiral_struct.min_frequency;
     min_time=-1/min_frequency;
end

if min_frequency>max_frequency
    error('generateSpiralFrom: minfre > maxfre!')
end

sp=spiral(min_frequency,max_frequency);
sp=setoverlap(sp,overlap);
sp=settilt(sp,tilt);
sp=setstartradius(sp,start_radius);
heightscaler=getnroctaves(sp);
sp=setscaleheight(sp,heightscaler);
sp=setorginalvalues(sp,input);

if ~isfield(spiral_struct,'plotwithdots');
    sp=setplotwithdots(sp,'y'); % all pitches below this value are cut off
else
    sp=setplotwithdots(sp,spiral_struct.plotwithdots); % all pitches below this value are cut off
end


if isoftype(input,'frame')
    nr_chan=getnrchannels(input);
    for i=1:nr_chan
        sig=getsinglechannel(input,i);
        if tilt_amount>0
            sig=tilt(sig,tilt_amount);
        end
        [heights,maxima]=getlocalmaxima(sig);

        nr=length(heights);
        for j=1:nr
            if maxima(j) > min_time & maxima(j) < max_time
                shift=1-(i-1)/(nr_chan+1);
                sp=addmax(sp,shift,heights(j),maxima(j));
            end
        end
    end
end

if isoftype(input,'signal')
    if tilt_amount>0
        sig=tilt(input,tilt_amount);
    else
        sig=input;
    end
    [heights,maxima]=getlocalmaxima(sig,min_time,max_time);
    sp=addmax(sp,0,heights,maxima);
end


% now all points are there, but we have to find out about the real size
lmin=log(getminimumfrequency(sp));
lmax=log(getmaximumfrequency(sp));
step=(lmax-lmin)/200;
ran=lmin:step:lmax;
range=exp(ran);

[x,y,z]=getcoordinates(sp,getmaximumfrequency(sp));
if abs(y) > abs(x)
    maxscale=abs(y);
else 
    maxscale=abs(x);
end

% first find the size of the unscaled version
scale_x=0.15*(getscreensize(sp)-2*getedgemargin(sp))/maxscale;
scale_y=0.15*(getscreensize(sp)-2*getedgemargin(sp))/maxscale;
% and set this as the scale
sp=setscalex(sp,scale_x);
sp=setscaley(sp,scale_y);


% add the spiral itself

[x1,y1,z1]=getcoordinates(sp,range);    % inner circel
[x2,y2,z2]=getcoordinates(sp,range,1);  % outer circel

cords.x=[];cords.y=[];cords.z=[];
nr=max(size(y1)); 

for i=1:nr
    cords.x=[cords.x; x1(i) x2(i)];
    cords.y=[cords.y; y1(i) y2(i)];
    cords.z=[cords.z; z1(i) z2(i)];
end

obj.coordinates=cords;
obj.type='spiral';

sp=addsurfobject(sp,obj);

return


function sp=addmax(sp,shift,heights,maxima)
global threshold;
nr=size(heights,2);
for i=1:nr
    if heights(i) > threshold
        mafre=maxima(i);
        if mafre > 0
            error('GenerateSpiralFrom: addmax: error: frequency negativ');
        end
        newdot.frequency=1/-mafre;
        newdot.pitchstrength=heights(i);
        newdot.octave_shift=shift;
        newdot.color='r';
        sp=adddots(sp,newdot);
    end
end
