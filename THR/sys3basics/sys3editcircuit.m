function FCname = sys3editcircuit(Cname);
% sys3editcircuit - edit COF circuit in RPvdS
%   sys3editcircuit('Foo') opens circuit named "foo.rcx" in RPvdS.
%   The circuit file is located using the path which may be  set using 
%   RPvdSpath. Default extension for circuit files is .rcx,
%   but this can be overruled by specifying a different file extension.
%   Sys3editcircuit returns the full name of the circuit.
%     
%   See also RPvdSpath, sys3loadCircuit, sys3CircuitInfo.

% locate file
FCname = FullFileName(Cname,'','.rcx'); % provide extension if needed
D = fileparts(FCname); % extract directory spec if any
if isempty(D), % look in sys3COFdir and subdirs
    FCname = SearchInPath(FCname, RPvdSpath, 'file');
end
if ~exist(FCname,'file') || isempty(FCname),
    error(['cannot find RCX file ''' Cname ''' in RPvdS path.']);
end
winopen(FCname);
