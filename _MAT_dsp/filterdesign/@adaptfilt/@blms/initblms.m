function initblms(h,varargin)

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

% Default LMS initializer input args
lmsargs = varargin;

if nargin > 4,
    lmsargs = {varargin{1:3}};
    set(h,'BlockLength',varargin{4});
end
      
if nargin > 5,
    lmsargs = {varargin{1:3},varargin{5:nargin-1}};
end

initlms(h,lmsargs{:});
