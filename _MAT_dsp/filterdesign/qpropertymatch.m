function [name,msgObj] = qpropertymatch(name,validnames)
%QPROPERTYMATCH  Match property names against valid list.
%   [NAME, ERRMSG] = PROPERTYMATCH(NAME, VALIDNAMES) matches string NAME against
%   strings in cell array VALIDNAMES, and does completion if NAME uniquely
%   matches one of the VALIDNAMES.  An error message is returned in string
%   ERRMSG.  If no errors, then ERRMSG is empty.

%   Thomas A. Bryan, 6 October 1999
%   Copyright 1999-2011 The MathWorks, Inc.

msgObj = [];
if ~ischar(name)
  msgObj = message ('dsp:qpropertymatch:invalidInput1');
  return
end
if ~iscell(validnames)
  msgObj = message ('dsp:qpropertymatch:invalidInput2');
  return
end
name = lower(name);
ind = strmatch(name,validnames);
if isempty(ind)
  msgObj = message ('dsp:qpropertymatch:invalidInput3');
  return
end
if length(ind)==1
  name = validnames{ind};
end
switch name
  case validnames
  otherwise
    completions = sprintf('%s ',validnames{ind});
    msgObj = message ('dsp:qpropertymatch:invalidInput4', name, completions);
end
