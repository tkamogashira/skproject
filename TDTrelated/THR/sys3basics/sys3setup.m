function y = sys3setup(Prop, Val);  
% Sys3setup - list setup properties for local TDT setup
%    Sys3setup lists all current TDT setup properties.
%
%    Sys3setup('Foo') displays and returns sys3 property Foo.
%    Properties are case INsensitive and may be abbreviated.
%    Valid properties are
%         devicelist: list of hardware devices connected to this computer
%         connection: connection type GB/USB. 
%      defaultdevice: default sys3 device, e.g. RP2_1
%            COFpath: semicolon-separated dir list for locating COF files
%       DSPcount_RX6: number of DSPs in RX6 (2 or 5)
%         maxFsamRX6: max sample rate (kHz) for sequenced play on RX6
%      resethardware: whether to reset the hardware at initialization time
%                    (i.e., at the first call of sys3dev in a Matlab
%                    session). This helps preventing anomalous DC offsets
%                    in the analog input channels of the RX6.
%
%    These properties can be set using the functions listed below.
%
%    See also sys3devicelist, sys3connection, sys3defaultDev, RPvdSpath,
%    RX6DSPcount.

DoSet = nargin>1;

SFN = 'sys3setup'; % local TDT settings (this computer only)

if nargin<1, % just list
    y = FromSetupfile(SFN);
    if nargout<1, 
        disp(' ');
        disp(['--' SFN '---'])
        disp(y); 
        clear y
    end
    return;
end
y = FromSetupfile(SFN);
%if isnan(y), return; end
AllProps = {'devicelist' 'connection' 'defaultdevice' 'COFpath' 'DSPcount_RX6' 'maxFsamRX6' 'resethardware'};
[Prop, Mess] = keywordMatch(Prop, AllProps, 'Sys3 setting');
error(Mess);
FacErr = ['No factory value exists for sys3 setting ''' Prop '''.'];
switch Prop,
    case 'devicelist',
        if DoSet,
            if isequal('-factory', Val), error(FacErr); end
            if ~isequal({},Val) && ~iscellstr(Val), error('Device List must be cell array of strings'); end
        else,
            y = FromSetupFile(SFN, Prop);
        end
    case 'COFpath',
        path_1 = fullfile(versiondir, 'TDT\rpvds');
        path_2 = fullfile(versiondir, 'TDT\seqplay\rpvds');
        DefPath = [genpath(path_1) genpath(path_2)]; % include subdirs
        if DoSet,
            if isequal('-factory', Val), Val = DefPath; end
            if ~ischar(Val), error('COFpath must be character strings'); end
        else,
            y = FromSetupFile(SFN, Prop, '-default*', DefPath);
        end
    case 'connection',
        if DoSet,
            if isequal('-factory', Val), error(FacErr); end
            if ~isequal('GB', Val) & ~isequal('USB', Val), 
                error('Sys3 ''connection'' property must be either GB or USB.'); 
            end
        else,
            y = FromSetupFile(SFN, Prop);
        end
    case 'defaultdevice',
        if DoSet,
            if isequal('-factory', Val), error(FacErr); end
            if ~ischar(Val), error('Default device must be char string.'); end
        else,
            y = FromSetupFile(SFN, Prop);
        end
    case 'DSPcount_RX6',
        DefCount = 2; % default: 2 DSPs in RX6
        if DoSet,
            if isequal('-factory', Val), Val = DefCount; end
            if ~isequal(2, Val) && ~isequal(5, Val), error('DSPcount_RX6 must be either 2 or 5.'); end
        else,
            y = FromSetupFile(SFN, Prop, '-default*', DefCount);
        end
    case 'maxFsamRX6',
        DefRate = inf; % default: no restriction
        if DoSet,
            if isequal('-factory', Val), Val = DefRate; end
        else,
            y = FromSetupFile(SFN, Prop, '-default*', DefRate);
        end
    case 'resethardware',
        DefReset = 0; % default: don't reset at init time
        if DoSet,
            if isequal('-factory', Val), Val = DefReset; end
            if ~isequal(0, Val) && ~isequal(1, Val), error('DSPcount_RX6 must be either 0 (false) or 1 (true).'); end
        else,
            y = FromSetupFile(SFN, Prop, '-default*', DefReset);
        end
end % switch/case
if DoSet, 
    ToSetupFile(SFN, '-propval', Prop, Val),
end





