classdef AnalyticSignal < matlab.System
%AnalyticSignal Analytic signals of discrete-time inputs
%   HANLYTC = dsp.AnalyticSignal returns a System object, HANLYTC, that
%   computes the complex analytic signal corresponding to each channel of a
%   real M-by-N input matrix.
%
%   HANLYTC = dsp.AnalyticSignal('PropertyName', PropertyValue, ...)
%   returns an analytic signal System object, HANLYTC, with each specified
%   property set to the specified value.
%
%   HANLYTC = dsp.AnalyticSignal(FILTERORDER, 'PropertyName',
%   PropertyValue, ...) returns an analytic signal System object, HANLYTC,
%   with FilterOrder property set to FILTERORDER and other specified
%   properties set to the specified values.
%
%   The real part of the analytic signal in each channel is a replica of
%   the real input in that channel, and the imaginary part is the Hilbert
%   transform of the input. In the frequency domain, the analytic signal
%   retains the positive frequency content of the original signal while
%   zeroing-out negative frequencies and doubling the DC component. The
%   object computes the Hilbert transform using an equiripple FIR filter.
%
%   Step method syntax:
%
%   Y = step(HANLYTC, X) computes the analytic signal, Y, of the input X.
%
%   AnalyticSignal methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create analytic signal object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states
%
%   AnalyticSignal properties:
%
%   FilterOrder          - Filter order used to compute Hilbert transform
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE: Compute the analytic signal of a sinusoidal input.
%       t = (-1:0.01:1)';
%       x = sin(4*pi*t); 
%       hanlytc = dsp.AnalyticSignal(200);   % Filter order = 200
%       y = step(hanlytc, x);
%       subplot(2,1,1), plot(t, x); 
%       title('Original Signal');
%       subplot(2,1,2), plot(t, [real(y) imag(y)]); 
%       title('Analytic signal of the input')
%       legend('Real signal', 'Imaginary signal', 'Location', 'best');
%
%   See also dsp.FFT, dsp.IFFT.

%   Copyright 1995-2011 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>

properties (Nontunable)
  %FilterOrder Filter order used to compute Hilbert transform
  %   Specify the order of the equiripple filter used in computing the
  %   Hilbert transform as an even integer scalar. The default value of
  %   this property is 100.
  FilterOrder = 100;
end

properties (Nontunable, Logical)
  %FrameBasedProcessing Process input in frames or as samples
  %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
  %  property to false to enable sample-based processing. The default value
  %  of this property is true.
  FrameBasedProcessing = true;
end

properties(Access = private, Nontunable)
  cDelay;
  cFIRFilter;
end

  methods
    function obj = AnalyticSignal(varargin)
      coder.allowpcode('plain');
      setProperties(obj, nargin, varargin{:}, 'FilterOrder');
    end

    function set.FilterOrder(obj, value)
    validateattributes(value, { 'numeric' }, { 'positive', 'even', 'integer' }, '', 'FilterOrder'); %#ok<EMCA>
      obj.FilterOrder = value;
    end
  end

  methods(Access = protected)
    function out = stepImpl(obj, in)
      out = complex(step(obj.cDelay, in), step(obj.cFIRFilter, in));

    end
    
    function flag = isInputSizeLockedImpl(~,~)
        flag = true;
    end
    
    function flag = isInputComplexityLockedImpl(~,~)
        flag = true;
    end
    
    function flag = isOutputComplexityLockedImpl(~,~)
        flag = true;
    end
    
    function validateInputsImpl(obj,x) %#ok<MANU>
      % Only floating point inputs are supported
      coder.internal.assert(isfloat(x), 'MATLAB:system:invalidInputDataType','X','floating-point');

      coder.internal.errorIf(ndims(x) > 2, 'dsp:system:AnalyticSignal:inDimsGreaterThanTwo');
    end

    function setupImpl(obj, ~)
      N = obj.FilterOrder;
      obj.cDelay = dsp.Delay( ...
        'Length', N/2, ...
        'FrameBasedProcessing', obj.FrameBasedProcessing);

      b = dspblkanalytic2('design', false, N);

      obj.cFIRFilter = dsp.DigitalFilter( ...
        'TransferFunction', 'FIR (all zeros)', ...
        'Structure','Direct form transposed', ...
        'Numerator', b, ...
        'FrameBasedProcessing', obj.FrameBasedProcessing);
    end

    function  resetImpl(obj)
        reset(obj.cDelay);
        reset(obj.cFIRFilter);
    end
    
    function  releaseImpl(obj)
        release(obj.cDelay);
        release(obj.cFIRFilter);
    end
    
    function s = saveObjectImpl(obj)
      s = saveObjectImpl@matlab.System(obj);
      if isLocked(obj)
         s.cDelay     = matlab.System.saveObject(obj.cDelay); 
         s.cFIRFilter = matlab.System.saveObject(obj.cFIRFilter); 
      end
    end

    function loadObjectImpl(obj, s, wasLocked)
      if wasLocked
        obj.cDelay     =  matlab.System.loadObject(s.cDelay);
        obj.cFIRFilter =  matlab.System.loadObject(s.cFIRFilter);
      end
      % Call the base class method
      loadObjectImpl@matlab.System(obj, s);
    end
  end
 
end
