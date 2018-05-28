function [Dstr, mess] = sys3defaultdev(dev);
% sys3defaultdev - default sys3 device
%    sys3defaultdev returns a char string that identifies the default
%    sys3 TDT device, e.g. 'RP2_1'. This default value is used by most
%    sysXXX calls if no device is specified. If no default device is known,
%    an error message is returned, unless a second outarg was specified
%    (see below).
%
%    [Dstr, Mess] = supresses the "no default device known" error and
%    it in the string Mess instead. On succesful exit, Mess is empty.
%
%    sys3defaultdev('Foo') sets the default device to Foo.
%
%    See also sys3setup, sys3dev, sys3getpar.

if nargin<1, % get
    mess = '';
    ERR = 'No default device specified for this setup. See Sys3defaultdev.';
    try,
        Dstr = myflag('defaultdevice');
        if isempty(Dstr), 
            Dstr = sys3setup('defaultdevice'); 
            myflag('defaultdevice', Dstr); % store for fast retrieval
        end
    catch,
        if nargout<2, % throw error
            error(ERR);
        else, % suppress error but return erreo mess
            Dstr = '';
            mess = ERR;
        end
    end
else, % set
    % uniquify device name & test for existence
    dev = private_devicename(dev); 
    sys3setup('defaultdevice', dev);
    myflag('defaultdevice', dev);
end




