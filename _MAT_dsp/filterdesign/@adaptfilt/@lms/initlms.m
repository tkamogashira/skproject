function initlms(h,L,Step,Leakage,varargin)
%INITLMS Initialize LMS-based objects.
%
%   Inputs:
%       L        - filter length
%       Step     - LMS Step size
%       Leakage  - Leakage factor
%       varargin - changes depending on algorithm


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1 && ~isempty(L), % Test for empty for the sake of nlms
    set(h,'FilterLength',L);
end

if nargin > 2, set(h,'Step',Step); end

if nargin > 3, set(h,'Leakage',Leakage); end

% Call initializer
initialize(h,varargin{:});
