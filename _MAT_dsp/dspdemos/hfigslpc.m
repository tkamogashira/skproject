function varargout = hfigslpc(mode,varargin)
%HFIGSLPC - Setup and cleanup scope window for plotting data in 
% dspLinearPredictiveCoder demo.
%   S = HFIGSLPC('SETUP', FS, FRAMESIZE, FFTLEN)
%       HFIGSLPC('CLEANUP', S)

%   Copyright 2006-2010 The MathWorks, Inc.

if strcmp(mode, 'setup')    
    [Fs, frameSize, fftLen] = deal(varargin{:});
    
    % Create a scope object with 3 axes
    hscope = dsp.private.Scope(...
      'Name','DSPLPC: Linear Prediction of Speech');

    % Create LinePlot object
    hlineplot = dsp.private.LinePlot('DataPlot', 'Constant', ....
        'FrameSize', [fftLen/2 fftLen/2], ...
        'XResolution', [1/fftLen*Fs/2*1e-3 1/fftLen*Fs/2*1e-3], ...
        'X0', [0 0], ...
        'Title','Signal and LPC Spectrum', ...
        'XLabel','Frequency (kHz)', 'YLabel','Magnitude (dB)', ...
        'Legend',{'Signal','LPC'}, ...
        'AxisScaling',[0 (fftLen/2-1)/fftLen*Fs/2*1e-3 -30 50]);
      
    % Attach the LinePlot object to the scope
    hscope.PlotObject = hlineplot;
    setup(hscope);
    
    % Structure with handles to plot objects and other relevant information
    s.hscope    = hscope;
    s.hlineplot = hlineplot;
    s.Fs        = Fs;
    s.frameSize = frameSize;
    s.fftLen    = fftLen;
    s.time      = 0:1/s.Fs*1e3:(s.frameSize-1)/s.Fs*1e3;
    varargout{1} = s;
    
elseif strcmpi(mode, 'cleanup')
    s = varargin{1};
    close(s.hscope);
end


