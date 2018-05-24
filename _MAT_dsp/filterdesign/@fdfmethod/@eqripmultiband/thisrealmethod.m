function m = thisrealmethod(this)
%THISREALMETHOD   

%   Copyright 2008-2011 The MathWorks, Inc.
  
if this.MinPhase || this.MaxPhase || ~this.UniformGrid || this.privForcedFreqPoints

    if isequal(this.privUGridFlag,1)
        warning(message('dsp:fdfmethod:eqripmultiband:thisrealmethod:UniformGridTrueIgnored'));
    end

   m = @firgr;

else
    m = @firpm;
end

% [EOF]
