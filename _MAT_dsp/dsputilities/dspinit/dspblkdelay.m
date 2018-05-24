function [str, ic] = dspblkdelay(action,varargin)
% DSPBLKDELAY Mask dynamic dialog function for delay block

% Copyright 1995-2011 The MathWorks, Inc.
if nargin==0
  action = 'dynamic';   % mask callback
end

switch action
 case 'initInputProcessing'
   blkh = varargin{1};
   dspSetFrameUpgradeParameter(blkh, 'InputProcessing', ...
       'Inherited (this choice will be removed - see release notes)');
   
 case 'init'
  
  delayUnitSamps = strncmp(varargin{1},'Samples',1);
  delay_eval = varargin{2};
  ic = varargin{3};
  
  if (delayUnitSamps && ~isempty(delay_eval))
      % Delay in samples
      if(ndims(delay_eval) > 2)
          str = 'Delay'; 
      else
          str = ['-' mat2str(delay_eval)]; 
      end
  elseif (~delayUnitSamps && ~isempty(delay_eval))
      % Delay in frames
      if (isscalar(delay_eval))
          if (delay_eval==0)   
              % scalar  0
              str = ['-' mat2str(delay_eval)];
          elseif (delay_eval ==1)   
              % scalar 1
              str = ['-' 'N'];
          else
              % other scalar cases
              str = ['-' mat2str(delay_eval) 'N'];
          end
      else
          % vector cases
          str = ['-' mat2str(delay_eval) 'N'];
      end
  elseif (isempty(delay_eval))
      % other cases: invalid or undefined
      str = '-?';
  end
  
  % for cell array IC, we first process the cell array in the mask helper
  % function. From edit box we get a cell array which must have 'nChans'
  % cells (nChans = # of channels) and each cell must be a vector. The S
  % function gets the cell info in the following format:
  % a cell array consisting of 3 cells {[1st_cell] [2nd_cell] [3rd_cell]}
  % 1st_cell: all 'nChans' cells are concatenated to get this cell.
  %           In this mask helper function we do not get the value of
  %           'nChans'. M,N in 2nd_cell provide this info to S function.
  % 2nd_cell: it has 3 elements [size of cell array (M N) 'mf']
  %           The definition of M,N,'mf' are given hereafter.
  % 3rd_cell: one element (non-zero value identifies a specific error)

  % Since S function doesn't get the info of each cell, we need to check
  % the validity of each cell in this mask helper function

  %%%%%%%validity checking and pre-processing for ONLY cell array IC.%%%%%%%
  if (iscell(ic))
    %checking 1: double checking (see delay validity checking in S function)
    if ( isempty(delay_eval)|| (~isnumeric(delay_eval)) )
      ic = {[] [] 1}; %errFlag = 1 for empty or non-numeric delay
      return;
    end
    %checking 2
    SizeIC = size(ic);
    SizeDelay = size(delay_eval);

    DelayIsVector = (length(SizeDelay)==2) && (SizeDelay(1) == 1 || SizeDelay(2) == 1); %supporting row convenience
    IcIsVector    = (length(SizeIC)==2) && (SizeIC(1) == 1 || SizeIC(2) == 1); %supporting row convenience

    % Since it is not possible to get nChans here, it is not possible
    % to verify IC in accordance with delay for scalar delay.
    % we have to do that checking in S function using the size of the
    % delay that is passed from this mask helper function.
    if ( length(delay_eval)~= 1 )
      if (DelayIsVector)
        if (~IcIsVector)
          ic = {0 0 2}; % errFlag = 2 for DelayIsVector(non scalar)
                        % but IcIsNotVector
          return;
          %else IC is vector
        elseif  (length(delay_eval) ~= length(ic))
          % each channel must have a vector
          ic = {0 0 3}; % errFlag = 3 for Delay and IC both are Vector
                        % but length(delay_eval) ~= length(ic)
          return;
        else % DelayIsVector and ICisVector
          if SizeIC(1) == 1 % if DelayIsRowVector, IC must be RowVector,
                      % else make IC rowVector
            if (SizeDelay(1)~=1), delay_eval = delay_eval'; end
          else
            % SizeIC(2) must be 1. if DelayIsColVector, IC must be
            % ColVector, else make IC ColVector
            if (SizeDelay(2)~=1), delay_eval = delay_eval'; end
          end
        end
        % delay is matrix
      elseif (~areCorrespondingDimsAreIdentical(SizeIC,SizeDelay))
        ic = {0 0 4}; % errFlag = 4: if delayIsMatrix IC must be 
                      % matrix of the same dim.
        return;
      end
    end

    a=[];
    first_time = 1;
    lst_quotient = 0; % values used when (delay_value == 0-> delay Unit 
                      % sample or frame), or (delay_unit_sample)
    for j=1:prod(SizeIC),
        [m, n] = size(ic{j});
        if ((m  ~= 1) && (n  ~= 1)) %empty vector throws this error
          ic = {0 0 5}; % ic = {[a] [M N] [errFlag]}; errFlag = 5
                        % for non-vector cell
          return; %set the errFlag and return to the invoking function
        end
        if (length(delay_eval) == 1)
          delay_value = delay_eval;
        else
          delay_value = delay_eval(j);
        end
        if (delay_value == 0 && length(ic{j}) ~= 1) 
          %true whether delay unit is sample or frame
          ic = {0 0 6};  %errFlag = 6, for zero delay length(ic{i,j} ~= 1
          return;
        elseif (delay_value ~= 0)
          if (iscell(ic{j}))
            ic = {0 0 7};  % errFlag = 7, cell contains a cell, but it must
                           % be a vector
            return;
          elseif (~isnumeric(ic{j}))
              % If any cells in the array are non-numeric, throw this error
              ic = {0 0 10};
              return;
          end
          % when delay unit sample: The length of each cell vector
          % must equal to the delay value of the corresponding
          % channel.
          % when delay unit frame: The length of each cell vector
          % must be an integer multiple of the delay value of the
          % corresponding channel. The multiplying factor (mf)
          % must be the same for each channel. It is not possible
          % to verify the value of 'mf' (which is equal to the
          % frame length). So when delay unit frame, this 'mf' is
          % passed to the S function for validity checking.

          if delayUnitSamps,
            if (length(ic{j}) ~= delay_value)
              ic = {0 0 8};  %errFlag = 8, length(ic{i,j} ~= delay_value
              return;
            end
          else  % delay unit frame.
            quotient = length(ic{j})/ delay_value;
            if (quotient ~= floor(quotient)) % quotient is not an integer
              ic = {0 0 9};  % errFlag = 9, for delay unit = frame,
                             % length of each cell ~= FrmLen*delay value,
                             % exception zero delay case.
              return;
            end
            if (first_time)
              lst_quotient = quotient; %quotient = length(ic{1,1})/ delay_value;
              first_time = 0;
            end
            if (quotient ~= lst_quotient)
              ic = {0 0 9};  %same as above(errFlag = 9)
              return;
            end
          end
        end

        if (m ~= 1)
          ic{j} = (ic{j}).'; % guard against transpose
        end
        if (delay_value ~= 0)
          % for zero delay value, skip the corresponding cell vector.
          a=[a ic{j}];%#ok trade speed for memory
        end
    end
    IC_Vec = [];
    for i = 1:length(SizeIC)
        IC_Vec = [IC_Vec  SizeIC(i)];
    end
    ic = {a [IC_Vec lst_quotient] 0}; 
    % nChan = SizeIC(1)*SizeIC(2); errFlag = 0--> means No error,
    % lst_quotient = multiplying factor
    % when 1st_quotient=0, no need to check it, 
    % else check (if 1st_quotient=FrmLen)
    % {a} for RTP. {nChan}, {b} & errFlag for error checking
  elseif  isempty(ic)
    ic = 0;
  end % if (iscell(ic))
 case 'dynamic'
  % Moved the gcbh call here, as SEA never calls this section, and gcbh is
  % not defined when Simulink is not installed
  blk = gcbh;
  mEnables = get_param(blk, 'MaskEnables');
  mVisibilities = get_param(blk,'MaskVisibilities');
  needDelayUnitWidget = ~strcmpi(get_param(blk,'InputProcessing'), ...
      'Elements as channels (sample based)');
  if needDelayUnitWidget
      mEnables{2} = 'on';
      mVisibilities{2} = 'on';
  else
      mEnables{2} = 'off';
      mVisibilities{2} = 'off';
  end
  set_param(blk, 'MaskEnables',      mEnables);
  set_param(blk, 'MaskVisibilities', mVisibilities);
  
  mask_prompts = get_param(blk,'maskPrompts');
  if (strcmp(get_param(blk,'dly_unit'),'Samples') && ...
      strcmp (mask_prompts(3), 'Delay (frames):') )
    mask_prompts(3) = {'Delay (samples):'};
    set_param(blk,'maskPrompts',mask_prompts);
  elseif (strcmp(get_param(blk,'dly_unit'),'Frames') && ...
          strcmp (mask_prompts(3), 'Delay (samples):') )
    mask_prompts(3) = {'Delay (frames):'};
    set_param(blk,'maskPrompts',mask_prompts);
  end
 otherwise
  error(message('dsp:dspblkdelay:unhandledCase'));
end

function areDimsIdentical = areCorrespondingDimsAreIdentical(inDims1,inDims2)
areDimsIdentical = true;
if (length(inDims1) ~= length(inDims2)) 
    areDimsIdentical = false;
end
for i = 1:length(inDims1)
    if (inDims1(i) ~= inDims2(i))
        areDimsIdentical = false;
    end
end

