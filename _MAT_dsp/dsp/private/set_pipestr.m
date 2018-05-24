function outpipestr = set_pipestr(inpipestr, pos, str)
% SET_PIPESTR Sets the POS'th string in pipe delimited input string
%    INPIPESTR to be the string STR.  If the POS'th entry exceeds the
%    number of delimited strings in INPIPESTR, empty strings are
%    appended up to the POS'th position.

% Copyright 1995-2011 The MathWorks, Inc.

c=cellpipe(inpipestr);
if ~ischar(str),
   error(message('dsp:set_pipestr:invalidFcnInput1'));
end
if (pos<1),
   error(message('dsp:set_pipestr:invalidFcnInput2'));
end
c{pos}=str;
outpipestr = cellpipe(c);
