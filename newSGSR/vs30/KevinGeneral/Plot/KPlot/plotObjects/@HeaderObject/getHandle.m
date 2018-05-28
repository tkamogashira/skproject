function hdl = getHandle(H)
% GETHANDLE returns the handle of the HeaderObject object
%
% double hdl = getHandle(HeaderObject H)

% Created by: Kevin Spiritus
% Last edited: December 7th, 2006


%% see if the handle exists, and return
hdl = H.hdl;
try
    findobj(hdl);
catch
    hdl = 0;
end