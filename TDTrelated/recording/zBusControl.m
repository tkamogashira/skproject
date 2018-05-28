function varargout=zBusControl(varargin)
%zBusControl -- Interface for the TDT system3 zBUS
%  Slightly easier than directly using invoke command
%

global zBus %ActiveX Control handle

%If no input is specified, list the options with some explanations
if ~nargin
    disp('###### zBusControl ######')
    disp('Handle Name:  zBus (global)');
    disp(' ')
    disp('--- Command List ---')
    disp('''Initialize'' | Define ActX object');
    disp('''TrigA'' | Trigger A');
    disp('''TrigB'' | Trigger B');
    disp('''GetError'' | Get error message');
    
    return
else
    Action=varargin{1};
end

switch lower(Action)
case 'initialize' %Initialize RP2 and return the ActX handle
    zBus=actXcontrol('ZBUS.x',[1 1 1 1]); 

%    e=double(invoke(zBus, 'connectZBUS','USB'));
    e=double(invoke(zBus, 'connectZBUS',TDTInterface));

    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
case 'triga' %Trigger A
    e=double(invoke(zBus,'zBusTrigA',0,0,8));
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end

case 'trigb' %Trigger B
    e=double(invoke(zBus,'zBusTrigB',0,0,8));
    %Return the flag for error
    if nargout
        varargout{1}=e;
    end
case 'geterror' %Get error message
    mystr=invoke(zBus,'GetError');
    if nargout
        varargout{1}=mystr;
    end
otherwise
    error(['Unrecognized action ''' Action '''']);
end
