function vqplot_error(hploterror, err_array) 
% plots error data, sets grid, markers, labels
% hploterror = handles.plotErrIter;

%   Copyright 1988-2003 The MathWorks, Inc.

     Xgrid_plotErrIter = get(hploterror,'Xgrid');
     Ygrid_plotErrIter = get(hploterror,'Ygrid');
	
     h_line=plot(hploterror, err_array);
     xlabel(hploterror, 'Number of Iterations');
     ylabel(hploterror, 'Mean Square Error');
     % always call after setting axes, xlabel and ylabel, and plot command
     set(h_line,'ButtonDownFcn',@setdatamarkers);
     set(hploterror,'Xgrid',Xgrid_plotErrIter);
     set(hploterror,'Ygrid',Ygrid_plotErrIter);
     
% [EOF]
