function hc = vertcat(varargin);
% DATASET/VERTCAT - VERTCAT for DATASET objects
%   [DS1; DS2 ..] is a column vector of datasets. 
%   Datasets may only be vertcatted if their Stimtype is identical.

% refer to a non-method because that is easier to use (dataset/subsref usage)
hc = datasetCat(1, varargin{:});