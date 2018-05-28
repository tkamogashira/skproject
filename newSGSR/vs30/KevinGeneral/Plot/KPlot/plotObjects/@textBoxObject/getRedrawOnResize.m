function doRedraw = getRedrawOnResize(textBoxObject)


%% see if the handle exists
hdlExists = 1;
try
    findobj(textBoxObject.hdl);
catch
    hdlExists = 0;
end

%% return values
if isequal(1, hdlExists)
    doRedraw = textBoxObject.params.RedrawOnResize;
else
    doRedraw = 0;
end
