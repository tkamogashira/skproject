function varargout = dspblkchirp2(action,isBlk,varargin)
% DSPBLKCHIRP2 DSP System Toolbox CHIRP block helper function.

% Copyright 1995-2011 The MathWorks, Inc.


switch action,
case 'icon'
    blk = gcbh;

	t = (0:0.1:1.5*pi);
	y = (sin(t.*t)+1)/2*0.7;
	t = t / max(t);
   
    % Determine string on icon:
    txt = get_param(blk,'sweep');
    switch txt
    case {'Quadratic'}
        txt=txt(1:4); 
    case {'Linear', 'Logarithmic'}
        txt=txt(1:3); 
    case {'Swept cosine'}
        txt=txt(1:5); 
    end
    
   varargout = {t,y,txt};
   
case 'param'
   sweep = varargin{1};
   f0    = double(varargin{2});
   f1    = double(varargin{3});
   varargout = {};
   
   switch sweep
     case {1, 2}
       % Swept cosine and Linear
       % No validation required for these cases
     case 3
       % Logarithmic
       if ~((f1>f0) && (f0>0))  %up-sweep only
           if isBlk
             errordlg(msg,gcb);
           else
             error(message('dsp:dspblkchirp2:invalidFrequencySpec'));
           end
           varargout = {};   
           return;
       end
     otherwise
       % Quadratic
       % No validation required for this case
   end

end

