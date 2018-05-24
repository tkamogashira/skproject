function drawgsmmask(hfig,cropaxis)
%DRAWGSMMASK Utility to draw a GSM mask for the DDC filter chain demo:
% "Implementing the Filter Chain of a Digital Down-Converter in HDL"

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

if nargin < 1
    hfig = gcf;
    if nargin < 2,
        cropaxis = false;
    end
end

oldfig = get(0, 'CurrentFigure');
set(0, 'CurrentFigure', hfig);

args = {'Color',[1 0 1],'LineWidth',1,'LineStyle','--'};
freqMhz = [0 0.1 0.1 0.1 0.1 0.3 0.3 0.3 0.3 0.5 0.5 0.5 0.5 0.7 0.7 0.7 0.7 1.1];
magdB   = [0 0 0 -18 -18 -18 -18 -50 -50 -50 -50 -85 -85 -85 -85 -95 -95 -95];
line(freqMhz,magdB,args{:})
 
set(0, 'CurrentFigure', oldfig);

if cropaxis,
    xlim = [min(freqMhz) max(freqMhz)];
    ylim = [min(magdB)-100 max(magdB)+5];
    axis(xlim,ylim);
end
