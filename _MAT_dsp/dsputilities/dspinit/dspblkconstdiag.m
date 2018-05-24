function varargout = dspblkconstdiag(action,q)
% DSPBLKCONSTDIAG DSP System Toolbox Constant Diagonal Matrix block
% helper function.

% Copyright 1995-2011 The MathWorks, Inc.

if nargin == 0
  action = 'dynamic';
end
blk = gcbh;
fullblk = getfullname(blk);
obj = get_param(blk,'object');

switch (action)
 case 'icon'
  % q is the desired diagonal
  q_elements = q(:);
  a = diag(q_elements);
  
  % For plotting
  x = [0,NaN,100,NaN,[20 10 10 20],NaN,[84 96 96 84],NaN,[20 80]];
  y = [0,NaN,100,NaN,[90 90 10 10],NaN,[90 90 10 10],NaN,[80 20]];
  varargout = {a,x,y};
  
 case 'init'
  const_obj = get_param([fullblk '/Constant'],'object');
  enable_frame_obj = get_param([fullblk '/Frame Status Conversion'],'object');
  
  % Set frame-based behavior in underlying Frame Status Conversion block
  currentFrameStr  = enable_frame_obj.OutFrame;

  if strcmp(obj.frame,'on')
    % Only set to Frame-based if it isn't already set
    if ( strcmp(currentFrameStr, 'Frame based') == 0 )
      enable_frame_obj.OutFrame = 'Frame based';
    end
  else
    % Only set to Sample-based if it isn't already set
    if ( strcmp(currentFrameStr, 'Sample based') == 0 )
      enable_frame_obj.OutFrame = 'Sample based';
    end
  end
  
  % Now to set the constant block
  % SL Constant data type
  switch obj.dataType
   case 'Fixed-point'
    % set the mode
    wordLen = obj.wordLen;
    WLval = str2double(wordLen);
    if isoktocheckparam(WLval)
        if (~isreal(WLval)) || (numel(WLval) ~= 1) || (WLval<1) || (WLval>128) || (floor(WLval)~=WLval) || (~isnumeric(WLval))
            error(message('dsp:dspblkconstdiag:paramPositiveIntegerError'));
        end
    end
    
    fracLen = obj.numFracBits;
    
    if strcmpi(obj.isSigned,'on')
      signed = '1';
    else
      signed = '0';
    end 
    
    % set the scaling
    if strcmp(obj.fracBitsMode,'Best precision')
        const_obj.OutDataTypeStr = ['fixdt(' signed ',' wordLen ')'];
    else
        const_obj.OutDataTypeStr = ['fixdt(' signed ',' wordLen ',' fracLen ')'];
    end
    
   case 'User-defined'   
    % set the mode
    % set the data type
    udDataType = obj.udDataType;    
    if ~isempty(udDataType)       
        % set the scaling, if necessary
        if ~dspDataTypeDeterminesFracBits(obj.udDataType)
            if ~strcmp(obj.fracBitsMode,'Best precision')
                numBits = obj.numFracBits;
                outScaling = ['2^(-(' num2str(numBits) '))'];
                const_obj.OutDataTypeStr = ['slDataTypeAndScale(''' udDataType ''',''' outScaling ''')'];
            else
                const_obj.OutDataTypeStr = udDataType;
            end
        else
            const_obj.OutDataTypeStr = udDataType;
        end
    end
    
   case 'Inherit from ''Constant(s) along diagonal'''
        const_obj.OutDataTypeStr = 'Inherit: Inherit from ''Constant value''';
   
   case 'Inherit via back propagation'
        const_obj.OutDataTypeStr = 'Inherit: Inherit via back propagation';
    
   otherwise
    % DSP Constant choice maps one-to-one to Simulink Constant choice
    const_obj.OutDataTypeStr = obj.dataType;
  end
  
 case 'dynamic'
  vis = obj.MaskVisibilities;
  [vis,lastVis]=dspProcessFixptSourceParams(obj,5,1,vis);
  
  if ~isequal(vis,lastVis)
    obj.MaskVisibilities = vis;
  end
  
end
