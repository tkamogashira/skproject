function Hs = tosysobj(this,returnSysObj)
%TOSYSOBJ Convert mfilt CIC decimator structure to System object

%   Copyright 2011 The MathWorks, Inc.

if ~returnSysObj
  % If returnSysObj is false, then it means that we want to know if the
  % System object conversion is supported for the class at hand. Return a
  % flag as an output instead of returning the filter System object.
  Hs = true;
  return;
end  

% CIC decimator structures are mapped to a CICDecimator System object
Hs = dsp.CICDecimator;

Hs.DecimationFactor = this.DecimationFactor;
Hs.DifferentialDelay = this.DifferentialDelay;
Hs.NumSections = this.NumberOfSections;

if this.PersistentMemory  
 warning(message('signal:dfilt:basecatalog:PersistentMemory',class(this),'sysobj'));
end

if strcmpi(this.Arithmetic, 'fixed')
  Q = get_filterquantizer(this);
  setsysobjfixedpoint(Q,Hs)  
end

% [EOF]