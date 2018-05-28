function display(ds)
%DISPLAY    display function for an adjustable dataset
%
%   Attention! This object is created in function of the RAP project and 
%   should not be used directly from the MATLAB command-line interface.

%B. Van de Sande 22-10-2003

Cs = cellstr(disp(ds.dataset));
Cs{1} = [Cs{1}, ' (ADJUSTABLE)'];
disp(char(Cs));