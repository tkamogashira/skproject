function varargout=mfilt(varargin) %#ok<STOUT>
%MFILT  Multirate Filter Implementation.
%   Hm = MFILT.<STRUCTURE>(...) returns a multirate filter Hm that associates
%   rate change factors and coefficients with a particular filter STRUCTURE. 
%   If coefficients are omitted, a low-pass filter is automatically designed. 
%   Type "help mfilt/structures" to get the complete list of <a href="matlab:help mfilt/structures">structures</a>.
%
%   Note that one need not always construct multirate filters explicitly.
%   Instead, these filters can be obtained as a result from a design using
%   <a href="matlab:help fdesign">FDESIGN</a>. An example of this is shown below.
%
%   Multirate filters are equipped with a variety of <a href="matlab:help mfilt/functions">functions</a> for analyses, 
%   simulations and code generation. (type "help mfilt/functions" to get the
%   complete list). The functions most commonly used with multirate filters
%   are:
%   <a href="matlab:help mfilt/filter">filter</a>      - Execute ("run") the multirate filter.
%   <a href="matlab:help mfilt/freqz">freqz</a>       - Compute the frequency response of the multirate filter.
%   <a href="matlab:help mfilt/realizemdl">realizemdl</a>  - Generate a Simulink subsystem.   (Simulink Required) 
%   <a href="matlab:help mfilt/block">block</a>       - Generate a Digital Filter block. (Simulink Required)
%   <a href="matlab:help mfilt/generatehdl">generatehdl</a> - Generate HDL code.               (Filter Design HDL Coder Required)
%   <a href="matlab:help mfilt/sysobj">sysobj</a>      - Generate a filter System object. (DSP System Toolbox Required)
%
%   Notice that the DSP System Toolbox, along with the Fixed-Point Designer
%   enables single precision floating-point and fixed-point
%   support for most MFILT structures.
%
%   EXAMPLES:
%
%    %Example 1: Design a lowpass decimator for a decimation factor of 3. 
%    M = 3; % Decimation factor;
%    d = fdesign.decimator(M,'lowpass');
%    Hm = design(d,'equiripple','FilterStructure', 'firdecim');
%    fvtool(Hm)
%    % Decimate a signal which consists of the sum of 2 sinusoids. 
%    N = 160;
%    x = sin(2*pi*.05*[0:N-1]+pi/3)+cos(2*pi*.03*[0:N-1]+pi/3);
%    y = filter(Hm,x); 
%
%    %Example 2: Using existing coefficients to decimate a signal by a factor
%    %of 2.
%    M = 2; % Decimation factor
%    b = firhalfband('minorder',.45,0.0001);
%    Hm = mfilt.firdecim(M,b); 
%    fvtool(Hm)
%    % Decimate a signal which consists of the sum of 2 sinusoids. 
%    N = 160;
%    x = sin(2*pi*.05*[0:N-1]+pi/3)+cos(2*pi*.03*[0:N-1]+pi/3);
%    y = filter(Hm,x); 
%
%   For more information, see the <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\mfiltgettingstarteddemo.html'])">Getting Started Demo</a> or enter "doc mfilt"
%   at the MATLAB command line.
%
%   <a href="matlab: help dsp">DSP System Toolbox TOC</a>
%
%   See also FDESIGN, DFILT, ADAPTFILT.
%

%   Copyright 1999-2011 The MathWorks, Inc.

error(message('dsp:mfilt:mfilt:FilterErr'));

% [EOF]
