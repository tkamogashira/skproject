function ds = adjds(varargin)
%ADJDS  constructor for an adjustable dataset
%   ads = ADJDS(ds) returns an adjustable dataset created from
%   the standard dataset ds.
%
%   Attention! This object is created in function of the RAP project and 
%   should not be used directly from the MATLAB command-line interface.

%B. Van de Sande 22-10-2003

S = struct([]);

if (nargin == 1) & isa(varargin{1}, 'adjds'), %Copy constructor ...
    ds = varargin{1};
elseif (nargin == 1) & isa(varargin{1}, 'edfdataset'),
    %If dataset is an EDFdataset, the extra information is discarded ...
    ds = class(S, 'adjds', varargin{1}.dataset);
elseif (nargin == 1) & isa(varargin{1}, 'dataset'),
    ds = class(S, 'adjds', varargin{1});
elseif (nargin == 0), %Creation of empty adjustable dataset ...
    ds = class(S, 'adjds', dataset);
else, error('Wrong creation of an adjustable dataset.'); end