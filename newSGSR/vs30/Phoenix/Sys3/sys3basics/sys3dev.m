function y = sys3dev(keyword, varargin);  
% Sys3dev - create/delete actxcontrols for commnunication with sys3 devices  
%    Sys3dev creates actxcontrols for the devices listed by Sys3DeviceList.
%    The type of connection (USB vs Gigabit) is determined by Sys3Connection.
%    Nothing is done if the devices are already connected.
%      
%    Sys3dev('CLOSE') deletes the actxcontrols.
%
%    Sys3dev('FORCE') deletes the actxcontrols and creates new ones.
%
%    Sys3dev('PA5_1') returns the actxcontrol of the first PA5, etc.
%    This type of call is used by sys3XXX functions internally; end users
%    do not need it: they can ignore actxcontrols and may simply specify 
%    the *name* of the device, as in Sys3setPar(3.1415, 'Mytag', 'RP2')
%  
%    See also setPA5, Sys3DeviceList, Sys3Connection.

persistent deviceStructure

if nargin < 1
    keyword = 'INIT'; 
end

switch upper(keyword)  
case 'INIT'
    if isempty(deviceStructure)
        deviceStructure = local_Init(varargin{:});
    end
    y = deviceStructure;
case 'FORCE'
    sys3dev('CLOSE');  
    y = sys3dev('INIT');  
case 'CLOSE'  
    if ~isempty(deviceStructure)
        fileNames = fieldnames(deviceStructure);
        for ii=1:length(fileNames)
            fileName = fileNames{ii};
            if ~isequal('fighandles', fileName)
                delete(getfield(deviceStructure,fileName)); 
            end
        end
        delete(deviceStructure.fighandles);
        clear deviceStructure;
    end  
otherwise % return the named device  
    if isempty(deviceStructure)
        sys3dev('INIT'); 
    end % initialize if not yet done  
    try
        y = getfield(deviceStructure,upper(keyword));  
    catch
        error(['Unknown device ''' keyword '''']);  
    end % try/catch  
end % switch/case  


%====================================================

function deviceStructure = local_Init(varargin);
if nargin<1
    varargin = sys3devicelist; 
end % local list of devices
CONNEXION = 'GB'; % GB | USB
deviceStructure.fighandles  = [];  
shh = get(0,'showhiddenhandles');  
set(0,'showhiddenhandles','on');  
for ii=1:length(varargin),
    [devName, devIndex] = strtok(varargin{ii},'_'); % eg RP2_2 is 2nd RP2
    if isempty(devIndex), devIndex = 1;
    else, devIndex = str2num(devIndex(2:end)); % '_2' -> 2, etc
    end
    %devName, devIndex
    if isequal('PA5', upper(devName(1:3))),
        AXC = actxcontrol('PA5.x');
    else, % RP2, RX6 (??) ...
        AXC = actxcontrol('RPco.x');
    end
    set(gcf, 'visible', 'off', 'handlevisibility','off','integerhandle','off');  
    deviceStructure.fighandles = [deviceStructure.fighandles gcf];  
    if ~invoke(AXC, ['connect' devName], CONNEXION, devIndex),  
        error(['Failed connecting ' varargin{ii}]);  
    end  
    eval(['deviceStructure.' varargin{ii} ' = AXC;']);
end
set(0,'showhiddenhandles',shh);  





