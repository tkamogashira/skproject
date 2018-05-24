classdef SecondOrderSectionFilter  < matlab.System  & dsp.private.FilterAnalysis
%SECONDORDERSECTIONFILTER Implements filter formed of cascade of second
%order sections. 

%   Copyright 2013 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>
properties (Dependent)
  % Numerator Numerator coefficients of size Lx3, where L is the
  % number of sections.
  Numerator = [1 .1 .2];
  % Denominator Denominator coefficients of size Lx2, where L is
  % the number of sections. The first coefficient is always unity.
  Denominator = [1 .1];
  % ScaleValues Scale values of the sections, of length L+1, where
  % L is the number of sections.
  ScaleValues = [1 1];
end

properties (Access = private)
  % pBiquad Handle to dsp.BiquadFilter object
  pBiquad;
  % pNumerator Reshaped numerator coefficients 
  pNumerator;
  % pDenominator Reshaped denominator coefficients 
  pDenominator;
  % pScaleValues Reshaped scale values 
  pScaleValues;
end
%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  function obj = SecondOrderSectionFilter(varargin)
    % Constructor
    coder.allowpcode('plain');
    setProperties(obj, nargin, varargin{:});
  end
  %------------------------------------------------------------------------
  function set.Denominator(obj,val)
    % strip off leading unity coefficient
    obj.pDenominator = val(:,2:3).';
  end
  %------------------------------------------------------------------------
  function denum = get.Denominator(obj)
    denum = obj.pDenominator;
  end
  %------------------------------------------------------------------------
  function set.Numerator(obj,val)
    obj.pNumerator =val.';
  end
  %------------------------------------------------------------------------
  function num = get.Numerator(obj)
    num = obj.pNumerator;
  end
  %------------------------------------------------------------------------  
  function set.ScaleValues(obj,val)
    obj.pScaleValues =val.';
  end
  %------------------------------------------------------------------------
  function scale = get.ScaleValues(obj)
    scale = obj.pScaleValues;
  end
end
%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------  
methods (Access = protected) 
  function setupImpl(obj, ~)
    % Setup Biquad Filter
    obj.pBiquad = dsp.BiquadFilter('SOSMatrixSource','Input port');
  end
  %------------------------------------------------------------------------
  function y = stepImpl(obj, x )
    % use dsp.BiquadFilter to perofrm filtering. Coefficients and
    % gains are tunable (specified from input port)
    y = step(obj.pBiquad,x,obj.pNumerator,obj.pDenominator,...
             obj.ScaleValues);
  end
  %------------------------------------------------------------------------
  function resetImpl(obj)
    % reset biquad filter
    reset(obj.pBiquad);
  end
  %------------------------------------------------------------------------  
  function releaseImpl(obj)
    % release biquad filter
    release(obj.pBiquad);
  end
  %------------------------------------------------------------------------
  function s = saveObjectImpl(obj)
    s = saveObjectImpl@matlab.System(obj);
    if isLocked(obj)
        s.pBiquad      = matlab.System.saveObject(obj.pBiquad);
        s.pNumerator   = obj.pNumerator;
        s.pDenominator = obj.pDenominator;
        s.pScaleValues = obj.pScaleValues;
    end
  end
  %------------------------------------------------------------------------
  function loadObjectImpl(obj, s, wasLocked)
    if wasLocked
        obj.pBiquad      = matlab.System.loadObject(s.pBiquad);
        obj.pNumerator   = s.pNumerator;
        obj.pDenominator = s.pDenominator;
        obj.pScaleValues = s.pScaleValues;
    end
    loadObjectImpl@matlab.System(obj, s);
  end
  %------------------------------------------------------------------------
  function d = convertToDFILT(obj, arith)
    % Delegate to convertToDFILT method of equivalent dsp.BiquadFilter
    % object
    hbiquadfvtool = dsp.BiquadFilter;
    hbiquadfvtool.SOSMatrix = [obj.Numerator.',...
                               ones(size(obj.Numerator.',1),1),...
                               obj.Denominator.'];
    hbiquadfvtool.ScaleValues = obj.ScaleValues;
    d = hbiquadfvtool.convertToDFILT(arith);
  end
end
%--------------------------------------------------------------------------
% Hidden methods
%--------------------------------------------------------------------------  
methods (Hidden)
  % Methods required for filter analysis functionality
  function restrictionsCell = getFixedPointRestrictions(~,~)
    restrictionsCell = {}; %#ok
  end
  function props = getFixedPointProperties(~)
    props = {}; %#ok
  end
  function props = getNonFixedPointProperties(obj)
    props = obj.getPropertyNames;
    idxtoprune = [];
    for k = 1:length(props)
        if(isInactiveProperty(obj, props{k})) %#ok
            idxtoprune = [idxtoprune, k]; %#ok
        end
    end
    props(idxtoprune) = [];
  end
  function flag = isPropertyActive(obj,prop)
    flag = ~isInactiveProperty(obj, prop);
  end
end
end