function [b] = dspblkpad(action)
% DSPBLKPAD DSP System Toolbox Pad block helper function

% Copyright 1995-2004 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

switch action
 case 'icon'
     blk = gcbh;
     b = get_labels(blk);
 case 'dynamic'

  [PAD_OVER, DETERMINE_OUT_SIZE, OUT_SIZE_MODE, ...
      OUT_ROW_MODE, OUT_COL_MODE, PAD_VAL_SRC] = deal(1,5,13,6,8,3);

  % Cache current block
  this = get_param(gcbh,'Object');
  valueOnDialog = this.MaskValues;

  % Cache current block mask enables
  cachedVisibles = this.MaskVisibilities;
  newVisibles    = cachedVisibles;

  padAlongWhatDim           = valueOnDialog{PAD_OVER};
  determineOutSize          = valueOnDialog(DETERMINE_OUT_SIZE);
  outputSizeMode            = valueOnDialog(OUT_SIZE_MODE);
  outRowMode                = valueOnDialog(OUT_ROW_MODE);
  outColMode                = valueOnDialog(OUT_COL_MODE);
  padValueSource            = valueOnDialog(PAD_VAL_SRC);  
  
  % Enable parameters always visible and disable conditionlly visible ones
  newVisibles{1} = 'on'; % Pad over
  newVisibles{2} = 'off'; % Dimensions to pad
  newVisibles{3} = 'on'; % Pad value source
  newVisibles{4} = 'off'; % Pad value
  newVisibles{5} = 'off'; % Determine output size
  newVisibles{6} = 'off'; % Output row mode
  newVisibles{7} = 'off'; % Output row size
  newVisibles{8} = 'off'; % Output column mode
  newVisibles{9} = 'off'; % Output column size
  newVisibles{10} = 'off'; % Variable dimension mode. always off.
  newVisibles{11} = 'off'; % Pad at beginning
  newVisibles{12} = 'off'; % Pad at end
  newVisibles{13} = 'off'; % Output size mode
  newVisibles{14} = 'off'; % Output size
  newVisibles{15} = 'on'; % Pad signal at
  newVisibles{16} = 'off'; % Action when truncation occurs
  
  if (strcmp(padValueSource, 'Specify via dialog'))
      newVisibles{4} = 'on'; % Pad value
  else
      newVisibles{4} = 'off'; % Pad value
  end
  
  if (strcmp(padAlongWhatDim, 'Specified dimensions'))
      newVisibles{2} = 'on'; % Dimensions to pad
      newVisibles{5} = 'on'; % Determine output size
      if (strcmp(determineOutSize, 'Pad size'))
          newVisibles{11} = 'on'; % Pad at beginning
          newVisibles{12} = 'on'; % Pad at end
          newVisibles{15} = 'off'; % Pad signal at
      else
          newVisibles{13} = 'on'; % Output size mode
          if (strcmp(outputSizeMode, 'User-specified'))
              newVisibles{14} = 'on'; % Output size
              newVisibles{16} = 'on'; % Action when truncation occurs
          end
      end
  elseif (strcmp(padAlongWhatDim, 'Columns'))
      newVisibles{6} = 'on'; % Output row mode      
      if (strcmp(outRowMode, 'User-specified'))
          newVisibles{7} = 'on'; % Output row size          
          newVisibles{16} = 'on'; % Action when truncation occurs
      end 
  elseif (strcmp(padAlongWhatDim, 'Rows'))
      newVisibles{8} = 'on'; % Output column mode
      if (strcmp(outColMode, 'User-specified'))
          newVisibles{9} = 'on'; % Output column size          
          newVisibles{16} = 'on'; % Action when truncation occurs
      end
  elseif (strcmp(padAlongWhatDim, 'Columns and rows'))
      newVisibles{6} = 'on'; % Output row mode      
      if (strcmp(outRowMode, 'User-specified'))
          newVisibles{7} = 'on'; % Output row size          
          newVisibles{16} = 'on'; % Action when truncation occurs
      end
      newVisibles{8} = 'on'; % Output column mode
      if (strcmp(outColMode, 'User-specified'))
          newVisibles{9} = 'on'; % Output column size          
          newVisibles{16} = 'on'; % Action when truncation occurs
      end
  else % None
      newVisibles{3} = 'off'; % Pad value source
      newVisibles{4} = 'off'; % Pad value
      newVisibles{15} = 'off';% Pad signal at
  end

  % Only update the block mask enables if they have changed
  if ~(isequal(cachedVisibles, newVisibles))
      this.MaskVisibilities = newVisibles;
      this.MaskEnables      = newVisibles;
  end
end

% ----------------------------------------------------------
 function ports = get_labels(blk)    
     padsrc = get_param(blk, 'valSrc');
     if strcmp(padsrc,'Input port')
         ports.type1='input';
         ports.port1=1;
         ports.txt1='I';

         ports.type2='input';
         ports.port2=2;
         ports.txt2='PVal';

         ports.type3='output';
         ports.port3=1;
         ports.txt3='';
     else
         ports.type1='input';
         ports.port1=1;
         ports.txt1='';

         ports.type2='input';
         ports.port2=1;
         ports.txt2='';

         ports.type3='output';
         ports.port3=1;
         ports.txt3='';
     end
