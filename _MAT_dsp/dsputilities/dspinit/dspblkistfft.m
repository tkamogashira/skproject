function varargout = dspblkistfft(varargin)
% DSPBLKISTFFT Mask dynamic dialog function for inverse STFFT block

% Copyright 1995-2011 The MathWorks, Inc.

blk = gcb;
firstArg = varargin{1}; 

if ischar(firstArg)
    action = varargin{1};
else
    action = 'errorfcn';
end
   
switch action
    case 'init'
        % Mask initialization code
        doAssert = varargin{2};
        ovLap    = varargin{3};
        W        = varargin{4};
        cSymm    = varargin{5};
        
        ifftBlk  = [gcb, '/IFFT'];
        
        if doAssert
            isTerminatorPresent = exist_block(blk, 'Terminator');
            if isTerminatorPresent
                aBlkName = [gcb, '/Terminator'];
                bBlkName = [gcb, '/Window Assert'];
                pos = get_param(aBlkName,'Position');
                delete_block(aBlkName);
                load_system('dspmisc');
                add_block('dspmisc/Window Assert', ...
                    bBlkName, 'Position', pos, 'winsize', 'W', ...
                    'decimat','L','tol','Tol');
            end
        else
            isTerminatorPresent = exist_block(blk, 'Terminator');
            if ~isTerminatorPresent
                aBlkName = [gcb, '/Window Assert'];
                bBlkName = [gcb, '/Terminator'];
                pos = get_param(aBlkName,'Position');
                delete_block(aBlkName);
                add_block('built-in/Terminator', ...
                    bBlkName, 'Position', pos);
            end
        end
        
        if cSymm
            set_param(ifftBlk, 'cs_in', 'on');
        else
            set_param(ifftBlk, 'cs_in', 'off');
        end 
        
        varargout = {W-ovLap};
	case 'dynamic'
      % Execute dynamic dialogs 
      doAssert    = get_param(gcb,'DoAssert');
      mask_vis    = get_param(gcb,'maskvisibilities');
      mask_vis{6} = doAssert;
      set_param(gcb,'maskvisibilities',mask_vis);
  case 'errorfcn'
      disp('In error function');
      err = sllasterror;
      if strcmp(err(1).MessageID, 'Simulink:blocks:AssertionAssert')
          varargout = {'Assertion: Reconstruction error exceeds tolerance'};
      else
          varargout = {err.Message};
      end
          
  otherwise
     error(message('dsp:dspblkistfft:unhandledCase'));
end

% end of dspblkistfft.m
