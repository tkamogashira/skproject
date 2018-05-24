function sendupdate(this)
%SENDUPDATE   Method to send all the events necessary to update the filter.
%   THis method is used to update all the filter internals along with the
%   states whenever a quantity changes that affects them.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

% Send the updateinternals event
send(this,'updateinternals');

% Quantize states after internals have been updated
send_quantizestates(this);


% [EOF]
