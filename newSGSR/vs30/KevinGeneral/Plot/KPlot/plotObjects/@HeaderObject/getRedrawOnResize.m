function doRedraw = getRedrawOnResize(HeaderObject)


%% see if the handle exists
hdlExists = 1;
try
    findobj(HeaderObject.hdl);
catch
    hdlExists = 0;
end

%% return values
if isequal(1, hdlExists)
    doRedraw = HeaderObject.params.RedrawOnResize;
else
    doRedraw = 0;
end
