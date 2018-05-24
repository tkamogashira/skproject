classdef DigitalConverterBase < matlab.System
    %dsp.private.DigitalConverterBase Baseclass for the DigitalDownConverter and
    %DigitalUpconverter classes.
    
    %   Copyright 2010-2012 The MathWorks, Inc.
    
    %#codegen
    %#ok<*EMCA>
    
    properties (Nontunable)
        %NumAccumulatorBits Number of NCO accumulator bits
        %   Specify this property as an integer scalar in the range [1
        %   128]. This property applies when you set the Oscillator
        %   property to 'NCO'. The default is 16.
        %
        %   See also dsp.NCO.
        NumAccumulatorBits = 16;
        %NumQuantizedAccumulatorBits Number of NCO quantized accumulator
        %bits
        %   Specify this property as an integer scalar in the range [1
        %   128]. The value you specify in the NumQuantizedAccumulatorBits
        %   property must be less than the value you specify in the
        %   NumAccumulatorBits property. This property applies when you set
        %   the Oscillator property to 'NCO'. The default is 12.
        %
        %   See also dsp.NCO.
        NumQuantizedAccumulatorBits = 12;
        %NumDitherBits Number of NCO dither bits
        %   Specify this property as an integer scalar smaller than the
        %   number of accumulator bits that you specify in the
        %   NumAccumulatorBits property. This property applies when you set
        %   the Oscillator property to 'NCO' and the Dither property to
        %   true. The default is 4.
        %
        %   See also dsp.NCO.
        NumDitherBits = 4;
    end
    
    properties (Logical, Nontunable)
        %Dither Dither control for NCO
        %   When you set this property to true, a number of dither bits
        %   specified in the NumDitherBits property will be used to apply
        %   dither to the NCO signal. This property applies when you set
        %   the Oscillator property to 'NCO'. The default is true.
        %
        %   See also dsp.NCO.
        Dither = true;
    end
    
    properties (Nontunable)
        %SecondFilterOrder Order of CIC compensation filter stage
        %   Set this property to a positive, integer scalar. This property
        %   applies when you set the FilterSpecification property to
        %   'Design parameters' and the MinimumOrderDesign property to
        %   false. The default is 12.
        SecondFilterOrder
        %Bandwidth Two sided bandwidth of input signal in Hertz
        %   Set this property to a positive, integer scalar. The object
        %   sets the passband frequency of the cascade of filters to
        %   one-half of the value that you specify in the Bandwidth
        %   property. This property applies when you set the
        %   FilterSpecification property to 'Design parameters'. The
        %   default is 200e3 Hertz.
        Bandwidth
        %StopbandFrequency Stopband frequency in Hertz
        %   Set this property to a double precision positive scalar. This
        %   property applies when you set the FilterSpecification property
        %   to 'Design parameters' and the StopbandFrequencySource property
        %   to 'Property'. The default is 150e3 Hertz.
        StopbandFrequency
        %PassbandRipple Passband ripple of cascade response in dB
        %   Set this property to a double precision, positive scalar. When
        %   you set the MinimumOrderDesign property to true, the object
        %   designs the filters so that the cascade response meets the
        %   passband ripple that you specify in the PassbandRipple
        %   property. This property applies when you set the
        %   FilterSpecification property to 'Design parameters' and the
        %   MinimumOrderDesign property to true. The default is 0.1 dB.
        PassbandRipple
        %StopbandAttenuation Stopband attenuation of cascade response in dB
        %   Set this property to a double precision, positive scalar. When
        %   you set the MinimumOrderDesign property to true, the object
        %   designs the filters so that the cascade response meets the
        %   stopband attenuation that you specify in the
        %   StopbandAttenuation property. This property applies when you
        %   set the FilterSpecification property to 'Design parameters' and
        %   the MinimumOrderDesign property to true. The default is 60 dB.
        StopbandAttenuation
    end
    
    % Fixed-point properties
    
    properties (Nontunable)
        % SecondFilterCoefficientsDataType Data type of second filter
        % coefficients
        %   Specify the second filter coefficients data type as 'Same as
        %   input' |'Custom'. The default is 'Same as input'. This property
        %   applies when you set the FilterSpecification  property to
        %   'Coefficients'.
        SecondFilterCoefficientsDataType = 'Same as input';
        % CustomSecondFilterCoefficientsDataType Fixed-point data type of
        %                                        second filter coefficients
        %   Specify the second filter coefficients fixed-point type as a
        %   scaled numerictype object with a Signedness of Auto. This
        %   property applies when you set the
        %   SecondFilterCoefficientsDataType property to 'Custom'. The
        %   default is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomSecondFilterCoefficientsDataType = numerictype([],16,15);
        % OutputDataType Data type of output
        %    Specify the data type of output as 'Same as input' | 'Custom'.
        %    The default is 'Same as input'.
        OutputDataType = 'Same as input';
        % CustomOutputDataType Fixed-point data type of output
        %   Specify the output fixed-point type as a scaled numerictype
        %   object with a Signedness of Auto. This property applies when
        %   you set the OutputDataType property to 'Custom'. The default is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType = numerictype([],16,15);
    end
    
    properties(Constant, Hidden)
        OutputDataTypeSet = matlab.system.StringSet(...
            {'Same as input','Custom'});
        SecondFilterCoefficientsDataTypeSet = matlab.system.StringSet(...
            {'Same as input','Custom'});
    end
    
    properties (Nontunable, Access = protected)
        %pCIC CIC filter
        pCIC
        %pCICComp CIC compensator filter
        pCICComp
        %pReinterpretCastNumericType Numeric type of reinterpreted CIC output
        pReinterpretCastNumericType
        %pOscillator Oscillator for the frequency converter
        pOscillator
        %pOscillatorOutputNumericType Numeric type of oscillator output
        pOscillatorOutputNumericType
        %pOutputCastFunction Handle to the output cast function
        pOutputCastFunction
        %pNormalizeCICOutputFunction Handle to CIC normalization helper function
        pNormalizeCICOutputFunction
        %pInputDataType Input data type
        pInputDataType
        %pInputSize Size of input signal
        pInputSize
        %pArithmetic Arithmetic of filters. Can be 'double', 'single' or 'fixed-point'
        pArithmetic
        %pCastOutputToBuiltInInteger If true, then we need to cast the output to
        %a built in integer
        pCastOutputToBuiltInInteger
        %pCastOutputToFloatingFi If true then we need to cast the output to a
        %double or single fi object.
        pCastOutputToFloatingFi
        %pIsInputFixedPoint True if input is fixed point
        pIsInputFixedPoint
        %pInputNumericType If input is fixed point, this property holds the
        %numerictype of that input data.
        pInputNumericType
        %pOutputNumericType Numeric type of output
        pOutputNumericType
        %pSecondFilterCoefficientsNumericType Numeric type of second filter
        %coefficients
        pSecondFilterCoefficientsNumericType
        %pCICNormalizationFactor Scaling factor to normalize CIC response
        pCICNormalizationFactor 
        %pInputDesignDataType Data Type of input used in designFilters
        pInputDesignDataType
    end
    
    properties (Access = protected)
        %pInitOscillatorOutput Data initialization used to cast the oscillator
        %output.
        pInitOscillatorOutput
        %pInitMixerOutput Data initialization used to cast the mixer output
        pInitMixerOutput
        %pInitCICNormOutput Data initialization used to cast CIC normalization
        %output
        pInitCICNormOutput
        %pRemNormFactor Remaining normalization factor
        pRemNormFactor
        %pFilterDesigner Filter designer object
        pFilterDesigner
    end
    
    %----------------------------------------------------------------------
    % Abstract methods
    %----------------------------------------------------------------------
    methods(Access = protected, Abstract)
          fd = getFilterDesigner(obj)
          customFiltersDataType = getCustomFiltersDataType(obj)
          flag = isFilterCoefficientsDataTypeSameAsInput(obj)
          checkFactorLength(obj)
          checkFactorValues(obj)
          checkFsFc(obj)
          designDesignerIfEmpty(obj)
          releaseDesignerIfLocked(obj)
          setCustomCoefficientsDataType(obj)
    end
    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods
        function varargout = visualizeFilterStages(obj,varargin)
            %visualizeFilterStages Display response of filter stages
            %   visualizeFilterStages(H) plots the magnitude response of
            %   the filter stages and of the cascade response. When the
            %   FilterSpecification property is set to 'Design parameters'
            %   the method plots a mask based on the filter specifications.
            %   By default, the object plots the response of the filters up
            %   to the second CIC null frequency (or to the first when only
            %   one CIC null exists).
            %
            %   visualizeFilterStages(H,'Arithmetic',ARITH) specifies the
            %   arithmetic of the filter stages. You set input ARITH to
            %   'double', 'single', or 'fixed-point'. When object H is in
            %   an unlocked state you must specify the arithmetic. When
            %   object H is in a locked state the arithmetic input is
            %   ignored.
            %
            %   hfvt = visualizeFilterStages(H) returns a handle to an
            %   FVTool object.
            
            inputArith = parseArithmetic(obj,varargin{:});
            
            % Check if filters have been designed for the specified
            % arithmetic. If no designs are available, design the filters.
            designFilters(obj,inputArith)
            
            hfvt = callPlotMethod(obj,'visualizeFilterStages');
            if nargout == 1
                varargout{1} = hfvt;
            else
                coder.internal.errorIf(nargout > 1, ...
                    'dsp:system:DigitalConverterBase_FvtoolTooManyArguments');
            end
        end
        %------------------------------------------------------------------------
        function varargout = fvtool(obj,varargin)
            %fvtool Visualize response of filter cascade
            %   fvtool(H) plots the magnitude response of the cascade of
            %   filters. By default, the object plots the cascade response
            %   up to the second CIC null frequency (or to the first when
            %   only one CIC null exists). When the FilterSpecification
            %   property is set to 'Design parameters' the method plots a
            %   mask based on the filter specifications.
            %
            %   fvtool(H,..,'Arithmetic',ARITH,...) specifies the
            %   arithmetic of the filter cascade. You set input ARITH to
            %   'double', 'single', or 'fixed-point'. When object H is in
            %   an unlocked state you must specify the arithmetic. When
            %   object H is in a locked state the arithmetic input is
            %   ignored.
            %
            %   fvtool(H,..., PROP1, VALUE1,PROP2,VALUE2, etc.) launches
            %   FVTool and sets the specified FVTool properties to the
            %   specified values.
            %
            %  See also visualizeFilterStages.
            
            assertScalar(obj);
            if isempty(varargin)
                inputArith = [];
            else
                inputArith = [];
                idx = strcmp('Arithmetic',varargin);
                if any(idx)
                    idxCell = find(idx == 1);
                    inputArith = varargin{idxCell+1};
                    
                    coder.internal.errorIf( ~(strcmpi(inputArith,'double') || ...
                                              strcmpi(inputArith,'single') || ...
                                              strcmpi(inputArith,'fixed-point')), ...
                        'dsp:system:DigitalConverterBase_FvtoolInvalidArithmetic');
                    
                    inputArith = lower(inputArith);
                    if strcmp(inputArith,'fixed-point')
                        inputArith = 'fixed';
                    end
                    
                    varargin([idxCell idxCell+1]) = [];
                end
            end
            
            % Check if filters have been designed for the specified
            % arithmetic. If no designs are available, design the filters.
            designFilters(obj,inputArith)
            
            hfvt = callPlotMethod(obj,'fvtool',varargin{:});
            if nargout == 1
                varargout{1} = hfvt;
            else
                coder.internal.errorIf(nargout > 1, ...
                    'dsp:system:DigitalConverterBase_FvtoolTooManyArguments');
            end
        end
        %-----------------------------------------------------------------------
        function [d,f] = groupDelay(obj,varargin)
            %groupDelay Group delay of filter cascade
            %   D = groupDelay(H,N) returns a vector of group delays, D,
            %   evaluated at N frequency points equally spaced around the
            %   upper half of the unit circle. If you don't specify N, it
            %   defaults to 8192.
            %
            %   [D,F] = groupDelay(H,N) returns a vector of frequencies at
            %   which the group delay has been computed.

            assertScalar(obj);
            % If no design is available, design filters using double
            % arithmetic.
            if ~isLocked(obj.pFilterDesigner)
                obj.pFilterDesigner.Arithmetic = 'double';
                step(obj.pFilterDesigner, []);
                obj.pFilterDesigner.SystemObjectsToMfilt();
            end
            [d,f] = groupDelay(obj.pFilterDesigner,varargin{:});
        end
        %------------------------------------------------------------------
        % Set/Get methods
        %------------------------------------------------------------------
        %SecondFilterOrder
        function set.SecondFilterOrder(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','integer'}, '', 'SecondFilterOrder');
            
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.OrderStage2 = val;
        end
        
        function val = get.SecondFilterOrder(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.OrderStage2;
        end
        %---------------------------------------------
        %Bandwidth
        function set.Bandwidth(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','real'}, '', 'Bandwidth');
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.Bandwidth = val;
        end
        
        function val = get.Bandwidth(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.Bandwidth;
        end
        %---------------------------------------------
        %StopbandFrequency
        function set.StopbandFrequency(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','real'}, '', 'StopbandFrequency');
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.StopbandFrequency = val;
        end
        
        function val = get.StopbandFrequency(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.StopbandFrequency;
        end
        %---------------------------------------------
        %PassbandRipple
        function set.PassbandRipple(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','real'}, '', 'PassbandRipple');
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.PassbandRipple = val;
        end
        
        function val = get.PassbandRipple(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.PassbandRipple;
        end
        %---------------------------------------------
        %StopbandAttenuation
        function set.StopbandAttenuation(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','real'}, '', 'StopbandAttenuation');
            designDesignerIfEmpty(obj);
            releaseDesignerIfLocked(obj)
            obj.pFilterDesigner.StopbandAttenuation = val;
        end
        
        function val = get.StopbandAttenuation(obj)
            designDesignerIfEmpty(obj);
            val = obj.pFilterDesigner.StopbandAttenuation;
        end
        %---------------------------------------------
        %NumAccumulatorBits
        function set.NumAccumulatorBits(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','integer'}, '', 'NumAccumulatorBits');
            obj.NumAccumulatorBits = val;
        end
        %---------------------------------------------
        %NumQuantizedAccumulatorBits
        function set.NumQuantizedAccumulatorBits(obj,val)
            validateattributes(val, {'double'}, ...
                {'scalar','positive','integer'}, '', 'NumQuantizedAccumulatorBits');
            obj.NumQuantizedAccumulatorBits = val;
        end
        %---------------------------------------------
        %NumDitherBits
        function set.NumDitherBits(obj,val)
            validateattributes(val, ...
                {'double'},{'scalar','positive','integer'}, '', 'NumDitherBits');
            obj.NumDitherBits = val;
        end
        %---------------------------------------------
        % Fixed point properties
        %---------------------------------------------
        function set.CustomSecondFilterCoefficientsDataType(obj,val)
            validateCustomDataType(obj,'CustomSecondFilterCoefficientsDataType',val, ...
                {'AUTOSIGNED','SCALED'});
            obj.CustomSecondFilterCoefficientsDataType = val;
        end
        function set.CustomOutputDataType(obj,val)
            validateCustomDataType(obj,'CustomOutputDataType',val, ...
                {'AUTOSIGNED','SCALED'});
            obj.CustomOutputDataType = val;
        end
    end
    %----------------------------------------------------------------------
    % Protected methods
    %----------------------------------------------------------------------
    methods (Access = protected)
        function obj = DigitalConverterBase(varargin)
            obj.pFilterDesigner = obj.getFilterDesigner();
            setProperties(obj, nargin, varargin{:});
        end
        %------------------------------------------------------------------------
        function num = getNumOutputsImpl(~)
            num = 1;
        end
        %------------------------------------------------------------------------
        function flag = isInputSizeLockedImpl(~,~)
            flag = true;
        end
        %------------------------------------------------------------------------
        function flag = isInputComplexityLockedImpl(~,~)
            flag = true;
        end
        %------------------------------------------------------------------------
        function flag = isOutputComplexityLockedImpl(~,~)
            flag = true;
        end
        %------------------------------------------------------------------
        function dataType = getInputType(~,x)
            dataType = class(x);
            if isa(x,'embedded.fi')
                % Check if data is not fi double or fi single
                if isdouble(x)
                    dataType = 'double';
                elseif issingle(x)
                    dataType = 'single';
                end
            end
        end
        %------------------------------------------------------------------------
        function validatePropertiesImpl(obj)
            
            if strcmp(obj.FilterSpecification,'Coefficients')
                % Decimation or Interpolation factors must be vectors in this case
                checkFactorLength(obj);
            end
            checkFactorValues(obj);
            
            % Check that sample rate at oscillator input is at least twice the
            % oscillator frequency
            checkFsFc(obj);
            
            if  strcmp(obj.Oscillator,'NCO')
                coder.internal.errorIf(obj.NumQuantizedAccumulatorBits > obj.NumAccumulatorBits, ...
                    'dsp:system:DigitalConverterBase_invalidNumAccumBits');
                
                coder.internal.errorIf(obj.NumDitherBits > obj.NumAccumulatorBits, ...
                    'dsp:system:DigitalConverterBase_invalidNumAccumBits1');
            end
        end
        %------------------------------------------------------------------
        function setInputOutputTypes(obj,x)
            % Cache data types of inputs and outputs
            
            obj.pCastOutputToFloatingFi = false;
            obj.pCastOutputToBuiltInInteger = false;
            
            coder.internal.errorIf(strcmp(obj.pInputDataType,'uint8') || ...
                strcmp(obj.pInputDataType,'uint16') || ...
                strcmp(obj.pInputDataType,'uint32') || ...
                strcmp(obj.pInputDataType,'uint64'), ...
                'dsp:system:DigitalConverterBase_invalidInputDataType');
            
            if strcmp(obj.pInputDataType, 'embedded.fi')
                coder.internal.errorIf(~issigned(x),  ...
                    'dsp:system:DigitalConverterBase_invalidInputDataSignedness');
                nt = numerictype(true,x.WordLength,x.FractionLength);
                obj.pInputNumericType = nt;
                obj.pIsInputFixedPoint = true;
            elseif strcmp(obj.pInputDataType,'int8')
                obj.pInputNumericType = ...
                    numerictype(true,8,0);
                if strcmp(obj.OutputDataType,'Same as input')
                    obj.pCastOutputToBuiltInInteger = true;
                end
                obj.pIsInputFixedPoint = true;
            elseif strcmp(obj.pInputDataType,'int16')
                obj.pInputNumericType = ...
                    numerictype(true,16,0);
                if strcmp(obj.OutputDataType,'Same as input')
                    obj.pCastOutputToBuiltInInteger = true;
                end
                obj.pIsInputFixedPoint = true;
            elseif strcmp(obj.pInputDataType,'int32')
                obj.pInputNumericType = ...
                    numerictype(true,32,0);
                if strcmp(obj.OutputDataType,'Same as input')
                    obj.pCastOutputToBuiltInInteger = true;
                end
                obj.pIsInputFixedPoint = true;
            elseif strcmp(obj.pInputDataType,'int64')
                obj.pInputNumericType = ...
                    numerictype(true,64,0);
                if strcmp(obj.OutputDataType,'Same as input')
                    obj.pCastOutputToBuiltInInteger = true;
                end
                obj.pIsInputFixedPoint = true;
            else % input data type is double or single
                if isa(x,'embedded.fi')
                    obj.pCastOutputToFloatingFi = true;
                    if isdouble(x)
                        nt = numerictype('DataType','double');
                    elseif issingle(x)
                        nt = numerictype('DataType','single');
                    end
                    obj.pInputNumericType = nt;
                end
                obj.pIsInputFixedPoint = false;
            end
            
            if obj.pIsInputFixedPoint
                obj.pArithmetic = 'fixed';
                % Set the numeric type of the output
                if strcmp(obj.OutputDataType,'Same as input')
                    obj.pOutputNumericType = numerictype([],...
                        obj.pInputNumericType.WordLength,...
                        obj.pInputNumericType.FractionLength);
                else
                    obj.pOutputNumericType = numerictype([],...
                        obj.CustomOutputDataType.WordLength,...
                        obj.CustomOutputDataType.FractionLength);
                end
                
                if strcmp(obj.FilterSpecification,'Coefficients')
                    if strcmp(obj.SecondFilterCoefficientsDataType,'Same as input')
                        obj.pSecondFilterCoefficientsNumericType = numerictype([],...
                            obj.pInputNumericType.WordLength,...
                            obj.pInputNumericType.FractionLength);
                    else
                        obj.pSecondFilterCoefficientsNumericType = numerictype([],...
                            obj.CustomSecondFilterCoefficientsDataType.WordLength,...
                            obj.CustomSecondFilterCoefficientsDataType.FractionLength);
                    end
                end
            else
                obj.pArithmetic = obj.pInputDataType;
            end
        end
        %------------------------------------------------------------------
        function designOscillator(obj,frameLength,sampleRate)
            % Design a sine wave generator or an NCO
            
            if strcmp(obj.Oscillator,'Sine wave')
                if obj.pIsInputFixedPoint
                    obj.pOscillator = dsp.SineWave(...
                        'Frequency', obj.CenterFrequency,...
                        'SampleRate', sampleRate,...
                        'ComplexOutput', true,...
                        'SamplesPerFrame',frameLength);
                else % double or single
                    obj.pOscillator = dsp.SineWave(...
                        'Frequency', obj.CenterFrequency,...
                        'SampleRate', sampleRate,...
                        'ComplexOutput', true,...
                        'SamplesPerFrame',frameLength, ...
                        'OutputDataType', obj.pInputDataType);
                end
            elseif strcmp(obj.Oscillator,'NCO')
                Ts = 1/sampleRate;
                phaseInc = round(obj.CenterFrequency*(2^obj.NumAccumulatorBits)*Ts);
                if obj.pIsInputFixedPoint
                    if ~obj.Dither
                        obj.pOscillator = dsp.NCO(...
                            'PhaseIncrementSource','Property',...
                            'PhaseIncrement',phaseInc,...
                            'NumQuantizerAccumulatorBits',obj.NumQuantizedAccumulatorBits,...
                            'AccumulatorDataType', 'Custom',...
                            'CustomAccumulatorDataType',numerictype([],obj.NumAccumulatorBits),...
                            'Dither',obj.Dither,...
                            'SamplesPerFrame',frameLength,...
                            'Waveform','Complex exponential', ...
                            'OutputDataType', 'Custom', ...
                            'CustomOutputDataType', obj.pOscillatorOutputNumericType);
                    else
                        obj.pOscillator = dsp.NCO(...
                            'PhaseIncrementSource','Property',...
                            'PhaseIncrement',phaseInc,...
                            'NumQuantizerAccumulatorBits',obj.NumQuantizedAccumulatorBits,...
                            'AccumulatorDataType', 'Custom',...
                            'CustomAccumulatorDataType',numerictype([],obj.NumAccumulatorBits),...
                            'Dither',obj.Dither,...
                            'SamplesPerFrame',frameLength,...
                            'Waveform','Complex exponential', ...
                            'OutputDataType', 'Custom', ...
                            'CustomOutputDataType', obj.pOscillatorOutputNumericType, ...
                            'NumDitherBits', obj.NumDitherBits);
                    end
                else % double or single
                    if ~obj.Dither
                        obj.pOscillator = dsp.NCO(...
                            'PhaseIncrementSource','Property',...
                            'PhaseIncrement',phaseInc,...
                            'NumQuantizerAccumulatorBits',obj.NumQuantizedAccumulatorBits,...
                            'AccumulatorDataType', 'Custom',...
                            'CustomAccumulatorDataType',numerictype([],obj.NumAccumulatorBits),...
                            'Dither',obj.Dither,...
                            'SamplesPerFrame',frameLength,...
                            'Waveform','Complex exponential', ...
                            'OutputDataType', obj.pInputDataType);
                    else
                        obj.pOscillator = dsp.NCO(...
                            'PhaseIncrementSource','Property',...
                            'PhaseIncrement',phaseInc,...
                            'NumQuantizerAccumulatorBits',obj.NumQuantizedAccumulatorBits,...
                            'AccumulatorDataType', 'Custom',...
                            'CustomAccumulatorDataType',numerictype([],obj.NumAccumulatorBits),...
                            'Dither',obj.Dither,...
                            'SamplesPerFrame',frameLength,...
                            'Waveform','Complex exponential', ...
                            'OutputDataType', obj.pInputDataType, ...
                            'NumDitherBits', obj.NumDitherBits);
                    end
                end
            end
        end
        %------------------------------------------------------------------
        function designFilters(obj,inputArith)
            % Check the validity of inputArith and then design filters if a design
            % is not available or if the filters must be redesigned for a different
            % arithmetic.
            
            if ~isLocked(obj)
                % The arithmetic was not specified and the object is not locked
                coder.internal.errorIf(isempty(inputArith), ...
                    'dsp:system:DigitalConverterBase_methodLacksArithmetic');
                
                if strcmpi(inputArith,'fixed') && strcmp(obj.FilterSpecification,'Coefficients')
                    coder.internal.errorIf(isFilterCoefficientsDataTypeSameAsInput(obj), ...
                        'dsp:system:DigitalConverterBase_methodUnknownInputDataType');
                end
                
                if strcmpi(inputArith,'fixed')
                    % If fixed-point properties have changed, the filters may
                    % need to be redesigned.
                    
                    % Set the filter input data type to the custom data
                    % type specified by the user
                    inputFixedPointArguments = getCustomFiltersDataType(obj);
                    
                    if ~isnumerictype(obj.pInputDesignDataType)
                        release(obj.pFilterDesigner);  % Need to design filters again
                        obj.pInputDesignDataType = inputFixedPointArguments;
                    end
                    if ~isequivalent(obj.pInputDesignDataType, inputFixedPointArguments)
                        release(obj.pFilterDesigner);  % Need to design filters again
                        obj.pInputDesignDataType = inputFixedPointArguments;
                    end
                    
                    % Set the output data type to the custom data type
                    % specified by the user
                    if ~isnumerictype(obj.pFilterDesigner.OutputNumericType)
                        release(obj.pFilterDesigner);  % Need to design filters again
                        obj.pFilterDesigner.OutputNumericType = obj.CustomOutputDataType;
                        obj.pFilterDesigner.InputNumericType = obj.CustomOutputDataType;
                    end
                    if ~isequivalent(obj.pFilterDesigner.OutputNumericType, obj.CustomOutputDataType)
                        release(obj.pFilterDesigner);  % Need to design filters again
                        obj.pFilterDesigner.OutputNumericType = obj.CustomOutputDataType;
                        obj.pFilterDesigner.InputNumericType = obj.CustomOutputDataType;
                    end
                    
                    if ~isLocked(obj.pFilterDesigner) && strcmp(obj.FilterSpecification,'Coefficients')
                        % Set the coefficients data type of the designer object to the
                        % custom data types specified by the user
                        setCustomCoefficientsDataType(obj)
                    end
                else
                    inputFixedPointArguments = [];
                end
                
                if isLocked(obj.pFilterDesigner) && ~isempty(inputArith)
                    % Filters have been designed
                    
                    % Re-design filters if they are not available for the arithmetic of
                    % interest.
                    if ~strcmpi(obj.pFilterDesigner.Arithmetic,inputArith)
                        release(obj.pFilterDesigner);  % Need to design filters again
                    end
                end
                
                if ~isLocked(obj.pFilterDesigner)
                    % Design filters
                    obj.pFilterDesigner.Arithmetic = inputArith;
                    step(obj.pFilterDesigner, inputFixedPointArguments);
                end
            else
                if ~isempty(inputArith) && ...
                        ~strcmp(obj.pFilterDesigner.Arithmetic,inputArith)
                    % The arithmetic has been specified but the object is locked
                    coder.internal.warning('dsp:system:DigitalConverterBase_methodIgnoresArithmetic');
                end
            end
            
            % By now, filters have been designed in System objects. Convert
            % them to mfilts for use with filter analysis functions
            release(obj.pFilterDesigner);   % Need to release this for SystemObjectsToMfilt()
            obj.pFilterDesigner.IsFilterDesignAvailable = true; 
                    % This makes sure the step call after 2 lines does not
                    % do anything except locking the filter designer object
            obj.pFilterDesigner.SystemObjectsToMfilt(); % Create mfilt objects
            step(obj.pFilterDesigner, []); % Call step to lock object again 
            
        end
        %------------------------------------------------------------------------
        function hfvt = callPlotMethod(obj,plotMethod,varargin)
            % Call either fvtool or visualizeFilterStages of the filter designer
            % object. The plotMethod input can be 'fvtool' or 'visualizeFilterStages'.
            % Input varargin contains other arguments that can be passed to fvtool.
            if strcmp(plotMethod,'fvtool')
                hfvt = fvtool(obj.pFilterDesigner,varargin{:});
            else
                hfvt = visualizeFilterStages(obj.pFilterDesigner);
            end
        end
        %------------------------------------------------------------------------
        function inputArith = parseArithmetic(~,varargin)
            % Parse arithmetic input
            coder.internal.errorIf(length(varargin) > 2, ...
                'dsp:system:DigitalConverterBase_arithmeticTooManyInputs');
            
            if isempty(varargin)
                inputArith = [];
            else
                coder.internal.errorIf(length(varargin) == 1, ...
                    'dsp:system:DigitalConverterBase_arithmeticNotValidPVPair');
                
                coder.internal.errorIf(~strcmpi(varargin{1},'arithmetic'), ...
                    'dsp:system:DigitalConverterBase_arithmeticNotValidParamName');
                
                coder.internal.errorIf(~(strcmpi(varargin{2},'double') || ...
                                         strcmpi(varargin{2},'single') || ...
                                         strcmpi(varargin{2},'fixed-point')), ...
                    'dsp:system:DigitalConverterBase_arithmeticInvalidArithmetic');
                
                inputArith = lower(varargin{2});
                if strcmpi(inputArith,'fixed-point')
                    inputArith = 'fixed';
                end
            end
        end
        %------------------------------------------------------------------
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                s.pCIC        = matlab.System.saveObject(obj.pCIC);
                s.pCICComp    = matlab.System.saveObject(obj.pCICComp);
                s.pReinterpretCastNumericType = obj.pReinterpretCastNumericType;
                s.pOscillator = matlab.System.saveObject(obj.pOscillator);
                s.pOscillatorOutputNumericType = obj.pOscillatorOutputNumericType;
                s.pOutputCastFunction = obj.pOutputCastFunction;
                s.pNormalizeCICOutputFunction = obj.pNormalizeCICOutputFunction;
                s.pInputDataType = obj.pInputDataType;
                s.pInputSize = obj.pInputSize;
                s.pArithmetic = obj.pArithmetic;
                s.pCastOutputToBuiltInInteger = obj.pCastOutputToBuiltInInteger;
                s.pCastOutputToFloatingFi = obj.pCastOutputToFloatingFi;
                s.pIsInputFixedPoint = obj.pIsInputFixedPoint;
                s.pInputNumericType = obj.pInputNumericType;
                s.pOutputNumericType = obj.pOutputNumericType;
                s.pSecondFilterCoefficientsNumericType = obj.pSecondFilterCoefficientsNumericType;
                s.pCICNormalizationFactor = obj.pCICNormalizationFactor;
                s.pInputDesignDataType = obj.pInputDesignDataType;
                s.pFilterDesigner = matlab.System.saveObject(obj.pFilterDesigner);
                s.pInitOscillatorOutput = obj.pInitOscillatorOutput;
                s.pInitMixerOutput = obj.pInitMixerOutput;
                s.pInitCICNormOutput = obj.pInitCICNormOutput;
                s.pRemNormFactor = obj.pRemNormFactor;
            end
        end
        
        %------------------------------------------------------------------------
        function loadSubObjects(obj,s,wasLocked)
            if wasLocked
                obj.pCIC            =  matlab.System.loadObject(s.pCIC);
                obj.pCICComp        =  matlab.System.loadObject(s.pCICComp);
                obj.pReinterpretCastNumericType = s.pReinterpretCastNumericType;
                obj.pOscillator     =  matlab.System.loadObject(s.pOscillator);
                obj.pOscillatorOutputNumericType = s.pOscillatorOutputNumericType;
                obj.pOutputCastFunction = s.pOutputCastFunction;
                obj.pNormalizeCICOutputFunction = s.pNormalizeCICOutputFunction;
                obj.pInputDataType = s.pInputDataType;
                obj.pInputSize = s.pInputSize;
                obj.pArithmetic = s.pArithmetic;
                obj.pCastOutputToBuiltInInteger = s.pCastOutputToBuiltInInteger;
                obj.pCastOutputToFloatingFi = s.pCastOutputToFloatingFi;
                obj.pIsInputFixedPoint = s.pIsInputFixedPoint;
                obj.pInputNumericType = s.pInputNumericType;
                obj.pOutputNumericType = s.pOutputNumericType;
                obj.pSecondFilterCoefficientsNumericType = s.pSecondFilterCoefficientsNumericType;
                obj.pCICNormalizationFactor = s.pCICNormalizationFactor;
                if isfield(s, 'pInputDesignDataType')
                    %save files from previous versions may not have this
                    obj.pInputDesignDataType = getCustomFiltersDataType(obj);
                else
                    obj.pInputDesignDataType = s.pInputDesignDataType;
                end
                obj.pFilterDesigner = matlab.System.loadObject(s.pFilterDesigner);
                obj.pInitOscillatorOutput = s.pInitOscillatorOutput;
                obj.pInitMixerOutput = s.pInitMixerOutput;
                obj.pInitCICNormOutput = s.pInitCICNormOutput;
                obj.pRemNormFactor = s.pRemNormFactor;
            end
        end
    end
end


