function thisconstruct(h,varargin)
%THISCONSTRUCT Initializer for this class.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

% Default LMS initializer input args
lmsargs = varargin;

if nargin > 4,
    lmsargs = {varargin{1:3}};
    set(h,'SecondaryPathCoeffs',varargin{4});
    set(h,'SecondaryPathEstimate',varargin{4}); % By default estimate is the same
end
% Set the order of the secondary path model filter
set(h,'pathord',length(h.SecondaryPathCoeffs) - 1);

if nargin > 5,
    set(h,'SecondaryPathEstimate',varargin{5});
end
% Set the order of the secondary path model filter estimate
set(h,'pathestord',length(h.SecondaryPathEstimate) - 1);

if nargin > 6,
    lmsargs = {varargin{1:3},varargin{6:nargin-1}};
end

initlms(h,lmsargs{:});
capture(h);

