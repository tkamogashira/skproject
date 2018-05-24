classdef CICDecimator < matlab.System & dsp.private.FilterAnalysisCIC
%CICDecimator Decimate signal using Cascaded Integrator-Comb filter
%   HCICDEC = dsp.CICDecimator returns a System object, HCICDEC, that
%   applies a Cascaded Integrator-Comb (CIC) Decimation filter to the input
%   signal. Inputs and outputs to the object are signed fixed-point data
%   types. A Fixed-Point Designer license is required to use this System
%   object.
%
%   HCICDEC = dsp.CICDecimator('PropertyName', PropertyValue, ...) returns
%   a CIC decimation object, HCICDEC, with each specified property set to
%   the specified value.
%
%   HCICDEC = dsp.CICDecimator(R, M, N, 'PropertyName', PropertyValue, ...)
%   returns a CIC decimation object, HCICDEC, with the DecimationFactor
%   property set to R, the DifferentialDelay property set to M, the
%   NumSections property set to N, and other specified properties set to
%   the specified values.
%
%   Step method syntax:
%
%   Y = step(HCICDEC, X) decimates fixed-point input X to produce a
%   fixed-point output Y using the CIC decimator object HCICDEC.
%
%   CICDecimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create CIC decimation object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   CICDecimator properties:
%
%   DecimationFactor       - Decimation factor of filter
%   DifferentialDelay      - Differential delay of filter comb sections
%   NumSections            - Number of integrator and comb sections
%   FixedPointDataType     - Fixed-point property designations
%   SectionWordLengths     - Word lengths for each filter section
%   SectionFractionLengths - Fraction lengths for each filter section
%   OutputWordLength       - Word length for filter output
%   OutputFractionLength   - Fraction length for filter output
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.CICDecimator.helpFilterAnalysis.
%
%   % EXAMPLE: Decimate signal by a factor of 4 (downsample from 44.1 kHz 
%   % to 11.025 kHz) by specifying the 'Minimum section word lengths' 
%   % FixedPointDataType mode.
%       hcicdec = dsp.CICDecimator(4);  
%       % Specify DecimationFactor = 4, use default NumSections = 2, 
%       % DifferentialDelay = 1
%       hcicdec.FixedPointDataType = 'Minimum section word lengths'; 
%       hcicdec.OutputWordLength = 16;  % Specify the output word length
%       % Create fixed-point sinusoidal input signal 
%       Fs = 44.1e3;              % Original sampling frequency: 44.1 kHz
%       n = (0:1023)';            % 1024 samples, 0.0232 second long signal
%       x = fi(sin(2*pi*1e3/Fs*n),true,16,15);     
%       hsr = dsp.SignalSource(x, 64); % Create SignalSource System object
%       % Process the input signal
%       y = zeros(16,16);
%       for ii=1:16
%         % Decimated output with 16 samples per frame
%         y(ii,:) = step(hcicdec, step( hsr ));   
%       end
%       % Plot the first frame of the original and decimated signals. The output
%       % latency is 2 samples.  
%       gainCIC = ...
%       (hcicdec.DecimationFactor*hcicdec.DifferentialDelay)^hcicdec.NumSections;
%       stem(n(1:56)/Fs, double(x(4:59))); hold on;     
%       stem(n(1:14)/(Fs/hcicdec.DecimationFactor), double(y(1,3:end))/gainCIC,'r','filled'); 
%       xlabel('Time (sec)');ylabel('Signal Amplitude');
%       legend('Original signal', 'Decimated signal', 'location', 'north');
%       hold off;    
%
%   See also dsp.CICInterpolator, dsp.FIRDecimator.

%   Copyright 1995-2013 The MathWorks, Inc.

%#codegen
%#ok<*EMCLS>
%#ok<*EMCA>

  properties (Nontunable)
    %DecimationFactor Decimation factor of filter
    %   Specify a positive integer amount by which the input signal will be
    %   decimated. The default value of this property is 2.
    DecimationFactor = 2;
    
    %DifferentialDelay Differential delay of filter comb sections
    %   Specify a positive integer delay value to be used in each of the
    %   comb sections of the filter. The default value of this property is
    %   1.
    DifferentialDelay = 1;
    
    %NumSections Number of integrator and comb sections
    %   Specify the number of integrator and comb sections in the filter as
    %   a positive integer value. The default value of this property is 2.
    NumSections = 2;
    
    %FixedPointDataType Fixed-point property designations
    %   Specify the fixed-point data type as one of [{'Full precision'} |
    %   'Minimum section word lengths' | 'Specify word lengths' | 'Specify
    %   word and fraction lengths']. When this property is set to 'Full
    %   precision', the System object automatically determines the word and
    %   fraction lengths of the filter sections and output. When the
    %   property is set to 'Minimum section word length', the object
    %   automatically determines the word and fraction lengths of the
    %   filter sections and the fraction length of the output. When the
    %   property is set to 'Specify word lengths', the object automatically
    %   determines the fraction lengths of the filter sections and the
    %   output.
    FixedPointDataType = 'Full precision';
    
    % SectionWordLengths Word lengths for each filter section
    %   Specify the fixed-point word length to use for each filter section.
    %   There are (2*NumSections) filter sections to be specified. This
    %   property is applicable when the FixedPointDataType property is set
    %   to one of ['Specify word lengths' | 'Specify word and fraction
    %   lengths']. The default value of this property is [16 16 16 16].
    SectionWordLengths = [16 16 16 16];
    
    % SectionFractionLengths Fraction lengths for each filter section
    %   Specify the fixed-point fraction length to use for each filter
    %   section. There are (2*NumSections) filter sections to be specified.
    %   This property is applicable when the FixedPointDataType property is
    %   set to 'Specify word and fraction lengths'. The default value of
    %   this property is 0.
    SectionFractionLengths = [0 0 0 0];
    
    % OutputWordLength  Word length for filter output
    %   Specify the fixed-point word length to use for the filter output.
    %   This property is applicable when the FixedPointDataType property is
    %   set to one of ['Minimum section word lengths' | 'Specify word
    %   lengths' | 'Specify word and fraction lengths']. The default value
    %   of this property is 32.
    OutputWordLength = 32;
    
    % OutputFractionLength  Fraction length for filter output
    %   Specify the fixed-point fraction length to use for the filter
    %   output. This property is applicable when the FixedPointDataType
    %   property is set to 'Specify word and fraction lengths'. The default
    %   value of this property is 0.
    OutputFractionLength = 0;
    
  end

  properties(Access = private, Nontunable)
    cOutWL;      cOutFL;
    cCmbStage1;  cIntgStage1;
    cCmbStage2;  cIntgStage2;
    cCmbStage3;  cIntgStage3;
    cCmbStage4;  cIntgStage4;
    cCmbStage5;  cIntgStage5;
    cCmbStage6;  cIntgStage6;
    cCmbStage7;  cIntgStage7;
    cCmbStage8;  cIntgStage8;
    cCmbStage9;  cIntgStage9;
    cCmbStage10; cIntgStage10;
    cCmbStage11; cIntgStage11;
    cCmbStage12; cIntgStage12;
    cCmbStage13; cIntgStage13;
    cCmbStage14; cIntgStage14;
    cCmbStage15; cIntgStage15;
  end

  properties (Constant, Hidden)
    FixedPointDataTypeSet = matlab.system.StringSet({'Full precision', ...
        'Minimum section word lengths', 'Specify word lengths',...
        'Specify word and fraction lengths'});
  end

  methods
    function obj = CICDecimator(varargin)
      if isempty(coder.target)
        if ~isfixptinstalled
          error(message('dsp:systemCICDecimator:fixptTbxRq'));
        end
      end
      setProperties(obj, nargin, varargin{:}, 'DecimationFactor', 'DifferentialDelay', 'NumSections');
      setVarSizeAllowedStatus(obj,false);
    end

    function set.DecimationFactor(obj, value)
        validateattributes( value, { 'numeric' }, { 'positive', 'integer', 'scalar' }, '', 'DecimationFactor');
        clearMetaData(obj)
        obj.DecimationFactor = value;
    end
    
    function set.DifferentialDelay(obj, value)
        validateattributes( value, { 'numeric' }, { 'positive', 'integer', 'scalar' }, '', 'DifferentialDelay');
        clearMetaData(obj)
        obj.DifferentialDelay = value;
    end

    function set.NumSections(obj, value)
        validateattributes(value, { 'numeric' }, ...
            { 'positive', 'integer', 'scalar', '<=', 15 }, '', 'NumSections');
        clearMetaData(obj)
        obj.NumSections = value;
    end
    
    function set.OutputWordLength(obj, value)
        validateattributes(value, { 'numeric' }, ...
            { 'positive', 'integer', 'scalar', '<=', 128, '>=', 2 }, '', 'OutputWordLength'); %#ok<EMCA>
        obj.OutputWordLength = value;
    end
    
    function set.OutputFractionLength(obj, value)
        validateattributes(value, { 'numeric' }, ...
            {'integer', 'scalar'}, '', 'OutputFractionLength');
        obj.OutputFractionLength = value;
    end
    
    function set.SectionWordLengths(obj, value)
        if strncmp(obj.FixedPointDataType, 'Specify', 7)
            validateattributes(value, { 'numeric' }, ...
                {'integer', '<=', 128, '>=', 2}, '', 'SectionWordLengths');
        end
        obj.SectionWordLengths = value;
    end
    
    function set.SectionFractionLengths(obj, value)
        if strncmp(obj.FixedPointDataType, 'Specify word and fraction lengths', 30)
            validateattributes(value, { 'numeric' }, ...
                {'integer'}, '', 'SectionFractionLengths');
        end
        obj.SectionFractionLengths = value;
    end
    
    function g = gain(obj,varargin)
      %GAIN   Gain of the CIC decimation filter System object
      %   G  = gain(Hd) returns the gain, G, of the first stage up to and
      %   including the last stage of the CIC decimation filter System
      %   object, Hd.      
      assertScalar(obj);
      g = (obj.DecimationFactor)^(obj.NumSections);      
    end
  end

  methods (Hidden)
    
    function restrictionsCell = getFixedPointRestrictions(~,~)
      restrictionsCell = {};
    end
    function props = getNonFixedPointProperties(~)
      props = {...
        'DecimationFactor',...
        'DifferentialDelay',...
        'NumSections'};     
    end    
    function props = getFixedPointProperties(~)
      props = {...
        'FixedPointDataType',...
        'SectionWordLengths',...
        'SectionFractionLengths',...
        'OutputWordLength',...
        'OutputFractionLength'};     
    end
    function flag = isPropertyActive(obj,prop)
      flag = ~isInactivePropertyImpl(obj, prop);      
    end    
  end

  methods (Access=protected)
    function validateInputsImpl(obj,varargin)
          
      inputData = varargin{1};  
      % Only signed fixed point inputs are supported
      coder.internal.assert(~isfloat(inputData), 'MATLAB:system:invalidInputDataType','X','fixed-point');
      if isfi(inputData)
        isInputScaledDouble = isscaleddouble(inputData);
        if isInputScaledDouble 
          coder.internal.errorIf(isInputScaledDouble, 'dsp:system:scaledDoubleNotSupported');
        end
        wl = get(inputData,'WordLength');
        signedStr = get(inputData, 'Signedness');
        if ~(wl>1 && wl<129 && strncmp(signedStr, 'Signed', 6))
          coder.internal.errorIf(true, 'MATLAB:system:inputMustBeSignedFixedPoint');
        end
      else
        inStr = class(inputData);
        if ~(strncmp(inStr,'int8',4)  || strncmp(inStr,'int16',5) || ...
                strncmp(inStr,'int32',5) || strncmp(inStr,'int64',5))
           coder.internal.errorIf(true, 'MATLAB:system:inputMustBeSignedFixedPoint'); 
        end
      end
      % number of input rows must be a multiple of decimation factor
      coder.internal.errorIf(mod(size(inputData,1),obj.DecimationFactor)~=0, ...
          'MATLAB:system:invalidInputDimsForDecim');
      
      % Cache input data type for filter analysis
      if isempty(coder.target)
        if ~isempty(varargin)     
          cacheInputDataType(obj,inputData)
        end    
      end
    end    
   
    function setupImpl(obj, in)
        
        coder.extrinsic('getcicdecimwlnfl');
        coder.extrinsic('int2str');
        
        if strncmp(obj.FixedPointDataType, 'Full precision',4)
            FilterInternalsIdx = 1;
        elseif strncmp(obj.FixedPointDataType, 'Minimum section word lengths',4)
            FilterInternalsIdx = 2;
        elseif strncmp(obj.FixedPointDataType, 'Specify word lengths', 20)
            FilterInternalsIdx = 3;
        else
            FilterInternalsIdx = 4;
        end
        
        if length(obj.SectionWordLengths) == 1
            localSectionWL = obj.SectionWordLengths * ones(1,2*obj.NumSections);
        else
            localSectionWL = obj.SectionWordLengths;
        end
        if length(obj.SectionFractionLengths) == 1
            localSectionFL = obj.SectionFractionLengths * ones(1,2*obj.NumSections);
        else
            localSectionFL = obj.SectionFractionLengths;
        end
        
        if FilterInternalsIdx ~= 4
            switch FilterInternalsIdx
                case 1
                    modestr = 'fullprecision';
                case 2
                    modestr = 'minwordlengths';
                case 3
                    modestr = 'specifywordlengths';
            end
            
            if ~isfi(in)
                in1 = fi(in);
                inWL = get(in1,'WordLength');
                inFL = get(in1,'FractionLength');
            else
                inWL = get(in,'WordLength');
                inFL = get(in,'FractionLength');
            end
            if isempty(coder.target)
                a = getcicdecimwlnfl(inWL, inFL, modestr, obj.NumSections, ...
                obj.DecimationFactor, obj.DifferentialDelay, obj.OutputWordLength, ...
                localSectionWL);
            else
                a = coder.internal.const(double(getcicdecimwlnfl(inWL, inFL, modestr, obj.NumSections, ...
                obj.DecimationFactor, obj.DifferentialDelay, obj.OutputWordLength, ...
                localSectionWL)));
            end
            n = obj.NumSections;
            sectionWL = a(1:2*n);
            sectionFL = a(2*n+1:4*n);
            obj.cOutWL = a(end-1);
            obj.cOutFL = a(end);
        else
            % Binary point scaling
            sectionWL = localSectionWL;
            sectionFL = localSectionFL;
            obj.cOutWL = obj.OutputWordLength;
            obj.cOutFL = obj.OutputFractionLength;
        end
        
        n = obj.NumSections;
        for i = coder.unroll(1:n)
            intgStageName = coder.internal.const(['cIntgStage' int2str(i)]);
            obj.(intgStageName) = dsp.private.Integrator('CustomAccumulatorDataType', ...
                numerictype(true,sectionWL(i),sectionFL(i)));
        end
        for i = coder.unroll(1:n)
            cmbStageName = coder.internal.const(['cCmbStage' int2str(i)]);
            obj.(cmbStageName) = dsp.private.FIRCombFilter('DelayLength',obj.DifferentialDelay, ...
                'CustomAccumulatorDataType',numerictype(true,sectionWL(n+i),sectionFL(n+i)));
        end
    end
  
    function out = stepImpl(obj,in)
        coder.extrinsic('int2str');
        
        warning('off', 'SimulinkFixedPoint:util:Overflowoccurred');
        
        n = obj.NumSections;
        coder.internal.const(n);
        % Integrator stages
        for i = coder.unroll(1:n)
            if i == 1
                if isfi(in)
                    y = in;
                else
                    y = fi(in);
                end
            end
            name = coder.internal.const(['cIntgStage' int2str(i)]);
            y = step(obj.(name),y);
        end
        % Down sample
        y = y(1:obj.DecimationFactor:end, :);
        % Comb stages
        for i = coder.unroll(1:n)
            if i == 1
                y2 = y;
            end
            name = coder.internal.const(['cCmbStage' int2str(i)]);
            y2 = step(obj.(name),y2);
        end
        out = quantizefi(y2,1,obj.cOutWL,obj.cOutFL,'floor','wrap');
        
        warning('on', 'SimulinkFixedPoint:util:Overflowoccurred');
        
    end
    
    function resetImpl(obj)
        coder.extrinsic('int2str');
        n = obj.NumSections;
        for i = coder.unroll(1:n)
            intgStageName = coder.internal.const(['cIntgStage' int2str(i)]);
            cmbStageName  = coder.internal.const(['cCmbStage'  int2str(i)]);
            reset(obj.(intgStageName));
            reset(obj.(cmbStageName));
        end
    end
    
    function releaseImpl(obj)
        coder.extrinsic('int2str');
        n = obj.NumSections;
        for i = coder.unroll(1:n)
            intgStageName = coder.internal.const(['cIntgStage' int2str(i)]);
            cmbStageName  = coder.internal.const(['cCmbStage'  int2str(i)]);
            if ~isempty(obj.(intgStageName))
                release(obj.(intgStageName));
            end
            if ~isempty(obj.(cmbStageName))
                release(obj.(cmbStageName));
            end
        end
    end
    
    function s = saveObjectImpl(obj)
      s = saveObjectImpl@matlab.System(obj);
      if isLocked(obj)
        s.cOutWL = obj.cOutWL;
        s.cOutFL = obj.cOutFL;
        n = obj.NumSections;
        for i = coder.unroll(1:n)
          intgStageName = coder.internal.const(['cIntgStage' int2str(i)]);
          cmbStageName  = coder.internal.const(['cCmbStage'  int2str(i)]);
          s.(intgStageName) = saveobj(obj.(intgStageName));
          s.(cmbStageName)  = saveobj(obj.(cmbStageName));
        end
      end
    end

    function loadObjectImpl(obj, s, wasLocked)
      if wasLocked
        obj.cOutWL = s.cOutWL;
        obj.cOutFL = s.cOutFL;
        n = s.NumSections;
        for i = coder.unroll(1:n)
          intgStageName = coder.internal.const(['cIntgStage' int2str(i)]);
          cmbStageName  = coder.internal.const(['cCmbStage'  int2str(i)]);
          obj.(intgStageName) = matlab.system.CoreBlockSystem.loadobj(s.(intgStageName));
          obj.(cmbStageName)  = matlab.System.loadobj(s.(cmbStageName));
        end
      end
      % Call the base class method
      loadObjectImpl@matlab.System(obj, s);
    end

    function flag = isInactivePropertyImpl(obj, prop)
      flag = false;
      switch prop
        case {'SectionFractionLengths', 'OutputFractionLength'}
          if strcmp(obj.FixedPointDataType, 'Full precision') || ...
              strcmp(obj.FixedPointDataType, 'Minimum section word lengths') || ...
              strcmp(obj.FixedPointDataType, 'Specify word lengths')
            flag = true;
          end
        case 'SectionWordLengths'
          if strcmp(obj.FixedPointDataType, 'Full precision') || ...
              strcmp(obj.FixedPointDataType, 'Minimum section word lengths')
            flag = true;
          end
        case 'OutputWordLength'
          if strcmp(obj.FixedPointDataType, 'Full precision')
            flag = true;
          end
      end
    end
    
    function d = convertToDFILT(obj,arith)      
      d = mfilt.cicdecim;
      d.DecimationFactor  = obj.DecimationFactor;
      d.DifferentialDelay = obj.DifferentialDelay;
      d.NumberOfSections  = obj.NumSections;                  
      convertToDFILTCIC(obj,d,arith)
    end        
    
    function y = infoImpl(obj,varargin)
        y = infoFA(obj,varargin{:});
    end 
  end % methods, protected API

  methods(Access=protected)
    function setPortDataTypeConnections(obj)
      setPortDataTypeConnection(obj,1,1);
    end
  end

end
