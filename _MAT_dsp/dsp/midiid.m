function [ctl, device] = midiid
%midiid Interactively identify MIDI control
%   [CTL DEV] = midiid returns the control number and device name of the
%   MIDI control moved by the user.
%
%   This interactive function is used to determine dialog parameters for
%   the MIDI Controls block.  Call the function at the MATLAB command line
%   and then move the control you wish to identify on the MIDI control
%   surface.  The function detects which control you move and returns the
%   corresponding control number and device name that specify that control.
%   
%         >> [ctl dev] = midiid
%         Move the control you wish to identify; type ^C to abort.
%         Waiting for control message... done
%         ctl =
%                 1002
%         dev =
%         nanoKONTROL
%         >> 
%
%   See also MIDICONTROLS, MIDIREAD, MIDISYNC, and MIDICALLBACK.

%   Copyright 2011-2013 The MathWorks, Inc.
 
    assert(isempty(eml.target),'midiid is not supported for code generation.');
    
    sampleTime = 0.1;   % how often we poll controls.
    
    [cids, devices] = openOneControlPerDevice;
    c = onCleanup(@()cleanup(cids));
    if isempty(devices);
        warning(message('dsp:midiId:NoDevices'));
        ctl = [];
        device = '';
        return;
    end

    fprintf('Move the control you wish to identify; type ^C to abort.\nWaiting for control message...');
    try
        [idx, ctl, chn] = debouncedRead(cids, sampleTime);
    catch me
        disp(me);
    end
    fprintf(' done\n');

    deviceInfo = midiGetDeviceInfo(devices(idx));
    device = deviceInfo.name;
    ctl = ctl + chn * 1000;

end

function devices = getAllInputDevices
    devices = [];
    for i = 1:midiCountDevices
        info = midiGetDeviceInfo(i-1);
        if info.input
            devices(end+1) = i-1; %#ok<AGROW>
        end
    end
end

function [cids, devices] = openOneControlPerDevice
    devices = getAllInputDevices;
    anyControl = -1;
    dummyInitVal = 0;
    anyChannel = 0;
    sync = false;
    cids = [];
    devs = [];
    for i = 1:numel(devices)
        [cid, err] = midiOpenControl(anyControl,dummyInitVal,anyChannel,sync,devices(i));
        if ~err
            cids(end+1) = cid; %#ok<AGROW>
            devs(end+1) = devices(i); %#ok<AGROW>
        end
    end
    devices = devs;
end

function [idx, ctl, chn] = debouncedRead(cids, sampleTime)
    ctls = readControls(cids);
    while all(ctls(:) == -1)
        pause(sampleTime);
        ctls = readControls(cids);
    end
    idx = find(any(ctls ~= -1));
    ctl = ctls(1,idx);
    chn = ctls(2,idx);
end

function data = readControls(cids)
    data = zeros(2,numel(cids));
    for i = 1:numel(cids)
        [~, ctl, chn, err] = midiReadLastControl(cids(i));
        if err
            fprintf('%s\n', midiGetErrorMessage(err));
        end
        data(1:2, i) = [ctl; chn];
    end
end

function cleanup(cids)
    for i = 1:numel(cids)
        midiCloseControl(cids(i));
    end
    midiTerminate;
end
