function thisconstruct(h,varargin)
%THISCONSTRUCT Local this construct method.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin < 3,
    varargin{2} = 1; % Make Stepsize default to one as other
                     % projection algorithms. Convergence is
                     % guaranteed.
end

% Default LMS initializer input args
lmsargs = varargin;

if nargin > 4,
    lmsargs = {varargin{1:3}};
    set(h,'Offset',varargin{4});
end
     
if nargin > 5,
    lmsargs = {varargin{1:3},varargin{5:nargin-1}};
end

initlms(h,lmsargs{:});
