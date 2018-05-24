classdef FourthOrderSectionFilter  < matlab.System  & dsp.private.FilterAnalysis
%FOURTHORDERSECTIONFILTER Implements filter formed of cascade of fourth
%order sections. 

%   Copyright 2013 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>

properties
  % Numerator - Numerator coefficients of size Lx5, where L is the
  % number of sections.
  Numerator = [1 .1 .2 .3 1];
  % Denominator - Denominator coefficients of size Lx5, where L is
  % the number of sections.
  Denominator = [1 .1 .2 .3 1];
  % ScaleValues - Scale values of the sections, of length L+1, where
  % L is the number of sections.
  ScaleValues = [1 1];
end

properties (Access = private, Nontunable)
  % pSections Number of fourth order sections.
  pSections;
  % pIsInputReal Input complexity flag
  pIsInputReal;
  % pNumChans Number of input channels
  pNumChans;
end

properties (Access = private)
  % pStates Filter states. 4 states per section.
  pStates;
end

%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods 
  function obj = FourthOrderSectionFilter(varargin)
    % Constructor
    coder.allowpcode('plain');
    setProperties(obj, nargin, varargin{:});
  end
end
%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods (Access = protected) 
  function setupImpl(obj, x)   
    % Set the number of sections
    obj.pSections = size(obj.Numerator,1);
    obj.pIsInputReal = isreal(x);
    obj.pNumChans    = size(x,2);
  end
  %------------------------------------------------------------------------
  function y = stepImpl(obj, x )
    % Pre-allocate some variables for performance
    pstate = obj.pStates;
    num = obj.Numerator;
    denum = obj.Denominator;
    gain = obj.ScaleValues;
    psec = obj.pSections; 
    % Multiply by gain of first section
    in = x * gain(1);
    % Loop over each section
    for j=1:psec
        [in,pstate(:,:,j)] = filter(num(j,:),denum(j,:),in,pstate(:,:,j),1);
        in = in * gain(j+1);
    end
    % Assign to output
    y = in;
    % Update state matrix
    obj.pStates = pstate;
  end
  %------------------------------------------------------------------------
  function resetImpl(obj)
    % Initialize state matrix. Each input channel has seperate states. 
    if obj.pIsInputReal
        obj.pStates   = zeros(4,obj.pNumChans,obj.pSections);
    else
        obj.pStates   = zeros(4,obj.pNumChans,obj.pSections) + 1j *  zeros(4,obj.pNumChans,obj.pSections) ; 
    end
  end
  %------------------------------------------------------------------------ 
  function s = saveObjectImpl(obj)
    s = saveObjectImpl@matlab.System(obj);
    if isLocked(obj)
        s.pSections    = obj.pSections;
        s.pStates      = obj.pStates;
        s.pIsInputReal = obj.pIsInputReal;
        s.pNumChans    = obj.pNumChans;
    end
  end
  %------------------------------------------------------------------------
  function loadObjectImpl(obj, s, wasLocked)
    if wasLocked
        obj.pSections    = s.pSections;
        obj.pStates      = s.pStates;
        obj.pIsInputReal = s.pIsInputReal;
        obj.pNumChans    = s.pNumChans;
    end
        loadObjectImpl@matlab.System(obj, s);
  end
  %------------------------------------------------------------------------
  function d = convertToDFILT(obj, arith)
    % Returns equivalent dfilt to current object.
    % Fixed-point analysis is not currently supported
    assert(strcmpi(arith,'single') || strcmpi(arith,'double'));
    if(~isLocked(obj))
        sysObjToAnalyze = clone(obj);
        setup(sysObjToAnalyze, 1)
    else
        sysObjToAnalyze = obj;
    end
    % Create cascade of fourth order sections
    Hd = dfilt.scalar(sysObjToAnalyze.ScaleValues(1));
    for i=1:sysObjToAnalyze.pSections
        Hdi = dfilt.df2t(sysObjToAnalyze.Numerator(i,:), sysObjToAnalyze.Denominator(i,:));
        Hd = dfilt.cascade(Hd,Hdi,dfilt.scalar(sysObjToAnalyze.ScaleValues(i+1)));
    end
    d = Hd;
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
  %------------------------------------------------------------------------
  function props = getFixedPointProperties(~)
    props = {}; %#ok
  end
  %------------------------------------------------------------------------
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
  %------------------------------------------------------------------------
  function flag = isPropertyActive(obj,prop)
    flag = ~isInactiveProperty(obj, prop);
  end
end
end