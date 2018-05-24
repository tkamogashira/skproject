function Hs = tosysobj(this,returnSysObj)
%TOSYSOBJ Convert mfilt FIR interpolator structure to System object

%   Copyright 2011 The MathWorks, Inc.

if ~returnSysObj
  % If returnSysObj is false, then it means that we want to know if the
  % System object conversion is supported for the class at hand. Return a
  % flag as an output instead of returning the filter System object.
  Hs = true;
  return;
end  

% FIR interpolator structures are mapped to a FIRInterpolator System object
Hs = dsp.FIRInterpolator;

Hs.InterpolationFactor = this.InterpolationFactor;

% Make sure the System object coefficients are the refference coefficients
refFilter = reffilter(this);

Hs.Numerator = refFilter.Numerator;

if this.PersistentMemory  
  warning(message('signal:dfilt:basecatalog:PersistentMemory',class(this),'sysobj'));
end

if strcmpi(this.Arithmetic, 'fixed')
  Q = get_filterquantizer(this);
  setsysobjfixedpoint(Q,Hs)  
end

% [EOF]