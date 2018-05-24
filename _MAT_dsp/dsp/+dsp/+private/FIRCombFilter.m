classdef FIRCombFilter < matlab.System
%FIRCombFilter FIR Comb Filter
%   HCOMB = dsp.FIRCombFilter returns a System object, HCOMB, that applies
%   an FIR comb filter to the input signal. Inputs and outputs to the
%   object are signed fixed-point data types. A Fixed-Point Designer license
%   is required to use this System object.
%
%   HCOMB = dsp.FIRCombFilter('PropertyName', PropertyValue, ...) returns
%   an FIR comb filter object, HCOMB, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   Y = step(HCOMB, X) filters fixed-point input X to produce a fixed-point
%   output Y using the FIR comb filter object HCOMB.
%
%   FIR comb filter methods:
%
%   step     - See above description for use of this method 
%   release  - Allow property value and input characteristics changes 
%   clone    - Create integrator object with same property values 
%   isLocked - Locked status (logical) 
%   reset    - Reset the internal states to initial conditions
%
%   FIR comb filter properties:
%
%   DelayLength               - Amount of delay on FIR comb filter
%   CustomAccumulatorDataType - Custom accumulator data type
    
%   Copyright 2012 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>
%#ok<*EMCA>

  properties (Nontunable)
    %DelayLength Amount of delay
    %   Specify amount of delay for the FIR comb filter. This property
    %   must be set to a scalar. The default value of this property is 1.
    DelayLength   = 1;
    
    %CustomAccumulatorDataType Accumulator word and fraction lengths
    %   Specify the accumulator fixed-point type as a signed, scaled
    %   numerictype object. The default value of this property is
    %   numerictype(true,16,0).
    %
    %   See also numerictype.
    CustomAccumulatorDataType = numerictype(true,16,0);
  end

  properties(Access = private)
    cDelay;
  end

  methods
    function obj = FIRCombFilter(varargin)
      setProperties(obj, nargin, varargin{:}, 'DelayLength','CustomAccumulatorDataType');
    end
    
    function set.CustomAccumulatorDataType(obj, val)
      validateCustomDataType(obj, 'CustomAccumulatorDataType', val, {'SIGNED','SCALED'});
      obj.CustomAccumulatorDataType = val;
    end
  end

  methods(Access = protected)
    
    function setupImpl(obj, ~)
      obj.cDelay = dsp.Delay(obj.DelayLength);
    end
    
    function out = stepImpl(obj, in)
      out = quantizefi(in, obj.CustomAccumulatorDataType, 'floor', 'wrap');
      out = accumneg(out, step(obj.cDelay,in));
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
    
    function resetImpl(obj)
      reset(obj.cDelay);
    end
    
    function releaseImpl(obj)
      release(obj.cDelay);
    end
    
    function s = saveObjectImpl(obj)
      s = saveObjectImpl@matlab.System(obj);
      if isLocked(obj)
         s.cDelay = matlab.System.saveObject(obj.cDelay); 
      end
    end

    function loadObjectImpl(obj, s, wasLocked)
      if wasLocked
        obj.cDelay =  matlab.System.loadObject(s.cDelay);
      end
      % Call the base class method
      loadObjectImpl@matlab.System(obj, s);
    end
  end

end

