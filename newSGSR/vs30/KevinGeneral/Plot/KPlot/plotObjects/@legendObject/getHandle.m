function hdl = getHandle(LB)
% GETHANDLE returns the handle of the legendObject object
%
% double hdl = getHandle(legendObject LB)


%% ---------------- CHANGELOG -----------------------
%  Tue Apr 19 2011  Abel   
%   Initial creation based on code of Kevin Spiritus

%% see if the handle exists, and return
hdl = LB.hdl;
try
    findobj(hdl);
catch
    hdl = 0;
end