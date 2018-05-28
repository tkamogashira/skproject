function hdl = getHandle(TB)
% GETHANDLE returns the handle of the textBoxObject object
%
% double hdl = getHandle(textBoxObject TB)

% Created by: Kevin Spiritus
% Last edited: December 7th, 2006


%% see if the handle exists, and return
hdl = TB.hdl;
try
    findobj(hdl);
catch
    hdl = 0;
end