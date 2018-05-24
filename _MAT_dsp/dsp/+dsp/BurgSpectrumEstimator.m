classdef BurgSpectrumEstimator < matlab.System
%BurgSpectrumEstimator Parametric spectral estimation using the Burg method
%   HBURGSPEST = dsp.BurgSpectrumEstimator returns a System object,
%   HBURGSPEST, that estimates the power spectral density (PSD) of the
%   input frame using the Burg method. The object fits an autoregressive
%   (AR) model to the signal by minimizing (least squares) the forward and
%   backward prediction errors while constraining the AR parameters to
%   satisfy the Levinson-Durbin recursion.
%
%   HBURGSPEST = dsp.BurgSpectrumEstimator('PropertyName', PropertyValue,
%   ...) returns a burg spectrum estimator object, HBURGSPEST, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HBURGSPEST, X) outputs Y, a spectral estimate of input X,
%   using Burg spectrum estimation method.
%
%   BurgSpectrumEstimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create burg spectrum estimator object with same property
%              values
%   isLocked - Locked status (logical)
%
%   BurgSpectrumEstimator properties: 
%
%   EstimationOrderSource - Source of estimation order
%   EstimationOrder       - Order of AR model
%   FFTLengthSource       - Source of FFT length
%   FFTLength             - FFT length as power-of-two integer value
%   SampleRate            - Sample rate of input time series
%
%   % EXAMPLE: Spectrum estimation using BurgSpectrumEstimator System 
%   % object.
%      x = randn(100,1);
%      hburgspest = dsp.BurgSpectrumEstimator('EstimationOrder', 4);
%      y = filter(1,[1 1/2 1/3 1/4 1/5],x); % Fourth order AR filter
%      p = step(hburgspest, y);          % Uses default FFT length of 256
%      plot([0:255]/256, p);
%      title('Burg Method Spectral Density Estimate');
%      xlabel('Normalized frequency'); ylabel('Power/frequency');
%
%   See also dsp.BurgAREstimator.

%   Copyright 1995-2011 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>

properties (Nontunable)
    %EstimationOrderSource Source of estimation order
    %   Specify how to determine estimator order as one of ['Auto' |
    %   {'Property'}]. If this property is set to 'Auto', the estimation
    %   order is assumed to be one less than the length of the input
    %   vector.
    EstimationOrderSource = 'Property';
    %EstimationOrder Order of AR model 
    %   Specify the order of AR model as a real positive integer. This
    %   property is applicable when EstimationOrderSource is 'Property'.
    %   The default value of this property is 6.
    EstimationOrder = 6;
    %FFTLengthSource Source of FFT length
    %   Specify how to determine the FFT length as one of ['Auto' |
    %   {'Property'}]. If this property is set to 'Auto', the FFT length is
    %   assumed to be one more than the estimation order. Note that the FFT
    %   length must be a power-of-two integer value.
    FFTLengthSource = 'Property';
    %FFTLength FFT length as power-of-two integer value
    %   Specify the FFT length as a power-of-two numeric scalar. This
    %   property is applicable when the FFTLengthSource property is
    %   'Property'. The default value of this property is 256.
    FFTLength = 256;
    %SampleRate Sample rate of input time series
    %   Specify the sampling rate of the original input time series as a
    %   positive numeric scalar. The default value of this property is 1.
    SampleRate = 1;
  end

  properties(Access = private, Nontunable)
      %Subsystems
      cBurgAREst;
      cFFT;
  end

  properties(Constant, Hidden)
    % enum props
    EstimationOrderSourceSet = dsp.CommonSets.getSet( ...
        'AutoOrProperty');
    FFTLengthSourceSet = dsp.CommonSets.getSet( ...
        'AutoOrProperty');
  end
  
  properties(Hidden, Dependent, Nontunable)
    %SampleTime Sample time of input time series
    %   SampleTime property is not recommended. Use SampleRate property
    %   instead.
    SampleTime;
  end

  methods
    % CONSTRUCTOR
    function obj = BurgSpectrumEstimator(varargin)
      coder.allowpcode('plain');
      setProperties(obj, nargin, varargin{:});
    end

    function set.EstimationOrder(obj,val)
      validateattributes( val, { 'numeric' }, ...
        { 'positive', 'integer', 'scalar' }, '', 'EstimationOrder'); %#ok<EMCA>
      obj.EstimationOrder = val;
    end

    function set.FFTLength(obj,val)
      if numel(val) > 1 || ~isreal(val) || val <= 0 ||...
          ceil(val) ~= val || ~dspCheckPow2(val)
        matlab.system.internal.error('MATLAB:system:mustBePosIntPow2',...
          'FFTLength');        
      end
      obj.FFTLength = val;
    end    

    function set.SampleRate(obj,val)
        validateattributes( val, { 'numeric' }, ...
          { 'positive', 'scalar' }, '', 'SampleRate'); %#ok<EMCA>
        obj.SampleRate = val;
    end     
    
    function set.SampleTime(obj, val)
      isSysobjupdatable = false;
      matlab.system.throwDeprecatedPropertyWarning(obj, 'SampleTime', ...
          'SampleRate', isSysobjupdatable);
      obj.SampleRate = 1/val;
    end

    function val = get.SampleTime(obj)
      isSysobjupdatable = false;
      matlab.system.throwDeprecatedPropertyWarning(obj, 'SampleTime', ...
          'SampleRate', isSysobjupdatable);
      val = 1/obj.SampleRate;
    end
  end

  methods(Access = protected)
    function out = stepImpl(obj, x)
      [A, G] = step(obj.cBurgAREst,  x(:));
      y1 = abs(step(obj.cFFT, A)).^2;
      out = G./y1*1/obj.SampleRate;
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
    
    function validateInputsImpl(obj,x)
        % Check the input signal data type and error out if the data type is
        % not floating point
        if ~isfloat(x)
          matlab.system.internal.error(...
            'MATLAB:system:invalidInputDataType','X','floating-point');
        end
        %Check input signal data size and error out if it is not a vector
        if ~isvector(x) || isempty(x)
          matlab.system.internal.error(...
            'MATLAB:system:inputMustBeVector','X');
        end
        sz = size(x);
        coder.internal.errorIf(strcmp(obj.EstimationOrderSource, 'Auto') && ...
            strcmp(obj.FFTLengthSource, 'Auto') && ...
            ~dspCheckPow2(sz(1)), ...
            'dsp:system:BurgSpectrumEstimator:invalidInputs');        
    end

    function validatePropertiesImpl(obj)
       coder.internal.errorIf(strcmp(obj.EstimationOrderSource, 'Property') && ...
            strcmp(obj.FFTLengthSource, 'Auto') && ...
            ~dspCheckPow2(obj.EstimationOrder+1), ...
            'dsp:system:BurgSpectrumEstimator:invalidEstimationOrder');      
    end

    function setupImpl(obj, ~)
      pEstimationOrderSource = obj.EstimationOrderSource;
      if strcmp(pEstimationOrderSource, 'Property')
        obj.cBurgAREst = dsp.BurgAREstimator(...
          'EstimationOrderSource', pEstimationOrderSource, ...
          'EstimationOrder', obj.EstimationOrder);
      else
        obj.cBurgAREst = dsp.BurgAREstimator(...
          'EstimationOrderSource', pEstimationOrderSource);
      end
      if strcmp(obj.FFTLengthSource, 'Auto');
        obj.cFFT = dsp.FFT(...
          'FFTLengthSource', 'Auto');
      else
        obj.cFFT = dsp.FFT(...
          'FFTLengthSource', 'Property', ...
          'FFTLength', obj.FFTLength);
      end
    end

    function  resetImpl(obj)
        reset(obj.cBurgAREst);
        reset(obj.cFFT);
    end

    function  releaseImpl(obj)
        release(obj.cBurgAREst);
        release(obj.cFFT);
    end

  function flag = isInactivePropertyImpl(obj, prop)
      flag = false;
      if strcmp(prop,'EstimationOrder') && ...
              ~strcmp(obj.EstimationOrderSource, 'Property')
          flag = true;
      elseif strcmp(prop,'FFTLength') && ...
              ~strcmp(obj.FFTLengthSource, 'Property')
          flag = true;
      end
  end

  end % methods, protected API
  
  methods(Access=protected)
    
      function s = saveObjectImpl(obj)
          s.EstimationOrderSource = obj.EstimationOrderSource;
          s.EstimationOrder = obj.EstimationOrder;
          s.FFTLengthSource = obj.FFTLengthSource;
          s.FFTLength = obj.FFTLength;
          s.SampleRate = obj.SampleRate;
          if obj.isLocked
              s.cBurgAREst = matlab.System.saveObject(obj.cBurgAREst);
              s.cFFT       = matlab.System.saveObject(obj.cFFT);
          end
      end
      
      function loadObjectImpl(obj, s, wasLocked)
          obj.EstimationOrderSource = s.EstimationOrderSource;
          obj.EstimationOrder = s.EstimationOrder;
          obj.FFTLengthSource = s.FFTLengthSource;
          obj.FFTLength = s.FFTLength;
          obj.SampleRate = s.SampleRate;
          if wasLocked
              obj.cBurgAREst     =  matlab.System.loadObject(s.cBurgAREst);
              obj.cFFT           =  matlab.System.loadObject(s.cFFT);
          end
      end
      
  end 
  
end

