classdef midicontrols < handle
    % MIDICONTROLS Create midicontrols object to interact with MIDI control
    % surfaces.
    %   H=MIDICONTROLS returns a midicontrols object that responds to any
    %   control on the default MIDI device.  Calling MIDIREAD with the
    %   object returns the double scalar value of the MIDI control most
    %   recently moved since the creation of the object.  The value is
    %   normally in the range [0 1]; see OUTPUTMODE below for an
    %   alternative. A midicontrols object can only determine a control's
    %   value if the control is moved after the midicontrols object is
    %   created. If MIDIREAD is called before the control is moved,
    %   MIDIREAD will return a default initial value of 0.
    %
    %   H=MIDICONTROLS([]) is the same as H=MIDICONTROLS.
    %
    %   H=MIDICONTROLS(ControlNumbers) returns a midicontrols object that
    %   responds to the MIDI controls specified by ControlNumbers. Calling
    %   MIDIREAD with the object returns a double array the same shape as
    %   ControlNumbers.  Control numbers are integer-valued doubles.  Each
    %   control on the MIDI device has a specific integer assigned to it by
    %   the device manufacturer (some devices can also be reprogrammed by
    %   the user).  Use MIDIID to interactively identify the control number
    %   of individual MIDI controls.  If ControlNumbers is [] then the
    %   midicontrols object will respond to any control on the MIDI device,
    %   and MIDIREAD will return a double scalar.
    %
    %   H=MIDICONTROLS(ControlNumbers, InitialValues) returns a
    %   midicontrols object that uses the specified InitialValues when
    %   controls have not been moved since the object's creation.
    %   InitialValues must either be an array the same size as
    %   ControlNumbers or a scalar.  When InitialValues is not specified,
    %   the default initial value is 0. Initial values must normally be in
    %   the range [0 1]; see OUTPUTMODE below for an alternative. Initial
    %   values are quantized for the underlying MIDI protocol, so MIDIREAD
    %   may return an initial value that is slightly different from
    %   InitialValues.
    %
    %   H=MIDICONTROLS(... 'MIDIDevice', DEVICENAME) specifies the MIDI
    %   device to which the object responds.  DEVICENAME is a character
    %   string assigned by the device manufacturer and the host operating
    %   system.  Use MIDIID to interactively identify the name of a
    %   specific MIDI device.  The specified DEVICENAME can be a substring
    %   of the device's exact name (if DEVICENAME matches multiple device
    %   names, the host operating system chooses among the matches in an
    %   unspecified way).
    %
    %   If the 'MIDIDevice' name-value pair is not specified, the default
    %   MIDI device will be used.  The default device is determined by the
    %   MATLAB preference 'midi' 'DefaultDevice'.  For example, if your
    %   MIDI device is a Behringer BCF2000, you could set the default
    %   device this way:
    %
    %   % Example of how to set the default MIDI device.
    %   setpref midi DefaultDevice BCF2000
    %
    %   This preference will persist across MATLAB sessions, so you do not
    %   need to set it again unless you want to change devices.  See
    %   SETPREF for more information about MATLAB preferences.
    %
    %   If the MATLAB preference is not set, the default device will be
    %   chosen by the host operating system in an unspecified way.  Some
    %   systems have virtual (ie, software) MIDI devices installed which
    %   you may be unaware of, so even if you have only one hardware MIDI
    %   device attached to your system, the system may not choose it.  This
    %   is a common cause of confusion.  Best practice is to use MIDIID to
    %   identify the name of the device you want to use, and then use
    %   SETPREF to set it as the default device.
    %
    %   H=MIDICONTROLS(... 'OutputMode', MODE) specifies the range of
    %   values returned by MIDIREAD and accepted as InitialValues.  MODE is
    %   a string and must be one of 'normalized' or 'rawmidi'.  In
    %   normalized mode, values are in the range [0 1].  Also, initial
    %   values must be quantized for the underlying MIDI protocol. In raw
    %   MIDI mode, values are integers in the range [0 127], and
    %   quantization of initial values is not required.  If the
    %   'OutputMode' name-value pair is not specified, the default mode is
    %   'normalized'. In normalized
    %
    %   The 'MIDIDevice' and 'OutputMode' name-value pairs are optional and
    %   may be specified in any order, but may only appear at the end of the
    %   argument list.
    %
    %   Examples:
    %
    %   % Create an object responding to any control on the default device.
    %   h = midicontrols;
    %
    %   % Respond specifically to control 1081.
    %   h = midicontrols(1081);
    %
    %   % Make MIDIREAD return a square array, with initial value 0.5.
    %   h = midicontrols([1081 1083; 1082 1084], 0.5);
    %
    %   % Same as above, but use raw MIDI values:
    %   h = midicontrols([1081 1083; 1082 1084], 63, 'OutputMode', 'rawmidi');
    %
    %   % Respond to control 1001 on a Behringer BCF2000.
    %   h = midicontrols(1001, 'MIDIDevice', 'BCF2000');
    %
    %   See also MIDIID, MIDIREAD, MIDISYNC, MIDICALLBACK, and SETPREF.

    %   Copyright 2013 The MathWorks, Inc.
    
    properties (Access=private)
        ControlNumbers
        InitialValues
        MIDIDevice
        Normalize
        CallbackFunctionHandle
    end

    properties (Access=private, Transient)
        ControlIds
        DeviceNum
        Timer
        TimerListener
    end
    
    methods
        function obj = midicontrols(varargin)
            [obj.ControlNumbers, obj.InitialValues, obj.MIDIDevice, obj.Normalize] = parseargs(varargin{:});
            [obj.DeviceNum, obj.ControlIds] = connectToControls(obj.ControlNumbers, obj.InitialValues, obj.MIDIDevice);
            if midicontrols.trace
                fprintf('\nmidicontrols: construct %d\n', int32(obj.ControlIds(1)));
            end
        end
    end
    
    methods (Hidden)
        function [vals, lastctl] = read(obj)
            if ~isscalar(obj)
                error(message('dsp:midiread:handlenotscalar'));
            end
            vals = zeros(size(obj.ControlIds));
            for i = 1:numel(obj.ControlIds)
                [vals(i), err] = midiReadControl(obj.ControlIds(i));
                assert(~err, message('dsp:midi:readFailedUnknown', midiGetErrorMessage(err)));
            end
            if obj.Normalize
                vals = scaleFromRaw(vals);
            end
            if nargout > 1
                [~, ctl, chn, err] = midiReadLastControl(obj.ControlIds(1));
                if err
                    lastctl = [];
                else
                    lastctl = chn * 1000 + ctl;
                end
            end
        end
        
        function sync(obj, varargin)
            if ~isscalar(obj)
                error(message('dsp:midisync:handlenotscalar'));
            end
            if nargin > 2
                error(message('dsp:midisync:tooManyInputs'));
            elseif nargin == 2
                vals = varargin{1};
                checkSyncVal(vals, obj.Normalize, size(obj.ControlIds));
                
                if obj.Normalize
                    vals = scaleToRaw(vals);
                end
            else
                vals = obj.InitialValues;
            end
            if midicontrols.trace
                fprintf('\nmidicontrols: sync %d\n', int32(obj.ControlIds(1)));
            end
            for i = 1:numel(obj.ControlIds)
                if isscalar(vals)
                    midiSyncControl(obj.ControlIds(i), vals);
                else
                    midiSyncControl(obj.ControlIds(i), vals(i));
                end
            end
        end
        
        function oldfh = callback(obj, varargin)
            if ~isscalar(obj)
                error(message('dsp:midicallback:handlenotscalar'));
            end

            if nargin > 2
                error(message('dsp:midicallback:tooManyInputs'));
            end
            
            oldfh = obj.CallbackFunctionHandle;

            if nargin == 2
                newfh = varargin{1};
                if ~isempty(newfh) && ~isa(newfh, 'function_handle')
                    error(message('dsp:midicallback:invalidFunctionHandle'));
                end
                if midicontrols.trace
                    fprintf('\nmidicontrols: callback set %d\n', int32(obj.ControlIds(1)));
                end
                obj.CallbackFunctionHandle = newfh;
                
                % always delete listener
                if ~isempty(obj.TimerListener)
                    delete(obj.TimerListener);
                    obj.TimerListener = [];
                end
                
                if isempty(newfh)
                    % delete timer if we are clearing the callback
                    if ~isempty(obj.Timer)
                        obj.Timer.stop;
                        obj.Timer = [];
                    end
                else
                    % create timer for callback
                    if isempty(obj.Timer)
                        obj.Timer = internal.IntervalTimer(0.05);
                    end
                    
                    obj.TimerListener = midicallbacklistener(obj, obj.Timer, obj.CallbackFunctionHandle, obj.ControlIds(1)); 

                    obj.Timer.start;        % no-op if already started
                end
            end
        end
        
        function disp(obj)
            for i = 1:numel(obj)
                o = obj(i);
                nums = int32(o.ControlNumbers);
                if isempty(nums)
                    ctrlstr = 'any control';
                elseif isscalar(nums)
                    ctrlstr = sprintf('control %d', nums);
                elseif isContiguousVector(nums)
                    ctrlstr = sprintf('controls %d:%d', nums([1 end]));
                else
                    ctrlstr = sprintf('%d controls', numel(nums));
                end
                
                if o.DeviceNum == -1
                    devstr = 'no MIDI device';
                else
                    devinfo = midiGetDeviceInfo(o.DeviceNum);
                    devstr = ['''' devinfo.name ''''];
                end
                
                fprintf('midicontrols object: %s on %s\n', ctrlstr, devstr);
            end
        end
        
        function A = saveobj(obj)
            A.ControlNumbers = obj.ControlNumbers;
            A.InitialValues = obj.InitialValues;
            A.MIDIDevice = obj.MIDIDevice;
            A.Normalize = obj.Normalize;
            A.CallbackFunctionHandle = obj.CallbackFunctionHandle;
        end
    end
    
    methods (Hidden, Static)
        function obj = loadobj(A)
            % Avoid converting InitialValues raw => normalized => raw
            obj = midicontrols(A.ControlNumbers,A.InitialValues,'MIDIDevice',A.MIDIDevice, 'OutputMode', 'rawmidi');
            obj.Normalize = A.Normalize;
            callback(obj,A.CallbackFunctionHandle);
        end
        
        function out = trace(enable)
            persistent state
            if isempty(state)
                state = false;
            end
            out = state;
            if nargin > 0
                if ~islogical(enable)
                    error(message('dsp:midicontrols:invalidtracearg'));
                end
                state = enable;
            end
        end
        
        function devinfo = devices
            c = cell(1,midiCountDevices);
            devinfo = struct('interf',c,'name',c,'input',c);
            for i = 1:numel(devinfo)
                di = midiGetDeviceInfo(i-1);
                assert(di.input ~= di.output);
                devinfo(i).interf = di.interf; %#ok<*AGROW>
                devinfo(i).name = di.name;
                devinfo(i).input = (di.input ~= 0);
            end
        end
    end

    methods (Access = private)
        function delete(obj)
            if midicontrols.trace
                fprintf('\nmidicontrols: delete %d\n', int32(obj.ControlIds(1)));
            end
            if ~isempty(obj.Timer)
                obj.Timer.stop;
            end
            for i = 1:numel(obj.ControlIds)
                midiCloseControl(obj.ControlIds(i));
            end
        end
    end
        
end

function [controlNumbers, initialValues, midiDevice, normalize] = parseargs(varargin)
    parser = inputParser;
    addOptional(parser,   'ControlNumbers', [], @checkControlNum);
    addOptional(parser,   'InitialValues',   0, @checkInitialVal);
    addParamValue(parser, 'MIDIDevice',     '', @checkMidiDevice);
    addParamValue(parser, 'OutputMode',    'normalized', @checkOutputMode);
    parse(parser,varargin{:});
    controlNumbers = double(parser.Results.ControlNumbers);
    initialValues = double(parser.Results.InitialValues);
    midiDevice = parser.Results.MIDIDevice;
    outputMode = parser.Results.OutputMode;
    
    normalize = strncmpi(outputMode,'normalized',length(outputMode));
    checkInitialVal(initialValues, normalize, size(controlNumbers));

    if normalize
        initialValues = scaleToRaw(initialValues);
    end
end

function [deviceNum, controlIds] = connectToControls(controlNumbers, initialValues, midiDevice)
    
    deviceNum = getDeviceNum(midiDevice);
    
    if isempty(controlNumbers)
        controlNumbers = -1;
        chan = 0;
    else
        chan = floor(controlNumbers./1000);
        controlNumbers = controlNumbers - chan*1000;
    end
    
    controlIds = zeros(size(controlNumbers));
    
    if isscalar(initialValues)
        for i = 1:numel(controlNumbers)
            [controlIds(i), err] = midiOpenControl(controlNumbers(i),initialValues,chan(i),false,deviceNum);
            % deviceNum == -1  ==>  benign error
            % ignore because we have already warned.
            assert(~err || deviceNum == -1, message('dsp:midi:openFailedUnknown', midiGetErrorMessage(err)));
        end
    else
        for i = 1:numel(controlNumbers)
            [controlIds(i), err] = midiOpenControl(controlNumbers(i),initialValues(i),chan(i),false,deviceNum);
            % deviceNum == -1  ==>  benign error
            % ignore because we have already warned.
            assert(~err || deviceNum == -1, message('dsp:midi:openFailedUnknown', midiGetErrorMessage(err)));
        end
    end
end

function checkControlNum(arg)
    if isempty(arg) && isnumeric(arg)
        return;
    end
    
    arg = arg(:);
    ok = ...
        isnumeric(arg) && ... 
        isreal(arg) && ...
        numel(arg) > 0 && ...
        all(floor(arg) == arg) &&...
        all(arg >= 0)...
        ;

    if ~ok, 
        error(message('dsp:midicontrols:invalidControlNum'));
    end
    
    chan = floor(arg./1000);
    ctlnum = arg - chan*1000;
    ok = ok && ...
        all(0 <= chan) && ...
        all(chan <= 16) && ...
        all(0 <= ctlnum) && ...
        all(ctlnum <= 127)...
        ;
    if ~ok
        error(message('dsp:midicontrols:invalidControlNum'));
    end
end

function yes = isValidVal(arg, varargin)
    yes = ...
        isnumeric(arg) && ... 
        isreal(arg) && ...
        numel(arg) > 0 && ...
        all(0 <= arg(:)) ...
        ;

    if nargin > 1
        normalize = varargin{1};
        sz = varargin{2};
        yes = yes && (isscalar(arg) || isequal(sz, size(arg)));
        if normalize
            yes = yes && all(arg(:) <= 1);
        else
            yes = yes && all(arg(:) <= 127) && all(arg(:) == floor(arg(:)));
        end
    end
end

function checkInitialVal(arg, varargin)
    if ~isValidVal(arg, varargin{:})
        error(message('dsp:midicontrols:invalidInitialVal'));
    end
end

function checkSyncVal(arg, normalize, sz)
    if ~isValidVal(arg, normalize, sz)
        error(message('dsp:midisync:invalidSyncVal'));
    end
end

function checkMidiDevice(arg)
    ok = ischar(arg) && (isrow(arg) || isempty(arg));
    if ~ok
        error(message('dsp:midicontrols:invalidMIDIDevice'));
    end
end

function checkOutputMode(arg)
    ok = ischar(arg) && ...
        isrow(arg) && ...
        (strncmpi(arg, 'normalized', length(arg)) || strncmpi(arg, 'rawmidi', length(arg)));
    if ~ok
        error(message('dsp:midicontrols:invalidOutputMode'));
    end
end

function x = scaleFromRaw(x)
    % use dll for consistency
    % x = (x - (x > 63))./126;
    for i = 1:numel(x)
        x(i) = midiScaleFromRaw(x(i));
    end
end

function x = scaleToRaw(x)
    % use dll for consistency
    % x = floor(0.5 + x * 126)+(x>0.5);
    for i = 1:numel(x)
        x(i) = midiScaleToRaw(x(i));
    end
end

function deviceNum = getDeviceNum(deviceName)
    if isempty(deviceName)
        if ispref('midi','DefaultDevice')
            deviceName = getpref('midi','DefaultDevice');
            deviceNum = lookUpInputDeviceByName(deviceName);
            if deviceNum < 0
                warning(message('dsp:midi:preferredDefaultDeviceOpenFailed', deviceName));
            end
            return;
        else
            deviceNum = midiGetDefaultInputDevice;
            if deviceNum < 0
                warning(message('dsp:midi:systemDefaultDeviceOpenFailed'));
            end
        end
    else
        deviceNum = lookUpInputDeviceByName(deviceName);
        if deviceNum < 0
            warning(message('dsp:midi:specifiedDeviceOpenFailed', deviceName));
        end
    end
end

function deviceNum = lookUpInputDeviceByName(deviceName)
    for deviceNum = 0:midiCountDevices-1
        devinfo = midiGetDeviceInfo(deviceNum);
        if devinfo.input && ~isempty(strfind(devinfo.name, deviceName))
            return;
        end
    end
    deviceNum = -1;
end

function listener = midicallbacklistener(obj, timer, cb, id)
    prevVal = midiread(obj); % init for listenerCallback
    listener = event.listener(timer,'Executing',@listenerCallback);
    
    function listenerCallback(~,~)
        currVal = midiread(obj);
        if ~isequal(prevVal, currVal)
            prevVal = currVal;
            if midicontrols.trace
                fprintf('\nmidicontrols: callback run %d\n', uint32(id));
            end
            cb(obj);
        end
    end
end

function yes = isContiguousVector(nums)
    yes = isvector(nums) && ...
        isequal(nums, nums(1) : nums(1)+numel(nums)-1);
end

