function varargout = dspblkupfir2(blkh,action,FilterSource,varargin)
% DSPBLKUPFIR Mask dynamic dialog function for FIR interpolation block

% Copyright 1995-2011 The MathWorks, Inc.

switch action
  case 'icon'
    if FilterSource == 1
        % Coefficients from dialog parameters
        L = varargin{1};
        if isempty(L)  || ~isnumeric(L) || ~isscalar(L) || isfi(L)
            str = 'x[?]';  % Default display
        else
            str= ['x[n/' num2str(L) ']'];
        end
    else
        % Coefficients from filter object
        hd = varargin{1};
        if (isempty(hd) || ~isa(hd,'mfilt.firinterp'))
            str = 'x[?]';  % Default display
        else
            str=['x[n/' num2str(hd.InterpolationFactor) ']'];
        end
        str = [str '\nMFILT:\n' get_param(blkh,'FilterObject')];
    end
    varargout{1} = str;
    
  case 'init'
    dspSetFrameUpgradeParameter(blkh,'InputProcessing', ...
        'Inherited (this choice will be removed - see release notes)', ...
        'framing', 'Maintain input frame size');
    
  case 'setup'      
    filterDefined = false; % default
    %hd = [];
    h  = [];
    L  = [];
    outBufIC = 0;
    block = get_param(blkh,'Object');
    if FilterSource == 1
        % Input arguments for setup case when coeffs from dialog params:
        % dspblkupfir2('setup',FilterSource,h,L,outputBufInitCond)
        if isfield(block.UserData,'filter')
            block.UserData = rmfield(block.UserData,'filter');
        end
        dtRows = varargin{1};
        h = varargin{2};
        L = varargin{3};
        outBufIC = varargin{4};        
        framing = varargin{5};
        
        %dtInfo = dspGetFixptDataTypeInfo(blkh,47);
        dtInfo = dspGetUDTFixptDataTypeInfo(blkh, dtRows, true); 
        dtInfo.arithmetic = 0; % Default: double-precision arithmetic
        dtInfo.inputWordLength = 16;
        dtInfo.inputFracLength = 15;
        
        if isempty(h) || isempty(L)
            % Don't attempt any calculations in the mask helper on these 
            % parameters if any of them is currently empty or not defined.
            args.CoeffSource = FilterSource;
            args.h = h;
            args.L = L;
            args.outBufIC = outBufIC;
            varargout = {args,dtInfo};           
            return;
        end       
        % Do more checking before using h,L,outBufIC parameters
        if ~isnumeric(h) || isfi(h)
            error(message('dsp:dspblkupfir2:invalidCoefficient1'));
        end        
        if isfi(outBufIC) || ischar(outBufIC)
            error(message('dsp:dspblkupfir2:paramDTypeError1'));
        end
        if ~isnumeric(L) || isfi(L)            
            error(message('dsp:dspblkupfir2:paramDTypeError2'));            
        end
        if ~isreal(L) || ~ isscalar(L) || (L < 1) || (fix(L) ~= L)
            error(message('dsp:dspblkupfir2:paramRealScalarError'));
        end
                
        filterDefined = ~(isempty(h) || isempty(L));
        block.UserData.filterConstructor = 'mfilt.firinterp';
        if filterDefined
            block.UserData.filterConstructorArgs = {L,h};
        else
            block.UserData.filterConstructorArgs = [];
        end
        if ~isvector(h)
            error(message('dsp:dspblkupfir2:invalidCoefficient2'));
        end        
    else
        % Input arguments for setup case when coeffs from filter object:
        % dspblkupfir2('setup',FilterSource,FilterObject)
        if isfield(block.UserData,'filterConstructor')
            block.UserData = rmfield(block.UserData,'filterConstructor');
            block.UserData = rmfield(block.UserData,'filterConstructorArgs');
        end
        hd = varargin{1};
        framing = varargin{2};
        block.UserData.filter = [];
        if ~isempty(hd)
            if isa(hd,'mfilt.firinterp')
                block.UserData.filter = hd;
                hdx = reffilter(hd); % Get the reference coeffs, not the quantized ones
                h = hdx.Numerator;
                L = hdx.InterpolationFactor;
                filterDefined = true;
            else
                error(message('dsp:dspblkupfir2:invalidFilterObject'));
            end
        end
        dtInfo = getFixptDataTypeInfoFromFilterObject(hd);
    end

    if filterDefined
        % Update FVTool plot window, if open
        if dspIsFVToolOpen(blkh)
            dspLinkFVTool2Mask(blkh,'update');
        end

        % Need to reshuffle the coefficients into phase order        
        len = length(h);       
        if (rem(len, L) ~= 0)
            nzeros = L - rem(len, L);
            h = [h(:); zeros(nzeros,1)];
        end
        len = length(h);
        nrows = len / L;
        % Re-arrange the coefficient
        h = reshape(h, L, nrows).';       

        %Scale the initial conditions by 1/L
        %This is put in to maintain backward compatibility        
        outBufIC = outBufIC ./L;
    end

    % Gather up outputs
    args.CoeffSource = FilterSource;
    args.h = h;
    args.L = L;
    args.outBufIC = outBufIC;

    % Maintain input frame size(3) maps to Allow multi-rate(2)
    % Maintain input frame rate(4) maps to Enforce single-rate(1)
    if framing == 3
        framing = 2;
    elseif framing == 4
        framing = 1;
    end

    varargout = {args,dtInfo, framing};

    otherwise
    error(message('dsp:dspblkupfir2:unhandledCase'));
end

%------------------------------------------------------------------------------
function dtInfo = getFixptDataTypeInfoFromFilterObject(hd)
  % Initialize all to defaults
  dtInfo.arithmetic = 0; % Default: double-precision arithmetic
  dtInfo.inputWordLength  = 16;
  dtInfo.inputFracLength  = 15;
  dtInfo.firstCoeffMode = 2; % Default: same word length as input
  dtInfo.firstCoeffWordLength = 16;
  dtInfo.firstCoeffFracLength = 15;
  dtInfo.prodOutputMode = 2; % Default: same as input
  dtInfo.prodOutputWordLength = 32;
  dtInfo.prodOutputFracLength = 30;
  dtInfo.accumMode = 3; % Default: same as product output
  dtInfo.accumWordLength = 32;
  dtInfo.accumFracLength = 30;
  dtInfo.outputMode = 4; % Default: same as accumulator
  dtInfo.outputWordLength = 16;
  dtInfo.outputFracLength = 15;
  dtInfo.overflowMode = 1;
  dtInfo.roundingMode = 3; % floor

  if ~isempty(hd) && isfdtbxinstalled
      switch hd.arithmetic
        case 'double'
          dtInfo.arithmetic = 0;
        case 'single'
          dtInfo.arithmetic = 1;
        case 'fixed'
          dtInfo.arithmetic = 2;

          if strcmpi(hd.OverflowMode, 'wrap')
              dtInfo.overflowMode = 1;
          else
              dtInfo.overflowMode = 2;
          end

          if strcmpi(hd.RoundMode, 'ceil')
              dtInfo.roundingMode = 1;
          elseif strcmpi(hd.RoundMode, 'convergent')
              dtInfo.roundingMode = 2;
          elseif strcmpi(hd.RoundMode, 'floor')
                dtInfo.roundingMode = 3;
          elseif strcmpi(hd.RoundMode, 'nearest')
              dtInfo.roundingMode = 4;
          elseif strcmpi(hd.RoundMode, 'round')
              dtInfo.roundingMode = 5;  
          elseif strcmpi(hd.RoundMode, 'fix')
              dtInfo.roundingMode = 7;    %zero
          end

          if ~hd.Signed
              error(message('dsp:dspblkupfir2:invalidCoefficient3'));
          end

          if isprop(hd,'CastBeforeSum') && ~hd.CastBeforeSum
              warning(message('dsp:dspblkupfir2:invalidFilterObject1'));
          end

          dtInfo.inputWordLength  = hd.InputWordLength;
          dtInfo.inputFracLength  = hd.InputFracLength;

          dtInfo.firstCoeffMode = 0; % Binary point scaling
          dtInfo.firstCoeffWordLength = hd.CoeffWordLength;
          dtInfo.firstCoeffFracLength = hd.NumFracLength;

          dtInfo.prodOutputMode = 0; % Binary point scaling
          dtInfo.prodOutputWordLength = hd.ProductWordLength;
          dtInfo.prodOutputFracLength = hd.ProductFracLength;

          dtInfo.accumMode = 0; % Binary point scaling
          dtInfo.accumWordLength = hd.AccumWordLength;
          dtInfo.accumFracLength = hd.AccumFracLength;

          dtInfo.outputMode = 0; % Binary point scaling
          dtInfo.outputWordLength = hd.OutputWordLength;
          dtInfo.outputFracLength = hd.OutputFracLength;

        otherwise
          error(message('dsp:dspblkupfir2:invalidFilterObject2', hd.arithmetic));         
      end
  end

% end of dspblkupfir.m
