function varargout = figsDDCDesignDemo(varargin)
%figsDDCDesignDemo Helper function to setup spectrum plots for
%dspDigitalDownConverterDesign demo

%   Copyright 2010 The MathWorks, Inc.

Fs = varargin{1};
M1 = varargin{2};

pos = uiscopes.getDefaultPosition;
pos(1) = pos(1)+0.8*pos(3);

hf1 = figure('Name', 'Input Signal', ...
  'position', [pos(1)  pos(2)+0.8*pos(4) pos(3:4)], ...
  'Color','White','Visible','off','NumberTitle','off');

hf2 = figure('Name', 'Down converted signal', ...
  'position', [pos(1)  pos(2)-0.8*pos(4) pos(3:4)], ...
  'Color','White','Visible','off','NumberTitle','off');

fs1 = Fs/M1;

s.fs = Fs;
s.fs1 = fs1;
s.hfig1 = hf1;
s.hfig2 = hf2;
s.cnt = 0;
varargout{1} = s;
