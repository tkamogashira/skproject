function format_listener(this, varargin)

%   Copyright 1999-2010 The MathWorks, Inc.

try
  str = [ '[',num2str(getformat(this)),']' ];
  set(this.Handles.format,'String',str);
catch ME
  senderror(this, ME.identifier, ME.message);
end
