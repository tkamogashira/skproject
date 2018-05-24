function specifyall(this,flag)
%SPECIFYALL   

%   Author(s): R. Losada
%   Copyright 2003-2005 The MathWorks, Inc.

afnsfq_specifyall(this,flag);

if flag
    as = false;
else
    as = true;
end

this.StateAutoScale         = as;
this.SectionInputAutoScale  = as;
this.SectionOutputAutoScale = as;

% [EOF]
