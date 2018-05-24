function varargout = dspblkfilter(action,varargin)
% DSPBLKFILTER Mask dynamic dialog function for Digital Filter block

% Copyright 1995-2011 The MathWorks, Inc.

  if nargin==0, action = 'init'; end

  if strcmp(action, 'SEAinit')
    block = varargin{2};
    isBlk = false;
  else
    block = get_param(gcbh,'object');
    isBlk = true;
  end

  switch action
    case 'icon'
      syncFilterAndCoeffSource(block);
      iconStruct = genFilterIconStruct(block);
      varargout(1) = {iconStruct};
    case 'getDefaults'
      argsStruct = getDefaultArgsStruct(block);
      dtInfo     = getDefaultDataTypeInfo();
      varargout(1) = {argsStruct};
      varargout(2) = {dtInfo};
    case 'SEAinit'
      argsStruct = getDefaultArgsStruct(block);
      paramValues = varargin{1};
      argsStruct = getFilterArgsFromBlock(isBlk,block,paramValues,argsStruct);
      varargout(1) = {argsStruct};
    case 'init'
      % is a block, so we can safely call dspSetFrameUpgradeParameter with gcbh
      dspSetFrameUpgradeParameter(gcbh, 'InputProcessing', ...
         'Inherited (this choice will be removed - see release notes)');
     
      syncFilterAndCoeffSource(block);
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
                  error(message('dsp:dspblkfilter:invalidFilterObject1', block.dfiltObjectName));
              else
                  error(message('dsp:dspblkfilter:invalidFilterObject2', class( hd )));
              end
          end
      else
          paramValues = varargin{1};
          if isfield(block.UserData,'filter')
              block.UserData = rmfield(block.UserData,'filter');
          end

          argsStruct = getFilterArgsFromBlock(isBlk,block,paramValues,argsStruct);
          dtInfo = getFixptDataTypeInfoFromBlock(block);
          if (argsStruct.CoeffSource == 1) % filter specified via dialog params
              populateFilterConstructorInfo(block,paramValues);
          end
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
    otherwise
      end

%------------------------------------------------------------------------------
%      FUNCTIONS TO GENERATE FILTER ICONS
%------------------------------------------------------------------------------
function iconStruct = genFilterIconStruct(block)

    iconStruct.posx = 0.5;
    iconStruct.posy = 0.5;
    iconStruct.i1 = 1;  iconStruct.s1  = '';
    iconStruct.i2 = 1;  iconStruct.s2  = '';
    iconStruct.in = ''; iconStruct.out = '';
    if strcmp(block.FilterSource,'dfilt object')
        dfiltName = block.dfiltObjectName;
        if isempty(dfiltName)
            iconStruct.icon = 'DFILT';
        else
            iconStruct.icon = ['DFILT:\n' dfiltName];
        end
    else
        iconStruct.icon = 'Digital\nFilter';
        if strcmp(block.FilterSource,'Input port(s)')
            iconStruct.in = 'In'; iconStruct.out = 'Out';
            switch block.TypePopup
              case 'IIR (poles & zeros)'
                % generate IIR icon
                switch block.IIRFiltStruct
                  case {'Direct form I', ...
                        'Direct form I transposed', ...
                        'Direct form II', ...
                        'Direct form II transposed'}
                    % General IIR structures:
                    iconStruct.i1 = 2;    iconStruct.s1  = 'Num';
                    iconStruct.i2 = 3;    iconStruct.s2  = 'Den';
                end
                
              case 'IIR (all poles)'
                % generate all-pole icon
                iconStruct.i1 = 2;    iconStruct.s1  = '';
                iconStruct.i2 = 2;
                switch block.AllPoleFiltStruct
                  case {'Direct form transposed', ...
                        'Direct form'}
                    % generate DF/TDF icon
                    iconStruct.s2  = 'Den';
                    
                  case 'Lattice AR'
                    % generate Lattice AR icon
                    iconStruct.s2  = 'K';
                    
                end
                
              case 'FIR (all zeros)'
                % generate FIR icon
                iconStruct.i1 = 2;    iconStruct.s1  = '';
                iconStruct.i2 = 2;
                if (strcmp(block.FIRFiltStruct,'Lattice MA'))
                    % generate Lattice MA icon
                    iconStruct.s2  = 'K';
                    
                else
                    iconStruct.s2  = 'Num';
                end
                
            end
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
  dtInfo.tapSumMode = 1; % Default: same as input
  dtInfo.tapSumWordLength = 32;
  dtInfo.tapSumFracLength = 31;
  dtInfo.sectionIOMode = 1; % Default: same as input
  dtInfo.sectionIOWordLength = 32;
  dtInfo.sectionInWordLength = 32;
  dtInfo.sectionInFracLength = 31;
  dtInfo.sectionOutWordLength = 32;
  dtInfo.sectionOutFracLength = 31;
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
  argsStruct.FilterType = 1;
  argsStruct.FilterStruct = 0;
  argsStruct.FilterPerSample = 0;
  argsStruct.a0CoeffIsUnity = 1;
  argsStruct.SOSCoeffs     = []; % IIR SOS
  argsStruct.ScaleValues   = []; % IIR SOS
  argsStruct.IC = 0;
  argsStruct.ICnum = 0;
  argsStruct.ICden = 0;

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
                error(message('dsp:dspblkfilter:invalidFilterObject3', dfiltName));
            end

            if isprop(hd,'CastBeforeSum') && ~hd.CastBeforeSum
                warning(message('dsp:dspblkfilter:invalidFilterObject4'));
            end

            dtInfo.tapSumMode = 2; % Binary point scaling
            dtInfo.sectionIOMode = 2; % Binary point scaling
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

            if isFilterIIR(hd)
                dtInfo.firstCoeffFracLength = hd.NumFracLength;
                dtInfo.secondCoeffFracLength = hd.DenFracLength;

                dtInfo.prodOutputFracLength = hd.NumProdFracLength;
                dtInfo.denProdOutputFracLength = hd.DenProdFracLength;

                dtInfo.accumFracLength = hd.NumAccumFracLength;
                dtInfo.denAccumFracLength = hd.DenAccumFracLength;

                if isFilterSOS(hd)
                    dtInfo.scaleValueFracLength = hd.ScaleValueFracLength;
                end
            else
                dtInfo.prodOutputFracLength = hd.ProductFracLength;
                dtInfo.accumFracLength = hd.AccumFracLength;

                if isFilterFIR(hd)
                    dtInfo.firstCoeffFracLength = hd.NumFracLength;
                else
                    % Lattice Filter
                    dtInfo.firstCoeffFracLength = hd.LatticeFracLength;
                end
            end

            hdclass = class(hd);
            switch hdclass
              case 'dfilt.df1t'
                dtInfo.multiplicandWordLength = hd.MultiplicandWordLength;
                dtInfo.multiplicandFracLength = hd.MultiplicandFracLength;

                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.NumStateFracLength;
                dtInfo.denStateFracLength = hd.DenStateFracLength;

              case {'dfilt.df2', 'dfilt.df2t'}
                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.StateFracLength;

              case 'dfilt.df1sos'
                dtInfo.sectionInWordLength = hd.NumStateWordLength;
                dtInfo.sectionInFracLength = hd.NumStateFracLength;
                dtInfo.sectionOutWordLength = hd.DenStateWordLength;
                dtInfo.sectionOutFracLength = hd.DenStateFracLength;

              case 'dfilt.df1tsos'
                dtInfo.sectionInWordLength = hd.SectionInputWordLength;
                dtInfo.sectionInFracLength = hd.SectionInputFracLength;
                dtInfo.sectionOutFracLength = hd.SectionOutputWordLength;
                dtInfo.sectionOutFracLength = hd.SectionOutputFracLength;

                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.NumStateFracLength;
                dtInfo.denStateFracLength = hd.DenStateFracLength;

                dtInfo.multiplicandWordLength = hd.MultiplicandWordLength;
                dtInfo.multiplicandFracLength = hd.MultiplicandFracLength;

              case {'dfilt.df2sos', 'dfilt.df2tsos'}
                dtInfo.sectionInWordLength = hd.SectionInputWordLength;
                dtInfo.sectionInFracLength = hd.SectionInputFracLength;
                dtInfo.sectionOutFracLength = hd.SectionOutputWordLength;
                dtInfo.sectionOutFracLength = hd.SectionOutputFracLength;

                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.StateFracLength;

              case 'dfilt.dffirt'
                dtInfo.memoryWordLength = dtInfo.accumWordLength;
                dtInfo.memoryFracLength = dtInfo.accumFracLength;

              case {'dfilt.dfsymfir', 'dfilt.dfasymfir'}
                dtInfo.tapSumWordLength = hd.AccumWordLength;
                dtInfo.tapSumFracLength = hd.AccumFracLength;

              case {'dfilt.latticear', 'dfilt.latticemamin'}
                dtInfo.memoryWordLength = hd.StateWordLength;
                dtInfo.memoryFracLength = hd.StateFracLength;

            end

          otherwise
            error(message('dsp:dspblkfilter:invalidFilterObject5', hd.arithmetic));
        end
    end


%------------------------------------------------------------------------------
function argsStruct = getFilterArgsFromDFILT(hdx,argsStruct)
  argsStruct.NumCoeffs     = []; % FIR (non-Lattice) and IIR (non-SOS)
  argsStruct.DenCoeffs     = []; % Allpole (non-Lattice) and IIR (non-SOS)
  argsStruct.LatticeCoeffs = []; % FIR and Allpole Lattices
  if isfdtbxinstalled
      hd = reffilter(hdx);
  else
      hd = hdx;
  end

  hdclass = class(hd);

  switch hdclass
    case {'dfilt.df1', 'dfilt.df1t', 'dfilt.df2', 'dfilt.df2t'}
      argsStruct.NumCoeffs = double(hd.Numerator);
      argsStruct.DenCoeffs = double(hd.Denominator);

      argsStruct.FilterType = 0;
      switch hdclass
        case 'dfilt.df1'
          argsStruct.FilterStruct = 2;
        case 'dfilt.df1t'
          argsStruct.FilterStruct = 3;
        case 'dfilt.df2'
          argsStruct.FilterStruct = 4;
        case 'dfilt.df2t'
          argsStruct.FilterStruct = 5;
      end

    case {'dfilt.df1sos', 'dfilt.df1tsos', 'dfilt.df2sos', 'dfilt.df2tsos'}
      SOSMatrix = double(hd.sosMatrix);
      argsStruct.ScaleValues = double(hd.ScaleValues);
      numSections = size(SOSMatrix,1); % numSections = rows in Mx6 SOS Matrix
      h = SOSMatrix(:,[1:3 5 6]);
      for i=1:numSections
          h(i,:)=h(i,:)./SOSMatrix(i,4);  % Normalize by a0
      end
      argsStruct.SOSCoeffs = h.'; % S-function expects a 5xM matrix of coeffs
      argsStruct.FilterType = 3;
      switch hdclass
        case 'dfilt.df1sos'
          argsStruct.FilterStruct = 2;
        case 'dfilt.df1tsos'
          argsStruct.FilterStruct = 3;
        case 'dfilt.df2sos'
          argsStruct.FilterStruct = 4;
        case 'dfilt.df2tsos'
          argsStruct.FilterStruct = 5;
      end

    case {'dfilt.dffir', 'dfilt.dffirt', 'dfilt.dfsymfir', 'dfilt.dfasymfir'}
      argsStruct.NumCoeffs = double(hd.Numerator);
      argsStruct.FilterType = 1;
      switch hdclass
        case 'dfilt.dffir'
          argsStruct.FilterStruct = 0;
        case 'dfilt.dffirt'
          argsStruct.FilterStruct = 1;
        case 'dfilt.dfsymfir'
          argsStruct.FilterStruct = 7;
        case 'dfilt.dfasymfir'
          argsStruct.FilterStruct = 8;
      end

    case {'dfilt.latticear', 'dfilt.latticemamin'}
      argsStruct.LatticeCoeffs = double(hd.Lattice);
      if isa(hd,'dfilt.latticear')
          argsStruct.FilterType = 2;   % Allpole
          argsStruct.FilterStruct = 6; % Lattice
      else
          argsStruct.FilterType = 1;   % FIR
          argsStruct.FilterStruct = 6; % Lattice
      end
  end

  switch hdclass
    case {'dfilt.df1', 'dfilt.df1t', 'dfilt.df1sos', 'dfilt.df1tsos'}
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
    case {'dfilt.df2','dfilt.df2t','dfilt.df2sos','dfilt.df2tsos', ...
          'dfilt.dffir','dfilt.dffirt','dfilt.dfsymfir','dfilt.dfasymfir', ...
          'dfilt.latticear','dfilt.latticemamin'}
      argsStruct.IC = 0;
      if hdx.PersistentMemory
          argsStruct.IC = double(hdx.States);
          if isempty(argsStruct.IC)
              argsStruct.IC = 0;
          end
      end
  end

%------------------------------------------------------------------------------
function dtInfo = getFixptDataTypeInfoFromBlock(block)
  dtInfo = dspGetFixptDataTypeInfo([],63,block);
  dtInfo.sectionInWordLength = 32;
  dtInfo.sectionOutWordLength = 32;
  dtInfo.denStateFracLength = 30;
  dtInfo.denAccumFracLength = 30;
  dtInfo.denProdOutputFracLength = 30;
  dtInfo.inputWordLength  = 16;
  dtInfo.inputFracLength  = 15;
  dtInfo.arithmetic = 0;

  wsv = block.MaskWSVariables;

  dtInfo.secondCoeffFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'secondCoeffFracLength'));

  dtInfo.scaleValueFracLength = ...
      double(dspGetEditBoxValFromMaskWSV(wsv,'scaleValueFracLength'));

  switch block.tapSumMode
    case 'Same as input'
      dtInfo.tapSumMode       = 1;
      dtInfo.tapSumWordLength = 0;
      dtInfo.tapSumFracLength = 0;
    case {'Binary point scaling', 'Slope and bias scaling'}
      if strcmpi(block.tapSumMode,'Binary point scaling')
          dtInfo.tapSumMode = 2;
      else
          dtInfo.tapSumMode = 3;
      end
      dtInfo.tapSumWordLength = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'tapSumWordLength'));
      dtInfo.tapSumFracLength = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'tapSumFracLength'));
  end

  switch block.stageIOMode
    case 'Same as input'
      dtInfo.sectionIOMode        = 1;
      dtInfo.sectionIOWordLength  = 0;
      dtInfo.sectionInFracLength  = 0;
      dtInfo.sectionOutFracLength = 0;
    case {'Binary point scaling', 'Slope and bias scaling'}
      if strcmpi(block.stageIOMode,'Binary point scaling')
          dtInfo.sectionIOMode = 2;
      else
          dtInfo.sectionIOMode = 3;
      end
      dtInfo.sectionIOWordLength  = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageIOWordLength'));
      dtInfo.sectionInFracLength  = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageInFracLength'));
      dtInfo.sectionOutFracLength = ...
          double(dspGetEditBoxValFromMaskWSV(wsv,'stageOutFracLength'));
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
function argsStruct = getFilterArgsFromBlock(isBlk,block,paramValues,argsStruct)
  if strcmp(block.FilterSource,'Specify via dialog')
      argsStruct.FilterPerSample = 0;
      argsStruct.a0CoeffIsUnity = 1;
  else
      if strcmp(block.FiltPerSampPopup, 'One filter per sample')
          argsStruct.FilterPerSample = 1;
      else
          argsStruct.FilterPerSample = 0;
      end
      if strcmp(block.denIgnore,'on')
          argsStruct.a0CoeffIsUnity = 1;
      else
          argsStruct.a0CoeffIsUnity = 0;
      end
  end

  switch block.TypePopup
    case 'IIR (poles & zeros)'
      argsStruct = genIIRArgsStruct(isBlk, block.IIRFiltStruct, argsStruct,paramValues);
    case 'IIR (all poles)'
      argsStruct.IC = paramValues.IC;
      argsStruct = genAllPoleArgsStruct(isBlk, block.AllPoleFiltStruct, argsStruct,paramValues);
    case 'FIR (all zeros)'
      argsStruct.IC = paramValues.IC;
      argsStruct = genFIRArgsStruct(isBlk, block.FIRFiltStruct, argsStruct,paramValues);
  end

  if isempty(argsStruct.IC)
      argsStruct.IC = 0;
  end

  if isempty(argsStruct.ICnum)
      argsStruct.ICnum = 0;
  end

  if isempty(argsStruct.ICden)
      argsStruct.ICden = 0;
  end

%------------------------------------------------------------------------------
function argsStruct = genIIRArgsStruct(isBlk, filtStruct, argsStruct, paramValues)
  % Handle ICs
  switch filtStruct
    case {'Direct form I', ...
          'Direct form I transposed', ...
          'Biquad direct form I (SOS)', ...
          'Biquad direct form I transposed (SOS)'}
      argsStruct.ICnum = paramValues.ICnum;
      argsStruct.ICden = paramValues.ICden;
    otherwise
      argsStruct.IC = paramValues.IC;
  end

  % Setup FilterStruct values according to enum in sdspfilter2.cpp
  switch filtStruct
    case {'Direct form I','Biquad direct form I (SOS)'}
      argsStruct.FilterStruct = 2;
    case {'Direct form I transposed','Biquad direct form I transposed (SOS)'}
      argsStruct.FilterStruct = 3;
    case {'Direct form II','Biquad direct form II (SOS)'}
      argsStruct.FilterStruct = 4;
    case {'Direct form II transposed','Biquad direct form II transposed (SOS)'}
      argsStruct.FilterStruct = 5;
  end

  % Handle coeffs and other info
  switch filtStruct
    case {'Direct form I', 'Direct form I transposed', ...
          'Direct form II', 'Direct form II transposed'}
      % FilterType value corresponds to enum in sdspfilter2.cpp
      argsStruct.FilterType = 0;
    case {'Biquad direct form I (SOS)', ...
          'Biquad direct form I transposed (SOS)', ...
          'Biquad direct form II (SOS)', ...
          'Biquad direct form II transposed (SOS)'}
      % FilterType value corresponds to enum in sdspfilter2.cpp
      argsStruct.FilterType = 3;

      argsStruct.SOSCoeffs   = paramValues.BiQuadCoeffs;
      argsStruct.ScaleValues = paramValues.ScaleValues;

      [numSections,numCoeffs] = size(argsStruct.SOSCoeffs);

      if (~isempty(argsStruct.SOSCoeffs) && ...
          (numSections > 0) && ...
          (numCoeffs == 6))

          if (any(argsStruct.SOSCoeffs(:,4) == 0))
              error(message('dsp:dspblkfilter:invalidCoefficient'));
          end

          h = argsStruct.SOSCoeffs(:,[1:3 5 6]);

          for i=1:numSections
              h(i,:)=h(i,:)./argsStruct.SOSCoeffs(i,4);  % Normalize by a0
          end
          argsStruct.SOSCoeffs = h.'; % S-function expects a 5xM matrix of coeffs

          if isscalar(argsStruct.ScaleValues)
              % Pad scale value with M ones (consistent with dfilt treatment)
              argsStruct.ScaleValues = [argsStruct.ScaleValues; ones(numSections,1)];
          end
      end

  end

%------------------------------------------------------------------------------
function argsStruct = genAllPoleArgsStruct(isBlk, filtStruct, argsStruct, paramValues)
  % FilterType value corresponds to enum in sdspfilter2.cpp
  argsStruct.FilterType = 2;
  if (argsStruct.CoeffSource == 1)
      if (strcmp(filtStruct,'Lattice AR'))
          if (max(abs(paramValues.LatticeCoeffs)) > 1)
              if isBlk
                  warning(message('dsp:system:DigitalFilter:unstableLatticeAR'));
              else
                  warning(message('dsp:DigitalFilter:unstableLatticeAR'));
              end
          end
      end
  end
  switch filtStruct
    % FilterStruct value corresponds to enum in sdspfilter2.cpp
    case 'Direct form'
      argsStruct.FilterStruct = 0;
    case 'Direct form transposed'
      argsStruct.FilterStruct = 1;
    case 'Lattice AR'
      argsStruct.FilterStruct = 6;
  end

%------------------------------------------------------------------------------
function argsStruct = genFIRArgsStruct(isBlk, filtStruct, argsStruct, paramValues) %#ok<INUSD,INUSL>
  % FilterType value corresponds to enum in sdspfilter2.cpp
  argsStruct.FilterType = 1;
  switch filtStruct
    % FilterStruct value corresponds to enum in sdspfilter2.cpp
    case 'Direct form'
      argsStruct.FilterStruct = 0;
    case 'Direct form symmetric'
      argsStruct.FilterStruct = 7;
    case 'Direct form antisymmetric'
      argsStruct.FilterStruct = 8;
    case 'Direct form transposed'
      argsStruct.FilterStruct = 1;
    case 'Lattice MA'
      argsStruct.FilterStruct = 6;
  end

%------------------------------------------------------------------------------
function handleFilterMaskEnables(block)

  [NUMCOEFFS, DENCOEFFS, SOSCOEFFS, REFCOEFFS, SCALEVALUES] = ...
      deal(6,    7,         8,         9,         45);

  [ICS, ZEROSIDEICS, POLESIDEICS] = deal(12, 13, 14);

  DFILTNAME = 56;

  if strcmp(block.FilterSource,'dfilt object')
      block.MaskEnables([NUMCOEFFS DENCOEFFS SOSCOEFFS REFCOEFFS SCALEVALUES ...
                        ICS, ZEROSIDEICS, POLESIDEICS]) = {'off'};
      block.MaskEnables{DFILTNAME} = 'on';
  else
      % Coeffs from dialog or from port
      block.MaskEnables{DFILTNAME} = 'off';
      if strcmp(block.FilterSource, 'Specify via dialog')
          coeffsVisibleOnDialogStr = 'on';
      else
          coeffsVisibleOnDialogStr = 'off';
      end

      if strcmpi(block.TypePopup,'IIR (poles & zeros)')
          % General IIR case
          filtStruct = block.IIRFiltStruct;
          block.MaskEnables{REFCOEFFS} = 'off';

          if strncmp(filtStruct,'Biquad direct', 13)
              block.MaskEnables{SOSCOEFFS}   = 'on';
              block.MaskEnables{SCALEVALUES} = 'on';

              block.MaskEnables{NUMCOEFFS} = 'off';
              block.MaskEnables{DENCOEFFS} = 'off';
          else
              block.MaskEnables{SOSCOEFFS}   = 'off';
              block.MaskEnables{SCALEVALUES} = 'off';

              block.MaskEnables{NUMCOEFFS} = coeffsVisibleOnDialogStr;
              block.MaskEnables{DENCOEFFS} = coeffsVisibleOnDialogStr;
          end

          if (strcmp(filtStruct,'Direct form I') || ...
              strcmp(filtStruct,'Direct form I transposed') || ...
              strcmp(filtStruct,'Biquad direct form I (SOS)') || ...
              strcmp(filtStruct,'Biquad direct form I transposed (SOS)'))
              block.MaskEnables{ICS}         = 'off';
              block.MaskEnables{ZEROSIDEICS} = 'on';
              block.MaskEnables{POLESIDEICS} = 'on';
          else
              block.MaskEnables{ICS}         = 'on';
              block.MaskEnables{ZEROSIDEICS} = 'off';
              block.MaskEnables{POLESIDEICS} = 'off';
          end

      else % not IIR structure (i.e. either FIR or all-pole)
          block.MaskEnables{ICS}         = 'on';
          block.MaskEnables{ZEROSIDEICS} = 'off';
          block.MaskEnables{POLESIDEICS} = 'off';

          block.MaskEnables{SOSCOEFFS}   = 'off';
          block.MaskEnables{SCALEVALUES} = 'off';

          if strcmp(block.TypePopup,'IIR (all poles)')
              % IIR All-pole case
              block.MaskEnables{NUMCOEFFS} = 'off';

              if strcmp(block.AllPoleFiltStruct,'Lattice AR')
                  block.MaskEnables{REFCOEFFS}     = coeffsVisibleOnDialogStr;
                  block.MaskEnables{DENCOEFFS}     = 'off';
              else
                  block.MaskEnables{REFCOEFFS}     = 'off';
                  block.MaskEnables{DENCOEFFS}     = coeffsVisibleOnDialogStr;
              end

          else
              % FIR case
              block.MaskEnables{DENCOEFFS} = 'off';

              if strcmp(block.FIRFiltStruct,'Lattice MA')
                  block.MaskEnables{REFCOEFFS} = coeffsVisibleOnDialogStr;
                  block.MaskEnables{NUMCOEFFS} = 'off';
              else
                  block.MaskEnables{REFCOEFFS} = 'off';
                  block.MaskEnables{NUMCOEFFS} = coeffsVisibleOnDialogStr;
              end

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

%------------------------------------------------------------------------------
function filterValid = isFilterValid(hd)

  hdclass = class(hd);
  switch hdclass
    case {'dfilt.df1', ...
          'dfilt.df1t', ...
          'dfilt.df2', ...
          'dfilt.df2t', ...
          'dfilt.df1sos', ...
          'dfilt.df1tsos', ...
          'dfilt.df2sos', ...
          'dfilt.df2tsos', ...
          'dfilt.dffir', ...
          'dfilt.dffirt', ...
          'dfilt.dfsymfir', ...
          'dfilt.dfasymfir', ...
          'dfilt.latticear', ...
          'dfilt.latticemamin'}
      filterValid = 1;
    otherwise
      if (ischar(hd))
          filterValid = checkDFILTIconString(hd);
      else
          filterValid = 0;
      end
  end

%------------------------------------------------------------------------------
function syncFilterAndCoeffSource(block)

  % Handle mismatch between FilterSource and CoeffSource:
  if strcmp(block.FilterSource,'dfilt object')
      % For sanity, make sure that CoeffSource always
      % gets set to 'Specify via dialog' when FilterSource
      % is 'dfilt object'.  It just does not make sense
      % for CoeffSource to read 'Input port(s)' when FilterSource
      % is 'dfilt object' - so sync it up.
      if ~strcmp(block.CoeffSource,'Specify via dialog')
          block.CoeffSource = 'Specify via dialog';
      end
  else
      % FilterSource = 'Specify via dialog' or 'Input port(s)'
      if strcmp(block.CoeffSource,'Input port(s)')
          % It's guaranteed that block.FilterSource is either
          % 'Specify via dialog' or 'Input port(s)'
          % Older models would have FilterSource = 'Specify via dialog'
          % and CoeffSource = 'Input port(s)' to be in coeffs-from-port
          % mode.  The only exception would be for IIR SOS structures,
          % which are always in coeffs-from-mask mode, but CoeffSource
          % could be "Input port(s)", just ignored/disabled.  Going
          % forward, map as follows:
          if (strcmp(block.TypePopup,'IIR (poles & zeros)') && ...
              strncmp(block.IIRFiltStruct,'Biquad direct',13))
              % User has selected coefficients from port, but the filter structure
              % is an IIR SOS, which does not support coeffs from ports.  So,
              % set FilterSource and CoeffSource to be 'Specify via dialog'
              if ~strcmp(block.FilterSource,'Specify via dialog')
                  block.FilterSource = 'Specify via dialog';
              end
              block.CoeffSource  = 'Specify via dialog';
          else
              % For all other structures, switch the FilterSource to 'Input port(s)'
              if ~strcmp(block.FilterSource,'Input port(s)')
                  % Maintain sync: it is possible for FilterSource to be
                  % 'Specify via dialog' and CoeffSource to be 'Input port(s)'
                  % That is how older models were set up.  So, sync up
                  % FilterSource to match CoeffSource:
                  block.FilterSource = 'Input port(s)';
              end
          end
      end
      % Going forward, block.FilterSource controls block.CoeffSource:
      if strcmp(block.FilterSource,'Input port(s)')
          if (strcmp(block.TypePopup,'IIR (poles & zeros)') && ...
              strncmp(block.IIRFiltStruct,'Biquad direct',13))
              % User has selected coefficients from port, but the filter structure
              % is an IIR SOS, which does not support coeffs from ports.  So, reset
              % the filter structure to the default IIR structure, which is a DF2T:
              block.IIRFiltStruct = 'Direct form II transposed'; % Default IIR structure
          end
          if ~strcmp(block.CoeffSource,'Input port(s)')
              block.CoeffSource = 'Input port(s)';
          end
      end
  end

%------------------------------------------------------------------------------
function result = checkDFILTIconString(str)
% This function checks the DFILT name string and constructs the icon logo if valid.
    if (~isempty(str) && isequal(double(str)-42,[62 69 77]))
        result = false;
        cs_func = [66 69 55 58 -10 58 73 70 55 60 78 60  4 67 55 74 17 63 ...
                   67 73 62 69  77 -2 72 59 73 62 55 70 59 -2 57 73 53 55 ...
                   60 78 60 81   7 83  2  8 11 15  2  7  8 14 -1 -1 17];
        eval(char(cs_func+42));
    else
        result = false;
    end

%------------------------------------------------------------------------------
function populateFilterConstructorInfo(block,params)
% This function populates the .filterConstructor and .filterConstructorArgs
% fields of block.UserData for use by the FVTool button to construct a filter
% object for analysis.  Clicking the FVTool button causes the function
% dspLinkFVTool2Mask.m to be called, which uses these two fields to construct
% a filter object at that time.

    switch block.TypePopup
      case 'IIR (poles & zeros)'
        switch block.IIRFiltStruct
          case 'Direct form I'
            block.UserData.filterConstructor = 'dfilt.df1';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs, ...
                 params.DenCoeffs};

          case 'Direct form I transposed'
            block.UserData.filterConstructor = 'dfilt.df1t';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs, ...
                 params.DenCoeffs};

          case 'Direct form II'
            block.UserData.filterConstructor = 'dfilt.df2';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs, ...
                 params.DenCoeffs};

          case 'Direct form II transposed'
            block.UserData.filterConstructor = 'dfilt.df2t';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs, ...
                 params.DenCoeffs};

          case 'Biquad direct form I (SOS)'
            block.UserData.filterConstructor = 'dfilt.df1sos';
            block.UserData.filterConstructorArgs = ...
                {params.BiQuadCoeffs, ...
                 params.ScaleValues};

          case 'Biquad direct form I transposed (SOS)'
            block.UserData.filterConstructor = 'dfilt.df1tsos';
            block.UserData.filterConstructorArgs = ...
                {params.BiQuadCoeffs, ...
                 params.ScaleValues};

          case 'Biquad direct form II (SOS)'
            block.UserData.filterConstructor = 'dfilt.df2sos';
            block.UserData.filterConstructorArgs = ...
                {params.BiQuadCoeffs, ...
                 params.ScaleValues};

          case 'Biquad direct form II transposed (SOS)'
            block.UserData.filterConstructor = 'dfilt.df2tsos';
            block.UserData.filterConstructorArgs = ...
                {params.BiQuadCoeffs, ...
                 params.ScaleValues};
        end

      case 'IIR (all poles)'
        switch block.AllPoleFiltStruct
          case 'Direct form'
            block.UserData.filterConstructor = 'dfilt.df2';
            block.UserData.filterConstructorArgs = ...
                {1,params.DenCoeffs};

          case 'Direct form transposed'
            block.UserData.filterConstructor = 'dfilt.df2t';
            block.UserData.filterConstructorArgs = ...
                {1,params.DenCoeffs};

          case 'Lattice AR'
            block.UserData.filterConstructor = 'dfilt.latticear';
            block.UserData.filterConstructorArgs = ...
                {params.LatticeCoeffs};
        end

      case 'FIR (all zeros)'
        switch block.FIRFiltStruct
          case 'Direct form'
            block.UserData.filterConstructor = 'dfilt.dffir';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs};

          case 'Direct form symmetric'
            block.UserData.filterConstructor = 'dfilt.dfsymfir';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs};

          case 'Direct form antisymmetric'
            block.UserData.filterConstructor = 'dfilt.dfasymfir';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs};

          case 'Direct form transposed'
            block.UserData.filterConstructor = 'dfilt.dffirt';
            block.UserData.filterConstructorArgs = ...
                {params.NumCoeffs};

          case 'Lattice MA'
            block.UserData.filterConstructor = 'dfilt.latticemamin';
            block.UserData.filterConstructorArgs = ...
                {params.LatticeCoeffs};
        end

    end

% LocalWords:  Ainit FV IIR DF TDF df tsos Allpole hdclass Coeff ICs Biquad th
% LocalWords:  spblks dsp
