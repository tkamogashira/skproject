function b = dspblkinterp(varargin)
% DSPBLKINTERP Mask dynamic dialog function for Interpolation block

% Copyright 1995-2011 The MathWorks, Inc.

if nargin==0
  action = 'dynamic';   % mask callback
elseif nargin==1 
  action = 'icon';
else
  action = 'init';    % Design the filter
end

switch action
case 'icon'
%   ports = get_labels(gcb);
%   varargout = {ports};
blk = gcb;
b = get_labels(blk);

case 'dynamic'
   % Execute dynamic dialogs  
	mask_enables = get_param(gcb,'maskenables');
	mask_visibilities = get_param(gcb,'maskvisibilities');    
   mode = get_param(gcb, 'InterpMode');
   switch mode
   case 'Linear',
      mask_enables{4} = 'off';
      mask_enables{5} = 'off';
      mask_enables{6} = 'off';
      mask_visibilities{4} = 'off';
      mask_visibilities{5} = 'off';
      mask_visibilities{6} = 'off';
   case 'FIR',
      mask_enables{4} = 'on';
      mask_enables{5} = 'on';
      mask_enables{6} = 'on';
      mask_visibilities{4} = 'on';
      mask_visibilities{5} = 'on';
      mask_visibilities{6} = 'on';
   otherwise
      error(message('dsp:dspblkinterp:unhandledCase1'));
   end
   imode = get_param(gcb,'InterpSource');
   switch imode
   case 'Specify via dialog'
	   mask_enables{2} = 'on';
       mask_visibilities{2} = 'on';
   case 'Input port'
	   mask_enables{2} = 'off';
       mask_visibilities{2} = 'off';
   otherwise
	   error(message('dsp:dspblkinterp:unhandledCase2'));
   end
   set_param(gcb,'maskenables',mask_enables, ...
   				     'maskvisibilities',mask_visibilities);
      
case 'init'
   
   mode = varargin{1};
   if strcmp(mode, 'init')
      isBlk = varargin{2};
      b = [];
      R = double(varargin{3});
      L = double(varargin{4});
      alpha = double(varargin{5});
      
      if isoktocheckparam(R)
          if (~isreal(R)) || ~isnumeric(R) || (numel(R) ~= 1) || ...
                  (floor(R) ~= R) || R < 1
              error(message('dsp:dspblkinterp:paramPositiveIntegerError1'));
          end
      end
      
      if isoktocheckparam(L)
          if (~isreal(L)) || ~isnumeric(L) || (numel(L) ~= 1) || ...
                  (floor(L) ~= L) || L < 1
              error(message('dsp:dspblkinterp:paramPositiveIntegerError2'));
          end
      end
      
      if isoktocheckparam(alpha)
          if (~isreal(alpha)) || ~isnumeric(alpha) || (numel(alpha) ~= 1) || ...
                  alpha <= 0 || alpha > 1
              error(message('dsp:dspblkinterp:paramOutOfRange'));
          end
      end
      
      if ~isempty(R) && ~isempty(L) && ~isempty(alpha),
         b=intfilt(R,L,alpha);
         blen=length(b); bcols = ceil(blen/2/L);
         b = [zeros(bcols*2*L-blen,1);b(:)];
         b = flipud(reshape(b,bcols,2*L)');
      end
   else
      b = [];
   end  
   
otherwise
   error(message('dsp:dspblkinterp:unhandledCase3'));
end

% ----------------------------------------------------------
function ports = get_labels(blk)   
mode = get_param(blk,'InterpSource');

% Input port labels:
switch mode
case 'Specify via dialog'
   ports.type1='input';
   ports.port1=1;
   ports.txt1='';
   
   ports.type2='input';
   ports.port2=1;
   ports.txt2='';
   
   ports.type3='output';
   ports.port3=1;
   ports.txt3='';
   
case 'Input port'
   ports.type1='input';
   ports.port1=1;
   ports.txt1='In';
   
   ports.type2='input';
   ports.port2=2;
   ports.txt2='Pts';
   
   ports.type3='output';
   ports.port3=1;
   ports.txt3='Out';
   
end

return
% end of dspblkinterp.m

% LocalWords:  maskenables maskvisibilities Pts
