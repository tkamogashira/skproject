function [y, Device] = sys3dev(kw, varargin);  
% Sys3dev - create/delete actxcontrols for communication with sys3 devices  
%    Sys3dev('INIT') or just Sys3dev with no input args creates 
%    actxcontrols for all the devices listed by Sys3DeviceList.
%    Nothing is done if the devices are already connected.
%      
%    Sys3dev('CLOSE') deletes the actxcontrols ('disconnects').
%
%    Sys3dev('FORCE') deletes the actxcontrols and creates new ones.
%
%    Sys3dev('PA5_1') returns the actxcontrol of the first PA5, etc.
%    If no devices are connected, *all* devices are connected at the time
%    of this call. This type of call is used by sys3XXX functions internally, but 
%    end users do not need it: they can ignore actxcontrols and may simply 
%    specify the *name* of the device, as in:
%        Sys3setPar(3.1415, 'Mytag', 'RP2')
%    This implicitly connects all devices, if they weren't connected yet.
%
%    actx = Sys3dev('') returns the actxcontrol of the default sys3 device 
%
%    [actx, DevName] = Sys3dev(...) also returns the name of the device.
%
%  
%    See also Sys3setup, Sys3DeviceList, Sys3defaultDev.

persistent DS % device structure  
if (nargin<1),
    if (nargout<1), % default action: initialize all devices present
        kw = 'INIT';
    else, % return default device actxcontol & name
        kw = '';
    end
end 

switch upper(kw),  
case 'INIT',
   if isempty(DS),
      DS = local_Init(varargin{:});
   end
   y = DS;
case 'GET', % jsut return DS - no action
   y = DS;
case 'FORCE',  
   sys3dev('CLOSE');  
   y = sys3dev('INIT');  
case 'CLOSE',  
   if ~isempty(DS),
      FNS = fieldnames(DS);
      for ii=1:length(FNS),
         fn = FNS{ii};
         if ~isequal('fighandles', fn),
            delete(DS.(fn)); 
         end
      end
      delete(DS.fighandles);
      clear DS;
   end  
otherwise, % return the actx control and unique name of the device  
   if isempty(DS), sys3dev('INIT'); end % initialize if not yet done  
   Device = upper(kw);
   if isempty(Device), Device = sys3defaultdev; end
   % get "full", unique name of device & test for its existence
   [Device, Mess] = private_devicename(Device);
   error(Mess);
   y = DS.(Device);
end % switch/case  


%====================================================

function DS = local_Init(varargin);
if nargin<1, varargin = sys3devicelist; end % local list of devices
CONNEXION = sys3setup('Connection'); % GB | USB, as specified in local setup file
DS.fighandles  = [];  
% shh = get(0,'showhiddenhandles');  
% set(0,'showhiddenhandles','on');  
DS.fighandles = figure('visible', 'off', 'handlevisibility','off','integerhandle','off', 'userdata', 'dontclose', 'closereq', '');  
for ii=1:length(varargin),
   [devName, devIndex] = strtok(varargin{ii},'_'); % eg RP2_2 is 2nd RP2
   devIndex = str2double(devIndex(2:end)); % '_2' -> 2, etc
   % devName, devIndex
   pause(0.02); % fast calls interfere with previous calls, crashing actxcontrol ..
   if isequal('ZBU', upper(devName(1:3))), % ZBUS: special syntax (no device index)
       AXC = actxcontrol('zBus.x', [893   375   265   723], DS.fighandles);
        if ~invoke(AXC, ['connect' devName], CONNEXION),
            error(['Failed connecting ' varargin{ii}]);  
        end
        % If requested, issue hardware reset to prevent ADC offset anomaly of RX6.
        if sys3setup('resethardware'),
            Mess = '...resetting hardware.....';
            if isempty(gcg), disp(Mess);
            else, GUImessage(gcg, Mess, 'warn');
            end
            sys3hardwarereset(AXC);
            Mess = 'hardware reset.';
            if isempty(gcg), disp(Mess);
            else, GUImessage(gcg, Mess);
            end
        end
   else, % all non-zBus: PA5, RP2, RX6 ...
        if isequal('PA5', upper(devName(1:3))),
            AXC = actxcontrol('PA5.x', [893   375   265   723], DS.fighandles);
        else
            AXC = actxcontrol('RPco.x', [893   375   265   723], DS.fighandles);
        end
        if ~invoke(AXC, ['connect' devName], CONNEXION, devIndex),  
            error(['Failed connecting ' varargin{ii}]);  
        end
   end
   DS.(varargin{ii}) = AXC;
   % bookeeping
   private_CircuitInfo(varargin{ii}, '-reset');
end
% set(0,'showhiddenhandles',shh);  




















