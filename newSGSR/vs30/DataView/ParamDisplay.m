function ll = ParamDisplay(ds);
% PARAMDISPLAY - display stimulus parameters of dataset

Header = disp(ds);
if isequal('IDF/SPK',ds.fileformat), IDFdisp(ds.stimparam);
else, disp(ds.stimparam);
end








