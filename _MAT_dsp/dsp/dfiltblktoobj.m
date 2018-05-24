function hd = dfiltblktoobj(blockName, varargin)
% DFILTBLKTOOBJ Function to extract filter information
%   from a Digital Filter block and return it as a dfilt object.
%
% Calling options:
%   dfiltblktoobj(blockName, [options]);
%
%   [options] can be any of the following property-value pairs:
%
%      'mapstates' :  true or false
%     'arithmetic' :  'double' or 'single' or 'fixed'
%    'inputformat' :  [inputWL inputFL]
%
%   -blockName: name or handle of a Digital Filter block in a Simulink model
%
%   -mapstates: true or false
%     - If left unspecified, the function ignores initial conditions (leaves them
%       as zero and does not warn).
%
%     - If false [default], the function returns a DFILT with the
%       PersistentMemory flag set to 'false'.  This means the DFILT
%       will assume zero initial states for every run.
%
%     - If true, the function returns a DFILT with its initial state values
%       filled in with the block's initial condition values.  The DFILT will
%       have the same information as in the 'analysis' mode, but the
%       PersistentMemory flag will be set to 'true'.  Outputs obtained from the
%       first run of input through the resulting DFILT object should match
%       outputs obtained from running the same input through the block.
%       Outputs from subsequent runs of input through the DFILT will vary
%       because the DFILT will preserve the final states from the previous
%       run as the initial states in the next run in persistent memory.
%
%  -arithmetic: 'double' [default], or 'single', or 'fixed'
%       - The 'arithmetic' mode of the created DFILT.
%       - In 'double' or 'single' mode, no fixed-point info will
%         be filled in.
%       - In 'fixed' mode, the DFILT will be created with fixed-point
%         info from the block.  Since some of this info may require
%         knowledge of the input signal word- and fraction-lengths,
%         those parameters are required inputs to this function in
%         'fixed' mode.
%
%  -inputformat: A two-element vector that specifies the input wordlength
%         and input fraction length for the created DFILT.  The default
%         is [16 15].
%
%  Examples:
%
%  1. To get a dfilt object for floating-point analysis/implementation:
%
%     >> hd = dfiltblktoobj(blockName);
%
%     [OR, if the block has non-zero ICs:]
%
%     >> hd = dfiltblktoobj(blockName,'mapstates',true);
%
%  2. To get a dfilt object for fixed-point implementation with an input
%     signal that has 16 bit word length with 10 bits of precision:
%
%     >> hd = dfiltblktoobj(blockName,'arithmetic','fixed', ...
%                           'inputformat',[16 10]);
%
%     [OR, if the block has non-zero ICs:]
%
%     >> hd = dfiltblktoobj(blockName,'arithmetic','fixed', ...
%                           'inputformat',[16 10], ...
%                           'mapstates',true);
%

% Developers' note: This function throws errors/warnings with message IDs
% of the form 'dspblks:dfiltblktoobj:<Mnemonic>'.  This is done in the
% calls to the signal/sigtools function generatemsgid() below.  If your
% function calls dfiltblktoobj, please use the corresponding mnemonics below
% to catch and rethrow relevant error/warning strings.

% Copyright 2005-2011 The MathWorks, Inc.

    propvalcell = {};
    props = {'mapstates','arithmetic','inputformat'};

    % Obtain a cell-array of property values from inputArgs
    for n = 1:2:length(varargin)
        property = varargin{n};
        value = varargin{n+1};
        if ~isempty(property),
            proppos = strmatch(lower(property),props);
            if ~isempty(proppos),
                propvalcell = {propvalcell{:},property,value};
            end
        end
    end

    defaultOptions.mapstates   = []; %% If unspecified, don't even bother with initial conditions.
    defaultOptions.arithmetic  = 'double';
    defaultOptions.inputformat = [16 15];

    options = setstructfields(defaultOptions,struct(propvalcell{:}));

    if ~isempty(options.mapstates)
        %% Caller specified a value for 'mapstates', make sure the value
        %% is a boolean (logical) entity:
        if ~islogical(options.mapstates)
            error(message('dsp:dfiltblktoobj:InvalidMapstates'));
        end
    end

    options.arithmetic = lower(options.arithmetic);
    if strncmp(options.arithmetic,'double',6)
        options.nonDoubleMode = false;
        options.fixedMode     = false;
    elseif strncmp(options.arithmetic,'single',6)
        options.nonDoubleMode = true;
        options.fixedMode     = false;
    elseif strncmp(options.arithmetic,'fixed',5)
        options.nonDoubleMode = true;
        options.fixedMode     = true;
        if ~isfixptinstalled 
            error(message('dsp:dfiltblktoobj:FixptRequired'));
        end
    else
        error(message('dsp:dfiltblktoobj:InvalidArithmetic'));
    end

    if ~isnumeric(options.inputformat) || ~isvector(options.inputformat) || ...
            (length(options.inputformat) ~= 2)
        error(message('dsp:dfiltblktoobj:InvalidInputFormat'));
    end

    options.inputformat = double(options.inputformat);

    block = get_param(blockName,'Object');

    if ~isa(block,'Simulink.SFunction')
        error(message('dsp:dfiltblktoobj:InvalidBlock'));
    end

    switch block.FilterSource
      case 'Specify via dialog'
        hd = getDFILTFromBlockInfo(block,options);
      case 'dfilt object'
        hd = getDFILTFromReferencedDFILT(block,options);
      case 'Input port(s)'
        error(message('dsp:dfiltblktoobj:InvalidBlock1'));
    end

%----
function hd = getDFILTFromBlockInfo(block,options)
    arithmetic    = options.arithmetic;
    mapstates     = options.mapstates;
    fixedMode     = options.fixedMode;
    nonDoubleMode = options.nonDoubleMode;
    inputformat   = options.inputformat;

    filterConstructor = '';
    filterConstructorArgs = [];
    if isfield(block.UserData,'filterConstructor')
        filterConstructor = block.UserData.filterConstructor;
        filterConstructorArgs = block.UserData.filterConstructorArgs;
    end
    argsAreEmpty = 0;
    if (isempty(filterConstructor) || ...
        isempty(filterConstructorArgs) || ...
        ~iscell(filterConstructorArgs))
        argsAreEmpty = 1;
    else
        for i = 1:length(filterConstructorArgs)
            if isempty(filterConstructorArgs{i})
                argsAreEmpty = 1;
            end
        end
    end

    if argsAreEmpty
        error(message('dsp:dfiltblktoobj:UninitializedModel'));
    end

    hd = feval(filterConstructor,...
               filterConstructorArgs{:});

    if fixedMode
        inputWordLength = inputformat(1);
        inputFracLength = inputformat(2);
        if (strncmpi(block.RoundingMode,'ceiling',7))
            roundMode = 'ceil';
        elseif (strncmpi(block.RoundingMode,'convergent',10))
            roundMode = 'convergent';
        elseif (strncmpi(block.RoundingMode,'floor',5))
            roundMode = 'floor';
        elseif (strncmpi(block.RoundingMode,'nearest',7))                     
              roundMode = 'nearest';
        elseif (strncmpi(block.RoundingMode,'round',5))
              roundMode = 'round';                          
        elseif (strncmpi(block.RoundingMode,'simplest',8))
            roundMode = 'floor';
        else
            roundMode = 'fix'; %block: zero ==> obj: fix
        end
        if (strncmpi(block.OverflowMode,'off',3))
            overflowMode = 'wrap';
        else
            overflowMode = 'saturate';
        end
    end

    switch block.TypePopup
      case 'IIR (poles & zeros)'
        switch block.IIRFiltStruct
          case 'Direct form I'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getOutputInfo(hd,block);

                end
            end
            %% END IIR DIRECT FORM I

          case 'Direct form I transposed'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.OutputMode      = 'SpecifyPrecision';
                    hd.StateAutoScale  = false;
                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                    hd = getMultiplicandInfo(hd,block);

                end
            end
            %% END IIR DIRECT FORM I TRANSPOSED

          case 'Direct form II'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.OutputMode      = 'SpecifyPrecision';
                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end
            %% END IIR DIRECT FORM II

          case 'Direct form II transposed'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.StateAutoScale  = false;
                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end
            %% END IIR DIRECT FORM II TRANSPOSED

          case 'Biquad direct form I (SOS)'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.OutputMode      = 'SpecifyPrecision';
                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getSOSSectionInfo(hd,block);
                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end
            %% END SOS DIRECT FORM I

          case 'Biquad direct form I transposed (SOS)'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.SectionInputAutoScale  = false;
                    hd.SectionOutputAutoScale = false;
                    hd.StateAutoScale         = false;
                    hd.OutputMode             = 'SpecifyPrecision';
                    hd.ProductMode            = 'SpecifyPrecision';
                    hd.AccumMode              = 'SpecifyPrecision';

                    hd = getSOSSectionInfo(hd,block);
                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                    hd = getMultiplicandInfo(hd,block);

                end
            end
            %% END SOS DIRECT FORM I TRANSPOSED

          case 'Biquad direct form II (SOS)'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.SectionInputAutoScale  = false;
                    hd.SectionOutputAutoScale = false;
                    hd.OutputMode             = 'SpecifyPrecision';
                    hd.ProductMode            = 'SpecifyPrecision';
                    hd.AccumMode              = 'SpecifyPrecision';

                    hd = getSOSSectionInfo(hd,block);
                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end
            %% END SOS DIRECT FORM II

          case 'Biquad direct form II transposed (SOS)'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.StateAutoScale         = false;
                    hd.OutputMode             = 'SpecifyPrecision';
                    hd.ProductMode            = 'SpecifyPrecision';
                    hd.AccumMode              = 'SpecifyPrecision';

                    hd = getSOSSectionInfo(hd,block);
                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end
            %% END SOS DIRECT FORM II TRANSPOSED

          otherwise
            error(message('dsp:dfiltblktoobj:InvalidStructure', block.Name));
        end

      case 'IIR (all poles)'
        switch block.AllPoleFiltStruct
          case 'Direct form'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    error(message('dsp:dfiltblktoobj:AllPoleFixptMismatch', block.Name));
                end
            end

          case 'Direct form transposed'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    error(message('dsp:dfiltblktoobj:AllPoleFixptMismatch1', block.Name));
                end
            end

          case 'Lattice AR'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.OutputMode      = 'SpecifyPrecision';
                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end

          otherwise
            error(message('dsp:dfiltblktoobj:InvalidStructure', block.Name));
        end

      case 'FIR (all zeros)'
        switch block.FIRFiltStruct
          case 'Direct form'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.FilterInternals = 'SpecifyPrecision';
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end

          case 'Direct form symmetric'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.FilterInternals = 'SpecifyPrecision';
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end

          case 'Direct form antisymmetric'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.FilterInternals = 'SpecifyPrecision';
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end

          case 'Direct form transposed'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.FilterInternals = 'SpecifyPrecision';
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getOutputInfo(hd,block);

                    if ~strncmpi(block.memoryMode,'Same as accumulator',19)
                        warning(message('dsp:dfiltblktoobj:FIRStateMismatch', block.Name, block.memoryMode));
                    end
                end
            end

          case 'Lattice MA'
            if nonDoubleMode
                hd.arithmetic = arithmetic;
                if fixedMode
                    hd.CoeffAutoScale  = false;
                    hd.RoundMode       = roundMode;
                    hd.OverflowMode    = overflowMode;
                    hd.InputWordLength = inputWordLength;
                    hd.InputFracLength = inputFracLength;

                    hd.OutputMode      = 'SpecifyPrecision';
                    hd.ProductMode     = 'SpecifyPrecision';
                    hd.AccumMode       = 'SpecifyPrecision';

                    hd = getCoeffInfo(hd,block);
                    hd = getProdInfo(hd,block);
                    hd = getAccumInfo(hd,block);
                    hd = getStateInfo(hd,block);
                    hd = getOutputInfo(hd,block);
                end
            end

          otherwise
            error(message('dsp:dfiltblktoobj:InvalidStructure.', block.Name));
        end

      otherwise
        error(message('dsp:dfiltblktoobj:InvalidType', block.Name));
    end


    if isfield(block.UserData,'ICData')
        ICData = block.UserData.ICData;
    end
    %% Can't use strncmpi for Direct form I since Direct form II also matches
    if (strncmpi(block.TypePopup,'IIR (poles & zeros)', 19) && ...
        (strcmpi(block.IIRFiltStruct,'Direct form I')                    || ...
         strncmpi(block.IIRFiltStruct,'Direct form I transposed', 24)    || ...
         strncmpi(block.IIRFiltStruct,'Biquad direct form I (SOS)', 26)  || ...
         strncmpi(block.IIRFiltStruct, ...
                  'Biquad direct form I transposed (SOS)', 37)))
        states = filtstates.dfiir;
        states.Numerator   = ICData.ICnum;
        states.Denominator = ICData.ICden;
        nonZeroICs = (any(states.Numerator(:)) || any(states.Denominator(:)));
    else
        states = ICData.IC;
        nonZeroICs = any(states(:));
    end
    if ~isempty(mapstates)
        if (mapstates)
            hd.PersistentMemory = true;
            hd.States = states;
        else
            % Mapstates is 'false'.  If block has non-zero ICs, warn that they are
            % ignored.
            if nonZeroICs
                warning(message('dsp:dfiltblktoobj:NonZeroICsIgnored', block.Name));
            end
        end
    end

%-----
function hd = getDFILTFromReferencedDFILT(block,options)
    %% DFILT mode
    dfiltName = block.dfiltObjectName;
    if ~isempty(dfiltName)
        ud = block.UserData;
        if isfield(ud,'filter');
            hd = copy(ud.filter);
            if isfdtbxinstalled
                dfiltArithmetic = lower(hd.arithmetic);
            else
                dfiltArithmetic = 'double';
            end
        else
            error(message('dsp:dfiltblktoobj:undefinedDFILT', dfiltName));
        end
    else
        error(message('dsp:dfiltblktoobj:emptyDFILT'));
    end

    if ~isempty(options.mapstates)
        if options.mapstates
            hd.PersistentMemory = true;
        end
    end

    if ~strcmp(dfiltArithmetic,options.arithmetic)
        %% Arithmetic mismatch, need to resolve
        if (strcmp(options.arithmetic,'double') || ...
            strcmp(options.arithmetic,'single'))
            %% If requested arithmetic is double or single, simply set hd.arithmetic
            hd.arithmetic = options.arithmetic;
        else
            %% Requested arithmetic is 'fixed', and hd is either double or single
            hd.arithmetic = 'fixed';
            hd.InputWordLength = options.inputformat(1);
            hd.InputFracLength = options.inputformat(2);
            hd.specifyall;

            hd.RoundMode = 'floor';
            hd.OverflowMode = 'wrap';

            %% Coeffs defaults: same word length as input
            hd.CoeffWordLength = hd.InputWordLength;
            hd.CoeffAutoScale  = true;

            %% Product output default: same as input
            hd.ProductWordLength = hd.InputWordLength;
            if isFilterIIR(hd)
                hd.NumProdFracLength = hd.InputFracLength;
                hd.DenProdFracLength = hd.NumProdFracLength;
            else
                hd.ProductFracLength = hd.InputFracLength;
            end

            %% Accumulator default: same as prod output = same as input
            hd.AccumWordLength = hd.InputWordLength;
            if isFilterIIR(hd)
                hd.NumAccumFracLength = hd.InputFracLength;
                hd.DenAccumFracLength = hd.NumAccumFracLength;
            else
                hd.AccumFracLength = hd.InputFracLength;
            end

            %% Output row: same as accumulator = same as prod = same as input
            hd.OutputWordLength = hd.InputWordLength;
            hd.OutputFracLength = hd.InputFracLength;

            switch class(hd)
              case 'dfilt.df1t'
                %% Multiplicand = same as output = same as input
                hd.MultiplicandWordLength = hd.InputWordLength;
                hd.MultiplicandFracLength = hd.InputFracLength;

                %% State = same as accum = same as input
                hd.StateWordLength    = hd.InputWordLength;
                hd.NumStateFracLength = hd.InputFracLength;
                hd.DenStateFracLength = hd.NumStateFracLength;

              case 'dfilt.df2'
                %% State = same as accum = same as input
                hd.StateWordLength = hd.InputWordLength;
                hd.StateFracLength = hd.InputFracLength;

              case 'dfilt.df2t'
                %% State = same as accum = same as input
                hd.StateWordLength = hd.InputWordLength;
                hd.StateFracLength = hd.InputFracLength;

              case 'dfilt.df1sos'
                %% Section input = same as input
                hd.NumStateWordLength = hd.InputWordLength;
                hd.NumStateFracLength = hd.InputFracLength;

                %% Section output = same as output = same as input
                hd.DenStateWordLength = hd.InputWordLength;
                hd.DenStateFracLength = hd.InputFracLength;

              case 'dfilt.df1tsos'
                %% Section input = same as input
                hd.SectionInputWordLength = hd.InputWordLength;
                hd.SectionInputFracLength = hd.InputFracLength;

                %% Section output = same as output = same as input
                hd.SectionOutputWordLength = hd.InputWordLength;
                hd.SectionOutputFracLength = hd.InputFracLength;

                %% State = same as accum = same as input
                hd.StateWordLength    = hd.InputWordLength;
                hd.NumStateFracLength = hd.InputFracLength;
                hd.DenStateFracLength = hd.NumStateFracLength;

                %% Multiplicand = same as output = same as input
                hd.MultiplicandWordLength = hd.InputWordLength;
                hd.MultiplicandFracLength = hd.InputFracLength;

              case 'dfilt.df2sos'
                %% Section input = same as input
                hd.SectionInputWordLength = hd.InputWordLength;
                hd.SectionInputFracLength = hd.InputFracLength;

                %% Section output = same as output = same as input
                hd.SectionOutputWordLength = hd.InputWordLength;
                hd.SectionOutputFracLength = hd.InputFracLength;

                %% State = same as accum = same as input
                hd.StateWordLength = hd.InputWordLength;
                hd.StateFracLength = hd.InputFracLength;

              case 'dfilt.df2tsos'
                %% Section input = same as input
                hd.SectionInputWordLength = hd.InputWordLength;
                hd.SectionInputFracLength = hd.InputFracLength;

                %% Section output = same as output = same as input
                hd.SectionOutputWordLength = hd.InputWordLength;
                hd.SectionOutputFracLength = hd.InputFracLength;

                %% State = same as accum = same as input
                hd.StateWordLength = hd.InputWordLength;
                hd.StateFracLength = hd.InputFracLength;

              case 'dfilt.latticear'
                %% State = same as accum = same as input
                hd.StateWordLength = hd.InputWordLength;
                hd.StateFracLength = hd.InputFracLength;

              case 'dfilt.latticemamin'
                %% State = same as accum = same as input
                hd.StateWordLength = hd.InputWordLength;
                hd.StateFracLength = hd.InputFracLength;
            end
        end
    else
        if strcmp(dfiltArithmetic,'fixed')
            dfiltInputFormat = [hd.InputWordLength hd.InputFracLength];
            if ~isequal(dfiltInputFormat,options.inputformat)
                error(message('dsp:dfiltblktoobj:InputFormatMismatch', dfiltName, num2str( dfiltInputFormat( 1 ) ), num2str( dfiltInputFormat( 2 ) ), num2str( options.inputformat( 1 ) ), num2str( options.inputformat( 2 ) )));
            end
        end
    end

%-----
function isIIR = isFilterIIR(hd)
    isIIR = isFilterBasicIIR(hd) || isFilterSOS(hd);

%-----
function isBasicIIR = isFilterBasicIIR(hd)
    isBasicIIR = (isa(hd,'dfilt.df1')  || ...
                  isa(hd,'dfilt.df1t') || ...
                  isa(hd,'dfilt.df2')  || ...
                  isa(hd,'dfilt.df2t'));

%-----
function isSOS = isFilterSOS(hd)
    isSOS = (isa(hd,'dfilt.df1sos')  || ...
             isa(hd,'dfilt.df1tsos') || ...
             isa(hd,'dfilt.df2sos')  || ...
             isa(hd,'dfilt.df2tsos'));

%-----
function isFIR = isFilterFIR(hd)
    isFIR = (isa(hd,'dfilt.dffir')     || ...
             isa(hd,'dfilt.dffirt')    || ...
             isa(hd,'dfilt.dfsymfir')  || ...
             isa(hd,'dfilt.dfasymfir'));

%-----
function isLattice = isFilterLattice(hd)
    isLattice = (isa(hd,'dfilt.latticemamin') || ...
                 isa(hd,'dfilt.latticear'));

%-----
function isDF1orDF1T = isFilterDF1orDF1T(hd)
    isDF1orDF1T = (isa(hd,'dfilt.df1')     || ...
                   isa(hd,'dfilt.df1t')    || ...
                   isa(hd,'dfilt.df1sos')  || ...
                   isa(hd,'dfilt.df1tsos'));



%-----
function hd = getCoeffInfo(hd,block)

    switch block.firstCoeffMode
      case {'Same word length as input','Specify word length'}
        if strncmpi(block.firstCoeffMode,'Same word length as input',25)
            hd.CoeffWordLength = hd.InputWordLength;
        else
            hd.CoeffWordLength = evalin('base',block.firstCoeffWordLength);
        end
        fcArgs = block.UserData.filterConstructorArgs;
        if (isFilterFIR(hd) || isFilterBasicIIR(hd))
            if strncmpi(block.TypePopup,'IIR (all poles)', ...
                        length(block.TypePopup))
                hd.NumFracLength = hd.CoeffWordLength - 2;
            else
                hd.NumFracLength = getBestPrecFracLength( ...
                    fcArgs{1},hd.CoeffWordLength);
            end
        end
        if (isFilterBasicIIR(hd))
            hd.DenFracLength = getBestPrecFracLength( ...
                fcArgs{2}, hd.CoeffWordLength);
        end
        if (isFilterLattice(hd))
            hd.LatticeFracLength = getBestPrecFracLength( ...
                fcArgs{1}, hd.CoeffWordLength);
        end
        if (isFilterSOS(hd))
            sosMatrix = fcArgs{1};
            scaleValues = fcArgs{2};
            hd.NumFracLength = getBestPrecFracLength( ...
                sosMatrix(:,1:3),hd.CoeffWordLength);
            hd.DenFracLength = getBestPrecFracLength( ...
                sosMatrix(:,5:6),hd.CoeffWordLength);
            hd.ScaleValueFracLength = getBestPrecFracLength( ...
                scaleValues, hd.CoeffWordLength);
        end

      case {'Binary point scaling','Slope and bias scaling'}
        hd.CoeffWordLength = evalin('base',block.firstCoeffWordLength);
        if (isFilterFIR(hd) || isFilterIIR(hd))
            if strncmpi(block.TypePopup,'IIR (all poles)', ...
                        length(block.TypePopup))
                hd.NumFracLength = hd.CoeffWordLength - 2;
            else
                hd.NumFracLength = evalin('base',block.firstCoeffFracLength);
            end
        end
        if (isFilterIIR(hd))
            hd.DenFracLength = evalin('base',block.secondCoeffFracLength);
        end
        if (isFilterLattice(hd))
            hd.LatticeFracLength = evalin('base',block.firstCoeffFracLength);
        end
        if (isFilterSOS(hd))
            hd.ScaleValueFracLength = evalin('base', ...
                                             block.scaleValueFracLength);
        end

      otherwise
        error(message('dsp:dfiltblktoobj:InvalidCoeffMode', block.firstCoeffMode, block.Name));
    end % switch Coefficients

%-----
function hd = getProdInfo(hd,block)

    switch block.prodOutputMode
      case 'Same as input'
        hd.ProductWordLength = hd.InputWordLength;
        if isFilterIIR(hd)
            hd.NumProdFracLength = hd.InputFracLength;
            hd.DenProdFracLength = hd.NumProdFracLength;
        else
            hd.ProductFracLength = hd.InputFracLength;
        end
      case {'Binary point scaling','Slope and bias scaling'}
        hd.ProductWordLength = evalin('base',block.prodOutputWordLength);
        if isFilterIIR(hd)
            hd.NumProdFracLength = evalin('base',block.prodOutputFracLength);
            hd.DenProdFracLength = hd.NumProdFracLength;
        else
            hd.ProductFracLength = evalin('base',block.prodOutputFracLength);
        end
      otherwise
        error(message('dsp:dfiltblktoobj:InvalidProdOutputMode', block.productOutputMode, block.Name));
    end % switch Product output

%-----
function hd = getAccumInfo(hd,block)

    switch block.accumMode
      case 'Same as input'
        hd.AccumWordLength    = hd.InputWordLength;
        if isFilterIIR(hd)
            hd.NumAccumFracLength = hd.InputFracLength;
            hd.DenAccumFracLength = hd.NumAccumFracLength;
        else
            hd.AccumFracLength = hd.InputFracLength;
        end
      case 'Same as product output'
        hd.AccumWordLength    = hd.ProductWordLength;
        if isFilterIIR(hd)
            hd.NumAccumFracLength = hd.NumProdFracLength;
            hd.DenAccumFracLength = hd.DenProdFracLength;
        else
            hd.AccumFracLength = hd.ProductFracLength;
        end
      case {'Binary point scaling','Slope and bias scaling'}
        hd.AccumWordLength    = evalin('base',block.accumWordLength);
        if isFilterIIR(hd)
            hd.NumAccumFracLength = evalin('base',block.accumFracLength);
            hd.DenAccumFracLength = hd.NumAccumFracLength;
        else
            hd.AccumFracLength = evalin('base',block.accumFracLength);
        end
      otherwise
        error(message('dsp:dfiltblktoobj:InvalidAccumMode', block.accumMode, block.Name));
    end % switch Accumulator

%-----
function hd = getStateInfo(hd,block)

    switch block.memoryMode
      case 'Same as input'
        hd.StateWordLength = hd.InputWordLength;
        if isFilterDF1orDF1T(hd)
            hd.NumStateFracLength = hd.InputFracLength;
            hd.DenStateFracLength = hd.NumStateFracLength;
        else
            hd.StateFracLength = hd.InputFracLength;
        end
      case 'Same as accumulator'
        hd.StateWordLength = hd.AccumWordLength;
        if isFilterDF1orDF1T(hd)
            hd.NumStateFracLength = hd.NumAccumFracLength;
            hd.DenStateFracLength = hd.DenAccumFracLength;
        else
            if isFilterIIR(hd)
                hd.StateFracLength = hd.NumAccumFracLength;
            else
                hd.StateFracLength = hd.AccumFracLength;
            end
        end
      case {'Binary point scaling','Slope and bias scaling'}
        hd.StateWordLength = evalin('base',block.memoryWordLength);
        if isFilterDF1orDF1T(hd)
            hd.NumStateFracLength = evalin('base',block.memoryFracLength);
            hd.DenStateFracLength = hd.NumStateFracLength;
        else
            hd.StateFracLength = evalin('base',block.memoryFracLength);
        end
      otherwise
        error(message('dsp:dfiltblktoobj:InvalidStateMode', block.memoryMode, block.Name));
    end

%-----
function hd = getOutputInfo(hd,block)

    switch block.outputMode
      case 'Same as input'
        hd.OutputWordLength = hd.InputWordLength;
        hd.OutputFracLength = hd.InputFracLength;
      case 'Same as accumulator'
        hd.OutputWordLength = hd.AccumWordLength;
        if isFilterIIR(hd)
            hd.OutputFracLength = hd.NumAccumFracLength;
            if (strcmp(class(hd),'dfilt.df1') || ...
                strcmp(class(hd),'dfilt.df1sos'))
                hd.OutputFracLength = hd.DenAccumFracLength;
            end
        else
            hd.OutputFracLength = hd.AccumFracLength;
        end
      case {'Binary point scaling','Slope and bias scaling'}
        hd.OutputWordLength = evalin('base',block.outputWordLength);
        hd.OutputFracLength = evalin('base',block.outputFracLength);
      otherwise
        error(message('dsp:dfiltblktoobj:InvalidOutputMode', block.outputMode, block.Name));
    end % switch Output

%-----
function hd = getSOSSectionInfo(hd,block)

    switch block.stageIOMode
      case 'Same as input'
        if isa(hd,'dfilt.df1sos')
            hd.NumStateWordLength = hd.InputWordLength;
            hd.NumStateFracLength = hd.InputFracLength;

            hd.DenStateWordLength = hd.InputWordLength;
            hd.DenStateFracLength = hd.InputFracLength;
        else
            hd.SectionInputWordLength = hd.InputWordLength;
            hd.SectionInputFracLength = hd.InputFracLength;

            hd.SectionOutputWordLength = hd.InputWordLength;
            hd.SectionOutputFracLength = hd.InputFracLength;
        end

      case {'Binary point scaling','Slope and bias scaling'}
        if isa(hd,'dfilt.df1sos')
            hd.NumStateWordLength = evalin('base',block.stageIOWordLength);
            hd.NumStateFracLength = evalin('base',block.stageInFracLength);

            hd.DenStateWordLength = hd.NumStateWordLength;
            hd.DenStateFracLength = evalin('base',block.stageOutFracLength);
        else
            hd.SectionInputWordLength = evalin('base',block.stageIOWordLength);
            hd.SectionInputFracLength = evalin('base',block.stageInFracLength);

            hd.SectionOutputWordLength = hd.SectionInputWordLength;
            hd.SectionOutputFracLength = evalin('base', ...
                                                block.stageOutFracLength);
        end

      otherwise
        error(message('dsp:dfiltblktoobj:InvalidOutputMode', block.outputMode, block.Name));
    end % switch stageIO

%-----
function hd = getMultiplicandInfo(hd,block)

    switch block.multiplicandMode
      case 'Same as output'
        hd.MultiplicandWordLength = hd.OutputWordLength;
        hd.MultiplicandFracLength = hd.OutputFracLength;

      case {'Binary point scaling','Slope and bias scaling'}
        hd.MultiplicandWordLength = evalin('base',block.multiplicandWordLength);
        hd.MultiplicandFracLength = evalin('base',block.multiplicandFracLength);

      otherwise
        error(message('dsp:dfiltblktoobj:InvalidMultiplicandMode', block.multiplicandMode, block.Name));
    end % switch multiplicandMode


%-----
function fracLength = getBestPrecFracLength(values,wordLength)
%
% Given a matrix of double-precision floating-point values,
% compute best precision fraction length.

    fracLength = 0;
    if ~isempty(values)
        valuesCol = double(values(:));
        if isreal(values)
            minVal = min(valuesCol); % note: may be pos or neg
            maxVal = max(valuesCol); % note: may be pos or neg
        else
            realValues = real(valuesCol);
            imagValues = imag(valuesCol);

            % note: min vals may be pos or neg
            realMinVal = min(realValues);
            imagMinVal = min(imagValues);
            minVal     = min([realMinVal; imagMinVal]);

            % note: max vals may be pos or neg
            realMaxVal = max(realValues);
            imagMaxVal = max(imagValues);
            maxVal = max([realMaxVal; imagMaxVal]);
        end

        % If there is a tie, use the (potentially) positive value
        % (in the 'else' case below).  Otherwise use the minVal.
        if abs(minVal) > abs(maxVal)
            valueToUse = minVal;
        else
            valueToUse = maxVal;
        end

        % fixptbestexp computes pow2 exponent (negate for frac length)
        fracLength = -fixptbestexp(valueToUse,double(wordLength),1.0);
    end
