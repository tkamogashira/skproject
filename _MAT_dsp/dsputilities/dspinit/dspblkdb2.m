function varargout = dspblkdb2(action)
% DSPBLKDB2 Mask helper function for dB block.

% Copyright 1995-2011 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end

blk=gcb;
isAmp =  strcmp(get_param(blk,'intype'),'Amplitude');


switch action

   case 'checkparam'

      R = get_param(blk,'R');
      if str2num(R) <= 0
         error(message('dsp:dspblkdb2:paramOutOfRange'));
      end


   case 'dynamic'
      % Enable the Elements edit dialog:
      ena = get_param(blk,'MaskEnables');
      vis = get_param(blk,'MaskVisibilities');
      if isAmp==1,
         new_ena = 'on';
      else
         new_ena = 'off';
      end

      % Don't dirty model until absolutely necessary:
      if ~strcmp(ena{3},new_ena)
         ena{3} = new_ena;
         set_param(blk,'MaskEnables',ena);
      end

      % Make edit box invisible if disabled, visible if enabled:
      if ~strcmp(vis{3},new_ena)
          vis{3} = new_ena;
          set_param(blk,'MaskVisibilities',vis);
      end

   case 'init'

      dBtype = get_param(blk,'dBtype');

      if isAmp == 1
         R = get_param(blk,'R');
         if str2num(R) <= 0
            str = sprintf('%s \n %s','Invalid','resistance.');
         else
            str = sprintf('%s \n (%s ohm)',dBtype,R);
         end
      else
         str = dBtype;
      end

      varargout{1} = str;
      fuzz  =  get_param(blk,'fuzz');
      if strcmp(fuzz,'on')
        varargout{2} = eps;
      else
        varargout{2} = 0.0;
      end

      if strcmp(get_param(blk,'dBtype'),'dBm');
         % Decibels relative to 1 mW (milliWatt)
         % Set dBval (offset under mask)
         varargout{3} = 30.0;
      else
         varargout{3} = 0.0;
      end

   case 'update'

      %%%%%%%%% Input signal popup menu %%%%%%%
      magsqname = [blk '/Magsq'];
      scalename = [blk '/Scale by R'];
      if isAmp == 1
         % AMPLITUDE: Add the magsq and 1/R blocks
         % (if they are not already present...)
         try
             find_system(magsqname);
         catch
             %% find_system failed to find magsqname, therefore
             %% the Magsq block does not exist, and by implication
             %% the Scale by R block must not exist either.  Add both:

             %% clear sllasterror flag:
             sllasterror([]);

             magsqpos = [155 15 180 45];
             scalebyrpos = [210 15 240 45];

             delete_line(blk,'Sum1/1','log10/1');
             add_block('built-in/Math',magsqname,'position',magsqpos,'Operator','magnitude^2');
             add_block('built-in/Gain',scalename,'position',scalebyrpos,'Gain','1/R');
             add_line(blk,'Sum1/1','Magsq/1');
             add_line(blk,'Magsq/1','Scale by R/1');
             add_line(blk,'Scale by R/1','log10/1');
         end
      else
         % POWER: Remove the magsq and 1/R blocks
         % (if they are present ...)
         magsqBlockPresent = true;
         try
             find_system(magsqname);
         catch
             %% clear sllasterror flag:
             sllasterror([]);
             magsqBlockPresent = false;
         end
         if magsqBlockPresent
             delete_line(blk,'Sum1/1','Magsq/1');
             delete_line(blk,'Magsq/1','Scale by R/1');
             delete_line(blk,'Scale by R/1','log10/1');
             delete_block(magsqname);
             delete_block(scalename);
             add_line(blk,'Sum1/1','log10/1');
         end
      end

   otherwise
      error(message('dsp:dspblkdb2:unhandledCase'));
end

% [EOF] dspblkdb2.m
