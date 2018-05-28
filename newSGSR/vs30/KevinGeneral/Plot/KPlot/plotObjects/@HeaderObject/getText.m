function text = getText(HeaderObject)
% getText returns the text of a HeaderBox object
% size = getText(HeaderObject)
%
% If the HeaderObject was deleted or
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
    text = HeaderObject.text;
else
    text = [];
end
