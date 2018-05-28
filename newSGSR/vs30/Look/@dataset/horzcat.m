function hc = horzcat(varargin);
% DATASET/HORZCAT - HORZCAT for DATASET objects
%   [DS1 DS2 ..] is a row vector of datasets. 
%   Datasets may only be horzcatted if their Stimtype is identical.

% refer to a non-method because that is easier to use (dataset/subsref usage)
hc = datasetCat(2, varargin{:});