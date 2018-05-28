function y = sys3dev(kw);  
% SYS3DEV - create/delete actxcontrols for commnunication with sys3 devices  
%    SYS3DEV creates actxcontrols for RP2_1, RV8_1 and PA5. Connections over the GIGABIT
%    are attempted to devices of all kinds: one RP2_1, one RV8_1 and two PA5s.  
%      
%    SYS3DEV('CLOSE') deletes the actxcontrols  
%  
%    See also setPA5  
  
persistent RP2_1 RV8_1 RP2_2 RV8_2 PA5_1 PA5_2 fighandles  
CONNEXION = 'GB'; % GB | USB

if nargin>0,  
    switch upper(kw),  
    case 'FORCE',  
        sys3dev('CLOSE');  
        sys3dev;  
    case 'CLOSE',  
        if ~isempty(RP2_1),  
            delete(RP2_1); RP2_1 = [];  
            delete(RV8_1); RV8_1 = [];  
            delete(RP2_2); RP2_2 = [];  
            delete(RV8_2); RV8_2 = [];  
            delete(PA5_1); PA5_1 = [];  
            delete(PA5_2); PA5_2 = [];  
            delete(fighandles); fighandles = [];  
        end  
    otherwise, % return the named device  
        if isempty(RP2_1), sys3dev; end % initialize if not yet done  
        try, y = eval(upper(kw));  
        catch, error(['Unknown device ''' kw '''']);  
        end % try/catch  
    end % switch/case  
    return;  
elseif nargout>0, % return all devices in struct  
    if isempty(RP2_1), sys3dev; end % initialize if not yet done  
    y = collectInStruct(RP2_1, RV8_1, RP2_2, RV8_2, PA5_1, PA5_2, fighandles);  
    return  
end  
  
fighandles  = [];  
shh = get(0,'showhiddenhandles');  
set(0,'showhiddenhandles','on');  

%-----RP2_1.1-----  
RP2_1 = actxcontrol('RPco.x');  
set(gcf, 'visible', 'off', 'handlevisibility','off','integerhandle','off');  
fighandles = [fighandles gcf];  
if ~invoke(RP2_1, 'connectRP2', CONNEXION, 1),  
    error('Failed connecting RP2_1');  
end  
  
%------RV8_1-------  
RV8_1 = actxcontrol('RPco.x');  
set(gcf, 'visible', 'off', 'handlevisibility','off', 'integerhandle','off');  
fighandles = [fighandles gcf];  
if ~invoke(RV8_1, 'connectRV8', CONNEXION, 1),  
    error('Failed connecting RV8_1');  
end  

%-----RP2_2.1----- 
RP2_2 = actxcontrol('RPco.x');  
set(gcf, 'visible', 'off', 'handlevisibility','off','integerhandle','off');  
fighandles = [fighandles gcf];  
if ~invoke(RP2_2, 'connectRP2', CONNEXION, 2),  
    error('Failed connecting RP2_2');  
end  
  
%------RV8_2 -------  
%RV8_2 = actxcontrol('RPco.x');  
%set(gcf, 'visible', 'off', 'handlevisibility','off', 'integerhandle','off');  
%fighandles = [fighandles gcf];  
%if ~invoke(RV8_2, 'connectRV8', CONNEXION, 2),  
%    error('Failed connecting RV8_2');  
%end  

%------PA5s-------  
PA5_1 = actxcontrol('PA5.x');  
set(gcf, 'visible', 'off', 'handlevisibility','off', 'integerhandle','off');  
fighandles = [fighandles gcf];  
PA5_2 = actxcontrol('PA5.x');  
set(gcf, 'visible', 'off', 'handlevisibility','off', 'integerhandle','off');  
fighandles = [fighandles gcf];  
if ~invoke(PA5_1, 'ConnectPA5', CONNEXION, 1),  
    error('Failed connecting PA5_1');  
end  
if ~invoke(PA5_2, 'ConnectPA5', CONNEXION, 2),  
    error('Failed connecting PA5_2');  
end  
set(0,'showhiddenhandles',shh);  
  
  
  
  
  
