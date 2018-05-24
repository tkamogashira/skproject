function varargout = dspblkbiquad3(action,varargin)
% DSPBLKBIQUAD Mask dynamic dialog function for IIR Biquad Filter block

% Copyright 2008-2011 The MathWorks, Inc.

  if nargin==0, action = 'init'; end

  if strcmp(action, 'SEAinit')
    block = varargin{2};
  else
    block = get_param(gcbh,'object');
  end

  switch action
    case 'icon'
      iconStruct = genFilterIconStruct(block);
      varargout(1) = {iconStruct};
    
    case 'getDefaults'
      argsStruct = getDefaultArgsStruct(block);
      dtInfo     = getDefaultDataTypeInfo();
      varargout(1) = {argsStruct};
      varargout(2) = {dtInfo};
    
    case 'init'
      % is a block, not a System object, so we can safely call
      % dspSettFrameUpgradeParameter with gcbh
      dspSetFrameUpgradeParameter(gcbh, 'InputProcessing', ...
          'Inherited (this choice will be removed - see release notes)');
      
      handleFilterMaskEnables(block);
              
      argsStruct = getDefaultArgsStruct(block);
      if strcmp(block.FilterSource,'dfilt object')
          hd = varargin{1};
          
          if isfield(block.UserData,'filterConstructor')
              block.UserData = rmfield(block.UserData,'filterConstructor');
              block.UserData = rmfield(block.UserData,'filterConstructorArgs');
          end
          if isfield(block.UserData,'ICData')
              block.UserData = rmfield(block.UserData,'ICData');
          end
          block.UserData.filter = [];
          if isFilterValid(hd)
              block.UserData.filter = hd;
              argsStruct = getFilterArgsFromDFILT(hd,argsStruct);
              dtInfo = getFixptDataTypeInfoFromDFILT(block,hd);
          else
              if isempty(hd)
                  error(message('dsp:dspblkbiquad:dfiltNotDefined', block.dfiltObjectName));
              else
                  error(message('dsp:dspblkbiquad:unsupportedFilterStructure', class( hd )));
              end
          end
      else
          paramValues = varargin{1};
          if isfield(block.UserData,'filter')
              block.UserData = rmfield(block.UserData,'filter');
          end
          
          argsStruct = getFilterArgsFromBlock(block,paramValues,argsStruct);
          dtInfo = getFixptDataTypeInfoFromBlock(block);
          populateFilterConstructorInfo(block,paramValues);
          block.UserData.ICData.ICnum = paramValues.ICnum;
          block.UserData.ICData.ICden = paramValues.ICden;
          block.UserData.ICData.IC    = paramValues.IC;
      end

      % Update FVTool plot window, if open
      if dspIsFVToolOpen(gcbh)
          dspLinkFVTool2Mask(gcbh,'update');
      end

      varargout(1) = {argsStruct};
      varargout(2) = {dtInfo};
      
    case 'dynamic'
      handleFilterMaskEnables(block);
      
  end

%------------------------------------------------------------------------------
%      FUNCTIONS TO GENERATE FILTER ICONS
%------------------------------------------------------------------------------
function iconStruct = genFilterIconStruct(block)

    iconStruct.posx = 0.5;
    iconStruct.posy = 0.5;
    iconStruct.i1 = 1;  iconStruct.s1  = '';
    iconStruct.i2 = 1;  iconStruct.s2  = '';
    iconStruct.i3 = 1;  iconStruct.s3  = '';
    iconStruct.in = ''; iconStruct.out = '';

    iconStruct.icon = 'Biquad';
    
    if strcmp(block.FilterSource,'Input port(s)')
        iconStruct.in = 'In'; iconStruct.out = 'Out';
        iconStruct.i1 = 2;    iconStruct.s1  = 'Num';
        iconStruct.i2 = 3;    iconStruct.s2  = 'Den';
        if strcmp(block.ScaleValueMode,'Specify via input port (g)')
            iconStruct.i3 = 4;    iconStruct.s3  = 'g';
        end
    end

%------------------------------------------------------------------------------
%      FUNCTIONS TO GENERATE FILTER ARGUMENTS
%------------------------------------------------------------------------------
function dtInfo = getDefaultDataTypeInfo
  
  dtInfo.arithmetic = 0;
  dtInfo.inputWordLength  = 16;
  dtInfo.inputFracLength  = 15;
  dtInfo.secondCoeffFracLength = 15;
  dtInfo.scaleValueFracLength  = 15;
  dtInfo.stageInputMode  = 1; % Default: same as input
  dtInfo.stageOutputMode = 1; % Default: same as section input
  dtInfo.stageInputWordLength = 32;
  dtInfo.stageInputFracLength = 31;
  dtInfo.stageOutputWordLength = 32;
  dtInfo.stageOutputFracLength = 31;
  dtInfo.multiplicandMode = 1; % Default: same as output
  dtInfo.multiplicandWordLength = 32;
  dtInfo.multiplicandFracLength = 30;
  dtInfo.denProdOutputFracLength = 30;
  dtInfo.denAccumFracLength = 30;
  dtInfo.denStateFracLength = 30;
  dtInfo.firstCoeffMode = 2; % Default: same word length as input
  dtInfo.firstCoeffWordLength = 16;
  dtInfo.firstCoeffFracLength = 15;
  dtInfo.prodOutputMode = 2; % Default: same as input
  dtInfo.prodOutputWordLength = 32;
  dtInfo.prodOutputFracLength = 30;
  dtInfo.accumMode = 3; % Default: same as product output
  dtInfo.accumWordLength = 32;
  dtInfo.accumFracLength = 30;
  dtInfo.memoryMode = 4; % Default: same as accumulator
  dtInfo.memoryWordLength = 32;
  dtInfo.memoryFracLength = 30;
  dtInfo.outputMode = 4; % Default: same as accumulator
  dtInfo.outputWordLength = 16;
  dtInfo.outputFracLength = 15;
  dtInfo.overflowMode = 1;
  dtInfo.roundingMode = 3; % floor


%------------------------------------------------------------------------------
function argsStruct = getDefaultArgsStruct(block)
  switch block.FilterSource
    case 'Specify via dialog'
      argsStruct.CoeffSource = 1;
    case 'Input port(s)'
      argsStruct.CoeffSource = 2;
    case 'dfilt object'
      argsStruct.CoeffSource = 3;
  end
  argsStruct.FilterStruct  = 0;
  argsStruct.SOSCoeffs     = [1 0.3 0.4 1 0.1 0.2]; 
  argsStruct.ScaleValues   = 1;
  argsStruct.OptimizeScaleValues = 1;
  argsStruct.ScaleValueMode = 2;
  argsStruct.IC = 0;
  argsStruct.ICnum = 0;
  argsStruct.ICden = 0;

%------------------------------------------------------------------------------
function dtInfo = getFixptDataTypeInfoFromBlock(block)
  dtInfo = dspGetFixptDataTypeInfo([],63,block);
  dtInfo.inputWordLength  = 16;
  dtInfo.inputFracLength  = 15;
  dtInfo.arithmetic = 0;

  wsv = block.MaskWSVariables;
  
 dtInfo.denAccumFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'denAccumFracLength'));
      
  dtInfo.denProdOutputFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'denProdOutputFracLength'));

  dtInfo.secondCoeffFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'secondCoeffFracLength'));

  dtInfo.scaleValueFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'scaleValueFracLength'));

  % used only for DF1T
  dtInfo.denStateFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'secondMemoryFracLength'));

  switch block.stageInputMode
    case 'Same as input'
      dtInfo.stageInputMode        = 1;
      dtInfo.stageInputWordLength  = 0;
      dtInfo.stageInputFracLength  = 0;
    case {'Binary point scaling', 'Slope and bias scaling'}
      if strcmpi(block.stageInputMode,'Binary point scaling')
          dtInfo.stageInputMode = 2;
      else
          dtInfo.stageInputMode = 3;
      end
      dtInfo.stageInputWordLength  = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageInputWordLength'));
      dtInfo.stageInputFracLength  = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageInputFracLength'));
  end

  switch block.stageOutputMode
    case 'Same as section input'
      dtInfo.stageOutputMode        = 1;
      dtInfo.stageOutputWordLength  = 0;
      dtInfo.stageOutputFracLength  = 0;
    case {'Binary point scaling', 'Slope and bias scaling'}
      if strcmpi(block.stageOutputMode,'Binary point scaling')
          dtInfo.stageOutputMode = 2;
      else
          dtInfo.stageOutputMode = 3;
      end
      dtInfo.stageOutputWordLength  = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageOutputWordLength'));
      dtInfo.stageOutputFracLength  = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageOutputFracLength'));
  end
  
  switch block.multiplicandMode
    case 'Same as output'
      dtInfo.multiplicandMode       = 1;
      dtInfo.multiplicandWordLength = 0;
      dtInfo.multiplicandFracLength = 0;
    case {'Binary point scaling', 'Slope and bias scaling'}
      if strcmpi(block.multiplicandMode,'Binary point scaling')
          dtInfo.multiplicandMode = 2;
      else
          dtInfo.multiplicandMode = 3;
      end
      dtInfo.multiplicandWordLength = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'multiplicandWordLength'));
      dtInfo.multiplicandFracLength = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'multiplicandFracLength'));
  end


%------------------------------------------------------------------------------
function argsStruct = getFilterArgsFromBlock(block, paramValues, argsStruct)

argsStruct = genIIRArgsStruct(block.IIRFiltStruct, argsStruct, paramValues);

%------------------------------------------------------------------------------
function argsStruct = genIIRArgsStruct(filtStruct, argsStruct, paramValues)

 [~,warnEnum,errorEnum] = deal(1,2,3);
  
  % Handle ICs
  switch filtStruct
    case {'Direct form I', ...
          'Direct form I transposed'}
      argsStruct.ICnum = paramValues.ICnum;
      argsStruct.ICden = paramValues.ICden;
    otherwise
      argsStruct.IC = paramValues.IC;
  end

  % Setup FilterStruct values according to enum in sdspfilter2.cpp
  switch filtStruct
    case {'Direct form I'}
      argsStruct.FilterStruct = 0;
    case {'Direct form I transposed'}
      argsStruct.FilterStruct = 1;
    case {'Direct form II'}
      argsStruct.FilterStruct = 2;
    case {'Direct form II transposed'}
      argsStruct.FilterStruct = 3;
  end

  % Handle coeffs and other info
  if (argsStruct.CoeffSource == 2)  
    argsStruct.ScaleValueMode = paramValues.ScaleValueMode;
  else
    argsStruct.SOSCoeffs   = paramValues.BiQuadCoeffs;
    argsStruct.ScaleValues = paramValues.ScaleValues;
    argsStruct.OptimizeScaleValues = paramValues.OptimizeScaleValues;

    msgStr = ['The leading denominator coefficients must be one. ' ...
                'Change the a0 entries (4th column) of the SOS matrix to one.'];

    [numSections,numCoeffs] = size(argsStruct.SOSCoeffs);
    if (~isempty(argsStruct.SOSCoeffs) && (numSections > 0) && (numCoeffs == 6))
        if (any(argsStruct.SOSCoeffs(:,4) ~= 0))
            if (any(argsStruct.SOSCoeffs(:,4) ~= 1))
                if (paramValues.a0Flag == errorEnum)
                   error(message('dsp:dspblkbiquad:a0NotEqualOneError'));
                elseif (paramValues.a0Flag == warnEnum)
                   warning(message('dsp:dspblkbiquad:a0NotEqualOneWarn'));
                end
            end
        end
    end
    
  end

%------------------------------------------------------------------------------
function populateFilterConstructorInfo(block,params)
% This function populates the .filterConstructor and .filterConstructorArgs
% fields of block.UserData for use by the FVTool button to construct a filter
% object for analysis.  Clicking the FVTool button causes the function
% dspLinkFVTool2Mask.m to be called, which uses these two fields to construct
% a filter object at that time.
    
  switch block.IIRFiltStruct
    case 'Direct form I'
    block.UserData.filterConstructor = 'dfilt.df1sos';
    block.UserData.filterConstructorArgs = ...
        {params.BiQuadCoeffs, ...
            params.ScaleValues};

    case 'Direct form I transposed'
    block.UserData.filterConstructor = 'dfilt.df1tsos';
    block.UserData.filterConstructorArgs = ...
        {params.BiQuadCoeffs, ...
            params.ScaleValues};

    case 'Direct form II'
    block.UserData.filterConstructor = 'dfilt.df2sos';
    block.UserData.filterConstructorArgs = ...
        {params.BiQuadCoeffs, ...
            params.ScaleValues};

    case 'Direct form II transposed'
    block.UserData.filterConstructor = 'dfilt.df2tsos';
    block.UserData.filterConstructorArgs = ...
        {params.BiQuadCoeffs, ...
            params.ScaleValues};    
  end
  
%------------------------------------------------------------------------------
function dtInfo = getFixptDataTypeInfoFromDFILT(block,hd)
% Initialize all to defaults
    dtInfo = getDefaultDataTypeInfo();

    if isfdtbxinstalled
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

            dfiltName = block.dfiltObjectName;
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
                error(message('dsp:dspblkbiquad:noUnsignedSupport', dfiltName));
            end

            if isprop(hd,'CastBeforeSum') && ~hd.CastBeforeSum
                warning(message('dsp:dspblkbiquad:unsupportedCastAfterSum'));
            end

            dtInfo.stageInputMode  = 2; % Binary point scaling    
            dtInfo.stageOutputMode = 2; % Binary point scaling
            dtInfo.firstCoeffMode = 0; % Binary point scaling
            dtInfo.prodOutputMode = 0; % Binary point scaling
            dtInfo.accumMode = 0; % Binary point scaling
            dtInfo.memoryMode = 0; % Binary point scaling
            dtInfo.outputMode = 0; % Binary point scaling
            dtInfo.multiplicandMode = 2; % Binary point scaling

            dtInfo.inputWordLength  = hd.InputWordLength;
            dtInfo.inputFracLength  = hd.InputFracLength;

            dtInfo.outputWordLength = hd.OutputWordLength;
            dtInfo.outputFracLength = hd.OutputFracLength;

            dtInfo.firstCoeffWordLength = hd.CoeffWordLength;
            dtInfo.prodOutputWordLength = hd.ProductWordLength;
            dtInfo.accumWordLength = hd.AccumWordLength;

            dtInfo.firstCoeffFracLength  = hd.NumFracLength;
            dtInfo.secondCoeffFracLength = hd.DenFracLength;
            dtInfo.prodOutputFracLength    = hd.NumProdFracLength;
            dtInfo.denProdOutputFracLength = hd.DenProdFracLength;
            dtInfo.accumFracLength    = hd.NumAccumFracLength;
            dtInfo.denAccumFracLength = hd.DenAccumFracLength;
            dtInfo.scaleValueFracLength = hd.ScaleValueFracLength;
   
            hdclass = class(hd);
            switch hdclass
              case 'dfilt.df1sos'
                dtInfo.stageInputWordLength = hd.NumStateWordLength;
                dtInfo.stageInputFracLength = hd.NumStateFracLength;
                dtInfo.stageOutputWordLength = hd.DenStateWordLength;
                dtInfo.stageOutputFracLength = hd.DenStateFracLength;

              case 'dfilt.df1tsos'
                dtInfo.stageInputWordLength = hd.SectionInputWordLength;
                dtInfo.stageInputFracLength = hd.SectionInputFracLength;
                dtInfo.stageOutputWordLength = hd.SectionOutputWordLength;
                dtInfo.stageOutputFracLength = hd.SectionOutputFracLength;

                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.NumStateFracLength;
                dtInfo.denStateFracLength = hd.DenStateFracLength;

                dtInfo.multiplicandWordLength = hd.MultiplicandWordLength;
                dtInfo.multiplicandFracLength = hd.MultiplicandFracLength;

              case {'dfilt.df2sos', 'dfilt.df2tsos'}
                dtInfo.stageInputWordLength = hd.SectionInputWordLength;
                dtInfo.stageInputFracLength = hd.SectionInputFracLength;
                dtInfo.stageOutputWordLength = hd.SectionOutputWordLength;
                dtInfo.stageOutputFracLength = hd.SectionOutputFracLength;

                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.StateFracLength;
              
            end

          otherwise
            error(message('dsp:dspblkbiquad:unsupportedDfiltArith', hd.arithmetic));
        end
    end
    
%------------------------------------------------------------------------------
function argsStruct = getFilterArgsFromDFILT(hdx,argsStruct)
  if isfdtbxinstalled
      hd = reffilter(hdx);
  else
      hd = hdx;
  end

  hdclass = class(hd);

    SOSMatrix = double(hd.sosMatrix);
    argsStruct.ScaleValues = double(hd.ScaleValues);
    argsStruct.OptimizeScaleValues = double(hdx.OptimizeScaleValues);
    argsStruct.SOSCoeffs = SOSMatrix;
    
    switch hdclass
    case 'dfilt.df1sos'
        argsStruct.FilterStruct = 0;
    case 'dfilt.df1tsos'
        argsStruct.FilterStruct = 1;
    case 'dfilt.df2sos'
        argsStruct.FilterStruct = 2;
    case 'dfilt.df2tsos'
        argsStruct.FilterStruct = 3;
    end

  switch hdclass
    case {'dfilt.df1sos', 'dfilt.df1tsos'}
      if hdx.PersistentMemory
          numStates = double(hdx.States.Numerator);
          denStates = double(hdx.States.Denominator);
          if isempty(numStates)
              numStates = 0;
          end
          if isempty(denStates)
              denStates = 0;
          end
          argsStruct.ICnum = numStates;
          argsStruct.ICden = denStates;
      end
    case {'dfilt.df2sos','dfilt.df2tsos'}
      argsStruct.IC = 0;
      if hdx.PersistentMemory
          argsStruct.IC = double(hdx.States);
          if isempty(argsStruct.IC)
              argsStruct.IC = 0;
          end
      end
  end
  
%------------------------------------------------------------------------------
function filterValid = isFilterValid(hd)

  hdclass = class(hd);
  switch hdclass
    case {'dfilt.df1sos', ...
          'dfilt.df1tsos', ...
          'dfilt.df2sos', ...
          'dfilt.df2tsos'}
      filterValid = 1;
    otherwise
      if (ischar(hd))
          filterValid = checkDFILTIconString(hd);
      else
          filterValid = 0;
      end
  end
  
  
%--------------------------------------------------------------------------
  function handleFilterMaskEnables(block)

  [SOSCOEFFS, SCALEVALUES, IC, ICNUM, ICDEN] = ...
      deal(3,    33,        5,   6,      7);

  DFILTNAME = 45;

  if strcmp(block.FilterSource,'dfilt object')
      block.MaskEnables([SOSCOEFFS SCALEVALUES IC, ICNUM, ICDEN]) = {'off'};
      block.MaskEnables{DFILTNAME} = 'on';
  else
      % Coeffs from dialog or from port
      block.MaskEnables{DFILTNAME} = 'off';
      if strcmp(block.FilterSource, 'Specify via dialog')
          block.MaskEnables([SOSCOEFFS SCALEVALUES])  = {'on'};
      else
          block.MaskEnables([SOSCOEFFS SCALEVALUES])  = {'off'};
      end
      if (strcmp(block.IIRFiltStruct,'Direct form I') || ...
              strcmp(block.IIRFiltStruct,'Direct form I transposed'))
          block.MaskEnables([ICNUM ICDEN])  = {'on'};
          block.MaskEnables(IC)  = {'off'};
      else
          block.MaskEnables([ICNUM ICDEN])  = {'off'};
          block.MaskEnables(IC)  = {'on'};
      end
  end
  
