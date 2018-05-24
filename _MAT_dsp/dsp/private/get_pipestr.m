function str = get_pipestr(pipestr, pos, extendFlag)
% GET_PIPESTR(PIPESTR, POS) returns the POS'th string from pipe-delimited
%   string PIPESTR.  If POS exceeds the number of strings in the PIPESTR,
%   an error is returned.
%
% GET_PIPESTR(PIPESTR, POS, 1) returns an empty string if POS exceeds the
%   number of strings in PIPESTR.

% Copyright 1995-2011 The MathWorks, Inc.

error(nargchk(2,3,nargin));
if nargin<3, extendFlag=0; end

if ~ischar(pipestr),
   error(message('dsp:get_pipestr:invalidFcnInput1'));
end
if pos<1,
   error(message('dsp:get_pipestr:invalidFcnInput2'));
end

c = cellpipe(pipestr);

if pos > length(c),
   if ~extendFlag,
      error(message('dsp:get_pipestr:invalidFcnInput3'));
   end
   str='';
else
   str=c{pos};
end

