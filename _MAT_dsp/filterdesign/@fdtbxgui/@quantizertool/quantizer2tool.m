function quantizer2tool(this,q)
%   Copyright 1999-2010 The MathWorks, Inc.

% Set the quantizer class by getting the packagename.classname and stripping
% off the packagename by finding the dot.  It will be quantizer or unitquantizer.
qclass = class(q);
this.quantizerclass = qclass(find(qclass=='.')+1:end);
switch q.mode
 case 'none'
  % this.mode does not allow 'none' because quantizer('none') is turned on
  % and off by this.checkbox.
  this.checkbox = false;
 otherwise
  this.mode = q.mode;
  this.checkbox = true;
  this.roundmode = q.roundmode;
  this.overflowmode = q.overflowmode;
  switch q.mode
   case {'fixed', 'ufixed'}
    this.fixedformat = q.format;
   case {'float', 'double', 'single'}
    this.floatformat = q.format;
  end
end


% Set the values in the gui if it is rendered.
% MODE already has a listener attached to it, so it will be updated
% automatically, so only the other properties are listed here.
if isrendered(this)
  set(this.Handles.checkbox,'Value',this.checkbox)
  if ~isempty(this.Handles.quantizerclass)
    % The value of the popup follows the strings quantizer/unitquantizer.
    lbls = get(this.Handles.quantizerclass,'String');
    set(this.Handles.quantizerclass,'Value',strmatch(this.quantizerclass,lbls));
  end
  % Don't change anything else if the mode is 'none'.
  if ~strcmpi(q.mode,'none')
    lbls = get(this.Handles.roundmode,'String');
    set(this.Handles.roundmode,'Value',strmatch(this.roundmode,lbls));
    
    lbls = get(this.Handles.overflowmode,'String');
    set(this.Handles.overflowmode,'Value',strmatch(this.overflowmode,lbls));
    
    switch q.mode
     case {'fixed', 'ufixed'}
      set(this.Handles.format,'String',['[',num2str(this.fixedformat),']']);
     case {'float', 'double', 'single'}
      set(this.Handles.format,'String',['[',num2str(this.floatformat),']']);
    end
  end
end
