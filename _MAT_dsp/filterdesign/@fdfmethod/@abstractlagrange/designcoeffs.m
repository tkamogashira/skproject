function varargout = designcoeffs(this, specs, varargin)
%DESIGNCOEFFS   Design the filter and return the coeffs.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

if nargin < 2,
    % Create a default specifications object
    specs = feval(validspecobj(this));
end

% Allow subclasses to process the specifications.
specs = preprocessspecs(this, specs);

% Validate the specifications
[isvalid,errmsg,msgid] = validate(specs);
if ~isvalid,
    error(message(msgid,errmsg));
end

% Perform algorithm specific validation
validate(this,specs);

% Try/Catch the subclass.  We do not know if they will error out and we
% will need to reset the normalizedFrequency property if they do.
try
    % Perform actual design
    [varargout{1:nargout}] = actualdesign(this,specs,varargin{:});
catch ME
    throwAsCaller(ME);
end

% [EOF]
