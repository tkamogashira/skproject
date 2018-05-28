function y=rmsdB(x, zeromean);
% RMSDB - RMS in dB re RMS==1
%   See also RMS

if nargin<2, zeromean = 0; end;

y = a2db(rms(x,zeromean));

