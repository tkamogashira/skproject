function s = saveobj(this)
%SAVEOBJ   Save this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% Get all the public properties.
s = rmfield(get(this), 'Algorithm');

% Get the class.
s.class   = class(this);

% Save the release information.
s.version = this.version;

% Make sure we have reset working better.
s.CapturedProperties = this.CapturedProperties;

% Let the subclass add fields.
s = setstructfields(s, thissaveobj(this));

% [EOF]
