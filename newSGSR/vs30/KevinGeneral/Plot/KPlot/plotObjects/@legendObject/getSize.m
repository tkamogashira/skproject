function size = getSize(legendObject)
% GETSIZE returns the size of a legendObject object
% size = getSize(legendObject)
%
% A 1x2 array is returned, containing respectively width and height of the
% legendObject when it was last drawn. The values are normalized to the
% axes the legendObject belongs to. If the legendObject was deleted or
% not created yet, 0 is returned.

%% see if the handle exists
hdlExists = 1;
try
    findobj(legendObject.hdl);
catch
    hdlExists = 0;
end

%% return values
if isequal(1, hdlExists)
    size = legendObject.size;
else
    size = 0;
end
