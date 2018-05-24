function varargout = dspblkkalman(action, blkh, varargin)
% DSPBLKKALMAN DSP System Toolbox Kalman Filter block helper
% function.

% Copyright 2006-2011 The MathWorks, Inc.
%     
%  

    % constant variables used by multiple functions in this file
    subsys_list  = {'Control', 'Options', 'Core'};

    inport_list  = {'En_core', 'Reset', 'Index', 'Z', 'Enable', 'En_delay',...
        'H', 'Ht', 'X', 'P',};

    outport_list = {'Z_est', 'X_est', 'MSE_est',...
        'Z_prd', 'X_prd', 'MSE_prd', 'P_prd'};

    [idx.enable, idx.reset, idx.h, idx.zest, idx.xest, idx.mseest, idx.zprd, ...
        idx.xprd, idx.mseprd] = deal(1, 2, 3, 4, 5, 6, 7, 8, 9);

    % find the path of the block
    parent = get(blkh, 'Parent');
    blk = [parent '/' get(blkh, 'Name')];

    switch action

      % check to see if at least one output port is chosen
      % and modify the block if any control parameter is changed
      case 'init'
        idx_num = length(fieldnames(idx));
        paramControl = false([1, idx_num]);
        if varargin{1} == 2 % enable port is used
            paramControl(idx.enable) = true;
            paramControl(idx.reset)  = varargin{2};
        else
            paramControl(idx.enable) = false;
            paramControl(idx.reset)  = false;
        end
        paramControl(idx.h) = (varargin{3}==2); % H port is used
        [paramControl(idx.zest: idx.mseprd)]...
            = [varargin{4}, varargin{5}, varargin{6},...
                varargin{7}, varargin{8}, varargin{9}];

        if isempty(find(paramControl(idx.zest: idx.mseprd), 1))
            varargout = {'You must select at least one output check box.'};
            return;
        end

        % get the current parameters used in the block
        paramControlCur = getCurrentParameters(blkh, idx);

        % modify the block if any control parameter is changed
        if ~isempty(find(paramControl ~= paramControlCur, 1))
            w = warning;
            warning('off'); %#ok<WNOFF>

            errmsg = editSystem(blk, subsys_list, outport_list, idx,...
                paramControl, paramControlCur);

            if isempty(errmsg)
                % change the order of input and output ports in all subsystems.
                % The order of a port is determined by its position in
                % inport_list or outport_list. Port appears earlier has lower
                % port number.
                resetPortNumbers(blk, subsys_list, inport_list);
                resetPortNumbers(blk, subsys_list, outport_list);
            end

            warning(w);
        else
            errmsg = '';
        end
        varargout = {errmsg};

      % get the port numbers for icon display. It is called even when no
      % control parameter has been changed.
      case 'icon'
        inport  = getPortNumbers(blk, inport_list);
        outport = getPortNumbers(blk, outport_list);

        % the first input port, 'Z', is always visible, so it's not passed 
        % to the mask
        varargout = [{inport(2:3)}, {outport}] ;

      % check the algorithm parameters. 
      % varargout: [errmsg, num_targets, len_state, len_measure, param]
      % This option may be called from DDG or mask.
      % If it is from DDG, varargin{1} is false and the parameters are always
      % checked. If it is from mask, varargin{1} is true and the parameters
      % are checked only at the Ctr-D time (simulation status is 'update').
      case 'check_param'
        [errmsg, num_targets, len_state, len_measure, param]...
            = getAlgorithmParameters(blkh, varargin);
        if varargin{1} % called from mask
            varargout =...
                [{errmsg}, {num_targets}, {len_state}, {len_measure}, {param}];
        else
            varargout = {errmsg};
        end

      otherwise
        varargout = {'Unknown parameters.'};

    end % end of switch statement
end

%=============================================================================== 
% Function getAlgorithmParameters check and return the parameters used for
% the Kalman algorithm. It can be called (1) from DDG when the user press Apply
% or OK (which is referred to as Apply time in this file), or (2) from the mask 
% at the Apply time or when the block is being updated (Ctr-D time). 
%
% Input:
% blkh, isCalledFromMask, sourceMeasure, num_targets, A, H, X, P, R, Q
%
% (1) Called from DDG:
% The subsequent parameters are the user-input strings in the edit boxes. 
% Function evalin() is used to evaluate the values of the parameters. 
% If a parameter has numeric value at that time, its attributes are checked. 
% Otherwise, if evalin() returns any error, this parameter is omitted. 
%
% (2) Called from mask:
% The subsequent parameters are the numeric values if they are valid matlab
% commands or variables, and empty otherwise. These parameters are checked
% only at the Ctr-D time.
%
% By this method, this block accepts undefined variables or functions at
% the Apply time, but rejects any invalid parameter if it is already
% defined. A comprehensive check is carried out at the Ctr-D time.
function [errmsg, num_targets, len_state, len_measure, param]...
        = getAlgorithmParameters(blkh, varargin)

    errmsg      = [];
    num_targets = 1; %#ok<NASGU>
    param       = [];
    len_state   = 1;
    len_measure = 1;
    % lengths of state and measures are used to check the dimensions of
    % other parameters. They are initialized to zeros and the function 
    % does not use their value in the checking until they are updated to
    % no-zeros values.
    
    isCalledFromMask = varargin{1}{1}; 
    sourceMeasure = varargin{1}{2}; 
    num_targets = varargin{1}{3}; 
    A = varargin{1}{4}; 
    H = varargin{1}{5}; 
    X = varargin{1}{6}; 
    P = varargin{1}{7}; 
    R = varargin{1}{8}; 
    Q = varargin{1}{9}; 

    if isCalledFromMask 
        % called from mask, will check parameter only at Ctr-D time
        % check the status of the system
        parent = get(blkh, 'Parent');
        loc_slash = find(parent == '/');
        if isempty(loc_slash)
            root_sys = parent;
        else
            root_sys = parent(1: loc_slash(1)-1);
        end
        if strcmpi(get_param(root_sys, 'SimulationStatus'), 'stopped')
            return; % invoked at the Apply time by the mask, do nothing
        else
            isSimStatusUpdate = true;
            isInputMeasure = (sourceMeasure==2); % H port is used
        end
    else    % called from DDG at the Apply time
        isSimStatusUpdate = false;
        isInputMeasure  = strcmpi(sourceMeasure, 'Input port <H>');
    end

    str_len_state   = [' does not match the number of rows'...
        ' in the State transition matrix parameter.'];
    str_len_measure = [' does not match the number of rows'...
        ' in the Measurement matrix parameter.'];
    
    % num_targets
    [errmsg, num_row] = checkParam(num_targets, 'Number of filters parameter',...
        [1, 1], ' does not equal to 1.', ' does not equal to 1.',...
        'positiveinteger', isSimStatusUpdate); %#ok<NASGU>
    if ~isempty(errmsg), return; end
    
    % state transition matrix (A)
    [errmsg, len_state] = checkParam(A, 'State transition matrix parameter',...
        [0, 0], '', '', 'square', isSimStatusUpdate);
    if ~isempty(errmsg), return; end
    
    % initial conditions for state (X)
    [errmsg, num_row] = checkParam(X,...
        'Initial condition for estimated state parameter',...
        [len_state, 1], str_len_state, '1', '', isSimStatusUpdate); %#ok<NASGU>
    if ~isempty(errmsg), return; end
    
    % initial conditions for state error covariance (P)
    [errmsg, num_row] = checkParam(P,...
        'Initial condition for estimated state error covariance parameter',...
        [len_state, len_state], str_len_state, str_len_state, '',...
        isSimStatusUpdate); %#ok<NASGU>
    if ~isempty(errmsg), return; end
    
    % process noise covariance (Q)
    [errmsg, num_row] = checkParam(Q, 'Process noise covariance parameter',...
        [len_state, len_state], str_len_state, str_len_state,...
        'covariance', isSimStatusUpdate); %#ok<NASGU>
    if ~isempty(errmsg), return; end
    
    if ~isInputMeasure
        % measurement matrix (H)
        % Measurement matrix is from mask. Get length of measurement from H.
        [errmsg, len_measure] = checkParam(H, 'Measurement matrix parameter',...
            [0, len_state], '', str_len_state, '', isSimStatusUpdate);
        if ~isempty(errmsg), return; end

        % measurement noise covariance (R)
        [errmsg, num_row] = checkParam(R,...
            'Measurement noise covariance parameter',...
            [len_measure, len_measure], str_len_measure, str_len_measure,...
            'covariance', isSimStatusUpdate); %#ok<NASGU>
        if ~isempty(errmsg), return; end
    else
        % measurement noise covariance (R)
        % Measurement matrix is from input port. Get length of measurement
        % from measurement noise covariance (R)
        [errmsg, len_measure] = checkParam(R,...
            'Measurement noise covariance parameter',...
            [0, 0], str_len_measure, str_len_measure,...
            'covariance', isSimStatusUpdate);
        if ~isempty(errmsg), return; end
    end
    
    if isSimStatusUpdate
        % convert initial conditions for estimated state and estimated state
        % error covariance to predicted state and predicted state error
        % covariance
        X_prd0 = A * X;
        P_prd0 = A * P * A' + Q;

        param.A = A;
        param.At = A';
        param.H = H;
        param.Ht = H';
        param.X = X_prd0;
        param.P = reshape(P_prd0, [len_state^2, 1]);
        param.Q = Q;
        param.R = R;
        param.XAll = kron(ones(1, num_targets), X_prd0);
        param.PAll = kron(ones(1, num_targets), param.P);
    end
end

%===============================================================================
% Check the attributes of a parameter
function [errmsg, num_row]...
    = checkParam(param, name, dimen, str_row, str_col, attr, isSimStatusUpdate)
    
    if isSimStatusUpdate   % invoked at the Ctr-D time and originated from mask
        value  = param;
    else     % invoked at the apply time, originated from DDG
        try
            value = evalin('base', param);
        catch
            % ignore an invalid matlab command or undefined variable at
            % the apply time, and catch it if it is still invalid/undefined
            % at the Ctr-D time.
            errmsg = [];
            num_row = 0;
            return;
        end
    end
    
    % check the data attributes
    errmsg = checkDataAttributes(value, name, dimen, str_row, str_col, attr);
    num_row = size(value, 1);
end

%=============================================================================== 
function errmsg = checkDataAttributes(value, name, dimen, str_row, str_col, attr)

    errmsg = [];

    if isempty(value)
        errmsg.message = ['The ', name, ' is undefined.'];
        errmsg.identifier = 'dspblks:dspblkkalman:undefinedParam';
        return;
    end
    
    if ~isnumeric(value)
        errmsg.message = ['The ', name, ' must be a numeric value.'];
        errmsg.identifier = 'dspblks:dspblkkalman:nonNumericParam';
        return;
    end
    
    if ~isreal(value)
        errmsg.message = ['The ', name, ' must be real valued.'];
        errmsg.identifier = 'dspblks:dspblkkalman:nonRealParam';
        return;
    end
    
    if ~isempty(find(isnan(value)|isinf(value), 1))
        errmsg.message = ['The ', name, ' cannot be NaN or Inf.'];
        errmsg.identifier = 'dspblks:dspblkkalman:infOrNaNParam';
        return;
    end
    
    % check dimensions. If the dimen variable is zero, 
    % it means that one of the parameters was not defined and
    % the check will be skipped
    if dimen(1)
        if size(value, 1) ~= dimen(1)
            errmsg.message = ['The number of rows in the ', name, str_row];
            errmsg.identifier = 'dspblks:dspblkkalman:invalidDimen';
        return;
        end
    end
    if dimen(2)
        if size(value, 2) ~= dimen(2)
            errmsg.message = ['The number of columns in the ', name, str_col];
            errmsg.identifier = 'dspblks:dspblkkalman:invalidDimen';
        return;
        end
    end
    
    if strcmpi(attr, 'square')
        if size(value, 1) ~= size(value, 2)
            errmsg.message = ['The ', name, ' must be a square matrix.'];
            errmsg.identifier = 'dspblks:dspblkkalman:squareMatrix';
        return;
        end
    elseif strcmpi(attr, 'covariance')
        if size(value, 1) ~= size(value, 2)
            errmsg.message = ['The ', name, ' must be a square matrix.'];
            errmsg.identifier = 'dspblks:dspblkkalman:squareMatrix';
        return;
        end
        if ~isempty(find(value<0, 1))
            errmsg.message = ['The ', name, ' must be nonnegative.'];
            errmsg.identifier = 'dspblks:dspblkkalman:negativeparam';
        return;
        end
        if ~isequal(value, diag(diag(value)))
            errmsg.message = ['The ', name, ' must be a diagonal matrix.'];
            errmsg.identifier = 'dspblks:dspblkkalman:nonDiagMatrix';
        return;
        end
    elseif strcmpi(attr, 'positiveinteger')
        if ~isempty(find(value<= 0 | floor(value)~=value, 1))
            errmsg.message = ['The ', name, ' must be a positive integer.'];
            errmsg.identifier = 'dspblks:dspblkkalman:nonPositiveInt';
        return;
        end
    end
end

%===============================================================================
% get current parameters by searching for corresponding blocks
function paramControl = getCurrentParameters(blkh, idx)
    paramControl(idx.enable)     = exist_block(blkh, 'Enable');
    paramControl(idx.reset)      = exist_block(blkh, 'En_Delay');
    paramControl(idx.h)          = exist_block(blkh, 'H');
    paramControl(idx.xprd)       = exist_block(blkh, 'X_prd');
    paramControl(idx.zprd)       = exist_block(blkh, 'Z_prd');
    paramControl(idx.mseprd)     = exist_block(blkh, 'MSE_prd');
    paramControl(idx.xest)       = exist_block(blkh, 'X_est');
    paramControl(idx.zest)       = exist_block(blkh, 'Z_est');
    paramControl(idx.mseest)     = exist_block(blkh, 'MSE_est');
end

%=============================================================================== 
% Set the port numbers for all subsystems. The number of a port is
% determined by its position in the list: If it appears earlier, it is
% assigned lower number.
function resetPortNumbers(blk, subsys_list, port_list)
    sys_num = length(subsys_list) + 1;
    port_num = length(port_list);

    for ins = sys_num: -1: 1,
        % name of current sub-system
        cur_blk = blk;
        for inp = 1: ins-1
            cur_blk = [cur_blk, '/', subsys_list{inp}]; %#ok<AGROW>
        end
        
       % find the existing ports in all systems
        ports = false(1, port_num);
        for inp=1: port_num
            if exist_block(cur_blk, port_list{inp})
                ports(inp) = true;
            end
        end
        
        % pick up the valid ports and set their new numbers
        cur_port = 1;
        for inp=1: port_num
            if ports(inp)
                set_param([cur_blk, '/', port_list{inp}],... 
                    'Port', num2str(cur_port));
                cur_port = cur_port + 1;
            end
        end
    end
end

%=============================================================================== 
% Get the port name and number in the toppest subsystem so as to draw the
% icon. This function is not combined with function resetPortNumbers because: 
% (1) this function will be called at every Apply and Ctr-D time, while
% resetPortNumbers is called only when the control parameters are changed;
% (2) this function only involves the toppest subsystem.
function [port_disp] = getPortNumbers(blk, port_list)
    port_num = length(port_list);

    % find existing ports
    ports = zeros(1, port_num);
    for inp=1: port_num
        if exist_block(blk, port_list{inp})
            ports(inp) = 1;
        end
    end

    % find out the number of every existing port
    cur_port = 1;
    for inp=1: port_num
        if ports(inp)
            port_disp(cur_port).port = cur_port; %#ok<AGROW>
            port_disp(cur_port).txt  = port_list{inp}; %#ok<AGROW>
            cur_port = cur_port + 1;
        end
    end
    
    % set the unused ports to the first one
    for inp = cur_port: port_num
        port_disp(inp).port = port_disp(1).port; %#ok<AGROW>
        port_disp(inp).txt = port_disp(1).txt; %#ok<AGROW>
    end
end

%=============================================================================== 
% Get port number from name. 
function point = getPointFromPort(sys, prefix, blk, port)
    
    if ischar(port)
        % if idLabel is a string, find its corresponding port number
        port_id = get_param([sys, '/', blk, '/', prefix, port], 'Port');
        point = [blk, '/', num2str(port_id)];
        
    elseif isnumeric(port)
        % if idLabel is a number, use it as is
        if (port > 0)
            point = [blk, '/', num2str(port)];
            
        % if idLabel is zero or negative, use the block as is.
        % This is used when the port is the Enable Port in a subsystem. In
        % this case, blk = 'some_block\Enable'.
        else
            point = blk;
        end
    end    
end

%=============================================================================== 
% The Kalman filter has four levels and five customized systems. 
% The hierarchy is
% Kalman -> Control -> Options -> Core
%                              -> Assign/reset
% Each of the control parameters is associated with a set of blocks and 
% lines in different systems. The change of a parameter will cause the 
% addition or subtraction of these blocks and/or lines. The set of blocks 
% and lines associated to a parameter is defined as,
% SUBSYS = {action1, sys1, prefix1, offset1, BLOCKS1, LINES1, 
%           action2, sys, prefix2, offset12, BLOCKS2, LINES2, 
%           action3, sys3, prefix3, offset13, BLOCKS3, LINES3, 
%           …}
% BLOCKS defines the blocks, while LINES defines the lines. 
%   They will be detailed later.
% action can be ‘add’ or ‘delete’. It is the action to take when 
%   this parameter is switched from OFF to ON. 
%   If the parameter is switched from ON to OFF, the opposite action is taken.
% sys is the system the action is going to take. 
%   It can be one of the five systems listed above.
% prefix is the string which can be added to the 
%   block name or parameter value.
% offset is the value to adjust block position from its original 
%   ones which are defined in the structure BLOCKS.
% prefix and offset are used so subsystems with same structure 
% can use the same piece of code.
% 
% BLOCKS defines the set of blocks which are going to add or delete 
% at a system for a control parameter. It is a cell array and 
% has the following structure.
% BLOCKS{i} = {library, src_blk, dst_blk, position, 
%              param_name1, param_value1, isParamUsePrefix1, 
%              param_name2, param_value2, isParamUsePrefix2, 
%              …}
% Library and src_blk specify the block to copy from.
% Name of destination block is [prefix dst_blk].
% Actual position of the destination block is determined by position and offset.
% Parma_name and param_value specify the property of the block. 
% If isParamUsePrefix is true, param_value is modified to [prefix, param_value].
%  
% LINES defines the set of lines which are going to modify. Its format is
% LINES{i} = {src_blk, src_prt, dst_blk, dst_prt}
% src_blk and dst_blk specify the blocks which the line is going 
% to connect or disconnect, while src_prt and dst_prt specify the ports.
% The ports (src_prt and dst_prt) can have different types of values:
% (1) String: Its value is the port name. 
%   The port number will be found by looking into the block.
% (2) Positive number: Its value is the port number.
% (3) Zero: This special case is used for the Enable Port. 


%=============================================================================== 
% Format of lines: src_blk, src_prt, dst_blk, dst_prt
function errmsg = editLine(action, sys, prefix, lines)
    errmsg = '';
    num_line = length(lines);
    isAdd = strcmpi(action, 'add');

    try
        for ind = 1: num_line
            param = lines{ind};
            len_param = length(param);
            if len_param ~= 4
                errmsg.Message    = 'Unable to modify the block.';
                errmsg.identifier = 'dspblks:dspblkkalman:modifyBlock';
                return;
            end

            src_port  = param{2};
            dst_port  = param{4};
            if ischar(src_port)
                src_blk   = param{1};
            else
                src_blk   = [prefix, param{1}];
            end
            if ischar(dst_port)
                dst_blk   = param{3};
            else
                dst_blk   = [prefix, param{3}];
            end
            
            src_point = getPointFromPort(sys, prefix, src_blk, src_port);
            dst_point = getPointFromPort(sys, prefix, dst_blk, dst_port);

            if isAdd
                if ischar(src_port) || ischar(dst_port) 
                    % autorounting is turned off if this line connects to a
                    % subsystem. Otherwise, the line will look wired if the port
                    % numbers of the subsystem are changed later.
                    add_line(sys, src_point, dst_point, 'autorouting', 'off');
                else
                    add_line(sys, src_point, dst_point, 'autorouting', 'on');
                end
            else
                delete_line(sys, src_point, dst_point);
            end
        end
    catch errmsg
    end
end

%=============================================================================== 
% Format of blks:
% library, src_blk, dst_name, position, param_name1, param_value1, flag_prefix1,
function errmsg = editBlock(action, sys, prefix, blks, offset)

    try
        errmsg = '';
        num_blk = length(blks);
        isAdd = strcmpi(action, 'add');

        for ind = 1: num_blk
            param = blks{ind};
            len_param = length(param);
            if len_param < 4 || mod(len_param-4, 3)
                errmsg.Message    = 'Unable to modify the block.';
                errmsg.identifier = 'dspblks:dspblkkalman:modifyBlock';
                return;
            end

            [lib, src_name, dst_name, dst_pos]...
                = deal(param{1}, param{2}, param{3}, param{4});

            if isAdd    % add the block
                src_blk = [lib, '/', src_name];
                dst_blk = [sys, '/', prefix, dst_name];
                position = sprintf('[%d %d %d %d]',...
                    dst_pos(1)+offset(1), dst_pos(2)+offset(2),...
                    dst_pos(3)+offset(1), dst_pos(4)+offset(2));

                if ~strcmpi(lib, 'built-in')
                    load_system(lib);
                end
                add_block(src_blk, dst_blk, 'Position', position);

                PVPairs = {}; % Accumulate all PV pairs and perform one set
                for inp = 5:3:len_param
                    [param_name, param_value, isAddPrefix2Value]...
                        = deal(param{inp}, param{inp+1}, param{inp+2});
                    if isAddPrefix2Value
                        param_value = [prefix, param_value]; %#ok<AGROW>
                    end

                    PVPairs{end+1} = param_name; %#ok
                    PVPairs{end+1} = param_value; %#ok
                end

                % Set all parameters at once
                if ~isempty(PVPairs)
                    set_param(dst_blk, PVPairs{:});
                end
                
            else      % delete the block
                dst_blk = [sys, '/', prefix, dst_name];
                delete_block(dst_blk);
            end
        end
    catch errmsg
    end
end

%=============================================================================== 
function errmsg = editSubSystem(action, subsys)
    errmsg = '';

    len_subsys = length(subsys);
    if mod(len_subsys, 6)
        errmsg.Message    = 'Unable to modify the block.';
        errmsg.identifier = 'dspblks:dspblkkalman:modifyBlock';
        return;
    end
    
    try
        if strcmpi(action, 'add')
            % edit subsystems from low to high levels
            isAdd = true;
            proc_order = len_subsys-5: -6: 1;
        else
            % edit subsystems from hgih to low levels
            isAdd = false;
            proc_order = 1: 6: len_subsys;
        end
        for ind = proc_order
            [operation, base_sys, prefix, offset, blks, line]...
                = deal(subsys{ind}, subsys{ind+1}, subsys{ind+2},...
                subsys{ind+3}, subsys{ind+4}, subsys{ind+5});

            % blocks are added before lines, but are deleted after lines.
            % Blocks and lines are added in the case of ("add" and "yes") or
            % ("delete" and "no"), or deleted in the other cases.
            if (isAdd && strcmpi(operation, 'yes'))...
                    || (~isAdd && strcmpi(operation, 'no'))
                errmsg = editBlock('add', base_sys, prefix, blks, offset);
                if ~isempty(errmsg) 
                    rethrow(errmsg); 
                end
                errmsg = editLine('add', base_sys, prefix, line);
                if ~isempty(errmsg) 
                    rethrow(errmsg); 
                end
            else
                errmsg = editLine('delete', base_sys, prefix, line);
                if ~isempty(errmsg) 
                    rethrow(errmsg); 
                end
                errmsg = editBlock('delete', base_sys, prefix, blks, offset);
                if ~isempty(errmsg) 
                    rethrow(errmsg); 
                end
            end
        end
    catch errmsg
    end
end

%===============================================================================
function errmsg = editSystem(blk, sub_blk, outport_list, idx,...
                             paramControl, paramControlCur)

    errmsg    = '';
    emptyBlk  = {};
    emptyLine = {};

    klm_blk  =  blk;
    ctr_blk  = [klm_blk, '/', sub_blk{1}];
    opt_blk  = [ctr_blk, '/', sub_blk{2}];
    core_blk = [opt_blk, '/', sub_blk{3}];
    
    klmEnableBlk{1} = {'built-in', 'Inport', 'Enable', [20 78 45 92]};
    klmEnableBlk{2} = {'built-in', 'SignalSpecification',...
        'En_CheckDimension', [75 74 225 96],...
        'Dimensions', '[1, num_targets]', false};
    klmEnableLine{1} = {'Enable', 1, 'En_CheckDimension', 1};
    klmEnableLine{2} = {'En_CheckDimension', 1, 'Control', 'Enable'};

    klmResetBlk{1} = {'built-in', 'UnitDelay', 'En_Delay', [290 115 320 145],...
        'SampleTime', '-1', false, 'X0', '0', false};
    klmResetLine{1} = {'En_CheckDimension', 1, 'En_Delay', 1};
    klmResetLine{2} = {'En_Delay', 1, 'Control', 'En_delay'};

    klmHBlk{1} = {'built-in', 'Inport', 'H', [20 168 45 182]};
    klmHBlk{2} = {'built-in', 'SignalSpecification', 'H_CheckDimension',... 
        [75 163 225 187], 'Dimensions', '[len_measure, len_state]', false};
    klmHBlk{3} = {
        'built-in', 'DataTypeConversion', 'H_Conversion', [255 164 300 186],... 
        'OutDataTypeStr', 'Inherit: Inherit via back propagation', false,... 
        'ConvertRealWorld', 'Real World Value (RWV)', false};
    klmHBlk{4} = {'dspmtrx3', 'Transpose', 'H_Transpose', [330 209 355 231]};
    klmHLine{1} = {'H', 1, 'H_CheckDimension', 1};
    klmHLine{2} = {'H_CheckDimension', 1, 'H_Conversion', 1};
    klmHLine{3} = {'H_Conversion', 1, 'Control', 'H'};
    klmHLine{4} = {'H_Conversion', 1, 'H_Transpose', 1};
    klmHLine{5} = {'H_Transpose', 1, 'Control', 'Ht'};

    ctrEnableBlk{1} = {'built-in', 'Inport', 'Enable', [35 38 65 52]};
    ctrEnableBlk{2} = {'built-in', 'Selector', 'En_Selector',[105 28 150 97],... 
        'NumberOfInputDimensions', '2', false,... 
        'IndexMode', 'One-based', false, 'RowSrc', 'Internal', false,...
        'Rows', '-1', false, 'ColumnSrc', 'External', false};
    ctrEnableLine{1} = {'Enable', 1, 'En_Selector', 1};
    ctrEnableLine{2} = {'Iterator', 1, 'En_Selector', 2};
    ctrEnableLine{3} = {'En_Selector', 1, 'Options/Enable', 0};

    ctrEnableResetLine{1} = {'En_Selector', 1, 'Options/Enable', 0};

    ctrResetBlk{1} = {'built-in', 'Inport', 'En_delay', [110 148 140 162]};
    ctrResetBlk{2} = {
        'built-in', 'Selector', 'Rst_Selector', [170 143 225 187],...
        'NumberOfInputDimensions', '2', false,...
        'IndexMode', 'One-based', false, 'RowSrc', 'Internal', false,...
        'Rows', '-1', false, 'ColumnSrc', 'External', false};
   ctrResetBlk{3} = {'built-in', 'Logic', 'En_Not', [185 86 215 114],...
        'Operator', 'NOT', false, 'SampleTime', '-1', false,...
        'AllPortsSameDT', 'off', false};
    ctrResetBlk{4} = {
        'built-in', 'Logic', 'Rst_And', [250 105 285 185],... 
        'Operator', 'AND', false, 'SampleTime', '-1', false,...
        'Inputs', '2', false, 'AllPortsSameDT', 'off', false};
    ctrResetBlk{5} = {
        'built-in', 'Logic', 'En_Or', [340 57 370 88],...
        'Operator', 'OR', false, 'SampleTime', '-1', false,...
        'Inputs', '2', false, 'AllPortsSameDT', 'off', false};
    ctrResetLine{1} = {'En_delay', 1, 'Rst_Selector', 1};
    ctrResetLine{2} = {'Iterator', 1, 'Rst_Selector', 2};
    ctrResetLine{3} = {'En_Selector', 1, 'En_Not', 1};
    ctrResetLine{4} = {'En_Not', 1, 'Rst_And', 1};
    ctrResetLine{5} = {'Rst_Selector', 1, 'Rst_And', 2};
    ctrResetLine{6} = {'Rst_And', 1, 'Options', 'Reset'};
    ctrResetLine{7} = {'En_Selector', 1, 'En_Or', 1};
    ctrResetLine{8} = {'Rst_And', 1, 'En_Or', 2};
    ctrResetLine{9} = {'En_Or', 1, 'Options/Enable', 0};
    ctrResetLine{10} = {'En_Selector', 1, 'Options', 'En_core'};

    ctrHBlk{1} = {'built-in', 'Inport', 'H', [265 278 295 292]};
    ctrHBlk{2} = {'built-in', 'Inport', 'Ht', [265 318 295 332]};
    ctrHLine{1} = {'H', 1, 'Options', 'H'};
    ctrHLine{2} = {'Ht', 1, 'Options', 'Ht'};

    optEnableBlk{1} = {'built-in', 'EnablePort', 'EnablePort', [445 25 465 45]};

    optResetBlk{1} = {'built-in', 'Inport', 'Reset', [30 28 60 42]};
    optResetBlk{2} = {
        'built-in', 'Goto', 'Reset_Goto', [95 23 145 47],...
        'GotoTag', 'Reset', false, 'TagVisibility', 'scoped', false};
    optResetBlk{3} = {
        'built-in', 'GotoTagVisibility', 'Reset_Visibility', [170 23 223 43],...
        'GotoTag', 'Reset', false};
    optResetBlk{4} = {'built-in', 'Inport', 'En_core', [130 138 160 152]};
    optResetLine{1} = {'Reset', 1, 'Reset_Goto', 1};
    optResetLine{2} = {'En_core', 1, 'Core/Enable', 0};

    optHBlk{1} = {'built-in', 'Inport', 'H', [140 263 170 277]};
    optHBlk{2} = {'built-in', 'Inport', 'Ht', [140 323 170 337]};
    optHLine{1} = {'H', 1, 'Core', 'H'};
    optHLine{2} = {'Ht', 1, 'Core', 'Ht'};
    
    coreResetBlk{1} = {'built-in', 'EnablePort', 'EnablePort', [845 20 865 40]};

    coreHPrtBlk{1} = {'built-in', 'Inport', 'H', [25 33 50 47]};
    coreHPrtBlk{2} = {'built-in', 'Inport', 'Ht', [320 68 345 82]};
    coreHPrtLine{1} = {'H', 1, 'H_Goto', 1};
    coreHPrtLine{2} = {'H', 1, 'H*P_prdt', 1};
    coreHPrtLine{3} = {'Ht', 1, 'H*P_prdt*Ht', 2};

    coreHCstBlk{1} = {'built-in', 'Constant', 'Hcst', [20 28 75 52],...
        'Value', 'param.H', false, 'SampleTime', 'inf', false,...
        'OutDataTypeStr', 'Inherit: Inherit via back propagation', false,...
        'VectorParams1D', 'off', false};
    coreHCstBlk{2} = {'built-in', 'Constant', 'Hcst_t', [295 64 355 86],...
        'Value', 'param.Ht', false, 'SampleTime', 'inf', false,...
        'OutDataTypeStr', 'Inherit: Inherit via back propagation', false,...
        'VectorParams1D', 'off', false};
    coreHCstLine{1} = {'Hcst', 1, 'H_Goto', 1};
    coreHCstLine{2} = {'Hcst', 1, 'H*P_prdt', 1};
    coreHCstLine{3} = {'Hcst_t', 1, 'H*P_prdt*Ht', 2};

    asgnResetBlk{1} = {'built-in', 'Constant', 'Reset_Value', [35 36 105 54],...
        'Value', 'reset_value', false, 'SampleTime', 'inf', false,...
        'OutDataTypeStr', 'Inherit: Inherit via back propagation', false,...
        'VectorParams1D', 'off', false};
    asgnResetBlk{2} = {'built-in', 'From', 'Reset', [35 71 80 89],...
        'GotoTag', 'Reset', false};
    asgnResetBlk{3} = {'built-in', 'Switch', 'Switch', [140 24 170 136],...
        'Criteria', 'u2 ~= 0', false};
    asgnResetLine{1} = {'Reset_Value', 1, 'Switch', 1};
    asgnResetLine{2} = {'Reset', 1, 'Switch', 2};
    asgnResetLine{3} = {'In', 1, 'Switch', 3};
    asgnResetLine{4} = {'Switch', 1, 'Assignment', 1};
    
    asgnAlwaysLine{1} = {'In', 1, 'Assignment', 1};

    % Output ports X_prd and P_prd have initial values different than
    % zeros, so their Assignment blocks has one more port. Hence the lines
    % are different.
    asgnXResetBlk{1} = {'built-in', 'Constant', 'Reset_Value', [35 36 105 54],...
        'Value', 'param.X', false, 'SampleTime', 'inf', false,...
        'OutDataTypeStr', 'Inherit: Inherit via back propagation', false,...
        'VectorParams1D', 'off', false};
    asgnXResetBlk{2} = {'built-in', 'From', 'Reset', [35 71 80 89],...
        'GotoTag', 'Reset', false};
    asgnXResetBlk{3} = {'built-in', 'Switch', 'Switch', [140 24 170 136],...
        'Criteria', 'u2 ~= 0', false};
    
    asgnPResetBlk{1} = {'built-in', 'Constant', 'Reset_Value', [35 36 105 54],...
        'Value', 'param.P', false, 'SampleTime', 'inf', false,...
        'OutDataTypeStr', 'Inherit: Inherit via back propagation', false,...
        'VectorParams1D', 'off', false};
    asgnPResetBlk{2} = {'built-in', 'From', 'Reset', [35 71 80 89],...
        'GotoTag', 'Reset', false};
    asgnPResetBlk{3} = {'built-in', 'Switch', 'Switch', [140 24 170 136],...
        'Criteria', 'u2 ~= 0', false};

    asgnXPResetLine{1} = {'Reset_Value', 1, 'Switch', 1};
    asgnXPResetLine{2} = {'Reset', 1, 'Switch', 2};
    asgnXPResetLine{3} = {'In', 1, 'Switch', 3};
    asgnXPResetLine{4} = {'Switch', 1, 'Assignment', 2};

    asgnXPAlwaysLine{1} = {'In', 1, 'Assignment', 2};
    
    klmOutBlk{1} = {'built-in', 'Outport', '', [530 33 560 47]};   % step [0 45]
    klmOutLine{1} = {'Control', '', '', 1};

    ctrOutBlk{1} = {'built-in', 'Outport', '', [485 123 515 137]}; % step [0 45]
    ctrOutLine{1} = {'Options', '', '', 1};
    
    optXBlk{1} = {'dspadpt3/Kalman Filter/Control/Options',... 
        'Z_est_Assign', '_Assign', [375 228 455 252],...
        'reset_value', 'zeros(len_state, 1)', false,...
        'num_rows', 'len_state', false, 'num_cols', 'num_targets', false};
    optZBlk{1} = {'dspadpt3/Kalman Filter/Control/Options',... 
        'Z_est_Assign', '_Assign', [375 183 455 207],...
        'reset_value', 'zeros(len_measure, 1)', false,...
        'num_rows', 'len_measure', false,...
        'num_cols', 'num_targets', false}; % step [0 135]
    optMSEBlk{1} = {'dspadpt3/Kalman Filter/Control/Options',...
        'Z_est_Assign', '_Assign', [375 273 455 297],...
        'reset_value', '0', false, 'num_rows', '1', false,...
        'num_cols', 'num_targets', false}; % step [0 135]

    optOutBlk{1} = {'built-in', 'Outport', '', [490 188 520 202]}; % step [0 45]
    optOutLine{1} = {'Core', '', '_Assign', 1};
    optOutLine{2} = {'_Assign', 1, '', 1};
    
    % step [265, 0]
    coreMSEBlk{1} = {
        'dspmtrx3', 'Extract Diagonal', '_Diagonal', [405 244 475 276]};
    coreMSEBlk{2} = {'built-in', 'Sum', '_Sum', [515 242 545 278],...
                     'Inputs', '+', false, 'SampleTime', '-1', false,...
                     'OutDatatypeStr', 'Inherit: Inherit via internal rule', false,...
                     'InputSameDT', 'on', false};
    coreMSEBlk{3} = {'built-in', 'Outport', '', [575 253 605 267]};
    coreMSELine{1} = {'_Diagonal', 1, '_Sum', 1};
    coreMSELine{2} = {'_Sum', 1, '', 1};

    coreMSEestLine{1} = {'P_prd-K*H*P_prd', 1, 'MSE_est_Diagonal', 1};
    
    coreMSEprdLine{1} = {'A*P*At+Q', 1, 'MSE_prd_Diagonal', 1};
    
    % step [265, -10]
    coreZBlk{1} = {'built-in', 'From', '_H', [440 312 475 328],...
                   'GotoTag', 'H', false};
    coreZBlk{2} = {
        'dspmtrx3', 'Matrix Multiply', '_Multiply', [495 309 550 356],...
        'SampleTime', '-1', false,...
        'OutDatatypeStr', 'Inherit: Same as first input', false,...
        'InputSameDT', 'on', false};
    coreZBlk{3} = {'built-in', 'Outport', '', [570 328 600 342]};
    coreZLine{1} = {'_H', 1, '_Multiply', 1};
    coreZLine{2} = {'_Multiply', 1, '', 1};
    
    coreZestLine{1} = {'X_prd+K*(Z-H*X_prd)', 1, 'Z_est_Multiply', 2};
    
    coreZprdLine{1} = {'A*X', 1, 'Z_prd_Multiply', 2};
    
    coreXestBlk{1} = {'built-in', 'Outport', 'X_est', [510 393 540 407]};
    coreXestLine{1} = {'X_prd+K*(Z-H*X_prd)', 1, 'X_est', 1};
    
    % subsystems related to each of the options
    subsys{idx.enable} = {...
        'yes', klm_blk, '', [0, 0], klmEnableBlk, klmEnableLine,...
        'yes', ctr_blk, '', [0, 0], ctrEnableBlk, ctrEnableLine,...
        'yes', opt_blk, '', [0, 0], optEnableBlk, emptyLine};

    subsys{idx.reset} = {...
        'yes', klm_blk , '', [0, 0], klmResetBlk, klmResetLine,...
        'yes', ctr_blk , '', [0, 0], ctrResetBlk, ctrResetLine,...
        'no' , ctr_blk , '', [0, 0], emptyBlk, ctrEnableResetLine,...
        'yes', opt_blk , '', [0, 0], optResetBlk, optResetLine,...
        'yes', core_blk, '', [0, 0], coreResetBlk, emptyLine};

    subsys{idx.h} = {...
        'yes', klm_blk, '', [0, 0], klmHBlk, klmHLine,...
        'yes', ctr_blk, '', [0, 0], ctrHBlk, ctrHLine,...
        'yes', opt_blk, '', [0, 0], optHBlk, optHLine,...
        'yes', core_blk, '', [0, 0], coreHPrtBlk, coreHPrtLine,...
        'no' , core_blk, '', [0, 0], coreHCstBlk, coreHCstLine};

    subsys{idx.zest} = {...
        'yes', klm_blk, 'Z_est', [0, 0], klmOutBlk, klmOutLine,...
        'yes', ctr_blk, 'Z_est', [0, 0], ctrOutBlk, ctrOutLine,...
        'yes', opt_blk, 'Z_est', [0, 0], optOutBlk, optOutLine,...
        'yes', opt_blk, 'Z_est', [0, 0], optZBlk, emptyLine,...
        'yes', core_blk, '', [0, 0], emptyBlk, coreZestLine,...
        'yes', core_blk, 'Z_est', [0, 0], coreZBlk, coreZLine};

    subsys{idx.zprd} = {...
        'yes', klm_blk, 'Z_prd', [0, 135], klmOutBlk, klmOutLine,...
        'yes', ctr_blk, 'Z_prd', [0, 135], ctrOutBlk, ctrOutLine,...
        'yes', opt_blk, 'Z_prd', [0, 135], optOutBlk, optOutLine,...
        'yes', opt_blk, 'Z_prd', [0, 135], optZBlk, emptyLine,...
        'yes', core_blk, '', [0, 0], emptyBlk, coreZprdLine,...
        'yes', core_blk, 'Z_prd', [265, -10], coreZBlk, coreZLine};

    subsys{idx.xest} = {...
        'yes', klm_blk, 'X_est', [0, 45], klmOutBlk, klmOutLine,...
        'yes', ctr_blk, 'X_est', [0, 45], ctrOutBlk, ctrOutLine,...
        'yes', opt_blk, 'X_est', [0, 45], optOutBlk, optOutLine,...
        'yes', opt_blk, 'X_est', [0, 0], optXBlk, emptyLine,...
        'yes', core_blk, '', [0, 0], coreXestBlk, coreXestLine};

    subsys{idx.xprd} = {...
        'yes', klm_blk, 'X_prd', [0, 180], klmOutBlk, klmOutLine};

    subsys{idx.mseest} = {...
        'yes', klm_blk, 'MSE_est', [0, 90], klmOutBlk, klmOutLine,...
        'yes', ctr_blk, 'MSE_est', [0, 90], ctrOutBlk, ctrOutLine,...
        'yes', opt_blk, 'MSE_est', [0, 90], optOutBlk, optOutLine,...
        'yes', opt_blk, 'MSE_est', [0, 0], optMSEBlk, emptyLine,...
        'yes', core_blk, '', [0, 0], emptyBlk, coreMSEestLine,...
        'yes', core_blk, 'MSE_est', [0, 0], coreMSEBlk, coreMSELine};

    subsys{idx.mseprd} = {...
        'yes', klm_blk, 'MSE_prd', [0, 225], klmOutBlk, klmOutLine,...
        'yes', ctr_blk, 'MSE_prd', [0, 225], ctrOutBlk, ctrOutLine,...
        'yes', opt_blk, 'MSE_prd', [0, 225], optOutBlk, optOutLine,...
        'yes', opt_blk, 'MSE_prd', [0, 135], optMSEBlk, emptyLine,...
        'yes', core_blk, '', [0, 0], emptyBlk, coreMSEprdLine,...
        'yes', core_blk, 'MSE_prd', [265, 0], coreMSEBlk, coreMSELine};


    try
        % delete in reverse order, because Reset depends on Enable
        idx_num = length(fieldnames(idx));
        for ind = idx_num: -1: 1
            if paramControlCur(ind) && ~paramControl(ind)
                errmsg = editSubSystem('delete', subsys{ind});
                if ~isempty(errmsg) 
                    rethrow(errmsg); 
                end
            end
        end

        % add subsystem in ascending order
        for ind = 1: idx_num
            if ~paramControlCur(ind) && paramControl(ind)
                errmsg = editSubSystem('add', subsys{ind});
                if ~isempty(errmsg) 
                    rethrow(errmsg); 
                end

                % if in the current settings, Reset is disabled, system of
                % Assign/reset must be modified.
                if ind>=idx.zest && ind~=idx.xprd && ~paramControlCur(idx.reset)
                    port_id = ind - idx.zest + 1;
                    cur_sys = [opt_blk, '/', outport_list{port_id}, '_Assign'];
                    subsys_assign = {...
                        'yes', cur_sys, '', [0, 0], asgnResetBlk, asgnResetLine,...
                        'no', cur_sys, '', [0, 0], emptyBlk, asgnAlwaysLine};
                    errmsg = editSubSystem('delete', subsys_assign);
                    if ~isempty(errmsg) 
                        rethrow(errmsg); 
                    end
                end
            end
        end

        % if Reset parameter is being changed, output ports must be changed
        % accordingly.
        if paramControlCur(idx.reset) ~= paramControl(idx.reset)
            if paramControlCur(idx.reset) && ~paramControl(idx.reset)
                action = 'delete';
            else 
                action = 'add';
            end
            for ind = idx.zest: idx_num
                if ind~=idx.xprd && paramControl(ind)
                    port_id = ind - idx.zest + 1;
                    cur_sys = [opt_blk, '/', outport_list{port_id}, '_Assign'];
                    subsys_assign = {...
                        'yes', cur_sys, '', [0, 0], asgnResetBlk, asgnResetLine,...
                        'no', cur_sys, '', [0, 0], emptyBlk, asgnAlwaysLine};
                    errmsg = editSubSystem(action, subsys_assign);
                    if ~isempty(errmsg) 
                        rethrow(errmsg); 
                    end
                end
            end

            % P_prd_Assign always exists
            cur_sys = [opt_blk, '/P_prd_Assign'];
            subsys_assign = {...
                'yes', cur_sys, '', [0, 0], asgnPResetBlk, asgnXPResetLine,...
                'no', cur_sys, '', [0, 0], emptyBlk, asgnXPAlwaysLine};
            errmsg = editSubSystem(action, subsys_assign);
            if ~isempty(errmsg) 
                rethrow(errmsg); 
            end

            % X_prd_Assign always exists
            cur_sys = [opt_blk, '/X_prd_Assign'];
            subsys_assign = {...
                'yes', cur_sys, '', [0, 0], asgnXResetBlk, asgnXPResetLine,...
                'no', cur_sys, '', [0, 0], emptyBlk, asgnXPAlwaysLine};
            errmsg = editSubSystem(action, subsys_assign);
            if ~isempty(errmsg) 
                rethrow(errmsg); 
            end
        end
    catch errmsg
    end
end

% [EOF] dspblkkalman.m

