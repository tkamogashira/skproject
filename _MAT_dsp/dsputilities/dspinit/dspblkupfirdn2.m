function varargout = dspblkupfirdn2(action,FilterSource,varargin)
% DSPBLKUPFIRDN Mask dynamic dialog function for FIR rate conversion block

% Copyright 1995-2011 The MathWorks, Inc.

blkh=gcbh;
switch action
  case 'icon'
    % Generate string used for drawing icon:
    filterDefined = false;
    if FilterSource == 1
        L = varargin{1};
        M = varargin{2};
        if (~isempty(L) && ~isempty(M))
            filterDefined = true;
        end
    else
        %% Coeffs from filter object:
        hd = varargin{1};
        if ~isempty(hd) && isa(hd,'mfilt.firsrc')
            L = hd.RateChangeFactors(1);
            M = hd.RateChangeFactors(2);
            filterDefined = true; 
        end
    end
    if filterDefined
        if isempty(L)  || ~isnumeric(L) || ~isscalar(L) || isfi(L) || ...
                isempty(M)  || ~isnumeric(M) || ~isscalar(M) || isfi(M)
            str = 'x[?]';
        else
            if (L == 1)
                str = ['x[' num2str(M) 'n]'];
            elseif (M == 1)
             str = ['x[n/' num2str(L) ']'];
            else
                str = ['x[' num2str(M) 'n/' num2str(L) ']'];
            end
        end
    else
        str = 'x[?]';
    end
    if FilterSource ~= 1
        str = [str '\nMFILT:\n' get_param(blkh,'FilterObject')];
    end
    varargout{1} = str;

  case 'setup'
    filterDefined = false; %% Default
    %hd = [];
    h  = [];
    L  = [];
    M  = [];
    block = get_param(blkh,'Object');
    if FilterSource == 1
        % Input arguments when coeffs from dialog params:
        % dspblkupfirdn2('setup',FilterSource,h,L,M)
        if isfield(block.UserData,'filter')
            block.UserData = rmfield(block.UserData,'filter');
        end
        dtRows = varargin{1};
        h = varargin{2};
        L = varargin{3};
        M = varargin{4};
        
        %dtInfo = dspGetFixptDataTypeInfo(blkh,47);
        dtInfo = dspGetUDTFixptDataTypeInfo(blkh, dtRows, true); 
        dtInfo.arithmetic = 0; % Default: double-precision arithmetic
        dtInfo.inputWordLength = 16;
        dtInfo.inputFracLength = 15;
        
        if isempty(h) || isempty(L) || isempty(M)
            % Don't attempt any calculations in the mask helper on these 
            % parameters if any of them is currently empty or not defined.            
            args.CoeffSource = FilterSource;
            args.h = h;
            args.L = L;
            args.M = M;            
            varargout = {args,dtInfo};            
            return;
        else
            filterDefined = true;
        end 
        
        % Do more checking before using h,D parameters
        if ~isnumeric(h) || isfi(h)
            error(message('dsp:dspblkupfirdn2:invalidCoefficient1'));
        end
        if ~isnumeric(M) || isfi(M)
            error(message('dsp:dspblkupfirdn2:paramDTypeError1'));
        end
        if ~isnumeric(L) || isfi(L)            
            error(message('dsp:dspblkupfirdn2:paramDTypeError2'));            
        end
        
        block.UserData.filterConstructor = 'mfilt.firsrc';
        block.UserData.filterConstructorArgs = [];
        if filterDefined
            block.UserData.filterConstructorArgs = {L,M,h};
        end
        if ~isempty(h)
            if ~isvector(h)
                error(message('dsp:dspblkupfirdn2:invalidCoefficient2'));
            end
        end
        if ~isempty(L)
            if (L < 1) || (fix(L) ~= L)
                error(message('dsp:dspblkupfirdn2:paramRealScalarError1'));
            end
        end
        if ~isempty(M)
            if (M < 1) || (fix(M) ~= M)
                error(message('dsp:dspblkupfirdn2:paramRealScalarError2'));
            end
        end
    else
        % Input arguments when coeffs from filter object:
        % dspblkupfirdn2('setup',FilterSource,FilterObject)
        if isfield(block.UserData,'filterConstructor')
            block.UserData = rmfield(block.UserData,'filterConstructor');
            block.UserData = rmfield(block.UserData,'filterConstructorArgs');
        end
        hd = varargin{1};
        block.UserData.filter = [];
        if ~isempty(hd)
            if isa(hd,'mfilt.firsrc')
                block.UserData.filter = hd;
                hdx = reffilter(hd); %% Get the reference coeffs, not the quantized ones
                h = hdx.Numerator;
                L = hdx.RateChangeFactors(1);
                M = hdx.RateChangeFactors(2);
                filterDefined = true;
            else
                error(message('dsp:dspblkupfirdn2:invalidFilterObject1'));
            end
        end
        dtInfo = getFixptDataTypeInfoFromFilterObject(hd);
    end

    if filterDefined
        %% Update FVTool plot window, if open
        if dspIsFVToolOpen(blkh)
            dspLinkFVTool2Mask(blkh,'update');
        end

        % Convert all mask params to double
        h = double(h); L = double(L); M = double(M);

        % Zero-pad the filter coeffs to a multiple of L
        len = length(h);
        if (rem(len, L) ~= 0)
            nzeros = L - rem(len, L);
            h = [h(:); zeros(nzeros,1)];
        end
        % Reshape into L polyphases
        h = (reshape(h, L, length(h)/L)).';
    end

    % Gather up outputs
    args.CoeffSource = FilterSource;
    args.h = h;
    args.L = L;
    args.M = M;
    varargout = {args,dtInfo};
end

%------------------------------------------------------------------------------
function dtInfo = getFixptDataTypeInfoFromFilterObject(hd)
  %% Initialize all to defaults
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
              error(message('dsp:dspblkupfirdn2:invalidFilterObject2'));
          end

          if isprop(hd,'CastBeforeSum') && ~hd.CastBeforeSum
              warning(message('dsp:dspblkupfirdn2:invalidFilterObject3'));
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
          error(message('dsp:dspblkupfirdn2:invalidFilterObject4', hd.arithmetic));
      end
  end

% end of dspblkupfirdn2.m
