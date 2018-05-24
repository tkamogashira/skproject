function varargout = dspspect3_helper(action, varargin)
% DSPSPECT3_HELPER Mask dynamic dialog helper function for
% 5 blocks in Power Spectrum Estimation (dspspect3) library: 
% Periodogram, Yule-Walker Method, Burg Method, Covariance and 
% Modified Covariance blocks
% This function implements the effects of 'Inherit sample time 
% from input' and 'Sample time of original time series' parameters.
% 
% Input args:
%   blk              - block (gcb)
%   inhTs_check      - 'Inherit sample time from input' parameter. Possible values - 'on' or 'off'.
%   blkPosition      - Position of the Frame Period To Sample Time OR Constant block that
%                      gets added to the subsystem. It is a 4 element vector that can be 
%                      used for setting 'Position' block property through set_param()
%   isBlkPeriodogram - Block is Periodogram block or not. Possible values - true or false

% Copyright 2009-2011 The MathWorks, Inc.

if nargin > 6
    error(message('dsp:dspspect3_helper:invalidFcnInput'));
end

varargout = {};

switch action
  case 'icon'

    d = 0.1; xe=4; x=-xe:d:xe;
    y = ones(size(x)); i=find(x); y(i)=sin(pi*x(i))./(pi*x(i));
    y = abs(y).^(0.75);

    varargout = {xe,x,y};

  case 'init'
    
    blk              = varargin{1};
    inhTs_check      = varargin{2};
    Ts               = varargin{3};
    blkPosition      = varargin{4};
    isBlkPeriodogram = varargin{5};

    if isBlkPeriodogram
        FP2STBlk = sprintf('Periodogram -\nFrame Period\nTo Sample Time');
    else
        FP2STBlk = sprintf('Frame Period To\nSample Time');
    end

    if strcmpi(inhTs_check,'on')
        % Inherit sample time from input is checked
        % check if anything needs to be done
        blockToAdd = FP2STBlk;
        isFp2TsAbsent = isempty(find_system(blk, 'LookUnderMasks', 'all', 'FollowLinks',...
                                            'on', 'SearchDepth', 1, 'Name', blockToAdd));
        if isFp2TsAbsent
            % Need to add Frame Period To Sample Time block. 
            % Before doing that, check if Constant block exists. If yes, then need to delete it
            % and its connections. 
            blockToDelete = 'Constant';
            isConstantPresent = ~isempty(find_system(blk, 'LookUnderMasks', 'all', ...
                                                     'FollowLinks', 'on', ...
                                                     'SearchDepth', 1, 'Name', blockToDelete));
            
            if isConstantPresent
                % Constant block exists - delete it and its connections
                delete_line(blk, 'Constant/1', 'Product/3');
                delete_block([blk '/Constant']);
            end
            destBlkName = [blk '/' blockToAdd];
            load_system('dspmisc');
            add_block(['dspmisc/' blockToAdd], destBlkName, 'Position', blkPosition);
            add_line(blk, 'In/1', [blockToAdd '/1']);
            add_line(blk, [blockToAdd '/1'], 'Product/3');
            
            % else
            % Frame Period To Sample Time block already present - no need to do anything
        end
        
    else
        % Inherit sample time from input is un-checked

        % validate Sample time of original time series parameter
        if (Ts <= 0) || ~isnumeric(Ts) || ~isscalar(Ts) || ~isreal(Ts) || isnan(Ts) || isinf(Ts)
            error(message('dsp:dspspect3_helper:invalidSampleTime'));
        end

        % check if anything needs to be done
        blockToAdd = 'Constant';
        isConstantAbsent = isempty(find_system(blk, 'LookUnderMasks', 'all', 'FollowLinks',...
                                               'on', 'SearchDepth', 1, 'Name', blockToAdd));
        
        if isConstantAbsent
            % Need to add Constant block. 
            % Before doing that, check if Frame Period To Sample Time block exists. If yes, 
            % then need to delete it and its connections.
            blockToDelete = FP2STBlk;
            isFp2TsPresent = ~isempty(find_system(blk, 'LookUnderMasks', 'all', 'FollowLinks',...
                                                  'on', 'SearchDepth', 1, 'Name', blockToDelete));
            
            if isFp2TsPresent
                % Frame Period to Sample Time block exists - delete it and its connections
                delete_line(blk, 'In/1', [blockToDelete '/1']);
                delete_line(blk, [blockToDelete '/1'], 'Product/3');
                delete_block([blk '/' blockToDelete]);
            end
            destBlkName = [blk '/' blockToAdd];
            load_system('simulink');
            add_block(['simulink/Sources/' blockToAdd], destBlkName, 'Position', blkPosition);
            add_line(blk, [blockToAdd '/1'], 'Product/3');
            set_param(destBlkName, 'value', 'Ts', 'OutDataTypeStr', 'Inherit: Inherit via back propagation');
            
            % else
            % Constant already present - no need to do anything
        end
    end
    
end % end of 'switch-case'

% [EOF] dspspect3_helper.m
