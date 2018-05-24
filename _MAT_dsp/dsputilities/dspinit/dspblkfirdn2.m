function varargout = dspblkfirdn2(blkh,action,FilterSource,varargin)
% DSPBLKFIRDN Mask dynamic dialog function for FIR decimation block

% Copyright 1995-2011 The MathWorks, Inc.

switch action
  case 'icon'
    if FilterSource == 1
        % Coefficients from dialog parameters
        D = varargin{1};
        if isempty(D)  || ~isnumeric(D) || ~isscalar(D) || isfi(D)        
            str = 'x[?]';  % Default display
        else
            str=['x[' num2str(D) 'n]'];
        end
    else
        % Coefficients from filter object
        hd = varargin{1};
        if (isempty(hd) || ~isFilterValid(hd))
            str = 'x[?]';  % Default display
        else
            str=['x[' num2str(hd.DecimationFactor) 'n]'];
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
    D  = [];
    outBufIC = 0;
    filtStruct = 1; % Direct form
    block = get_param(blkh,'Object');
    if FilterSource == 1
        % Coefficients from dialog parameters
        if isfield(block.UserData,'filter')
            block.UserData = rmfield(block.UserData,'filter');
        end
        dtRows = varargin{1};
        h = varargin{2};
        D = varargin{3};
        filtStruct = varargin{4};
        outBufIC = varargin{5};
        framing = varargin{6};
        
        %dtInfo = dspGetFixptDataTypeInfo(blkh,47);
        dtInfo = dspGetUDTFixptDataTypeInfo(blkh, dtRows, true); 
        dtInfo.arithmetic = 0; % Default: double-precision arithmetic
        dtInfo.inputWordLength = 16;
        dtInfo.inputFracLength = 15;
        
        if isempty(h) || isempty(D)
            % Don't attempt any calculations in the mask helper on these 
            % parameters if any of them is currently empty or not defined.            
            args.CoeffSource = FilterSource;
            args.h = h;
            args.D = D;
            args.filtStruct = filtStruct;
            args.outBufIC = outBufIC;
            varargout = {args,dtInfo};            
            return;
        else
            filterDefined = true;
        end        
        if filtStruct == 1
            block.UserData.filterConstructor = 'mfilt.firdecim';
        else
            block.UserData.filterConstructor = 'mfilt.firtdecim';
        end
        block.UserData.filterConstructorArgs = [];
        if filterDefined
            block.UserData.filterConstructorArgs = {D,h};
        end
        % Do more checking before using h,D parameters
        if ~isnumeric(h) || isfi(h)
            error(message('dsp:dspblkfirdn2:paramDTypeError1'));
        end        
        if ~isnumeric(D) || isfi(D)
            error(message('dsp:dspblkfirdn2:paramDTypeError2'));
        end       
        if ~isvector(h)
            error(message('dsp:dspblkfirdn2:invalidCoefficient'));            
        end
        if ((D < 1) || (fix(D) ~= D))
            error(message('dsp:dspblkfirdn2:paramRealScalarError'));
        end
    else
        % Coefficients from filter object
        hd = varargin{1};
        framing = varargin{2};
        
        if isfield(block.UserData,'filterConstructor')
            block.UserData = rmfield(block.UserData,'filterConstructor');
            block.UserData = rmfield(block.UserData,'filterConstructorArgs');
        end
        block.UserData.filter = [];
        if ~isempty(hd)
            if isFilterValid(hd)
                block.UserData.filter = hd;
                hdx = reffilter(hd); % Get the reference coeffs, not the quantized ones
                h = hdx.Numerator;
                D = hdx.DecimationFactor;
                if isa(hd,'mfilt.firdecim')
                    filtStruct = 1; % Direct form
                else
                    filtStruct = 2; % Direct form transposed
                end
                filterDefined = true;
            else
                error(message('dsp:dspblkfirdn2:invalidFilterObject1'));
            end
        end
        dtInfo = getFixptDataTypeInfoFromFilterObject(hd);
    end

    if filterDefined
        % Update FVTool plot window, if open
        if dspIsFVToolOpen(blkh)
            dspLinkFVTool2Mask(blkh,'update');
        end

        if (filtStruct == 1)
            % Direct form
            % Need to reshuffle the coefficients into phase order
            len = length(h);
            h = flipud(h(:));
            if (rem(len, D) ~= 0)
                nzeros = D - rem(len, D);
                h = [zeros(nzeros,1); h];
            end
            len = length(h);
            nrows = len / D;
            % Re-arrange the coefficients            
            h = flipud(reshape(h, D, nrows).');            
        else
            % Transposed direct form
            % Need to reshuffle the coefficients into phase order
            len = length(h);
            if (rem(len, D) ~= 0)
                nzeros = D - rem(len, D);
                h = [h zeros(1,nzeros)];
            end
            len = length(h);
            nrows = len / D;
            % Re-arrange the coefficients
            h = reshape(h, D, nrows).';
        end
    end

    % Gather up outputs    
    args.CoeffSource = FilterSource;
    args.h = h;
    args.D = D;
    args.filtStruct = filtStruct;
    args.outBufIC = outBufIC;
    
    % Maintain input frame size(3) maps to Allow multi-rate(2)
    % Maintain input frame rate(4) maps to Enforce single-rate(1)
    if framing == 3
        framing = 2;
    elseif framing == 4
        framing = 1;
    end

    varargout = {args, dtInfo, framing};

  otherwise
    error(message('dsp:dspblkfirdn2:unhandledCase'));
end

%------------------------------------------------------------------------------
function filterValid = isFilterValid(hd)

  switch class(hd)
    case {'mfilt.firdecim', ...
          'mfilt.firtdecim'}
      filterValid = 1;
    otherwise
      filterValid = 0;
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
              error(message('dsp:dspblkfirdn2:invalidFilterObject2'));
          end

          if isprop(hd,'CastBeforeSum') && ~hd.CastBeforeSum
              warning(message('dsp:dspblkfirdn2:invalidFilterObject3'));
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
          error(message('dsp:dspblkfirdn2:invalidFilterObject4', hd.arithmetic));
      end
  end


% end of dspblkfirdn2.m
