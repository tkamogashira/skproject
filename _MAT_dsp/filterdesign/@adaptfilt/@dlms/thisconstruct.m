function thisconstruct(h,varargin)
%THISCONSTRUCT Local this construct method.

%   Author(s): P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

% Default LMS initializer input args
lmsargs = varargin;

if nargin > 4,
    lmsargs = {varargin{1:3}};
    set(h,'Delay',varargin{4});
end
    
if nargin > 5,
    lmsargs = {varargin{1:3},varargin{5:nargin-1}};
end

initlms(h,lmsargs{:});
