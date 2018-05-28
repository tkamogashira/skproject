function [CT, mess] = sys3connection(CT);
% sys3connection - get/set type of TDT connection 
%    sys3connection returns a char string that identifies the connection
%    type of PC-to-TDT interface, which is one of USB, GB (=gigabit).
%
%    sys3connection USB    sets the connection type to USB.
%    sys3connection GB     sets the connection type to GB.
%    The setting is remembered across  MatLab sessions.
%
%    See also sys3setup, sys3devicelist, sys3defaultdev, RPvdSpath.

if nargin<1, % get
    mess = '';
    ERR = 'No connection type specified for this setup.';
    try,
        CT = myflag('connectiontype');
        if isempty(CT), 
            CT = sys3setup('connection'); 
            myflag('connectiontype', CT); % store for fast retrieval
        end
    catch,
        if nargout<2, % throw error
            error(ERR);
        else, % suppress error but return erreo mess
            CT = '';
            mess = ERR;
        end
    end
else, % set
    CT = upper(CT);
    if ~isequal('USB', CT) && ~isequal('GB', CT),
        error('TDT connection type must be one of USB, GB.');
    end
    sys3setup('connection', CT);
    myflag('connectiontype', CT);
end




