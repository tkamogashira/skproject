function varargout = legacyfixptfir(state_in) %#ok<*STOUT,*INUSD>
%LEGACYFIXPTFIR Toggles between pre and post-R14SP2 fixed-point FIR filters.
%   B = LEGACYFIXPTFIR returns FALSE if the R14SP2 versions of DFILT.DFFIR,
%   DFILT.DFFIRT, DFILT.DFSYMFIR and DFILT.DFASYMFIR are used (default)
%   when the Arithmetic property is set to 'fixed' or TRUE if pre-R14SP2
%   versions are used.
%
%   LEGACYFIXPTFIR(TRUE) sets a preference for the current session to
%   create pre-R14SP2 versions of DFILT.DFFIR, DFILT.DFFIRT, DFILT.DFSYMFIR
%   and DFILT.DFASYMFIR classes when the Arithmetic property is set to
%   'fixed'. This will not affect existing objects in the workspace.
%   
%   LEGACYFIXPTFIR(FALSE) switch the session preference back to post-R14SP2.
%
%   NOTE: LEGACYFIXPTFIR is obsolete and and no longer in use.

%   Copyright 1988-2012 The MathWorks, Inc.

error(message('dsp:legacyfixptfir:Obsolete'));

error(nargchk(0,1,nargin,'struct')); %#ok<*UNRCH>

persistent state %#ok<*NUSED>

if isempty(state),
    state = false;
end

if nargout,
    varargout = {state};
end

if nargin>0,
    if ~islogical(state_in),
        error(message('dsp:legacyfixptfir:MustBeLogical'));
    else
        state = state_in;
    end
end

mlock;


