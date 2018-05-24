function varargout=adaptfilt(varargin)
%ADAPTFILT  Adaptive Filter Implementation.
%   H = ADAPTFILT.ALGORITHM(...) returns an adaptive filter H, of type
%   ALGORITHM. Each algorithm takes several inputs. When inputs are
%   omitted, a filter with default parameters is created (the defaults
%   depend on the particular filter algorithm). 
%   Type "help adaptfilt/algorithms" to get the complete list of <a href="matlab:help adaptfilt/algorithms">algorithms</a>.
%   
%   Adaptive filters are equipped with a variety of <a href="matlab:help adaptfilt/functions">functions</a> for analyses 
%   simulations and code generation. (type "help adaptfilt/functions" to
%   get the complete list). The functions most commonly used with adaptive
%   filters are:
%   <a href="matlab:help adaptfilt/filter">filter</a>   - Execute ("run") the multirate filter.
%   <a href="matlab:help adaptfilt/freqz">freqz</a>    - Compute the instantaneous adaptive filter frequency response.
%   <a href="matlab:help adaptfilt/msesim">msesim</a>   - Calculate the measured mean-squared error for an adaptive filter.
%   <a href="matlab:help adaptfilt/block">block</a>    - Generate an Adaptive Filter block. (Simulink Required)
%
%   Example: System identification with LMS adaptive filter.
%      [s1 s2]= RandStream.create('mrg32k3a','NumStreams',2);
%      x  = randn(s1,1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(s2,1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      mu = 0.008;            % LMS step size
%      h = adaptfilt.lms(32,mu);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   For more information, enter "doc adaptfilt" at the MATLAB command line.
%
%   <a href="matlab: help dsp">DSP System Toolbox TOC</a>
%
%   See also DFILT, MFILT.

%   Copyright 1999-2013 The MathWorks, Inc.

error(message('dsp:adaptfilt:adaptfilt:FilterErr'))

% [EOF]
