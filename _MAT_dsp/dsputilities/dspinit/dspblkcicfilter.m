function varargout = dspblkcicfilter(action,blkh,filtFrom,varargin)
% DSPBLKCICFILTER Mask helper function for DSP System Toolbox
% CIC Decimation AND CIC Interpolation blocks.

%   Copyright 1995-2011 The MathWorks, Inc.

switch action
    case 'icon'
      if filtFrom == 1
          % filter specified via dialog parameters
          blkTypeStr = varargin{1};
          str = ['CIC\n' blkTypeStr];
      else
          % filter specified via MFILT object
          str = ['CIC Filter\nMFILT:\n' get_param(blkh,'filtobj')];
      end
      varargout = {str};
      
    case 'initCICInterp'
      dspSetFrameUpgradeParameter(blkh,'InputProcessing', ...
          'Inherited (this choice will be removed - see release notes)');
      % Maintain input frame size(4) maps to Allow multi-rate(2)
      % Maintain input frame rate(3) maps to Enforce single-rate(1)
      framing = varargin{1};
      if framing == 3
          framing = 1;
      elseif framing == 4
          framing = 2;
      end
      varargout{1} = framing;
      
    case 'initCICDecim'
      dspSetFrameUpgradeParameter(blkh,'RateOptions', ...
          'Inherit from input (this choice will be removed - see release notes)');

    case 'init'
      % Figure out whether or not proper licenses exist to allow use of
      % MFILT CIC objects (i.e. BOTH DSP Sys Tbx + Fix Pt Tbx are required)
      fdtbxexists = false;
      if isfdtbxinstalled,
          fdtbxexists = true;
      end
      fixptexists = false;
      if isfixptinstalled
          fixptexists = true;
      end

      % BOTH DSP Sys Tbx + Fix Pt Tbx are required to use MFILT CIC Objects
      okToUseMFILTCICObjects = fixptexists && fdtbxexists;

      filterDefined = false; % Assume undefined as default
      InputWL = 16;
      InputFL = 15; % Defaults, only used when coeffs from filter object

      block = get_param(blkh,'Object');
      if filtFrom == 1
          % filter specified via dialog parameters
          if isfield(block.UserData,'filter')
              block.UserData = rmfield(block.UserData,'filter');
          end
          ftype = getfiltinfo(get_param(blkh,'ftype'));

          % Cast sfunction args to double
          for i = 1:7
            if (ischar(varargin{i}))
                error(message('dsp:dspblkcicfilter:paramDTypeError1'));
            end
          end
          R           = double(varargin{1});
          M           = double(varargin{2});
          N           = double(varargin{3});
          section2NWL = double(varargin{4});
          section2NFL = double(varargin{5});
          outWL       = double(varargin{6});
          outFL       = double(varargin{7});
          filterInternals = double(varargin{8});
          
          filterDefined = true;
          
          if (ftype > 2)
              block.UserData.filterConstructor = 'mfilt.cicinterp';
          else
              block.UserData.filterConstructor = 'mfilt.cicdecim';
          end
                    
          if  isoktocheckparam(R)
              if ~isScalarRealDouble(R)
                  error(message('dsp:dspblkcicfilter:paramDTypeError2'));
              else
                  if ~isFloatIntegerGE(R,2)
                      error(message('dsp:dspblkcicfilter:paramPositiveIntegerError1'));
                  end
              end
          end

          if  isoktocheckparam(M)
              if ~isScalarRealDouble(M)
                  error(message('dsp:dspblkcicfilter:paramDTypeError3'));
              else
                  if ~isFloatIntegerGE(M,1)
                      error(message('dsp:dspblkcicfilter:paramPositiveIntegerError2'));
                  end
              end 
          end

          if  isoktocheckparam(N)
              if ~isScalarRealDouble(N)
                  error(message('dsp:dspblkcicfilter:paramDTypeError4'));
              else
                  if ~isFloatIntegerGE(N,1)
                      error(message('dsp:dspblkcicfilter:paramPositiveIntegerError3'));
                  end 
              end
          end
          
          block.UserData.filterConstructorArgs = ...
              {R,M,N,section2NWL,section2NFL,outWL,outFL,filterInternals};
      else
          % Translate CIC filter object parameters into S-fcn parameters
          if isfield(block.UserData,'filterConstructor')
              block.UserData = rmfield(block.UserData,'filterConstructor');
              block.UserData = rmfield(block.UserData,'filterConstructorArgs');
          end
          block.UserData.filter = [];
          if okToUseMFILTCICObjects
              blockType = varargin{1};
              filter = varargin{2};

              blockTypeIsDecimation = strcmpi(blockType,'decimation');
              if isoktocheckparam(filter)
                  % Base filter object checking on the library block type
                  if blockTypeIsDecimation
                      if ~isa(filter,'mfilt.cicdecim')
                          error(message('dsp:dspblkcicfilter:paramEmptyError1', get_param( blkh, 'filtobj' )));
                          return;
                      end
                  else
                      if ~isa(filter,'mfilt.cicinterp')
                          error(message('dsp:dspblkcicfilter:paramEmptyError2', get_param( blkh, 'filtobj' )));
                          return;
                      end
                  end
              end

              if ~isempty(filter)
                  % Filter object is assumed to be valid at this point
                  filterDefined = true;
                  block.UserData.filter = filter;
                  ftype = getfiltinfo(get(filter,'FilterStructure'));

                  % Get the sample rate change factor from the MFILT object.
                  if blockTypeIsDecimation
                      R = get(filter,'DecimationFactor');
                  else
                      R = get(filter,'InterpolationFactor');
                  end

                  M           = get(filter,'DifferentialDelay');
                  N           = get(filter,'NumberOfSections');
                  section2NWL = get(filter,'SectionWordLengths');
                  section2NFL = get(filter,'SectionFracLengths');
                  outWL       = get(filter,'OutputWordLength');
                  outFL       = get(filter,'OutputFracLength');
                  InputWL     = get(filter,'InputWordLength');
                  InputFL     = get(filter,'InputFracLength');
              else
                  % Filter object is assumed to be validempty at this point              
                  filterDefined = false;
              end
          end
      end
      
      % Return S-fcn parameters from initialization call
      if filterDefined
          % Update FVTool (if it's launched)
          if dspIsFVToolOpen(gcbh)
              dspLinkFVTool2Mask(gcbh,'update');
          end
          args.ftype       = ftype;
          args.section2NWL = section2NWL;
          args.section2NFL = section2NFL;
          args.states      = 0;
          args.outWL       = outWL;
          args.outFL       = outFL;
          args.InputWL     = InputWL;
          args.InputFL     = InputFL;
          args.R           = R;
          args.M           = M;
          args.N           = N;
      else
          % Filter is undefined.
          % Simulink will allow this to happen during mask edit time, but will
          % throw an error correctly at simulation run time.  So, let the
          % arguments to the S-function be empties/defaults for now.
          args.ftype       = 1;
          args.section2NWL = [];
          args.section2NFL = [];
          args.states      = [];
          args.outWL       = [];
          args.outFL       = [];
          args.InputWL     = [];
          args.InputFL     = [];
          args.R           = [];
          args.M           = [];
          args.N           = [];
      end
      varargout = {args};

end

% -------------------------------------------------------------------------
function ftype_Sfcn = getfiltinfo(filtstruct)

switch lower(filtstruct)
    case {'cascaded integrator-comb decimator','decimator'}
        ftype_Sfcn = 1;

    case {'zero-latency cascaded integrator-comb decimator','zero-latency decimator'}
        ftype_Sfcn = 2;

    case {'cascaded integrator-comb interpolator','interpolator'}
        ftype_Sfcn = 3;

    case {'zero-latency cascaded integrator-comb interpolator','zero-latency interpolator'}
        ftype_Sfcn = 4;

    otherwise
        errordlg('Internal error: Structure not supported.');
end


% -------------------------------------------------------------------------
function flag = isScalarRealDouble(x)

flag = isreal(x) && ~issparse(x) && isa(x,'double') && isscalar(x);

% -------------------------------------------------------------------------
function flag = isFloatIntegerValued(x)

flag = ~isinf(x) && ~isnan(x) && (fix(x) == x);

% -------------------------------------------------------------------------
function flag = isFloatIntegerGE(x,minVal)

flag = isFloatIntegerValued(x) && (x >= minVal);

% [EOF]


