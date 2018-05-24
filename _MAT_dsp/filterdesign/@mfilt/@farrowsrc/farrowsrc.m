function this = farrowsrc(varargin)
%FARROWSRC Farrow Sample-Rate Converter
%   Hm = MFILT.FARROWSRC(L,M,COEFFS) constructs a Farrow sample-rate
%   converter.
%   
%   L is the interpolation factor. It must be real and positive. If not
%   specified, it defaults to 3.
%
%   M is the decimation factor. It must be real and positive. If not
%   specified, it defaults to 2. 
%
%   COEFFS is a matrix containing the coefficients of the filter. If
%   omitted, it defaults to [-1 1;1 0], a linear interpolation filter.
%
%   % Example #1
%      %Sample-rate conversion to convert from 44.1kHz to 48kHz with a 
%      %linear interpolation filter.
%      [L,M] = rat(48/44.1);
%      Hm = mfilt.farrowsrc(L,M);           % We use the default filter
%      Fs = 44.1e3;                         % Original sampling frequency
%      n = 0:9407;                          % 9408 samples, 0.213 seconds long
%      x  = sin(2*pi*1e3/Fs*n);             % Original signal, sinusoid at 1kHz
%      y = filter(Hm,x);                    % 10241 samples, still 0.213 seconds
%      stem(n(1:45)/Fs,x(1:45))             % Plot original sampled at 44.1kHz
%      hold on
%      % Plot fractionally interpolated signal (48kHz) in red
%      stem((n(2:50)-1)/(Fs*L/M),y(2:50),'r','filled') 
%      xlabel('Time (sec)');ylabel('Signal value')
%      legend('44.1 kHz sample rate','48kHz sample rate')
%
%   % Example #2 
%      %Design sample-rate converter that uses a 3rd order Lagrange 
%      %interpolation filter to convert from 44.1kHz to 48kHz.
%      f = fdesign.polysrc(L,M,'Fractional Delay','Np',3);
%      Hm(2) = design(f,'lagrange');
%      hfvt = fvtool(Hm,'NormalizeMagnitudeto1','on');
%      axis([0 .06 -125 10])
%      legend(hfvt, 'Linear Interpolation', 'Cubic Lagrange Interpolation')
%
%   % Example #3 
%      %Convert a polyphase sample-rate converter to a Farrow sample-rate 
%      %converter and compare their respective implementation costs. 
%      fr = fdesign.rsrc(L,M);
%      Hpm = design(fr); % Polyphase SRC
%      p=polyphase(Hpm); % Polyphase decomposition
%      N = 5;            % Polynomial order
%      Np = size(p,2);   % Length of each polyphase filter
%      X = 0:1/L:(L-1)/L;
%      for i=1:Np,
%         fp(Np-i+1,:)=polyfit(X,p(:,i).',N);
%      end
%      Hfm = mfilt.farrowsrc(L,M,fp); % Farrow SRC
%      cost(Hpm)
%      cost(Hfm)
%
%   For more information about Farrow SRCs, see the
%   <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\efficientsrcdemo.html'])">Efficient Sample Rate Conversion between Arbitrary Factors</a> demo. 
%
%   See also MFILT/STRUCTURES.

%   Copyright 2007-2010 The MathWorks, Inc.

error(nargchk(0,3,nargin,'struct'));
this = mfilt.farrowsrc;
this.FilterStructure = 'Farrow Sample-Rate Converter';
if nargin>0,
    this.InterpolationFactor = varargin{1};
end
if nargin>1,
    this.DecimationFactor =  varargin{2};
end

if nargin>2,
    this.Coefficients =  varargin{3};
end

% [EOF]
