function EDFdsArray = vertcat(varargin)
% EDFDATASET/VERTCAT VERTCAT-function for EDF dataset objects
%   [DS1; DS2; ..] is a column vector of EDF datasets. 
%   Datasets may only be vertcatted if their schema name is identical.

%B. Van de Sande 07-08-2003

EDFdsArray = catEDFdataset(2, varargin{:});