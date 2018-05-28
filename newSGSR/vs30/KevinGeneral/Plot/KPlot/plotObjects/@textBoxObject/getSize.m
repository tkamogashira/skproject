function size = getSize(textBoxObject)
% GETSIZE returns the size of a textBox object
% size = getSize(textBoxObject)
%
% A 1x2 array is returned, containing respectively width and height of the
% textBoxObject when it was last drawn. The values are normalized to the
% axes the textBoxObject belongs to. If the textBoxObject was deleted or
% not created yet, 0 is returned.

%% see if the handle exists
hdlExists = 1;
try
    findobj(textBoxObject.hdl);
catch
    hdlExists = 0;
end

%% return values
if isequal(1, hdlExists)
    size = textBoxObject.size;
else
    size = 0;
end