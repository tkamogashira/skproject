function datasetOut = dspprogfirhdlReorderDataset(datasetIn)
%dspprogfirhdlReorderDataset Reorders the input Simulink(R) Dataset
%   Helper function for dspprogfirhdl_m
%   The input Simulink Dataset contains 

% create a dataset
datasetOut = Simulink.SimulationData.Dataset;
datasetOut.Name = datasetIn.Name;

% Order of output
% Coeff In, Write Addr, Write En, Write Done
% Filter In, Filter Out, Ref Out
datasetOut = datasetOut.addElement(datasetIn.getElement('Coeff In'));
datasetOut = datasetOut.addElement(datasetIn.getElement('Write Addr'));
datasetOut = datasetOut.addElement(datasetIn.getElement('Write En'));
datasetOut = datasetOut.addElement(datasetIn.getElement('Write Done'));
datasetOut = datasetOut.addElement(datasetIn.getElement('Filter In'));
datasetOut = datasetOut.addElement(datasetIn.getElement('Filter Out'));
datasetOut = datasetOut.addElement(datasetIn.getElement('Ref Out'));

% Change the data for Error to be logical
el = datasetIn.getElement('Error');
el.Values.Data = logical(el.Values.Data);
datasetOut = datasetOut.addElement(el);

end

