function hc = copy(this)
%COPY   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Construct the object.
hc = feval(str2func(class(this)));

rbf = this.PersistentMemory;

hc.PersistentMemory = true;

ws = warning('off','signal:dfilt:basefilter:warnifreset:PropWillBeReset');

% Set filter length and blocklength first
hc.FilterLength = this.FilterLength;
hc.ProjectionOrder = this.ProjectionOrder;

% Get all props
s = get(this);

% Remove props that have been copied already
s = rmfield(s,'FilterLength');
s = rmfield(s,'ProjectionOrder');

set(hc,s);

hc.PersistentMemory = rbf;

% Capture the state of the object so that we reset to this state.
capture(hc);

warning(ws);


% [EOF]
