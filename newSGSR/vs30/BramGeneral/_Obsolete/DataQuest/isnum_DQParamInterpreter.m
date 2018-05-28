function boolean = isnum_DQParamInterpreter(P)

%B. Van de Sande 09-07-2004

switch(P.DataType)
case {'real', 'int', 'ureal', 'uint'}, boolean = logical(1);
case {'char', 'time', 'interval'}, boolean = logical(0); end