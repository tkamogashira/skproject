function varargout = dspblkwinfcn2(action)
% DSPBLKWINFCN2 DSP System Toolbox Window Function block helper function
% for mask parameters.

% Copyright 1995-2009 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end
obj = get_param(gcbh,'object');

if (strcmpi(obj.firstCoeffFracLength,'internal error') || ...
    strcmpi(obj.firstCoeffFracLength,'best precision'))
    obj.firstCoeffFracLength = '0';
end

switch action
 case 'init'

  wintype = get_param(gcbh, 'wintype');
  winsamp = get_param(gcbh, 'winsamp');
  Rs      = get_param(gcbh, 'Rs');
  beta    = get_param(gcbh, 'beta');
  nbar    = get_param(gcbh, 'numSidelobes');
  sll     = get_param(gcbh, 'sidelobeLevel');
  userwinName     = get_param(gcbh, 'userWindow');
  OptionalParams  = get_param(gcbh, 'optParams');
  userwinParams   = get_param(gcbh, 'UserParams');

  [w,x,y,str]=dspblkwinfcn2get(wintype,32,winsamp,Rs,beta,nbar,sll,...
                               userwinName,OptionalParams,userwinParams);
  ports = get_labels(obj.winmode);
  dtInfo = dspGetFixptSourceDTInfo(obj);
  dtID = dspCalcSLBuiltinDataTypeID(gcbh,dtInfo,'spblks');
  fixptInfo = dspGetFixptDataTypeInfo(gcbh,43);

  varargout = {x,y,str,ports,w,dtInfo,dtID,fixptInfo};

end
return

% ----------------------------------------------------------
function ports = get_labels(wmode)

% Input port labels:
switch wmode
 case 'Generate window'
  % One label on output:
  ports = struct('type','output', ...
                 'port',1, ...
                 'txt',{'','','Win'});

 case 'Apply window to input'
  % No labels:
  ports = struct('type',{'input','output','output'}, ...
                 'port',1, ...
                 'txt','');

 case 'Generate and apply window'
  % Label all ports:
  ports = struct('type',{'input','output','output'}, ...
                 'port',{1,1,2}, ...
                 'txt',{'In','Out','Win'});
end

return

