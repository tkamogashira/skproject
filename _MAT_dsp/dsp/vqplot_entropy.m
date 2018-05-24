function vqplot_entropy(hplotentropy, entropy_array) 
% plots entropy data, sets grid, markers, labels
% hplotentropy = handles.plotEntropyIter;

%   Copyright 1988-2003 The MathWorks, Inc.

     Xgrid_plotEntropyIter = get(hplotentropy,'Xgrid');
     Ygrid_plotEntropyIter = get(hplotentropy,'Ygrid');
	
     h_line=plot(hplotentropy, entropy_array);
     xlabel(hplotentropy, 'Number of Iterations');
     ylabel(hplotentropy, 'Entropy');
     % always call after setting axes, xlabel and ylabel, and plot command
     set(h_line,'ButtonDownFcn',@setdatamarkers);
     set(hplotentropy,'Xgrid',Xgrid_plotEntropyIter);
     set(hplotentropy,'Ygrid',Ygrid_plotEntropyIter);
     
% [EOF]
