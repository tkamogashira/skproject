% method of class @signal
% function sigresult=smooth(org_sig,sigma)
%   INPUT VALUES:
%       org_sig:       orgiginal @signal
%       sigma:         smooth width
%       type:          'gauss'  gauss average, sigma is sigma of gauss function (default)
%                      'rect'   rectangle window,  width = 2*sigma+1 
%                               mirrow signal at border
%                       
%   RETURN VALUE:
%       sigresult:  smoothed @signal
%
% smoothes the signal by multipliing it with gaussian filters of
% the width "sigma" in ms
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=smooth(org_sig,sigma, type)

% vals=getvalues(org_sig);
% % check sigma 
% if sigma<3
%     sigma==3
% end
% if mod(sigma, 2)==0
%     sigma=sigma+1
% end
% % Generate Kernel
% t = (-2*sigma):(2*sigma);
% kernel = 1/(sqrt(2*pi)*sigma)*exp(-(t).^2/(2*sigma.^2));
% 
if (nargin<3)
    type='gauss';
end

vals=getvalues(org_sig);
new_vals=vals; 
% Stefans's version
if strcmp(type,'gauss')
    nr_points=getnrpoints(org_sig);
    smooth_base=1:nr_points;
    smooth_frame = zeros(nr_points,1);
    for ii = 1:nr_points
%         kernel = exp(-(smooth_base-ii).^2/(2*sigma^2));
        kernel = exp(-(((smooth_base-ii).*(smooth_base-ii))/(2*sigma*sigma)));
        kernel = kernel / sum(kernel);
        new_vals(ii) = sum(vals.*kernel');
    end
end
if strcmp(type, 'rect')
   nr_points=getnrpoints(org_sig); 
   % mirroring the border
   sigma=round(sigma);
   vals=vals';
   if (length(vals)<sigma)
       sig=signal(org_sig);
       results(1:nr_points) = mean(vals');
       sig=setvalues(sig, results');
       return;
   end
   vals = [upsidedown(vals(1:sigma)) vals upsidedown(vals((end-sigma+1):end))];
%    kernel = ones(1, (2*sigma+1));
%    kernel = kernel/sum(kernel);
   faktor = 1/(2*(sigma+1));
   vals = vals.*faktor;
   for i=1:nr_points
       new_vals(i) = sum(vals(i:(i+2*sigma)));
   end
   new_vals=new_vals';
end


 
sig=signal(org_sig);
sig=setvalues(sig, new_vals);
sig=setname(sig, sprintf('smoothed Signal %s', getname(org_sig)));



% turns a vector (row) upside down
function y=upsidedown(x)
y=[];
for i=length(x):-1:1
    y=[y x(i)];
end