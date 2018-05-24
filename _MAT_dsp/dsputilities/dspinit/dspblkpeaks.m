function [str, dtInfo] = dspblkpeaks(action, outIdx, outVal, pol)
% DSPBLKPEAKS Mask dynamic dialog function for peak finder block
% Copyright 1995-2005 The MathWorks, Inc.

blk = gcb;
blkh   = gcbh;

switch action

  case 'icon' 
    dtInfo = dspGetFixptDataTypeInfo(blkh,1);   

    switch pol,
        case 1,
            str.txt='Maxima';
        case 2,
            str.txt='Minima';
        case 3,
            str.txt='Extrema';
    end;

% Index and Value
if (outIdx == 1) & (outVal == 1)
      str.i1 = 2;  str.s1 = 'Idx';
      str.i2 = 3;  str.s2 = 'Val';
      if (pol == 3)
          str.i3 = 4; str.s3='Pol';
      else
          str.i3 = 1;  str.s3 = '';
      end
end

% Index
if (outIdx == 1) & (outVal == 0)
      str.i1 = 2;  str.s1 = '';
      str.i2 = 2;  str.s2 = 'Idx';
      if (pol == 3)
          str.i3 = 3; str.s3='Pol';
      else
          str.i3 = 1;  str.s3 = '';
      end
end

% Value
if (outIdx == 0) & (outVal == 1)
      str.i1 = 2;  str.s1 = '';
      str.i2 = 2;  str.s2 = 'Val';
      if (pol == 3)
          str.i3 = 3; str.s3='Pol';
      else
                str.i3 = 1;  str.s3 = '';
      end
end

% Count only
if (outIdx == 0) & (outVal == 0)
      str.i1 = 1;  str.s1 = '';
      str.i2 = 1;  str.s2 = '';
      str.i3 = 1;  str.s3 = '';
end
  
end % end of switch statement
 

% end of dspblkpeaks.m
