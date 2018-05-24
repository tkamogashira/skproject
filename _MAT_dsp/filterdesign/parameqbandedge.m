function [w1,w2] = parameqbandedge(w0,Dw,dir)
%PARAMEQBANDEDGE Calculate left and right bandedge frequencies from
%                bilinear transformation.
%
% Usage: [w1,w2] = parameqbandedge(this,w0,Dw,dir);
%    
%        [w1,w2] = parameqbandedge(this,w0,Dw);          equivalent to dir=0
%        [w1,w2] = parameqbandedge(this,w0,Dw,0);        calculate w1,w2 from w0,Dw
%        [w0,Dw] = parameqbandedge(this,w1,w2,1);        calculate w0,Dw from w1,w2
%
% w0  = center frequency in radians/sample (w0 = 2*pi*f0/fs)
% Dw  = bandwidth in radians per sample
% dir = 0,1, direction of calculation
%
% w1,w2 = left and right bandedge frequencies in rads/sample 
%
% notes: dir=0 case computes w1,w2 from w0,Dw as follows:
%            WB = tan(Dw/2); c0=cos(w0); s0=sin(w0);
%            cos(w1) = (c0 + WB*sqrt(WB^2+s0^2))/(WB^2+1);
%            cos(w2) = (c0 - WB*sqrt(WB^2+s0^2))/(WB^2+1);
%
%        dir=1 case computes w0,Dw from w1,w2 as follows:
%            Dw = w2-w1; cos(w0) = sin(w1+w2)/(sin(w1)+sin(w2));
%
%        LP case: w0=0,  Dw=cutoff measured from DC,      w1=0,     w2=Dw
%        HP case: w0=pi, Dw=cutoff measured from Nyquist, w1=pi-Dw, w2=pi

%   Author(s): S. Orfanidis
%   Copyright 2006 The MathWorks, Inc.

if nargin==2, dir=0; end

if dir==0,
   WB = tan(Dw/2); c0 = cos(w0); s0=sin(w0);
   w1 = acos((c0 + WB*sqrt(WB^2+s0^2))/(1+WB^2));
   w2 = acos((c0 - WB*sqrt(WB^2+s0^2))/(1+WB^2));
else
   w2 = Dw-w0;
   w1 = real(acos(sin(w0+Dw)/(sin(w0)+sin(Dw))));   
end

% real() is needed in the highpass case w1<pi, w2=pi, 
% and fixes the bug/problem that for some w1's, the value of 
% c0 = sin(w1+pi)/sin(w1) can be slightly less than -1, for example,
% w1=0.8*pi, gives c0 = sin(w1+pi)/sin(w1) = -1 - 2.2204e-16
% which would result in w0 = acos(c0) = pi - j*2.1073e-8

