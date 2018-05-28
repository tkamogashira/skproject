function y=rmsdB(x, zeromean);
% RMSdB - RMS in dB re RMS==1
%   RMSdB(W) returns the RMS of waveform (array) W in dB re RMS=1.
%   
%   RMSdB(W,1) first eliminates the mean of X, that is, the mean-zero RMS 
%   of W is returned.
%
%   See also RMS, STD.

if nargin<2, zeromean = 0; end;

y = a2db(rms(x,zeromean));

