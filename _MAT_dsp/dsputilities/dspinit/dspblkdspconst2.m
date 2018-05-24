function dspblkdspconst2(action)
% DSPBLKDSPCONST2 DSP System Toolbox DSP Constant block helper function.

% Copyright 1995-2004 The MathWorks, Inc.
  
  blk     = gcbh;
  obj     = get_param(blk,'object');
  fullblk = getfullname(blk);

  if nargin==0, action = 'dynamic'; end

  % Some constant values for the params that have their visibility
  % switched on and off
  [DISC_OUT,CONT_OUT,SAMP_TIME,FRAME_PERIOD] = deal(3,4,5,6);
  ON  = {'on'};
  OFF = {'off'};
  % NOTE: FRAME_POPUP is defined in set_discrete_samp_time subfunction as well
  FRAME_POPUP = 'Frame-based'; 
  SAMPLE_1D_POPUP = 'Sample-based (interpret vectors as 1-D)';
        
  % Note that everything besides the Value parameter is non-tunable

  sampMode     = obj.SampleMode;
  isContinuous = strcmp(sampMode,'Continuous');

  vis         = obj.MaskVisibilities;
  lastVis     = vis;

  % Set the Simulink Constant block to mirror what is set in the
  % DSP Constant
  switch action
   case 'init'
    % Normally, we need to make sure that fields are turned on before
    % accessing them, else we will get the last applied settings
    % instead of the last chosen ones - but, that's good enough, here
    % (because we're not in the 'dynamic' case)

    % Now to set the underlying blocks
    frame_blk_str = [fullblk '/Frame Status Conversion'];
    frame_obj = get_param(frame_blk_str,'object'); 
    const_blk_str = [fullblk '/Constant'];
    const_obj = get_param(const_blk_str,'object');
    
    frameStr  = frame_obj.OutFrame;
	
    if isContinuous
      % Continuous time -> SAMPLE-BASED:
      % CONT_OUT will be visible here
      outMode = obj.continuousOutput;
      % frame-ness
      if ~strcmp(frameStr,'Sample-based')
        frame_obj.OutFrame = 'Sample based';
      end
    else
      % DISC_OUT will be visible here
      outMode = obj.discreteOutput;
      if strcmp(outMode,FRAME_POPUP)
        % frame-based
        if ~strcmp(frameStr,'Frame-based')
          frame_obj.OutFrame = 'Frame based'; 
        end
      else
        % Sample-based:
        if ~strcmp(frameStr,'Sample-based')
          frame_obj.OutFrame = 'Sample based';
        end
      end
    end
    
    % 1-D checkbox
    if strcmp(outMode,SAMPLE_1D_POPUP)
      if ~strcmp(const_obj.VectorParams1D,'on')
        const_obj.VectorParams1D = 'on';
      end
    else
      if ~strcmp(const_obj.VectorParams1D,'off')
        const_obj.VectorParams1D = 'off';
      end
    end
   
    % SL Constant data type
    dType = obj.dataType;
    blkh = gcbh;
    switch dType
     case 'Fixed-point'
      % get the word length
      wordLen = obj.wordLen;
      wordLen_value = slResolve(wordLen, blkh, 'expression');

      % We have the throw the error here because the function fixdt 
      % silently modifies invalid word length without issuing error.
      if ~isnumeric(wordLen_value) || ~isscalar(wordLen_value) || wordLen_value <= 0
          throw(MSLException(gcbh, ...
                             message('Simulink:fixedandfloat:InvWordLength',wordLen)));
      end

      % get the sign
      if strcmpi(obj.isSigned,'on')
          sign = '1';
      else
          sign = '0';
      end

      % get the scaling
      fracBitsMode = obj.fracBitsMode;
      if strcmp(fracBitsMode,'Best precision')
          outscaling = '';
      else
          numBits = obj.numFracBits;
          numBits_value = slResolve(numBits, blkh, 'expression');
          if ~isnumeric(numBits_value) || ~isscalar(numBits_value) || numBits_value ~= round(numBits_value)
              throw(MSLException(gcbh, ...
                                 message('Simulink:fixedandfloat:InvFractionLength',numBits)));
          end
          outscaling = [',(' numBits ')'];
      end
      % assemble the data type string
      const_obj.OutDataTypeStr = [ 'fixdt(' sign ',' wordLen outscaling ')'];
     case 'User-defined'
      % get the data type container
      datatype = obj.udDataType;

      if dspDataTypeDeterminesFracBits(datatype)
          % only set the unified data type 
          const_obj.OutDataTypeStr = datatype;
      else
          % get the scaling
          fracBitsMode = obj.fracBitsMode;
          if strcmp(fracBitsMode,'Best precision')
              outscaling = '';
          else
              numBits = obj.numFracBits;
              numBits_value = slResolve(numBits, blkh, 'expression');
              if ~isnumeric(numBits_value) || ~isscalar(numBits_value) || numBits_value ~= round(numBits_value)
                  throw(MSLException(gcbh, ...
                                     'Simulink:fixedandfloat:InvFractionLength', ...
                                     DAStudio.message('Simulink:fixedandfloat:InvFractionLength',numBits)));
              end
              outscaling = ['2^(-(' numBits '))'];
          end
          if isempty(outscaling)
              const_obj.OutDataTypeStr = datatype;
          else
              const_obj.OutDataTypeStr = ['slDataTypeAndScale(''' datatype ''',''' outscaling ''')'];
          end
      end
     case {'double','single','int8','uint8','int16','uint16','int32','uint32','boolean'}
      % Simulink built-in data types
      const_obj.OutDataTypeStr = dType;
     case {'Inherit from ''Constant value''' 'Inherit via back propagation'}
      % Inheritance rules     
      const_obj.OutDataTypeStr = [ 'Inherit: ' dType];
     otherwise
      assert('Unexpected data types');   
    end
    
   case 'dynamic'
    if isContinuous
      vis(DISC_OUT) = OFF;
      vis(SAMP_TIME) = OFF;
      vis(FRAME_PERIOD) = OFF;
      vis(CONT_OUT) = ON;
    else
      vis(DISC_OUT) = ON;
      vis(CONT_OUT) = OFF;
      % update visibilities before accessing DISC_OUT
      obj.maskvisibilities = vis;
      lastVis = vis;
      outMode = obj.discreteOutput;
      if strcmp(outMode,FRAME_POPUP)
        vis(SAMP_TIME)    = OFF;
        vis(FRAME_PERIOD) = ON;
      else
        vis(SAMP_TIME)    = ON;
        vis(FRAME_PERIOD) = OFF;
      end              
    end
    
    % Update visibilities before processing fixpt params
    if ~isequal(vis,lastVis)
      obj.maskvisibilities = vis;
    end
   
    [vis,lastVis] = dspProcessFixptSourceParams(obj,9,1,vis);
    
    if ~isequal(vis,lastVis)
      obj.maskvisibilities = vis;
    end
   
   case 'update'    
     % Set constant block sample time 
     if isContinuous
       set_continuous_samp_time(blk);
     else
       set_discrete_samp_time(blk);
     end

  end   % switch
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_discrete_samp_time(blk)
  FRAME_POPUP = 'Frame-based';
  fullblk  = getfullname(blk);
  const_blk  = [fullblk '/Constant'];

  % DISC_OUT will be visible here
  outMode = get_param(blk,'discreteOutput');
  if strcmp(outMode,FRAME_POPUP)
    set_param(const_blk,'SampleTime','framePeriod');
  else
    set_param(const_blk,'SampleTime','sampTime');
  end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_continuous_samp_time(blk)
  fullblk   = getfullname(blk);
  const_blk  = [fullblk '/Constant'];
  set_param(const_blk,'SampleTime','inf');



% [EOF] dspblkdspconst2.m
