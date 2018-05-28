function EDFdsArray = horzcat(varargin)
% EDFDATASET/HORZCAT HORZCAT-function for EDF dataset objects
%   [DS1 DS2 ..] is a row vector of EDF datasets. 
%   Datasets may only be horzcatted if their schema name is identical.

%B. Van de Sande 07-08-2003

EDFdsArray = catEDFdataset(2, varargin{:});