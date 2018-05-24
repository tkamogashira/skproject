classdef CoupledAllpassFilter < matlab.System & dsp.private.FilterAnalysis
%CoupledAllpassFilter Coupled allpass IIR filter
%    
%   HCA = dsp.CoupledAllpassFilter returns a coupled allpass filter
%   System object(TM), HCA, that filters each channel of the input signal 
%   independently. This filtering process uses a coupled allpass filter 
%   with the default inner structures and coefficients.
%
%   HCA = dsp.CoupledAllpassFilter('PropertyName', PropertyValue, ...) 
%   returns a coupled allpass filter System object, HCA, with each 
%   specified property set to the specified value.
%
%   HCA = dsp.CoupledAllpassFilter(AllpassCoefficients1, 
%   AllpassCoefficient2) returns a coupled allpass filter System 
%   object, HCA, with 'Structure' set to 'Minimum multiplier'. The allpass 
%   coefficients for each of the two branches are set to each of the two 
%   specified values, respectively.
%
%   HCA = dsp.CoupledAllpassFilter(Structure, Coefficients1, Coefficient2) 
%   returns a coupled allpass filter System object, HCA, with
%   'Structure' set to the specified value (choice of 'Minimum multiplier',
%   'Wave Digital Filter' or 'Lattice'). The coefficients relevant to the
%   specified structure are set to the values provided.
%
%   Step method syntax:
%
%   Y = step(HCA, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. Each column of X is treated 
%   and filtered independently as a separate channel over time.
%
%   [Y, YPC] = step(HCA, X) Also returns YPC, the power-complementary
%   signal to primary output Y.
%
%   CoupledAllpassFilter methods:
%
%   step                - See preceding description for use of this method
%   release             - Allow changes to non-tunable properties' values
%                         and input characteristics
%   clone               - Create a coupled allpass filter object
%                         with the same property values and internal
%                         states
%   isLocked            - Locked status (logical)
%   reset               - Reset the internal states to zero
%   getBranches         - Return a structure with a copy of the two
%                         internal allpass filter branches
%
%   CoupledAllpassFilter properties:
%
%   Structure               - Structural realization of both internal
%                             allpass filter branches
%   AllpassCoefficients1    - Coefficients used for first branch when
%                             Structure is set to 'Minimum multiplier'
%   WDFCoefficients1        - Coefficients used for first branch when
%                             Structure is set to 'Wave Digital Filter'
%   LatticeCoefficients1    - Coefficients used for first branch when
%                             Structure is set to 'Lattice'
%   Delay                   - Delay length for first branch when
%                             PureDelayBranch is set to true
%   Gain1                   - Phase gain for first branch
%   AllpassCoefficients2    - Coefficients used for second branch when
%                             Structure is set to 'Minimum multiplier'
%   WDFCoefficients2        - Coefficients used for second branch when                          
%                             Structure is set to 'Wave Digital Filter'
%   LatticeCoefficients2    - Coefficients used for second branch when
%                             Structure is set to 'Lattice'
%   Gain2                   - Phase gain for second branch
%   Beta                    - Coupled phase gain
%   PureDelayBranch         - Replaces allpass filter in first branch with
%                             pure delay
%   ComplexConjugateCoefficients    - Enables providing complex
%                             coefficients for only the first branch. The
%                             coefficients for the second branch are
%                             automatically inferred as complex conjugate 
%                             values of the first branch coefficients
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.CoupledAllpassFilter.helpFilterAnalysis.
%
%   % EXAMPLE: Realize a Butterworth lowpass filter of order 3 using
%   % a coupled allpass structure with inner minimum multiplier structure
% 
%     Fs = 48000;    % in Hz 
%     Fc = 12000;    % in Hz 
%     frameLength = 1024;
%     [b, a] = butter(3, 2*Fc/Fs);
%     AExp = [freqz(b,a, frameLength/2); NaN];
%     [c1, c2] = tf2ca(b, a); 
%     Hca = dsp.CoupledAllpassFilter(c1(2:end), c2(2:end)); 
%     hTFE = dsp.TransferFunctionEstimator('FrequencyRange','onesided',... 
%         'SpectralAverages',2); 
%     hPlot = dsp.ArrayPlot('PlotType','Line','YLimits', [-40 5],... 
%         'YLabel','Magnitude (dB)','SampleIncrement', Fs/frameLength,... 
%         'XLabel','Frequency (Hz)','Title',...
%         'Magnitude Response, Actual (1) and Expected (2)',...
%         'ShowLegend', true); 
%     Niter = 200;
%     for k = 1:Niter 
%         in = randn(frameLength, 1); 
%         out = step(Hca, in); 
%         A = step(hTFE, in, out);
%         step(hPlot,db([A, AExp])); 
%     end
%
%   See also dsp.AllpassFilter, dsp.BiquadFilter, dsp.IIRFilter

%   Copyright 2012-2013 The MathWorks, Inc.

    properties(Nontunable, Dependent)
        %Structure Internal structure of allpass branches
        %   Specify the internal structure of allpass branches as
        %   one of {'Minimum multiplier' | 'Wave Digital Filter' |
        %   'Lattice'}. Each structure uses a different pair of 
        %   coefficient values, independently stored in the relevant 
        %   object property.
        Structure = 'Minimum multiplier'
        % PureDelayBranch Replaces the allpass filter in the first branch
        %   with a pure delay. When PureDelayBranch is set to true, the
        %   property holding the coefficients for the first allpass branch
        %   is disabled and Delay becomes enabled.
        %   This property should be used for better performance, when one
        %   of the two allpass branches is known to be a pure delay (e.g.
        %   for halfband filter designs)
        PureDelayBranch = false
    end
    
    properties(Dependent)
        %AllpassCoefficients1 Allpass polynomial coefficients of branch 1
        %   Specify the polynomial filter coefficients for the first
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Mininimum multiplier'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[0 0.5]}. This property is tunable.
        AllpassCoefficients1 = {[0 0.5]}
        %AllpassCoefficients2 Allpass polynomial coefficients of branch 2
        %   Specify the polynomial filter coefficients for the second
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Mininimum multiplier'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[]}. This property is tunable.
        AllpassCoefficients2 = {[]}
        %WDFCoefficients1 Wave Digital Filter coefficients of branch 1
        %   Specify the Wave Digital Filter coefficients for the first
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Wave Digital Filter'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[0.5 0]}. This property is tunable.
        WDFCoefficients1 = {[0.5 0]}
        %WDFCoefficients2 Wave Digital Filter coefficients of branch 2
        %   Specify the Wave Digital Filter coefficients for the second
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Wave Digital Filter'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[]}. This property is tunable.
        WDFCoefficients2 = {[]}
        %LatticeCoefficients1 Lattice coefficients of branch 1
        %   Specify the allpass lattice coefficients for the first
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Lattice'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[0.5 0]}. This property is tunable.
        LatticeCoefficients1 = {[0 0.5]}
        %LatticeCoefficients2 Lattice coefficients of branch 2
        %   Specify the allpass lattice coefficients for the second
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Lattice'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[]}. This property is tunable.
        LatticeCoefficients2 = {[]}
        %Delay Delay length in samples for branch 1
        %   Specify the delay length in number of samples for branch 1,
        %   when the latter operates as a pure delay.
        %   This property is only applicable when the PureDelayBranch
        %   property is set to true. This property is tunable.
        Delay = 0;
        %Beta Coupled phase gain
        %   Specify the value of the phasor gain used in complex conjugate
        %   forms in each of the two branches, respectively, in complex 
        %   coefficient configurations.
        %   This property is only applicable when the selected Structure 
        %   property supports complex coefficients.
        %   The absolute value of this property should be 1 and its
        %   default value is 1. This property is tunable.
        Beta = 1
    end
    
    properties(Nontunable, Dependent)
        %Gain1 Independent Branch 1 Phase Gain
        %   Specify the value of the independent phase gain applied to
        %   branch 1.
        %   This property can only accept values equal to '1', '-1', '0+1i'
        %   and '0-1i'. The default value for this property is '1'. 
        %   This property is nontunable.
        Gain1 = '1'
        %Gain2 Independent Branch 2 Phase Gain
        %   Specify the value of the independent phase gain applied to
        %   branch 2.
        %   This property can only accept values equal to '1', '-1', '0+1i'
        %   and '0-1i'. The default value for this property is '1'. 
        %   This property is nontunable.
        Gain2 = '1'
        % ComplexConjugateCoefficients Allows inferring the coefficients
        %   of the second allpass branch as complex conjugate of the first.
        %   When the input signal is real this triggers the use of an
        %   optimized structural realization. This property is only enabled
        %   if the currently selected structure supports complex
        %   coefficients, and it should only be used the filter
        %   coefficients are actually complex.
        ComplexConjugateCoefficients = false;
    end
    
    properties(Constant, Hidden)
        StructureSet = matlab.system.StringSet({...
            'Minimum multiplier',...
            'Wave Digital Filter',...
            'Lattice'});
        Gain1Set = matlab.system.StringSet({'1','-1','0+1i','0-1i'});
        Gain2Set = matlab.system.StringSet({'1','-1','0+1i','0-1i'});
    end
    
    properties(Access = private)
        % Cell vector of dsp.AllpassFilter objects
        PrivAllpassPair
        PrivSubbandAnalysis = 1 % {1} | 2 | 1:2
        PrivToPcDfilt = false
        PrivIsOutReal
     end
    
    properties(Hidden, Dependent)
        Coefficients1
        Coefficients2
    end

    methods
        
        function obj = CoupledAllpassFilter(varargin)
            % Accepts name-value pair arguments, as well as two different
            % syntaxes for value-only arguments.
            
            % Construct internal
            obj.PrivAllpassPair = dsp.private.CoupledAllpassPair();
            
            if(nargin > 0 && ischar(varargin{1}))
                setProperties(obj,length(varargin),varargin{:}, ...
                    'Structure', 'Coefficients1', 'Coefficients2');
            else
                setProperties(obj,length(varargin),varargin{:}, ...
                    'AllpassCoefficients1', 'AllpassCoefficients2');
            end
        end
        
        function set.Structure(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.Structure = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.Structure(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.Structure;
        end
            
        function set.Coefficients1(obj, coe)
            setActiveCoefficientsForBranch(obj, 1, coe)
        end
        
        function set.Coefficients2(obj, coe)
            setActiveCoefficientsForBranch(obj, 2, coe)
        end
        
        function set.AllpassCoefficients1(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.AllpassCoefficients1 = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.AllpassCoefficients1(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.AllpassCoefficients1;
        end
            
        function set.AllpassCoefficients2(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.AllpassCoefficients2 = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.AllpassCoefficients2(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.AllpassCoefficients2;
        end
            
        function set.WDFCoefficients1(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.WDFCoefficients1 = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.WDFCoefficients1(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.WDFCoefficients1;
        end
            
        function set.WDFCoefficients2(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.WDFCoefficients2 = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.WDFCoefficients2(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.WDFCoefficients2;
        end
            
        function set.LatticeCoefficients1(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.LatticeCoefficients1 = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.LatticeCoefficients1(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.LatticeCoefficients1;
        end
        
        function set.LatticeCoefficients2(obj, value)
            % Validate using underlying rules
            obj.PrivAllpassPair.LatticeCoefficients2 = value;
            % Required by dsp.private.FilterAnalysis
            clearMetaData(obj)
        end
        function value = get.LatticeCoefficients2(obj)
            % Get underlying value
            value = obj.PrivAllpassPair.LatticeCoefficients2;
        end
        
        function set.Beta(obj, value)
            obj.PrivAllpassPair.Beta = value;
            clearMetaData(obj)
        end
        function value = get.Beta(obj)
            value = obj.PrivAllpassPair.Beta;
        end
        
        function set.Gain1(obj, value)
            obj.PrivAllpassPair.Gain1 = value;
            clearMetaData(obj)
        end
        function value = get.Gain1(obj)
            value = obj.PrivAllpassPair.Gain1;
        end
        
        function set.Gain2(obj, value)
            obj.PrivAllpassPair.Gain2 = value;
            clearMetaData(obj)
        end
        function value = get.Gain2(obj)
            value = obj.PrivAllpassPair.Gain2;
        end
        
        function set.PureDelayBranch(obj, value)
            obj.PrivAllpassPair.PureDelayBranch = value;
            clearMetaData(obj)
        end
        function value = get.PureDelayBranch(obj)
            value = obj.PrivAllpassPair.PureDelayBranch;
        end
        
        function set.Delay(obj, value)
            obj.PrivAllpassPair.Delay = value;
            clearMetaData(obj)
        end
        function value = get.Delay(obj)
            value = obj.PrivAllpassPair.Delay;
        end
        
        function set.ComplexConjugateCoefficients(obj, value)
            obj.PrivAllpassPair.ComplexConjugateCoefficients =value;
            clearMetaData(obj)
        end
        function value = get.ComplexConjugateCoefficients(obj)
            value = obj.PrivAllpassPair.ComplexConjugateCoefficients;
        end
        
        function branches = getBranches(obj)
            %getBranches Return internal allpass branches
            %   Return copies of the internal allpass branches, as a
            %   two-field structure. Each branch is an instance of
            %   dsp.AllpassFilter
            assertScalar(obj);
            branches = getBranches(obj.PrivAllpassPair);
        end
        
    end
    
    methods (Access = protected)
        
        function setupImpl(obj, u)
            
            % Enables structural optimization if coefficients are complex
            % conjugate of each other and input signal is real
            % ... And setup relevant branches accordingly
            if(isSecondBranchInferred(obj) && isreal(u))
                obj.PrivAllpassPair.OnlyExecuteTopBranch = true;
            else
                obj.PrivAllpassPair.OnlyExecuteTopBranch = false;
            end
            
            % setup internal structure of parallel allpass filters
            setup(obj.PrivAllpassPair, u, u);

            % Determine output complexity for more efficient processing
            % with real output but non-conjugate filter pair
            [isBranch1Out, isBranch2Out] = areOutputsReal(...
                obj.PrivAllpassPair, u, u);
            obj.PrivIsOutReal = isBranch1Out && isBranch2Out;
            
        end
        
        function resetImpl(obj)
            
            reset( obj.PrivAllpassPair );
        end
        
        function releaseImpl(obj)
            release( obj.PrivAllpassPair );
        end
        
        function [x, xpc] = stepImpl(obj, x)

            if(~obj.PrivAllpassPair.OnlyExecuteTopBranch)
                % Recombine branch outputs into single output
                % output is scaled sum of y1 and y2

                % Process input through allpass branches
                [y1, y2] = step(obj.PrivAllpassPair, x, x);

                % First - compute 'direct' output
                x = 0.5 * (y1 + y2);

                % Check if second output (power complementary) is requested
                if(nargout > 1)
                    xpc = 0.5 * (y1 - y2);
                    if(~obj.PrivIsOutReal)
                        xpc = 1i * xpc;
                    end
                end
            
            else
                % Assumes x real and top branch using complex coefficients
                
                % Process through top branch
                % Branch is dsp.AllpassFilter System object

                [y1, ~] = step(obj.PrivAllpassPair, x, []);

                % Obtain outputs
                % This time use real() and imag() on complex output of top
                % branch
                % First get the 'direct' output
                x = real(y1);
                
                % Then get power-complementary output if requested
                if(nargout > 1)
                    xpc = -imag(y1);
                end
            end
            
        end
        
        function flag = isInactivePropertyImpl(obj, propertyName)
            flag = false;
            switch propertyName
                case {'AllpassCoefficients1',...
                        'WDFCoefficients1',...
                        'LatticeCoefficients1',...
                        'Beta',...
                        'ComplexConjugateCoefficients',...
                        'Delay'}
                    flag = isInactiveProperty(...
                        obj.PrivAllpassPair, propertyName);

                case {'AllpassCoefficients2',...
                        'WDFCoefficients2',...
                        'LatticeCoefficients2'}
                inactiveInBranches = isInactiveProperty(...
                    obj.PrivAllpassPair, propertyName);
                flag = inactiveInBranches || isSecondBranchInferred(obj);

            end
        end
        
        function num = getNumOutputsImpl(~)
            num = 2;
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);

            s.PrivAllpassPair = clone(obj.PrivAllpassPair);
            
            if isLocked(obj)
                % The following are set at setup
                s.PrivSubbandAnalysis = obj.PrivSubbandAnalysis;
                s.PrivToPcDfilt = obj.PrivToPcDfilt;
                s.PrivIsOutReal = obj.PrivIsOutReal;
                % This ensures analysis has all needed information in 
                % floating-point mode
                s.pLockedArithmetic = obj.pLockedArithmetic;
            end
        end
        
        function loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                % The following were set at setup
                obj.PrivSubbandAnalysis = s.PrivSubbandAnalysis;
                obj.PrivToPcDfilt = s.PrivToPcDfilt;
                obj.PrivIsOutReal = s.PrivIsOutReal;
                % This ensures analysis has all needed information in 
                % floating-point mode
                obj.pLockedArithmetic = s.pLockedArithmetic;
            end
            obj.PrivAllpassPair = clone(s.PrivAllpassPair);
            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        function s = getDiscreteStateImpl(obj)
            s = getDiscreteState(obj.PrivAllpassPair);
        end

        function setDiscreteStateImpl(~, s)
            setDiscreteState(obj.PrivAllpassPair, s);
        end

        function [f,l] = hasDiscreteStateImpl(~)
            f = hasDiscreteState(obj.PrivAllpassPair);
            l = inf;
        end
        
        function validateInputsImpl(obj, u)
            % Invoked at first call to setup/step, and then every time the
            % input dimensions change
            validateCurrentInputs(obj.PrivAllpassPair, u, u);

            if(~isLocked(obj))
                % Then this is the first time:
                % (Method of dsp.private.FilterAnalysis) Stores the data
                % type of input as ['double'|'single'|'fixed'] to use for
                % filter analysis
                cacheInputDataType(obj, u)
            end
            
        end
        
        function d = convertToDFILT(obj, arith)
            % Returns equivalent dfilt to current object.
            
            % Fixed-point analysis is not currently supported
            assert(strcmpi(arith,'single') || strcmpi(arith,'double'))
            
            % Need to use typed coefficients available to the step 
            % method to construct the equivalent dfilt. If setup has not 
            % been run yet, then parse and cast the coefficients provided 
            % by the user.
            if(~isLocked(obj))
                SoToAnalyze = clone(obj);
                setup(SoToAnalyze, 1)
            else
                SoToAnalyze = obj;
            end
            
            bsource = getBranches(SoToAnalyze);
            
            if(~SoToAnalyze.PureDelayBranch)
                % Nontrivial allpass filter case
                dBranch1 = convertToDFILT(bsource.Branch1, arith);
            else
                % Pure delay case
                dBranch1 = dfilt.delay(SoToAnalyze.Delay);
                dBranch1.Arithmetic = arith;
            end
            dBranch2 = convertToDFILT(bsource.Branch2, arith);

            dGain1 = dfilt.scalar(str2double(SoToAnalyze.Gain1));
            dGain2 = dfilt.scalar(str2double(SoToAnalyze.Gain2));
            
            dBetaGain1 = dfilt.scalar(...
                conj(SoToAnalyze.PrivAllpassPair.Beta));
            
            if(~obj.PrivToPcDfilt)
                dBetaGain2 = dfilt.scalar(SoToAnalyze.PrivAllpassPair.Beta);
            else
                dBetaGain2 = dfilt.scalar(-SoToAnalyze.PrivAllpassPair.Beta);
            end
            
            dBranch1 = dfilt.cascade(...
                dBranch1, ...
                dfilt.cascade(dGain1, dBetaGain1));
            
            dBranch2 = dfilt.cascade(...
                dBranch2, ...
                dfilt.cascade(dGain2, dBetaGain2));

            d = dfilt.cascade(dfilt.parallel(dBranch1, dBranch2), ...
                dfilt.scalar(0.5));
        end
        
        function [d, inputsCell] = parseArithmetic(...
                obj,inputsCell,forceToDouble,noDfilt)      
          % This overrides the same method of dsp.private.FilterAnalysis
          idx = [];      
          if nargin > 1
            idx = find(strcmpi(inputsCell,'arithmetic'));
          end

          forceToDoubleFlag = nargin > 2 && forceToDouble;

          if ~isempty(idx)
            idx = idx(1);
            if (length(inputsCell)>= idx+1 &&...
                ~any(...
                strcmpi({'double','single','fixed'},inputsCell{idx+1})))...
                || length(inputsCell)< idx+1
              coder.internal.errorIf(true, ['dsp:dsp:private:',...
                  'FilterSystemObjectBase:InvalidArithmeticInput'])
            end
            
            arith = inputsCell{idx+1};
            
            if strcmpi(arith, 'fixed')
              
              % CoupledAllpassFilter does not support fixed-point analysis
              coder.internal.errorIf(true, ['dsp:system',...
                  ':CoupledAllpassFilter:fixedAnalysisNotSupported'])
            end
            
            % arith single but object has other Structure than 'Lattice':
            % no analysis possible - dfilt.allpass and dfilt.wdfallpass
            % only support doubles
            if(strcmpi(arith, 'single') && ...
                    ~strcmp(obj.Structure,'Lattice'))
                coder.internal.errorIf(true, ['dsp:system',...
                    ':CoupledAllpassFilter:onlyDoubleAnalysisSupported'])
            end
            
            inputsCell([idx idx+1]) = [];
          else
            if isLocked(obj)
                assert(strcmpi(obj.pLockedArithmetic,'single') || ...
                    strcmpi(obj.pLockedArithmetic,'double'))
                if(strcmpi(obj.pLockedArithmetic, 'single') && ...
                    ~strcmp(obj.Structure,'Lattice'))
                    % Could not run the requested analysis. When 
                    % 'Structure' is set to 'Minumum multiplier' or 'Wave 
                    % Digital Filter', AllpassFilter only supports double-
                    % precision analysis
                    coder.internal.errorIf(true, ['dsp:system',...
                        ':CoupledAllpassFilter',...
                        ':onlyDoubleAnalysisSupported'])
                end
                arith = obj.pLockedArithmetic;
            else
                arith = 'double';        
            end
          end

          if forceToDoubleFlag
            arith = 'double';
          end

          noDfiltFlag = false;
          if nargin > 3 && noDfilt
            noDfiltFlag = noDfilt;
          end

          % Convert System object to dfilt using the parsed arithmetic
          if noDfiltFlag
            % If no dfilt is requested then we return the parsed arithmetic
            % value
            d = arith;
          else
            d = todfilt(obj,arith);
          end
        end
        
        function doesit = supportsComplexCoefficients(obj)
            doesit = supportsComplexCoefficients(obj.PrivAllpassPair);
        end
        
        function isit = isSecondBranchInferred(obj)
            supportsComplex = supportsComplexCoefficients(obj);
            isit = supportsComplex ...
                && obj.ComplexConjugateCoefficients;
        end
        
        function setActiveCoefficientsForBranch(obj, BranchId, coe)
            setActiveCoefficientsForBranch(...
                obj.PrivAllpassPair, BranchId, coe)
        end
        
        function coe = getActiveCoeffsInBranch(obj, branchNumber)
            coe = getActiveCoeffsInBranch(...
                obj.PrivAllpassPair, branchNumber);
        end
        
        function processTunedPropertiesImpl(obj)
            % Propagate coefficients changes to child objects
            propagateRelevantCoefficientsToBranches(obj.PrivAllpassPair)
        end
        
        function y = infoImpl(obj,varargin)
            y = infoFA(obj,varargin{:});
        end    
    end
    
    methods(Hidden)
        function restrictionsCell = getFixedPointRestrictions(~,~)
            restrictionsCell = {};
        end
        function props = getFixedPointProperties(~)
            props = {};
        end
        function props = getNonFixedPointProperties(obj)
            props = obj.getPropertyNames;
            idxtoprune = [];
            for k = 1:length(props)
                if(isInactiveProperty(obj, props{k}))
                    idxtoprune = [idxtoprune, k]; %#ok<AGROW>
                end
            end
           props(idxtoprune) = [];
        end
        function flag = isPropertyActive(obj,prop)
            flag = ~isInactiveProperty(obj, prop);      
        end
        function  customAnalysisOptions = parseObjectLevelOptions(obj, ...
                customAnalysisOptions)
            validateattributes(customAnalysisOptions, {'cell'}, {})
            % Search customAnalysisOptions for 'SubbandView'
            propertyName = 'SubbandView';

            pos = [];
            for k = 1:length(customAnalysisOptions)
                if(ischar(customAnalysisOptions{k}) && strcmp(...
                        customAnalysisOptions{k}, propertyName))
                    pos = k;
                end
            end
            optfound = ~isempty(pos) && ...
                length(customAnalysisOptions) >= pos+1;
            missingvalue = ~isempty(pos) && ...
                length(customAnalysisOptions) <= pos;
            if(optfound)
                optvalue = customAnalysisOptions{pos+1};
            elseif(missingvalue)
                coder.internal.errorIf(true, ['dsp:system',...
                    ':CoupledAllpassFilter:notfoundFvtoolDisplayOption'])
            else % (no relevant option string found)
                return
            end
            
            % Check if property value is in range - it can be a string, a
            % numeric integer value (1 or 2) or the vector 1:2
            areValuesValidNumbers = isnumeric(optvalue) && ...
                all((optvalue == 1) | (optvalue == 2));
            isValueValidString = ischar(optvalue) && ...
                strcmp(optvalue, 'all');
            if areValuesValidNumbers
                obj.PrivSubbandAnalysis = optvalue;
            elseif isValueValidString
                obj.PrivSubbandAnalysis = 1:2;
            else
                coder.internal.errorIf(true, ['dsp:system',...
                    ':CoupledAllpassFilter:invalidFvtoolDisplayOption'])
            end
            % Remove option and associated value
            customAnalysisOptions(pos)=[]; % removes property name
            customAnalysisOptions(pos)=[]; % removes corresponding value
        end
        function d = todfilt(obj,arith)
          % Convert System object to a DFILT object
          if nargin==1 || isempty(arith)
            if isLocked(obj) && ~isCICFilter(obj)
              arith = obj.pLockedArithmetic;
            elseif isCICFilter(obj)
              arith = 'fixed';
            else
              arith = 'double';
            end
          end
          
          numSubbands = length(obj.PrivSubbandAnalysis);
          d = [];
          for k = 1:numSubbands;
              switch obj.PrivSubbandAnalysis(k)
                  case 1,
                      obj.PrivToPcDfilt = false;
                  case 2
                      obj.PrivToPcDfilt = true;
                  otherwise
                      assert(false)
              end
              dk = convertToDFILT(obj,arith);
              d = [d dk]; %#ok<AGROW>
          end
          resetAnalysisOptions(obj)

          for i = 1:length(d)
              if isprop(d(i),'Arithmetic') && ...
                      strcmpi(d(i).Arithmetic,'fixed')
                if isLocked(obj)
                  d(i).InputWordLength=obj.pInputWordLength; %#ok<AGROW>
                  d(i).InputFracLength=obj.pInputFractionLength;%#ok<AGROW>
                else
                  d(i).InputWordLength = 16; %#ok<AGROW>
                  d(i).InputFracLength = 15; %#ok<AGROW>
                end
              end

              % Set metadata of the converted DFILT object
              setfdesign(d(i),obj.pFdesign)
              setfmethod(d(i),obj.pFmethod)
              if ~isempty(obj.pDesignMethod)
                setdesignmethod(d(i),obj.pDesignMethod)
              end
              d(i).FromSysObjFlag = true; %#ok<AGROW>

              clonedObj = clone(obj);
              release(clonedObj);
              d(i).ContainedSysObj = clonedObj;    %#ok<AGROW>

              d(i).SupportsNLMethods=isNLMSupported(obj,arith);%#ok<AGROW>
          end
          
        end
        function  resetAnalysisOptions(obj)
            obj.PrivSubbandAnalysis = 1;
            obj.PrivToPcDfilt = false;
        end
        
    end
    
    methods(Access = private, Static)
        function props = getPropertyNames()
          props = {...
            'Structure', ...
            'PureDelayBranch', ...
            'Delay', ...
            'AllpassCoefficients1', ...
            'AllpassCoefficients2', ...
            'WDFCoefficients1', ...
            'WDFCoefficients2', ...
            'LatticeCoefficients1', ...
            'LatticeCoefficients2', ...
            'Gain1', ...
            'Gain2', ...
            'Beta'};
        end
    end
    
end
