function devlist = sys3deviceList(varargin)
% sys3deviceList - specify/retrieve list of sys3 devices connected
%    y = sys3deviceList returns the list of sys3 devices hooked up to the current setup
%
%    sys3deviceList('RP2_1', ...) specifies the list. This list is remembered across
%    MatLab sessions.
%
%    sys3deviceList([]) specifies an empty list, indicating that no TDT
%    hardware is connected to this computer.
%
%    sys3deviceList KULAK   specifies the standard sys3 hardware connected
%    to Kulak: ZBUS_1 RX6_1 RP2_1 PA5_1 PA5_2
%
%    sys3deviceList SIUT   specifies the standard sys3 hardware connected
%    to Kulak: ZBUS_1 RX6_1 RP2_1 PA5_1 PA5_2
%
%    sys3deviceList CLUST   specifies the standard sys3 hardware connected
%    to Clust: ZBUS_1 RX6_1 RP2_1 PA5_1 PA5_2
%
%    sys3deviceList YXO   specifies the standard sys3 hardware connected
%    to YXO: ZBUS_1 RP2_1
%
%    sys3deviceList EE1285a  specifies the standard sys3 hardware connected
%    to Ee1285a: ZBUS_1 RX6_1
%
%    sys3deviceList Default  is equivalent to sys3devicelist(compuname());
%
%    See also sys3setup, sys3connection, sys3dev, compuname.

% delegated to more generic sys3setup file

if nargin<1, % query
    devlist = myflag('devicelist');
    if isempty(devlist), 
        devlist = sys3Setup('devicelist');
        myflag('devicelist', devlist);
    end;
elseif nargin==1 && isequal(upper(varargin{1}), 'KULAK'),
    devlist = sys3devicelist('ZBUS_1', 'RX6_1', 'PA5_1', 'PA5_2');
elseif nargin==1 && isequal(upper(varargin{1}), 'SIUT'),
    devlist = sys3devicelist('ZBUS_1', 'RX6_1', 'RP2_1', 'PA5_1', 'PA5_2');
elseif nargin==1 && isequal(upper(varargin{1}), 'CLUST'),
    devlist = sys3devicelist('ZBUS_1', 'RX6_1', 'RP2_1', 'PA5_1', 'PA5_2');
elseif nargin==1 && isequal(upper(varargin{1}), 'YXO'),
    devlist = sys3devicelist('ZBUS_1', 'RP2_1');
elseif nargin==1 && isequal(upper(varargin{1}), 'EE1285A'),
    devlist = sys3devicelist('ZBUS_1', 'RX6_1');
elseif nargin==1 && isequal(upper(varargin{1}), 'DEFAULT'),
    devlist = sys3devicelist(compuname());
else, % set
    if nargin==1 && isempty(varargin{1}),
        devlist = {};
    else,
        devlist = varargin;
        % add suffix '_1" if no index is present
        for ii=1:length(devlist),
            if isempty(strfind(devlist{ii}, '_')),
                devlist{ii} = [devlist{ii} '_1'];
            end
        end
        devlist = upper(devlist);
    end
    sys3Setup('devicelist', devlist);
    myflag('devicelist', devlist);
end






