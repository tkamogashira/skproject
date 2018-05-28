function doRedraw = getRedrawOnResize(legendObject)

%% see if the handle exists
hdlExists = 1;
try
    findobj(legendObject.hdl);
catch
    hdlExists = 0;
end

%% return values
if isequal(1, hdlExists)
    doRedraw = legendObject.params.RedrawOnResize;
else
    doRedraw = 0;
end
