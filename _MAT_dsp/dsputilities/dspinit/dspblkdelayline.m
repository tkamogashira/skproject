function varargout = dspblkdelayline(action,varargin)
% DSPBLKDELAYLINE Mask dynamic dialog function for Delay Line block

% Copyright 2011 The MathWorks, Inc.

  if nargin==0, action = 'init'; end

  switch action
	case 'icon'
      enable = get_param(gcbh,'enable_output');
      if (strcmp(enable,'on'))
        s.i1 = 1; s.i1s = 'In';
        s.i2 = 2; s.i2s = 'En_Out';
        s.o1 = 1; s.o1s = 'Out';  
      else
        s.i1 = 1; s.i1s = '';
        s.i2 = 1; s.i2s = '';    
        s.o1 = 1; s.o1s = '';
      end
      clear enable;
      
      varargout(1) = {s};
    
    case 'init'
        
        blkh = gcbh;
        blkUserData = get_param(blkh, 'UserData');
        if ~isfield(blkUserData, 'hasMChanOption')
            % Create and save the UserData field
            blkUserData.hasMChanOption = true;
            set_param(blkh, 'UserDataPersistent', 'on', ...
            'UserData', blkUserData);
            set_param(blkh, 'TreatMby1Signals', ...
            'M channels (this choice will be removed - see release notes)');
        end
        
      case 'dynamic'
          enable = get_param(gcbh,'enable_output');
          mask_visibles = get_param(gcbh,'MaskVisibilities');
          if (strcmp(enable,'on'))
              mask_visibles{5} = 'on';
          else
              mask_visibles{5} = 'off';
          end
          set_param(gcbh,'MaskVisibilities',mask_visibles);
          
  end
  
end

% LocalWords:  MChan Mby
