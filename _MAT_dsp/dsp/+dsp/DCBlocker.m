classdef DCBlocker < matlab.System & matlab.system.mixin.CustomIcon & matlab.system.mixin.Propagates
%DCBlocker Block DC component from input signal
%  H = dsp.DCBlocker returns a System object, H, that blocks the DC
%  component from each channel (i.e. column) of an input signal.  Operation
%  runs over time to continually estimate and remove the DC offset.
%
%  H = dsp.DCBlocker('PropertyName', PropertyValue, ...) returns a DC
%  blocker System object, H, with each specified property set to the
%  specified value.  You can specify additional name-value pair arguments
%  in any order as (Name1,Value1,...,NameN,ValueN).
%
%  Step method syntax:
%
%  Y = step(H, X) removes the DC component of the input X, returning the
%  result in Y.  X is a numeric, signed matrix, with time samples recorded
%  in rows and independent channels of data recorded in columns.
%
%  DCBlocker methods:
%
%   step     - See above description for use of this method
%   reset    - Reset internal states stored for mean computation
%   release  - Allow property value and input characteristics changes
%   clone    - Create DCBlocker object with same property values
%   isLocked - Locked status (logical)
%   fvtool   - Visualize lowpass filter used for DC blocking
%
%  DCBlocker properties:
%
%   Algorithm           - Algorithm for estimating DC offset
%   NormalizedBandwidth - Normalized bandwidth of lowpass IIR elliptic filter 
%   Order               - Order of lowpass IIR elliptic filter
%   Length              - Number of past input samples for FIR algorithm
%
%   % EXAMPLE: Remove a DC offset from a signal using 'FIR', 'IIR', and 
%   %'Subtract mean' techniques.  Loop to allow the IIR algorithm to converge.
%   t         = (0:0.001:100)';
%   x         = sin(30*pi*t) + 1;
%   hDCBlock1 = dsp.DCBlocker('Order', 6);  % IIR is default
%   hDCBlock2 = dsp.DCBlocker('Algorithm', 'FIR', 'Length', 100);
%   hDCBlock3 = dsp.DCBlocker('Algorithm', 'Subtract mean');
%   for idx = 1 : 100
%     range = (1:1000) + 1000*(idx-1);
%     y1 = step(hDCBlock1, x(range));
%     y2 = step(hDCBlock2, x(range));
%     y3 = step(hDCBlock3, x(range));
%   end
%   plot(t(1:1000),x(1:1000),...
%     t(1:1000),y1, ...
%     t(1:1000),y2, ...
%     t(1:1000),y3);
%   legend(sprintf('Input DC:%.3f',    mean(x)), ...
%     sprintf('IIR DC:%.3f',           mean(y1)), ...
%     sprintf('FIR DC:%.3f',           mean(y2)), ...
%     sprintf('Subtract mean DC:%.3f', mean(y3)));
%
%   See also dsp.FIRFilter, dsp.BiquadFilter.
  
%   Copyright 2013-2014 The MathWorks, Inc.
    
%#codegen
    
properties (Nontunable)
  %Algorithm Algorithm for estimating DC offset
  %  Specify the DC offset estimating algorithm as one of 'IIR' | 'FIR' |
  %  'Subtract mean'.  The default is 'IIR'. You can visualize the IIR and
  %  FIR responses with the fvtool method.
  %
  %  'IIR' uses a recursive estimate based on a narrow, lowpass elliptic
  %  filter whose order is set using the Order property and whose bandwidth
  %  is set using the NormalizedBandwidth property. This algorithm may use
  %  less memory than FIR and be more efficient.
  %
  %  'FIR' uses a non-recursive, moving average estimate based on a finite
  %  number of past input samples that is set using the Length property.
  %  This algorithm may use more memory than IIR and be less efficient.
  %  
  %  'Subtract mean' computes the means of the columns of the input matrix,
  %  and subtracts the means from the input.  This method does not retain
  %  state between inputs.
  Algorithm = 'IIR'
  %NormalizedBandwidth Normalized bandwidth of lowpass IIR elliptic filter
  %  Specify the normalized bandwidth of the IIR filter used to estimate
  %  the DC component of the input signal. This property applies when you
  %  set the Algorithm property to 'IIR'. It must be a real scalar greater
  %  than 0 and less than 1. The default value is 0.001.
  NormalizedBandwidth = 0.001
end
    
properties (Nontunable, PositiveInteger)
  % Length  Number of past input samples for FIR algorithm
  % Specify the number of past inputs used to estimate the running mean.
  % This property applies when you set the Algorithm property to 'FIR'.
  % It must be a positive integer. The default value is 50.
  Length = 50
  % Order   Order of lowpass IIR elliptic filter
  % Used when Algorithm is 'IIR'.  Specify the order of a lowpass elliptic
  % filter that estimates the DC level.  This property applies when you set
  % the Algorithm property to 'IIR'.  It must be an integer greater than 3.
  % The default value is 6.
  Order = 6  
end

properties (Constant, Hidden)
  AlgorithmSet = matlab.system.StringSet({'IIR','FIR','Subtract mean'})
end

properties (Access=private, Nontunable)
  pFilter            % holds a System object
  pUseFilter = true  % set this property in setupImpl to save time in stepImpl
end

properties (Access = protected)
  % pNumChannels Number of input channels
  pNumChannels;
end
    
methods
  function obj = DCBlocker(varargin)
    setProperties(obj, nargin, varargin{:});
    
    % Set initial pNumChannels to -1 (will be set to actual value in setup)
    obj.pNumChannels = -1;    
  end
  
  function set.Order(obj, value)
    validateattributes (value, {'numeric'}, ...
      {'real', 'scalar', 'positive', 'integer', 'nonnan', 'nonempty', ...
      'finite', '>=', 3}, ...
      '', 'Order');  %#ok<EMCA>
    obj.Order = value;
  end
  
  function set.NormalizedBandwidth(obj, value)
    validateattributes (value, {'numeric'}, ...
      {'real', 'scalar', 'nonnan', 'nonempty', 'finite', '>', 0, '<', 1}, ...
      '', 'NormalizedBandwidth');  %#ok<EMCA>
    obj.NormalizedBandwidth = value;
  end
  
  function set.Length(obj, value)
    validateattributes (value, {'numeric'}, ...
      {'real', 'positive', 'scalar', 'integer', 'nonnan', 'nonempty', ...
      'finite'}, ...
      '', 'Length');  %#ok<EMCA>
    obj.Length = value;
  end
  
  function varargout = fvtool(obj, varargin)
    % With fvtool, visualize the lowpass filter response used to estimate
    % DC.  Visualize the magnitude response, phase response, group delay,
    % impulse response, or pole-zero plot, and view the coefficients.
    
    usingSubtractMean = strcmpi(obj.Algorithm, 'Subtract mean');
    coder.internal.errorIf(usingSubtractMean, ...
      'dsp:system:DCBlocker_novisualiztion');
        
    % The fvtool method does not participate in code generation
    if ~isempty(coder.target)
      coder.internal.errorIf(true, 'dsp:system:DCBlocker_codegen');
    end
    
    prepareFilter(obj)
    if nargout > 0
      varargout{1} = fvtool(obj.pFilter, varargin{:});
    else
      fvtool(obj.pFilter, varargin{:});
    end
  end 
    
end
    
methods (Access=protected)
  function icon = getIconImpl(~)
    icon = sprintf('DC Blocker');
  end
  
  function varargout = getInputNamesImpl(obj)
    varargout = cell(1, getNumInputs(obj));
    varargout{1} = '';
  end
  
  function varargout = getOutputNamesImpl(obj)
    varargout = cell(1, getNumOutputs(obj));
    varargout{1} = '';
  end

  function validateInputsImpl(obj, x)    
    % Input must be numeric or fi.  Must be signed.
    coder.internal.errorIf(~isnumeric(x), ...
      'MATLAB:system:invalidInputDataType','X','numeric');
    
    inputIsUint = ~isempty(strfind(class(x), 'uint'));
    coder.internal.errorIf(inputIsUint, 'dsp:system:DCBlocker_unsigned');
    
    if isfi(x)
      inputIsUnsigned = strcmp(x.Signedness, 'Unsigned');
      coder.internal.errorIf(inputIsUnsigned, 'dsp:system:DCBlocker_unsigned');
    end
  
    % Warn if the input is a row vector
    if ( isrow(x) && ~isscalar(x) )
      coder.internal.warning('dsp:system:RowVectorScalarOps'); 
    end
    
    % The number of input channel is not allowed to change.
    coder.internal.errorIf(...
        obj.pNumChannels~=-1 && obj.pNumChannels ~= size(x,2), ...
        'dsp:system:varSizeChannelsNotSupported');
    
  end
  
  function flag = isInputComplexityLockedImpl(~,~)
    flag = true;
  end
  
  function flag = isOutputComplexityLockedImpl(~,~)
    flag = true;
  end
  
  function varargout = getOutputSizeImpl(obj)
    varargout = {propagatedInputSize(obj, 1)}; %#ok<EMCA>
  end
  
  function varargout = getOutputDataTypeImpl(obj)
    varargout = {propagatedInputDataType(obj, 1)}; %#ok<EMCA>
  end
  
  function varargout = isOutputComplexImpl(obj)
    varargout = {propagatedInputComplexity(obj, 1)}; %#ok<EMCA>
  end
  
  function setupImpl(obj, ~) 
    % Initialize internal values on first use.

    % For integer inputs, the BiquadFilter and FIRFilter will
    % convert coefficient datatypes as needed.
    coder.extrinsic('zp2sos');
    coder.extrinsic('eval');
    if strcmpi(obj.Algorithm, 'IIR')
      pbRipple    = 0.1;    % passband ripple, in dB
      sbAtten     = 60;     % stopband attenuation, in dB
      [z, p, k]   = ellip(obj.Order, pbRipple, sbAtten, ...
                          obj.NormalizedBandwidth);
      sos         = coder.const(zp2sos(z, p, k));
      obj.pFilter = dsp.BiquadFilter( ...
        'Structure', 'Direct form II transposed', ...
        'SOSMatrix', sos, ...
        'RoundingMethod', 'Convergent', ...
        'OverflowAction', 'Saturate');
      obj.pUseFilter = true;
    elseif strcmpi(obj.Algorithm, 'FIR')
      % Design a boxcar, lowpass filter
      obj.pFilter = dsp.FIRFilter( ...
        'Structure', 'Direct form transposed', ...
        'Numerator', ones(1,obj.Length)./obj.Length);
      obj.pUseFilter = true;
    else  % Subtract mean
      obj.pUseFilter = false;
    end
  end
        
  function resetImpl(obj)
    if obj.pUseFilter
      reset(obj.pFilter);
    end
  end
  
  function releaseImpl(obj)
    if obj.pUseFilter
      release(obj.pFilter);
    end
    obj.pNumChannels = -1;
  end
        
  function y = stepImpl(obj, u)
    % Block DC component of input signals
    if obj.pUseFilter
      y = u - step(obj.pFilter, u);
    else
      nChan = size(u, 2);
      y = u;  % for initialization in complexity and data type
      for iChan = 1 : nChan
        y(:,iChan) = u(:,iChan) - mean(u(:,iChan));
      end
    end
  end
        
  function flag = isInactivePropertyImpl(obj,prop)
    % True if property should not be displayed
    if strcmpi(obj.Algorithm, 'FIR')
      flag = strcmpi(prop, 'Order') || ...
             strcmpi(prop, 'NormalizedBandwidth'); % Suppress for 'FIR'
    elseif strcmpi(obj.Algorithm, 'IIR')
      flag = strcmpi(prop, 'Length'); % Suppress for 'IIR'
    elseif strcmpi(obj.Algorithm, 'Subtract mean')
      flag = strcmpi(prop, 'Order') || ...
             strcmpi(prop, 'NormalizedBandwidth') || ...
             strcmpi(prop, 'Length');  % Suppress for 'Subtract mean'
    end
  end
  
  function s = saveObjectImpl(obj)
    s = saveObjectImpl@matlab.System(obj);
    if isLocked(obj)
      % Public properties handled automatically
      s.pFilter      = matlab.System.saveObject(obj.pFilter);
      s.pUseFilter   = matlab.System.saveObject(obj.pUseFilter);
      s.pNumChannels = obj.pNumChannels;
    end
  end

  function loadObjectImpl(obj, s, wasLocked)
    if wasLocked
      % Public properties handled automatically
      obj.pFilter      = matlab.System.loadObject(s.pFilter);
      obj.pUseFilter   = matlab.System.loadObject(s.pUseFilter);
      obj.pNumChannels = s.pNumChannels;   
    end
    % Call the base class method
    loadObjectImpl@matlab.System(obj, s);
  end
  
  function prepareFilter(obj)
    if ~isLocked(obj)
      % We need to create the underlying filter first. Call setup to create
      % pFilter and then release. 
      setup(obj, 1);
      release(obj)
    end
  end  
  
end

methods(Static, Access = protected)
  function header = getHeaderImpl
    header = matlab.system.display.Header('dsp.DCBlocker', ...
      'Title', 'DC Blocker');
  end
end

end

% EOF
