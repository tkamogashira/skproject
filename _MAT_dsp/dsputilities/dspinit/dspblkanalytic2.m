function varargout = dspblkanalytic2(action,isBlk,varargin)
% DSPBLKANALYTIC2 DSP System Toolbox Analytic Signal block helper function.

% Copyright 1995-2011 The MathWorks, Inc.

switch action
    case 'design'
        
        N = varargin{1};
        if isnan(N) || isinf(N),
            error(message('dsp:dspblkanalytic2:invalidFilterOrder1'));
        end
        if ~isequal(floor(N), N),
            error(message('dsp:dspblkanalytic2:invalidFilterOrder2'));
        end
        if N < 1,
            error(message('dsp:dspblkanalytic2:invalidFilterOrder3'));            
        end
        varargout{1} = firpm(N, [0.05 0.95], [1 1], 1, 'Hilbert');
        
    case 'setup'
        % set the underneath blocks
                
        % Block specific operations
        if isBlk
            
            inputProcValue = varargin{1};            
            blockName = gcb;
                        
            % For frame upgrade
            dspSetFrameUpgradeParameter(gcbh, 'InputProcessing', ...
                'Inherited (this choice will be removed - see release notes)');
            
            % pass down the InputProcessing param value to Digital Filter and Delay blocks
            inputProcessingEnum = {'Columns as channels (frame based)', ...
                'Elements as channels (sample based)', ...
                'Inherited (this choice will be removed - see release notes)'};
            set_param([blockName '/Digital Filter'], 'InputProcessing', inputProcessingEnum{inputProcValue});
            set_param([blockName '/Delay'], 'InputProcessing', inputProcessingEnum{inputProcValue});
            
        end        
end
