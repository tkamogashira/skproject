classdef AllpassFilter < matlab.System & dsp.private.FilterAnalysis
%AllpassFilter Single-section or cascaded allpass filter with
%   Minimum-multiplier, Wave Digital Filter or Lattice structure
%
%   HAP = dsp.AllpassFilter returns an allpass filter System object(TM), 
%   HAP, that filters each channel of the input signal independently using 
%   an allpass filter with the default structure and coefficients.
%
%   HAP = dsp.AllpassFilter('PropertyName', PropertyValue, ...) returns an
%   allpass System object, HAP, with each specified property set to a
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HAP, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. Each column of X is treated 
%   and filtered independently as a separate channel over time.
%
%   AllpassFilter methods:
%
%   step                - See above description for use of this method.
%   release             - Allow changes to non-tunable properties' values
%                         and input characteristics.
%   clone               - Create an allpass filter object with the same 
%                         property values and internal states.
%   isLocked            - Locked status (logical).
%   reset               - Reset the internal states to initial conditions.
%
%   AllpassFilter properties:
%
%   AllpassCoefficients - Coefficients used with 'Minimum multiplier'
%                         structure.
%   WDFCoefficients     - Coefficients used with 'Wave Digital Filter'
%                         structure.
%   LatticeCoefficients - Coefficients used with 'Lattice' structure.
%   Structure           - Internal allpass filter structure
%   InitialConditions   - Initial value(s) of filter states.
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.AllpassFilter.helpFilterAnalysis.
%
%   % EXAMPLE: Use a Regalia shelving structure with a first-order 
%   % allpass filter to boost frequency components of a random signal below
%   % 10 kHz by 6 dB
% 
%     Fs = 48000;    % in Hz
%     wc = 2*pi*10000;
%     Vo = 2;        % 6 dB
%     c = -(2-wc/Fs)/(2+wc/Fs);
%     frameLength = 1024;
%     w = (2*pi*Fs/frameLength)*(0:frameLength/2);
%     AExp = nan(size(w.')); AExp(w < wc) = 2; AExp(w > wc) = 1;
%     hAP = dsp.AllpassFilter('AllpassCoefficients',  c);
%     hTFE = dsp.TransferFunctionEstimator('FrequencyRange','onesided',... 
%         'SpectralAverages',2); 
%     hPlot = dsp.ArrayPlot('PlotType','Line','YLimits', [-5 10],... 
%         'YLabel','Magnitude (dB)','SampleIncrement', Fs/frameLength,... 
%         'XLabel','Frequency (Hz)','Title',...
%         'Magnitude Response, Actual (1) and Target (2)',...
%         'ShowLegend', true); 
%     Niter = 300;
%     for k = 1:Niter
%         in = randn(frameLength, 1);
%         shelvedOut = -(1-Vo)/2 * step(hAP, in) + (1+Vo)/2 * in;
%         Txy = step(hTFE, in, shelvedOut);
%         step(hPlot, db([Txy, AExp]))
%     end
%
%   See also dsp.BiquadFilter, dsp.IIRFilter, dsp.TransferFunctionEstimator

%   Copyright 2013 The MathWorks, Inc.

    properties
        %AllpassCoefficients Allpass polynomial coefficients
        %   Specify the real allpass polynomial filter coefficients. This
        %   property is only applicable when the Structure property is set
        %   to 'Mininimum multiplier'. The value of this property can be
        %   either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is [-2^(-1/2), 1/2]. This property is 
        %   tunable.
        AllpassCoefficients = {[-2^(-1/2), 1/2]}
        
        %WDFCoefficients Wave Digital Filter allpass coefficients
        %   Specify the real allpass coefficients in Wave Digital Filter
        %   form. This property is only applicable when the Structure 
        %   property is set to 'Wave Digital Filter'. The value of this 
        %   property can be either a row vector (single-section 
        %   configuration) or a cell array with as many cells as filter 
        %   sections. Acceptable section orders are 1, 2 and 4. If the 
        %   order is 4, then the second and fourth coefficents must be 
        %   zeros. All elements must have absolute value <= 1. The default
        %   value for this property is [1/2, -2^(1/2)/3]. This property is
        %   tunable.
        WDFCoefficients = {[1/2, -2^(1/2)/3]}
        
        %LatticeCoefficients Lattice allpass coefficients
        %   Specify the real or complex allpass coefficients as lattice
        %   reflection coefficients form. This property is only applicable 
        %   when the Structure property is set to 'Lattice'. The value of 
        %   this property can be either a row vector (single-section 
        %   configuration) or a cell array with as many cells as filter 
        %   sections. The default value for this property is 
        %   [-2^(1/2)/3, 1/2]. This propery is tunable.
        LatticeCoefficients = {[-2^(1/2)/3, 1/2]}
    end
    
    properties(Nontunable)
        %Structure Internal allpass structure
        %   Specify the internal allpass filter implementation structure as
        %   one of {'Minimum multiplier' | 'Wave Digital Filter' |
        %   'Lattice'}. Each structure uses a different coefficients set,
        %   independently stored in the corresponding object property
        Structure = 'Minimum multiplier'
        
        %InitialConditions Initial value(s) of the filter states
        %   Specify the initial value of the internal filter states. 
        %   The default value of this property is 0. Acceptable values
        %   include numeric scalar, numeric 1-D or 2-D array, and cell 
        %   array with as many cells as filter sections. The numeric scalar
        %   is used for all filter states, and the numeric 1-D or 2-D array
        %   is single-section only. The inner dimensions should match 
        %   exactly those of the internal filter states
        InitialConditions = 0
    end
    
    properties(Constant, Hidden)
        StructureSet = matlab.system.StringSet({...
            'Minimum multiplier',...
            'Wave Digital Filter',...
            'Lattice'});
    end
    
    properties(Access = private)
        %PrivStates Holds internal filter states within a zero-padded 
        %  3-D array of size (maxStatesPerSection x numChannels x 
        %  numSections).
        PrivStates

        %PrivCoefficients Internal version of the relevant set of 
        % coefficients, to use within stepImpl. Cascaded coefficients
        % are organized as a 2-D zero-padded numerical array, cast to the
        % floating-point data type of the input signal. When the property
        % Structure is set to 'Wave Digital Filter', PrivCoefficients holds
        % a trasformed version of the numerical values in WDFCoeffcients.
        % This is directly used from within stepImpl
        PrivCoefficients
        
        %PrivWDFStageTypes Internal WDF stage type (WDF structure-specific)
        % This property is only applicable when the Structure property is
        % set to 'Wave Digital Filter'.
        PrivWDFStageTypes
        
        %SectionOrders is a column vector holding the values of the orders
        % of all filter sections across the cascade.
        SectionOrders
        
        %InputFloatProto holds a lightweight prototype of the input signal
        % for the purpose of casting the filter coefficients to the right 
        % data type. This property is set at setup, used at coefficients 
        % tuning.
        InputFloatProto
        
        %OutStateCplxProto holds a lightweight prototype of the output
        % signal. This is for the purpose of imposing the right 
        % floating-point data type to the filter output and internal
        % states.
        OutStateCplxProto
    end

    methods

        % Constructor
        
        function obj = AllpassFilter(varargin)
            % Support name-value pair arguments
            setProperties(obj, nargin, varargin{:});
        end
        
        % Accessor methods
        
        function set.AllpassCoefficients(obj, value)
            validateattributes(value, {'cell', 'single', 'double'}, ...
                {},'set.AllpassCoefficients','AllpassCoefficients')
            clearMetaData(obj)
            obj.AllpassCoefficients = ...
                obj.validateUserCoefficients(value, 1);
        end
        
        function set.WDFCoefficients(obj, value)
            validateattributes(value, {'cell', 'single', 'double'}, ...
                {},'set.WDFCoefficients', 'WDFCoefficients')
            clearMetaData(obj)
            obj.WDFCoefficients = ...
                obj.validateUserCoefficients(value, 2);
        end
        
        function set.LatticeCoefficients(obj, value)
            validateattributes(value, {'cell', 'single', 'double'}, ...
                {}, 'set.LatticeCoefficients', ...
                'LatticeCoefficients')
            clearMetaData(obj)
            obj.LatticeCoefficients = ...
                obj.validateUserCoefficients(value, 3);
        end
        
        function set.InitialConditions(obj, value)
            validateattributes(value, {'cell', 'single', 'double'},... 
                {'2d', 'nonempty'}, 'set.InitialConditions', ...
                'InitialConditions')
            obj.InitialConditions = value;
        end
        
    end
    
    methods (Access = protected)
        
        % Relevant to matlab.System
        
        function validatePropertiesImpl(obj)
            % Sanity checks already perfomed within set methods for
            % - AllpassCoefficients
            % - WDFCoefficients
            % - LatticeCoefficients
            
            % Checks on InitialConditions that are independent of internal
            % states (potentially not yet available), but related to 
            % coefficients.
            
            ic = obj.InitialConditions;
            if(isfloat(ic) && isscalar(ic))
                return;
            elseif(isfloat(ic) && ~isscalar(ic))
                icCell = {ic};
            elseif(iscell(ic))
                icCell = ic;
            else
                % ic is either cell or float (validate within set method)
                assert(false)
            end
            
            % Check that cell array has sound structure.
            icCell = obj.validateCascadeCellArray(icCell);

            % Inner cell contents should be matrices.
            cellsHoldMatrices = all(cellfun(@ismatrix, icCell));
            % ... with an equal number of columns
            nCols = size(icCell{1}, 2);
            matricesHaveSameNumOfColumns = ...
                all(cellfun(@(x) size(x,2) == nCols, icCell));
            if(~cellsHoldMatrices || ~matricesHaveSameNumOfColumns)
                coder.internal.errorIf(true, ['dsp:system:',...
                    'AllpassFilter:initCondCellArrayWithSameColsMatrices'])
            end
            
            % Cross-check with current coefficient configuration
            C = getCoefficients(obj);
            % Depending on structure, coefficients will generate a
            % different number of internal states.
            if(usingTwiceAsManyStates(obj))
                statedepths = 2 * cellfun(@(x) size(x,2), C);
            else
                statedepths = cellfun(@(x) size(x,2), C);
            end
            
            % Check that number of cells matches number of sections of
            % coefficients
            assert(iscolumn(icCell))
            numSections = size(icCell, 1);
            sameNumOfSections = length(statedepths) == numSections;
            if(~sameNumOfSections)
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:initCondAsManyCellsAsSections'])
            end
            
            % Check that rows in inner matrices match the corresponding 
            % state depth
            icdepths = cellfun(@(x) size(x,1), icCell);
            if(usingTwiceAsManyStates(obj))
                sameDepthAsCoefficients = all(icdepths == statedepths);
            else
                sameDepthAsCoefficients = all(icdepths == statedepths);
            end
            if(~sameDepthAsCoefficients)
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:initCondAsManyAsStates'])
            end            
        end
        
        function processTunedPropertiesImpl(obj)
            
            C = getCoefficients(obj);
            assert(iscolumn(C))
            newOrders = cellfun(@(x) size(x,2), C);
            newNumSections = length(newOrders);
            
            % Check number of sections against number of rows of 
            % PrivStates.
            if(newNumSections ~= size(obj.PrivStates, 3))
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:noChangeNumOfSections'])
            end
            
            % Check all new section orders vs obj.SectionOrders.
            if(any(newOrders ~= obj.SectionOrders))
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:noChangeSectionOrders'])
            end
            
            % Convert coefficient cell array into internal numeric
            % representation and cast to the right data type.
            [newCoe, newTypes, ~] = setupCoefficients(obj, ...
                obj.InputFloatProto);
            
            % Save new coefficients values
            obj.PrivCoefficients = newCoe;
            obj.PrivWDFStageTypes = newTypes;
        end
        
        function setupImpl(obj, u)
            inPrototype = obj.getPrototype(u);
            
            % *** Coefficients SETUP ***
            
            % Parse user-provided coefficients, transform to relevant
            % internal representation (WDF-only), and cast to the right 
            % data type and complexity.
            [coe, types, orders] = setupCoefficients(obj, inPrototype);
            
            % Save property values relevant to coefficents.
            obj.PrivCoefficients = coe;
            obj.PrivWDFStageTypes = types;
            obj.SectionOrders = orders;

            % *** States SETUP ***
            
            % Get system dimensions.
            numChannels = size(u,2);
            numSections = size(coe, 1);
            if(isempty(orders))
                orders = 0;
            end
            maxOrder = max(orders);
            
            % Complexity for internal states - dependent on input
            % and coefficients
            outCplxProto = obj.getPrototype(inPrototype,  coe);
            
            % Allocate internal states.
            if(usingTwiceAsManyStates(obj))
                % Minimum multiplier case needs twice as many states
                states = ...
                    obj.array(0, [2*maxOrder, numChannels, numSections],...
                    u, outCplxProto);
            else
                states = ...
                    obj.array(0, [maxOrder, numChannels, numSections],...
                    u, outCplxProto);
            end
            
            % Save property values relevant to internal states.
            obj.PrivStates = states;
            obj.InputFloatProto = inPrototype;
            obj.OutStateCplxProto = outCplxProto;
        end
        
        function resetImpl(obj)
            % Cache initial conditions and internal states.
            ic = obj.InitialConditions;
            states = obj.PrivStates;
            [maxStatesPerSection, numChannels, numSections] = size(states);
            
            if(iscell(ic))
                % If icc is a cell array, validate the format and convert 
                % it to internal representation (zero-padded numerical
                % array).
                doubledStatesFlag = usingTwiceAsManyStates(obj);
                icNumeric = obj.icCellToZeroPaddedArray(...
                    ic, doubledStatesFlag);
            else
                icNumeric = ic;
            end
            
            % Most checks performed by validatePropertiesImpl
            % Check here that number of channels in InitialConditions is
            % equal to that of PrivStates.
            icSimpleScalar = isscalar(icNumeric);
            icAndStatesColumnsMatch = size(icNumeric, 2) == size(states,2);
            if(~icSimpleScalar) && (~icAndStatesColumnsMatch)
                % Inner arrays within InitialConditions  must have as many 
                % columns as input signals to the filter
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:initCondCellInnerColsToMatchChannels'])
            end
            
            % Reset states using different approaches based on size of
            % initial conditions.
            obj.PrivStates = ...
                obj.array(icNumeric,...
                [maxStatesPerSection, numChannels, numSections], ...
                states, states);
        end
        
        function x = stepImpl(obj, u)
            
            % Cast complexity of input to that of output. Then
            % process in place.
            x = obj.castComplexity(u, obj.OutStateCplxProto);
            
            % Local version of states and coefficients
            Z = obj.PrivStates;
            orders = obj.SectionOrders;
            C = obj.PrivCoefficients;
            
            numSections = size(Z, 3);
            
            switch obj.Structure
                case 'Minimum multiplier'
                
                % ----- Minimum multiplier implementation
                % Need maxOrder to deal with double-sized states
                maxOrder = max(orders);
                for kS = 1:numSections
                    c = C(kS, 1:orders(kS));
                    z = Z(1:orders(kS), :, kS);
                    zbot = Z(maxOrder + (1:orders(kS)), :, kS);

                    [x, z, zbot] = obj.minmultSingleSection(c, x, z, zbot);
                    
                    Z(1:orders(kS),:,kS) = z;
                    Z(maxOrder + (1:orders(kS)), :, kS) = zbot;
                end
                % ----- End of Minimum multiplier
                
                case 'Wave Digital Filter'
                    
                % ----- WDF implementation
                % Reference: 
                % M. Lutovac, D. Tosic, B. Evans.
                % Filter Design for Signal Processing using MATLAB and
                % Mathematica. Prentice Hall, 2001.
            
                T = obj.PrivWDFStageTypes;
                for kS = 1:numSections
                    a = C(kS, 1:orders(kS));
                    types = T(kS, 1:orders(kS));
                    z = Z(1:orders(kS),:,kS);

                    [x, z] = obj.wdfSingleSection(a, types, x, z);

                    Z(1:orders(kS),:,kS) = z;
                end
                % ----- End of WDF implementation
                
                case 'Lattice'
                    
                % ----- Lattice implementation
                for kS = 1:numSections
                    c = C(kS, 1:orders(kS));
                    z = Z(1:orders(kS),:,kS);

                    [x, z] = obj.latticeSingleSection(c, x, z);
                
                    Z(1:orders(kS),:,kS) = z;
                end
                % ----- End of Lattice implementation
                
                otherwise
                assert(false);
            end
            obj.PrivStates = Z;

        end
        
        function s = getDiscreteStateImpl(obj)
            s = struct('FilterStates', {getStatesAsCellArray(obj)});
        end
        
        function [f,l] = hasDiscreteStateImpl(~)
            f = true;
            l = inf;
        end
        
        function validateInputsImpl(obj, u)
            % Invoked at first call to setup/step, and then every time the
            % input dimensions change
            validateattributes(u, {'single', 'double'}, {'2d'},'','')

            if(isLocked(obj))
                % Then we are here because the input size has changed:
                % Check consistency of input channels.
                if(size(u, 2) ~= size(obj.PrivStates, 2))
                    % Changing the number of channels is not allowed 
                    % without first calling the release() method.
                    coder.internal.errorIf(true, ['dsp:system',...
                        ':AllpassFilter:noNumOfChannelsChangeAllowed'])
                end
            else
                % Then this is the first time:
                % (Method of dsp.private.FilterAnalysis) Stores the data
                % type of input as ['double'|'single'|'fixed'] to use for
                % filter analysis
                cacheInputDataType(obj, u)
            end
        end
        
        function flag = isInactivePropertyImpl(obj, propertyName)
            flag = false;
            if(strcmp(propertyName, 'AllpassCoefficients'))
                flag = ~strcmp(obj.Structure, 'Minimum multiplier');
            elseif(strcmp(propertyName, 'WDFCoefficients'))
                flag = ~strcmp(obj.Structure, 'Wave Digital Filter');
            elseif(strcmp(propertyName, 'LatticeCoefficients'))
                flag = ~strcmp(obj.Structure, 'Lattice');
            end
        end

        function N = getNumInputsImpl(~)
            % Specify the number of System inputs.
            N = 1; % Because stepImpl has only one input beyond obj
        end
        
        function N = getNumOutputsImpl(~)
            % Specify the number of System outputs.
            N = 1; % Because stepImpl has one output
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);

            if isLocked(obj)
                % All the following are set at setup
                s.PrivStates = obj.PrivStates;
                s.PrivCoefficients = obj.PrivCoefficients;
                s.PrivWDFStageTypes = obj.PrivWDFStageTypes;
                s.SectionOrders = obj.SectionOrders;
                s.InputFloatProto = obj.InputFloatProto;
                s.OutStateCplxProto = obj.OutStateCplxProto;
                % This ensures analysis has all needed information in 
                % floating-point mode
                s.pLockedArithmetic = obj.pLockedArithmetic;
            end
        end
        
        function s = loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                % All the following were set at setup
                obj.PrivStates = s.PrivStates;
                obj.PrivCoefficients = s.PrivCoefficients;
                obj.PrivWDFStageTypes = s.PrivWDFStageTypes;
                obj.SectionOrders = s.SectionOrders;
                obj.InputFloatProto = s.InputFloatProto;
                obj.OutStateCplxProto = s.OutStateCplxProto;
                % This ensures analysis has all needed information in 
                % floating-point mode
                obj.pLockedArithmetic = s.pLockedArithmetic;
            end

            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        
        % Relevant to dsp.private.FilterAnalysis
        
        function d = convertToDFILT(obj, arith)
            % Returns equivalent dfilt to current object.
            
            % Fixed-point analysis is not currently supported
            assert(strcmpi(arith,'single') || strcmpi(arith,'double'))
            
            % You want to use typed coefficients available to the step 
            % method to construct the equivalent dfilt. If setup has not 
            % been run yet, then parse and cast the coefficients provided 
            % by the user.
            if(isLocked(obj))
                coe = obj.PrivCoefficients;
                types = obj.PrivWDFStageTypes;
                orders = obj.SectionOrders;
            else
                [coe, types, orders] = setupCoefficients(obj, []);
            end
            
            % Depending on structure, set relevant string for dfilt cascade
            % sections and for WDF structure convert back coefficients to
            % polynomial allpass form, as accepted by dfilt.wdfallpass
            switch obj.Structure
                case 'Minimum multiplier'
                ssname = 'allpass';
                    
                case 'Wave Digital Filter'
                ssname = 'wdfallpass';
                % C here hold WDF alpha coefficients - two conversion steps
                % needed: alpha to WDF, then WDF to allpass polynomial
                W = obj.coeAlphaToWDF(coe, orders, types);
                coe = obj.coeWDFToAllpass(W, orders);
                        
                case 'Lattice'
                ssname = 'latticeallpass';
                    
                otherwise
                assert(false)
                ssname = '';
            end
            
            % Create empty cascade dfilt.
            d = dfilt.cascade;
            % The default cascade object comes with two dummy sections. 
            % First remove them:
            d.removestage(1:2);
            % then, add actual sections (iterate through sections of obj).
            if(~isempty(coe))
                for k = 1:size(coe, 1)
                    c = double(coe(k, 1:orders(k)));
                    if(~isempty(c))
                        thissection = dfilt.(ssname)(c);
                    else
                        thissection = dfilt.(ssname);
                    end
                    
                    if(strcmp(ssname, 'latticeallpass'))
                        thissection.Arithmetic = arith;
                    end
                    
                    d.addstage(thissection);
                end
            else
                thissection = dfilt.(ssname);
                d.addstage(thissection);
            end
            
        end
        
        function [d, inputsCell] = parseArithmetic(...
                obj,inputsCell,forceToDouble,noDfilt)      
          % This overrides the same method of dsp.private.FilterAnalysis
            
          % Parse arithmetic input
          % Inputs:
          %
          % inputsCell    - cell containing PV-pairs. The method will look 
          %                 for the 'Arithmetic' input, parse its value and
          %                 delete the PV-pair from the cell. It will 
          %                 return the modified cell in the second output, 
          %                 inputsCell.
          % forceToDouble - If true, force arithmetic to 'double' 
          %                 regardless of the 'Arithmetic' input
          % noDfilt       - If true, do not generate a dfilt object from 
          %                 the System object and return the parsed 
          %                 arithmetic string instead of the dfilt object
          %                 in the first output, d.

          idx = [];      
          if nargin > 1
            idx = find(strcmpi(inputsCell,'arithmetic'));
          end

          forceToDoubleFlag = nargin > 2 && forceToDouble;

          if ~isempty(idx)
            idx = idx(1);
            if (length(inputsCell)>= idx+1 &&...
                ~any(strcmpi({'double','single','fixed'},...
                inputsCell{idx+1}))) || ...
                length(inputsCell)< idx+1
              
                coder.internal.errorIf(true, ['dsp:dsp:private',...
                    ':FilterSystemObjectBase:InvalidArithmeticInput'])
            end
            
            arith = inputsCell{idx+1};
            
            if strcmpi(arith, 'fixed')
              
              % AllpassFilter does not supports fixed-point analysis
              coder.internal.errorIf(true, ['dsp:system',...
                  ':AllpassFilter:fixedAnalysisNotSupported'])
              
            end
            
            % arith single but object has other Structure than 'Lattice':
            % no analysis possible - dfilt.allpass and dfilt.wdfallpass
            % only support doubles
            if(strcmpi(arith, 'single') && ...
                    ~strcmp(obj.Structure,'Lattice'))
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:onlyDoubleAnalysisSupported'])
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
                        ':AllpassFilter:onlyDoubleAnalysisSupported'])
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
            
    end
    
    methods(Access = private)
        
        % Instance-specific coefficient-management utilities
        
        function coe = getCoefficients(obj)
            switch obj.Structure
                case 'Minimum multiplier'
                coe = obj.AllpassCoefficients;

                case 'Wave Digital Filter'
                coe = obj.WDFCoefficients;
                
                case 'Lattice'
                coe = obj.LatticeCoefficients;
            end
        end

        function [coeCast, typesCast, orders] = setupCoefficients(...
                obj, inputPrototype)
            
            % Get user-provided coefficients relevant to current structure.
            coeCell = getCoefficients(obj);
            % Convert cell arrays to internal representation.
            [coe, orders] = obj.coeCellToZeroPaddedArray(coeCell);
            
            if(isempty(inputPrototype))
                inputPrototype = obj.getPrototype(coe);
            end
            
            % Transform (WDF only) and cast
            if(strcmp(obj.Structure, 'Wave Digital Filter'))
                % Convert WDFCoefficients to Alpha and Types.
                % and cast them to right type into PrivCoefficients
                [types, alphas] = obj.coeWDFToAlpha(coe, orders);
                % Convert coefficients to data type of input.
                [coeCast, typesCast] = castCoefficients(...
                    obj, inputPrototype, alphas, types);
            else
                % Convert coefficients to data type of input.
                [coeCast, typesCast] = castCoefficients(...
                obj, inputPrototype, coe);
            end
            
        end
        
        function [coeCast, typesCast] = castCoefficients(...
                obj, dataTypePrototype, varargin)
            % Cast internal coefficient matrix to dataTypePrototype.
            if(strcmp(obj.Structure, 'Wave Digital Filter'))
                assert(length(varargin) == 2)
                % For WDF structure, the coefficients to use at runtime are
                % the precomputed Alphas and the section Types
                alphas = varargin{1};
                types = varargin{2};
                coeCast = cast(alphas, class(dataTypePrototype));
                typesCast = cast(types, class(dataTypePrototype));
            else
                assert(length(varargin) == 1)
                % For Minimum multiplier and Lattice structures the
                % coefficients used at runtime are those provided by the
                % user. Cast these and put typed zeros within typesCast.
                coe = varargin{1};
                coeCast = cast(coe, class(dataTypePrototype));
                typesCast = zeros(1, class(dataTypePrototype));
            end
        end
        
        % State-management utilities
        
        function usingtwice = usingTwiceAsManyStates(obj)
            usingtwice = strcmp(obj.Structure, 'Minimum multiplier');
        end
        
        function Zout = getStatesAsCellArray(obj)

            % PrivStates representation is a numeric, zero-padded array
            % of size (maxNumStatesPerSection x numChannels x numSections).
            Z = obj.PrivStates;
            % Convert it into a vector of numSections cells
            Zc = squeeze(num2cell(Z,[1, 2]));
            
            % Now need to discard padding zeros within each of the cells
            
            % Local copy of section orders
            orders = obj.SectionOrders;
            maxOrder = max(orders);
            
            % Initialize returned value.
            Zout = cell(size(Zc));
            for kSection = 1:length(orders)
                if(~usingTwiceAsManyStates(obj))
                    % WDF and Lattice only have orders(kSection) states per
                    % section (and per channel): simply fill current cell
                    % with those valid values.
                    Zout{kSection} = Zc{kSection}(1:orders(kSection) ,:);
                else
                    % Minimum-multiplier structure has 2 x orders(kSection)
                    % states per section (and per channel): extract all
                    % valid values into  current cell
                    fullRows = [1:orders(kSection), ...
                        maxOrder + (1:orders(kSection))];
                    Zout{kSection} = Zc{kSection}(fullRows ,:);
                end
            end
            
        end
        
    end
    
    methods (Static)
        function g = poly2wdf(c)
            %poly2wdf Converts standard single-section allpass polynomial 
            % coefficients into Wave Digital Filter form.
            % Acceptable section orders are 1, 2 and 4. If the order is 4
            % then the first and third coefficents must be zeros. 
            % 
            %   % EXAMPLE: Convert a single-section dsp.AllpassFilter with
            %   % Minimum multiplier structure into an equivalent Wave 
            %   % Digital Filter form
            %   
            %   hReference = dsp.AllpassFilter(...
            %       'AllpassCoefficients', [0.1 0.2]);
            %   cPolycoeffs = hReference.AllpassCoefficients;
            %   wdfcoeffs = dsp.AllpassFilter.poly2wdf(cPolycoeffs{1});
            %   hWDFVersion = dsp.AllpassFilter(...
            %     'Structure', 'Wave Digital Filter', ...
            %     'WDFCoefficients', wdfcoeffs);
            %   % Display both filters in fvtool and verify all main
            %   % responses are equal
            %   fvtool(hReference, hWDFVersion)
            % 
            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
            
            validateattributes(c, {'single', 'double'}, {'row'})
            if(all(length(c) ~= [1,2,4]) || ...
                    (length(c) == 4 && ~all(c([1,3])==0)))
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:wdfSectionOrdersOnly124poly'])
            end
            switch length(c),
                case 1,
                    g = c;
                case 2,
                    g = [c(2), c(1)/(1+c(2))];
                case 4,
                    % This works only when c is of the form [0;c(2);0;c(4)]
                    g = [c(4), 0, c(2)/(1+c(4)), 0];
                otherwise
                    g = [];
                    assert(false)
            end
        end
        
        function c = wdf2poly(g)
            %wdf2poly Converts single-section Wave Digital Filter allpass 
            % coefficients into standard polynomial form.
            % Acceptable section orders are 1, 2 and 4. If the order is 4
            % then the second and fourth coefficents must be zeros. 
            % 
            %   % EXAMPLE: Convert a single-section dsp.AllpassFilter with
            %   % Wave Digital Filter structure into an equivalent Minimum
            %   % multiplier form.
            %   
            %   hReference = dsp.AllpassFilter(...
            %       'Structure', 'Wave Digital Filter', ...
            %       'WDFCoefficients', [0.1 0.2]);
            %   cWdfcoeffs = hReference.WDFCoefficients;
            %   polycoeffs = dsp.AllpassFilter.wdf2poly(cWdfcoeffs{1});
            %   hMMVersion = dsp.AllpassFilter(...
            %       'AllpassCoefficients', polycoeffs);
            %   % Display both filters in fvtool and verify all main
            %   % responses are equal
            %   fvtool(hReference, hMMVersion)           
            %
            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
            
            validateattributes(g, {'single', 'double'}, {'row'})
            if(all(length(g) ~= [1,2,4]) || ...
                    (length(g) == 4 && ~all(g([2,4])==0)))
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:wdfSectionOrdersOnly124wdf'])
            end
            switch(length(g))
                case 1
                    % Order 1
                    c = g;
                case 2
                    % Order 2
                    c = [g(2)*(1 + g(1)), g(1)];
                case 4
                    % Order 4
                    c = [0, g(3)*(1 + g(1)), 0, g(1)];
                otherwise
                    c = [];
                    assert(false)
            end
        end
        
    end
    
    methods (Hidden, Static)
        
        function okValue = validateUserCoefficients(value, coeStructFlag)
            % Note - coeStructFlag = ...
            % 1 - destination is AllpassCoefficients
            % 2 - destination is WDFCoefficients
            % 3 - destination is LatticeCoefficients
            
            % Wrap as cell if provided as numeric scalar or vector
            C = dsp.AllpassFilter.validateAndWrapSectionIfNumeric(value);
            % Ensure cell array container is 1-D and column-oriented
            C = dsp.AllpassFilter.validateCascadeCellArray(C);
            % Check constraints on:
            % - Inner coefficients alignment as row vectors
            % - Complexity of coefficients (WDF and Minimum multiplier)
            % - Order of sections (WDF)
            C = dsp.AllpassFilter.checkInnerCoeOrderAndComplexity(C,...
                coeStructFlag);
            % Now validated
            okValue = C;
        end
        
        function outproto = getPrototype(varargin)
            % p = dsp.AllpassFilter.getPrototype(x) returns a lightweight 
            %   prototype for the numerical variable x. x can be a
            %   - Numeric array (empty or non-empty)
            %   - Cell array with numeric arrays is all cells
            %   For valid cell arrays outproto is complex if at least one
            %   cell has complex content and it has the numeric class of
            %   the content in the first cell
            %   If x is none of the above then outproto = [].
            % p = dsp.AllpassFilter.getPrototype(x, y) returns a prototype 
            %   based on the product of x and y if they are both valid 
            %   numeric or cell arrays (see above)
            %   If any of the two has complex prototype the result is still 
            %   complex even if all input imaginary parts were 0.
            %   For valid inputs the value of outproto is either 1 or 1+0i.
            %   If any of x or y is not a valid option then outproto = []


            % Only one or two inputs allowed.
            assert((nargin == 1) || (nargin == 2))

            x = varargin{1};
            outproto = dsp.AllpassFilter.getNumericPrototype(x);
            if(isempty(outproto))
                coder.internal.warning(...
                    'dsp:system:AllpassFilter:badTypeForProto')
                return
            end
            
            if(nargin == 1)
                return
            end
            
            y = varargin{2};
            yproto = dsp.AllpassFilter.getNumericPrototype(y);
            if(isempty(yproto))
                outproto = yproto;
                coder.internal.warning(...
                    'dsp:system:AllpassFilter:badTypeForProto')
                return
            end
            
            % Take care of data type propagation first
            dtproto = outproto * yproto;
            % Set complexity right
            if(~isreal(outproto) || ~isreal(yproto))
                % Any of the two complex: result should be complex
                % dtroto so far is always real: add 0 imag part
                cplxproto = complex(dtproto);
                outproto = cplxproto;
            else
                % Both x and y real
                outproto = dtproto;
            end
            
        end
    end
    
    methods (Access = private, Static)
        
        % Filtering routines - all used by stepImpl
        
        function [u, ZT, ZB] = minmultSingleSection(c, u, ZT, ZB)
            % Local assumptions :
            % assert(isrow(c))
            % assert(all(size(ZT) == size(ZB)))
            % assert(size(ZT, 1) == order)
            order = length(c);
            
            % Check order - if 0 return input
            if(order > 0)

                % Loop through time
                for t = 1:size(u, 1)
                    % Isolate final top state across all channels
                    z0 = ZT(end, :);
                    ZT(2:end, :) = ZT(1:end-1, :);
                    ZT(1, :) = u(t, :);

                    % Top minus bottom states across all channels
                    zdelta = ZT(end:-1:1, :) - ZB;

                    % Compute output (re-use temp input)
                    % Note: Coefficients size is [Order, 1] 
                    u(t, :) = z0 + c * zdelta;

                    % Update states
                    ZB(2:end, :) = ZB(1:end-1, :);
                    ZB(1, :) = u(t, :);

                end      

            end

        end
        
        function [u, ZI] = wdfSingleSection(a, types, u, ZI)
            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
            
            order = length(a);
            Z = ZI(1:order, :);

            % Local assumptions:
            % assert(isrow(a))
            % assert(isrow(types))
            % assert(length(a) == length(types))
            % assert(size(Z, 1) == order)
            % assert(size(Z, 2) == size(u, 2))

            for t = 1:size(u, 1)

                % Filter in reverse order so the output of one stage is 
                % the input of the previous
                xv = [u(t, :); Z];

                for n = order:-1:1
                    
                     switch types(n)
                        case 1
                            % Figure 8.51 in reference
                            v  = xv(n, :) - xv(n+1, :);
                            % In-place equivalent of
                            % y  = xb + a*v;
                            % yb = y + v;
                            xv(n, :)  = xv(n+1, :) + a(n)*v;
                            xv(n+1, :) = xv(n, :) + v;
                        case 2
                            % Figure 8.52 in reference
                            v  = xv(n, :) - xv(n+1, :);
                            % In-place equivalent of
                            % yb = xb + a*v;
                            % y  = yb - v;
                            xv(n+1, :) = xv(n+1, :) + a(n)*v;
                            xv(n, :)  = xv(n+1, :) - v;
                        case 3
                            % Figure 8.48 in reference
                            v  = xv(n, :) + xv(n+1, :);
                            % In-place equivalent of
                            % yb = a*v - xb;
                            % y  = v - yb;            
                            xv(n+1, :) = a(n)*v - xv(n+1, :);
                            xv(n, :)  = v - xv(n+1, :);            
                        case 4
                            % Figure 8.49 in reference
                            v  = xv(n+1, :) - xv(n, :);
                            % In-place equivalent of
                            % y  = a*v + xb;
                            % yb = y - v;
                            xv(n, :)  = a(n)*v + xv(n+1, :);
                            xv(n+1, :) = xv(n, :) - v;
                        case 5
                            % Figure 8.50 in reference
                            tmp = xv(n+1, :);
                            % In-place equivalent of
                            % y  = xb;
                            % yb = x;
                            xv(n+1, :) = xv(n, :);
                            xv(n, :) = tmp;
                        otherwise
                            xv(n, :)  = zeros(size(xv(n, :)), class(xv));
                            xv(n+1, :) = xv(n, :);
                            assert(false)
                    end
                   
                    
                end

                u(t, :) = xv(1, :);
                Z = xv(2:end, :);

            end
            ZI(1:order, :) = Z;


        end
        
        function [u, Z] = latticeSingleSection(k, u, Z)

            % Local assumptions:
            % assert(isrow(k))
            % assert(size(Z, 1) == order)
            % assert(size(Z, 2) == size(u, 2))
            order = length(k);
            
            if(order > 0)

                for t = 1:size(u, 1)

                    % Preallocate top lattice path - simply set to Z for
                    % efficiency. All tmp will be overwritten
                    tmp = Z;

                    % Step 1 -  tmp holds the values at the nodes of the
                    %           stateless instantaneous top lattice path
                    for kCh = 1:size(Z,2)
                        tmp2 = u(t, kCh);
                        for idx = order:-1:1
                            tmp(idx, kCh) = tmp2 - k(idx) * Z(idx, kCh);
                            tmp2 = tmp(idx, kCh);
                        end
                        u(t, kCh) = tmp2;
                    end
                    
                    % Loop top branch and bottom branch at the end of the
                    % lattice
                    sectionReturn = u(t, :);

                    % Step 2 -  Bottom path of the lattice, where the 
                    %           states are.
                    %           tmp now to hold the outputs of all the sum
                    %           units in the bottom path.
                    % (All 2d arrays here below are [order x numchannels])
                    % Manually loop through channels
                    for kCh = 1:size(Z,2)
                        tmp(:, kCh) = conj(k(:)).*tmp(:, kCh) + Z(:, kCh);
                    end
                    
                    % State update and output
                    Z = [sectionReturn; tmp(1:end-1, :)];
                    u(t, :) = tmp(end, :);

                end

            end

        end
        
        % Numeric coefficients conversion utilities
        
        function [types, coe] = coeWDFToAlpha(coe, orders)
            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
            
            % Check all WDF coefficients are less than 1 in abs value
            % else no adaptor type selection allowed
            assert(all(all(abs(coe) <= 1)))
            assert(iscolumn(orders))
            assert(length(orders) == size(coe, 1))
            
            numSections = length(orders);

            types = zeros(size(coe));

            for s = 1:numSections
                for a = 1:orders(s)
                    % Type 1 - Figure 8.51 in reference
                    if(coe(s, a) > 0 && coe(s, a) <= 0.5)
                        % NOP [in and out equal]
                        types(s, a) = 1;

                    % Type 2 - Figure 8.52 in reference
                    elseif(coe(s, a) >= -1 && coe(s, a) < -0.5)
                        coe(s, a) = 1 + coe(s, a);
                        types(s, a) = 2;

                    % Type 3 - Figure 8.48 in reference
                    elseif(coe(s, a) <= 1 && coe(s, a) > 0.5)
                        coe(s, a) = 1 - coe(s, a);
                        types(s, a) = 3;

                    % Type 4 - Figure 8.49 in reference
                    elseif(coe(s, a) < 0 && coe(s, a) >= -0.5)
                        coe(s, a) = - coe(s, a);
                        types(s, a) = 4;

                    % Type 5 - Figure 8.50 in reference
                    elseif(coe(s, a) == 0);
                        coe(s, a) = 0;
                        types(s, a) = 5;

                    else
                        coe(s, a) = 0;
                        types(s, a) = 0;
                        assert(false)
                    end
                end
            end
        end
        
        function W = coeAlphaToWDF(A, orders, Types)

            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
            
            W = zeros(size(A));

            for k = 1:length(orders)
                coeVector = A(k, :);
                typesVector = Types(k, :);
                
                % All alpha coefficients are less than 0.5 in abs value
                assert(all(abs(coeVector) <= 0.5))
                % Size of types and coefficients are equal
                assert(all(size(typesVector) == size(coeVector)))
                assert(size(coeVector, 1) == 1);
            
                for n = 1:orders(k)
                    switch typesVector(n)
                        case 1
                            % Figure 8.51 in reference
                            coeVector(n) = coeVector(n);
                        case 2
                            % Figure 8.52 in reference
                            coeVector(n) = coeVector(n) - 1;
                        case 3
                            % Figure 8.48 in reference
                            coeVector(n) = 1 - coeVector(n);
                        case 4
                            % Figure 8.49 in reference
                            coeVector(n) = - coeVector(n);
                        case 5
                            % Figure 8.50 in reference
                            coeVector(n) = 0;
                        otherwise
                            coeVector(n) = 0;
                            assert(false)
                    end
                end
                W(k, 1:orders(k)) = coeVector(1:orders(k));
            end
        end
        
        function C = coeWDFToAllpass(W, orders)

            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
            
            C = zeros(size(W));

            for k = 1:length(orders)
                C(k, 1:orders(k)) = ...
                    dsp.AllpassFilter.wdf2poly(W(k, 1:orders(k)));
            end


        end
        
        % Data type and complexity handling for numerical arrays
        
        function y = array(x, Sy, yDatatypePrototype, yComplexityPrototype)
            % x                     : Scalar or array input
            % Sy                    : Desired size of output y
            % yDatatypePrototype    : Data type prototype to use for y
            % yComplexityPrototype  : Complexity prototype to use for y
            % y                     : Expanded/reshaped and casted replica 
            %                         of x

            coder.inline('always')
            if(~isscalar(x) && (numel(x) ~= prod(Sy)))
                coder.internal.errorIf(true, ...
                    'dsp:system:AllpassFilter:sizeXToMatchYIfNotScalar')
            end

            xTyped = cast(x, class(yDatatypePrototype));

            if(isscalar(x))
                xpand = repmat(xTyped, Sy);
            else
                % Reshape if source and target orientations differ
                % No-op if orientations match
                xpand = reshape(xTyped, Sy);
            end

            if(~isreal(yComplexityPrototype) && isreal(xpand))
                y = complex(xpand); % zero for imag part
            elseif(isreal(yComplexityPrototype) && ~isreal(xpand))
                y = real(xpand);    % zero-ing imag part
            else
                % x and y complexities match
                y = xpand;
            end

        end
        
        function y = castComplexity(x, yComplexityPrototype)
            % x                     : Scalar or array input
            % yComplexityPrototype  : Complexity prototype to use for y

            % coder.inline('always')
            if(~isreal(yComplexityPrototype) && isreal(x))
                y = complex(x); % zero for imag part
            elseif(isreal(yComplexityPrototype) && ~isreal(x))
                y = real(x);    % zero-ing imag part
            else
                % x and y complexities match
                y = x;
            end
        end
        
        function proto = getNumericPrototype(value)
            % Check that value is either numeric or cell array of numeric
            % values
            if(iscell(value) && all(cellfun(@isnumeric, value)))
                vreal = all(cellfun(@isreal, value));
                vclass = class(value{1});
            elseif(isnumeric(value))
                vreal = isreal(value);
                vclass = class(value);
            else
                % If none of the above, return empty value for prototype
                proto = [];
                return
            end
            
            xp = ones(1, vclass);

            if(vreal)
                proto = xp;
            else
                proto = complex(xp);
            end
        end

        % Validation utilities for cell-array data containers
        
        function C = validateAndWrapSectionIfNumeric(coe)
            if(isnumeric(coe) && (isvector(coe) || isempty(coe)))
                % Wrap with cell and ensure inner shape is row
                C = {reshape(coe,1,[])};
            elseif(iscell(coe))
                % Pass input
                C = coe;
            else
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:coeOnlyNumvectorOrCellarray'])
            end
        end   
        
        function coeCell = validateCascadeCellArray(coeCell)
            % Cell array itself must be a vector
            if ~isvector(coeCell)
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:cascadedParamsCellVector'])
            end
            
            % If provided as row cell array, turn into a column
            if(~isscalar(coeCell) && isrow(coeCell))
                coeCell = reshape(coeCell, [], 1);
            end
            
            % All numeric inner cell content must be numeric and it must 
            % share the same data type, either double or single
            alldouble = all(cellfun(@(x) isa(x, 'double'), coeCell));
            allsingle = all(cellfun(@(x) isa(x, 'single'), coeCell));
            if(~alldouble && ~allsingle)
                coder.internal.errorIf(true, ['dsp:system',...
                    ':AllpassFilter:sectionParamsSingleDouble'])
            end
            
        end
        
        function C = checkInnerCoeOrderAndComplexity(C, coeStructFlag)
            % Note - coeStructFlag = ...
            % 1 - destination is AllpassCoefficients
            % 2 - destination is WDFCoefficients
            % 3 - destination is LatticeCoefficients
            
            % Checked/adjusted previously
            assert(iscolumn(C))
            
            % Ensure inner orientations are all rows
            numSections = size(C, 1);
            orders = zeros(numSections, 1);
            for k = 1:numSections
                isCellEmpty = any(size(C{k}) == 0);
                if(~isCellEmpty && isvector(C{k}))
                    if(~isrow(C{k}))
                        C{k} = C{k}.';
                    end
                elseif(~isCellEmpty && ~isvector(C{k}))
                    coder.internal.errorIf(true, ['dsp:system',...
                        ':AllpassFilter:cascadedCoeOneRowPerSection'])
                end
                orders(k) = size(C{k}, 2);
            end
            
            % If structure is minimum multiplier or WDF, ensure
            % coefficients are real
            if(any(coeStructFlag == [1, 2]))
                areCoeReal = all(cellfun(@isreal, C));
                if(~areCoeReal)
                    coder.internal.errorIf(true, ['dsp:system',...
                        ':AllpassFilter:onlyRealCoeffs'])
                end
            end
            
            % If structure is WDF
            % - Ensure that the order of each section is 
            %   1, 2, or 4 (if 4 then with 1st and 3rd coefficient == 0)
            % - Ensure that magnitude of coefficients is <= 1
            if(coeStructFlag == 2)
                if(any(orders > 4) || any(orders == 3))
                    coder.internal.errorIf(true, ['dsp:system',...
                        ':AllpassFilter:wdfSectionOrdersOnly124wdf'])
                end
                for k = 1:length(orders)
                    if(orders(k) == 4)
                        if(any(C{k}([2,4]) ~= 0))
                            coder.internal.errorIf(true, ['dsp:system',...
                                ':AllpassFilter',...
                                ':wdfSectionOrdersOnly124wdf'])
                        end
                    end
                    % Checking inner WDF coefficients values are not bigger
                    % than 1 in absolute value
                    if(any(abs(C{k}) > 1))
                        coder.internal.errorIf(true, ['dsp:system',...
                            ':AllpassFilter:wdfCoeBiggerThanOne'])
                    end
                end
                
            end
            
        end
        
        % Conversion utilities for cell-array data containers 
        
        function [A, orders] = coeCellToZeroPaddedArray(C)

            orders = cellfun(@(x) size(x,2), C);

            maxorder = max(orders);
            numsections = length(orders);
            A=dsp.AllpassFilter.array(0,[numsections,maxorder],C{1},C{1});
            for k = 1:numsections
                A(k, 1:orders(k)) = C{k}(1:orders(k));
            end
        end        

        function icPad = icCellToZeroPaddedArray(icCell, doubledStatesFlag)

            assert(iscolumn(icCell))
            
            icDepths = cellfun(@(x) size(x,1), icCell);
            nCols = size(icCell{1}, 2);
            numSections = size(icCell, 1);

            % Zero-pad internal cell content to get uniform size across 
            % cells
            
            % Preallocate numerical array
            if(doubledStatesFlag)
                orders = icDepths/2;
            else
                orders = icDepths;
            end
            maxDepth = max(icDepths);
            maxOrder = max(orders);
            icPad = zeros(maxDepth, nCols, numSections);
            
            % Loop across sections and pad
            for kSt = 1:length(orders)
                icPad(1:orders(kSt),:,kSt) = icCell{kSt}(1:orders(kSt),:);
                if(doubledStatesFlag)
                    icPad(maxOrder + (1:orders(kSt)), :, kSt) = ...
                        icCell{kSt}(orders(kSt)+1:2*orders(kSt), :);
                end
            end

        end
        
    end
    
    methods(Hidden)
        function restrictionsCell = getFixedPointRestrictions(~,~)
            restrictionsCell = {};
        end
        function props = getFixedPointProperties(~)
            props = {};
        end
        function props = getNonFixedPointProperties(~)
            props = {...
                'Structure',...
                'AllpassCoefficients',...
                'WDFCoefficients', ...
                'LatticeCoefficients', ...
                'InitialConditions'};
        end
        function flag = isPropertyActive(obj,prop)
            flag = ~isInactivePropertyImpl(obj, prop);      
        end
        
        function setActiveCoefficients(obj, coe)
            switch obj.Structure
                case 'Minimum multiplier',
                        obj.AllpassCoefficients = coe;
                case 'Wave Digital Filter',
                        obj.WDFCoefficients = coe;
                case 'Lattice',
                        obj.LatticeCoefficients = coe;
                otherwise
                    assert(false)
            end

        end
        function coe = getActiveCoefficients(obj)
            switch obj.Structure
                case 'Minimum multiplier',
                        coe = obj.AllpassCoefficients;
                case 'Wave Digital Filter',
                        coe = obj.WDFCoefficients;
                case 'Lattice',
                        coe = obj.LatticeCoefficients;
                otherwise
                    assert(false)
            end

        end
    end
    
end
