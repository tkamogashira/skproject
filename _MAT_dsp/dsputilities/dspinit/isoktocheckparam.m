function okflag = isoktocheckparam(p)
% ISOKTOCHECKPARAM local function to guard mask parameter checks. 
% only check a parameter if 
% --- it is non-empty 
% --  or isempty && not at mask edit time
% This file shall be removed once g553546 is done

% Copyright 2009 The MathWorks, Inc.

    okflag = ~isempty(p) || (isempty(p)&&(~strcmp(get_param(bdroot,'simulationstatus'), 'stopped')));
