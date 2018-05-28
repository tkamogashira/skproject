function size = getSize(HeaderObject)
% GETSIZE returns the size of a HeaderBox object
% size = getSize(HeaderObject)
%
% A 1x2 array is returned, containing respectively width and height of the
% HeaderObject when it was last drawn. The values are normalized to the
% axes the HeaderObject belongs to. If the HeaderObject was deleted or
% not created yet, 0 is returned.

%% see if the handle exists
hdlExists = 1;
try
    findobj(HeaderObject.hdl);
catch
    hdlExists = 0;
end

%% return values
if isequal(1, hdlExists)
    size = HeaderObject.size;
else
    size = 0;
end
