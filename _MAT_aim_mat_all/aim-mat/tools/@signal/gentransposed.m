% method of class @signal
% function sig=gentransposed(sig,fc,fm)
%   INPUT VALUES:
%       sig: @signal with length and samplerate 
% create a transposed stimulus according to (Hartmann, 1998, p. 106):

% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=gentransposed(sig,fc,fm,phi_c,phi_m)

if nargin<5
    phi_m=pi;
end
if nargin<4
    phi_c=0;
end

x=getxvalues(sig);
y=zeros(size(x));
nr=length(x);

om_c=2*pi*fc;
om_m=2*pi*fm;

for i=1:nr
    c=om_c*x(i)+phi_m;
    m=om_m*x(i)+phi_m;
    
    y(i)=1/pi * sin(c) + 0.5 * cos(m) * sin(c) + 2/(3*pi) * cos(2*m)*sin(c);
    
end

sig=setvalues(sig,y);