function varargout = dspblkanalog(action, varargin)
% DSPBLKANALOG Mask dynamic dialog function for ANALOG IIR filter block

% Copyright 1995-2013 The MathWorks, Inc.

blk = gcb;
if nargin==0,
   action = 'dynamic';   % mask callback
end

switch action
case 'dynamic'
   % Execute dynamic dialogs      
   % The eighth dialog (checkbox for frame-based inputs)
   % disables/enables the ninth dialog(number of channels).
   
   mask_enables = get_param(blk,'maskenables');
   mask_prompts = get_param(blk,'maskprompts');
   mask_visibilities = get_param(blk,'maskvisibilities');
   
   filter_type = get_param(blk,'filttype');
   method = get_param(blk,'method');   
   switch filter_type
   case {'Lowpass','Highpass'},
      if (strcmp(method, 'Chebyshev II'))
         mask_prompts{4} = 'Stopband edge frequency (rad/s):';
      else
         mask_prompts{4} = 'Passband edge frequency (rad/s):';
      end
      mask_visibilities(5) = {'off'};
      mask_prompts{5} = '(unused)';
      % Only enable upper-band edge dialog for bandpass or bandstop
      
   case {'Bandpass','Bandstop'},
      mask_visibilities(5) = {'on'};
      if (strcmp(method, 'Chebyshev II'))
         mask_prompts{4} = 'Lower stopband edge frequency (rad/s):';
         mask_prompts{5} = 'Upper stopband edge frequency (rad/s):';
      else
         mask_prompts{4} = 'Lower passband edge frequency (rad/s):';
         mask_prompts{5} = 'Upper passband edge frequency (rad/s):';
      end
      
   otherwise
      error(message('dsp:dspblkanalog:unknownFilterType'));
   end 
   
   % Enable the appropriate passband and stopband ripple dialogs
   switch method
   case {'Butterworth','Bessel'}
      mask_visibilities{6} = 'off';
      mask_visibilities{7} = 'off';         
   case 'Chebyshev I',
      mask_visibilities{6} = 'on';
      mask_visibilities{7} = 'off';
   case 'Chebyshev II',
      mask_visibilities{6} = 'off';
      mask_visibilities{7} = 'on';
   case 'Elliptic',
      mask_visibilities{6} = 'on';
      mask_visibilities{7} = 'on';
   otherwise
       error(message('dsp:dspblkanalog:unknownFliterDesignType'));
   end
   
   set_param(blk,'maskenables',mask_enables, ...
      'maskvisibilities',mask_visibilities, ...
      'maskprompts',mask_prompts);
   
case 'design'
    sys = bdroot(blk);
    status = get_param(sys,'SimulationStatus') ;
    if ~strcmp(status,'stopped') && ~license('checkout','signal_blocks')
        error(message('dspshared:block:sigLicenseFailed','dspblkanalog'));
    end
   %Butterworth|Chebyshev I|Chebyshev II|Elliptic|Bessel
   %Lowpass|Highpass|Bandpass|Bandstop
   [varargout{1:nargout}] = dspanalogdes(varargin{:});
otherwise
   error(message('dsp:dspblkanalog:unhandledCase'));
end


% -------------------------------------------------------------------
function [a,b,c,d,h,w,str]=dspanalogdes(method,type,N,Wlo,Whi,Rp,Rs)
%DSPFDES DSP System Toolbox filter design interface
% Usage:
%    [a,b,c,d,h,w,str]=dspfdes(method,type,N,Wlo,Whi,Rp,Rs);
% where:
%  a,b,c,d: State-space coefficients of filter.
%        h: magnitude frequency response
%           of designed filter (for icon only)
%        w: normalized frequencies corresponding to indices of h (for icon only)
%      str: name of design function called (for icon only)
%


% Check for inf or Nan filter order
if isnan(N) | isinf(N),
    error(message('dsp:dspblkanalog:invalidFilterOrder1'));
end
   
% Check for non-integer filter order
if ~isequal(floor(N), N),
    error(message('dsp:dspblkanalog:invalidFilterOrder2'));
end

% Check for (filter order < 1)
if N < 1,
    error(message('dsp:dspblkanalog:invalidFilterOrder3'));
end

% Defaults for return:
a=[]; b=[]; c=[]; d=[]; h=[]; w=[]; str='';

% Default LHS for filter designs:
lhs='[a,b,c,d]';

switch method
case 'Butterworth'
  m={'butter',N};
case 'Chebyshev I'
  m={'cheby1',N,Rp};
case 'Chebyshev II'
  m={'cheby2',N,Rs};
case 'Elliptic'
  m={'ellip',N,Rp,Rs};
case 'Bessel'
  m={'besself',N};
otherwise,
  error(message('dsp:dspblkanalog:unknownFilterMethod'));
end

switch type
case 'Lowpass',
  t={m{:},Wlo};
case 'Highpass',
  t={m{:},Wlo,'high'};
case 'Bandpass',
  t={m{:},[Wlo Whi]};
case 'Bandstop',
  t={m{:},[Wlo Whi],'stop'};
otherwise,
  error(message('dsp:dspblkanalog:unknownFilterType1'));
end

% Append an 's' to all filter design parameter sets,
% signifying an analog filter design, EXCEPT for
% bessel:
if ~strcmp(method,'Bessel'),
	t={t{:},'s'};
end

% Return filter design coefficients:
s=[lhs '=feval(t{:});'];
eval(s);

% Return name for icon
str=m{1};

% Compute frequency response for icon
% Analog filters:
[num,den]=ss2tf(a,b,c,d,1);
switch type
case {'Lowpass','Highpass'},
  ww=Wlo;
otherwise,
  ww=sqrt(Wlo*Whi);
end

[h,w]=freqs(num,den,logspace(log10(ww/10),log10(10*ww),64));
h=20*log10(abs(h));
h=h-min(h); h=h./(max(h)+eps)*.75;

w=20*log10(w);
w=w-min(w); w=w./max(w);  % normalize to [0,1]

% Scale icon for display:
h = h./max(h)*0.75;  % Scaled for icon
w = (0:63)/63;  % normalize to [0,1]

% end of dspblkanalog.m
