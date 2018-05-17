% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/17 16:57:46 $
% $Revision: 1.3 $

function ret=frequencysharpening(current_frame,options)
% frequency sharpening does local lateral inhibition according to its
% parameters


if nargin < 2
    options=[];
end


if isfield(options,'excitatory_area') % how many erbs the excitation lasts
    excitatory_area=options.excitatory_area;
else
    excitatory_area=0.5;
end

if isfield(options,'grafix') % how many erbs the excitation lasts
    grafix=options.grafix;
else
    grafix=0;
end

if isfield(options,'inhibitory_area') % how many erbs the inhibition lasts
    inhibitory_area=options.inhibitory_area;
else
    inhibitory_area=1.5;
end

if isfield(options,'inhibitory_influence') % how strong the inhibition is
    inhibitory_influence=options.inhibitory_influence;
else
    inhibitory_influence=0.2;
end


cfs=getcf(current_frame);
EarQ = 9.26449;				%  Glasberg and Moore Parameters
minBW = 24.7;
order = 1;
ERB = ((cfs/EarQ).^order + minBW^order).^(1/order);
B=1.019*2*pi.*ERB;

vals=getvalues(current_frame);
nr_chan=size(vals,1);
nr_dots=size(vals,2);
new_vals=zeros(size(vals));

% calculate the interchannel crossinfluence for each channel
erb1=21.4*log10(4.73e-3*cfs(1)+1);  % from Glasberg,Moore 1990
erb2=21.4*log10(4.73e-3*cfs(nr_chan)+1);
nr_erbs=erb2-erb1;
erb_density=nr_chan/nr_erbs;
neighbourinfluence=zeros(nr_chan);
if grafix
    figure(2)
    clf
end
for i=1:nr_chan  % through all channels: prepare working variable
    count=1;
    for j=i-nr_chan:i+nr_chan  % calculate the influence of all channels
        if j>0 & j< nr_chan 
            dist=abs(i-j);  % we are symmetric
            disterbs=dist/erb_density;  % so many erbs between the channel and me
            
            % the function(disterbs) to describe the influence of
            % neighbouring channels:
            %             final=1/disterbs;
            
            % Mexican hat function:
            %             p=disterbs*disterbs/(threshold_decay_halflife*threshold_decay_halflife);
            % version with power
            %             final=(2-p)*exp(-0.5*p);
            % version with difference from gaussians:
            p1=disterbs*disterbs/(excitatory_area*excitatory_area);
            p2=disterbs*disterbs/(inhibitory_area*inhibitory_area);
            final=exp(-p1)-inhibitory_influence*exp(-p2);
            
            neighbourinfluence(i,count)=final;
            count=count+1;
        end
    end
    % normalize it
    %     scale=1/sum(neighbourinfluence(i,:));
    %     neighbourinfluence(i,:)=neighbourinfluence(i,:)*scale;
    if grafix
        figure(2)
        plot(neighbourinfluence(i,:)); hold on
        if i==30
            plot(neighbourinfluence(i,:),'.-r','linewidth',3); hold on
        end
    end
end

for i=1:nr_dots % through the time
    for j=1:nr_chan  % through all channels: prepare working variable
        new_vals(:,i)=new_vals(:,i)+vals(:,i).*neighbourinfluence(:,j);
    end
end

s=getfrequencysum(current_frame);
current_frame=setvalues(current_frame,new_vals);

ret=current_frame;

if grafix
    figure(3) ;clf;
    s2=getfrequencysum(current_frame);
    plot(s); hold on
    ax=axis;
    plot(s2,'.-r');
    axis([0 58 0 40000]);
end
