function FCname = sys3whichcircuit(Cname);
% sys3whichcircuit - find full file name of COF circuit in RPvdS
%   sys3whichcircuit('Foo') returns the full file name of circuit named 
%   "foo.rcx" in RPvdS. The circuit file is located using the path which 
%   may be  set using RPvdSpath. Default extension for circuit files is .rcx,
%   but this can be overruled by specifying a different file extension.
%     
%   See also sys3loadCircuit, sys3editCircuit.

% locate file
FCname = FullFileName(Cname,'','.rcx'); % provide extension if needed
D = fileparts(FCname); % extract directory spec if any
if isempty(D), % look in sys3COFdir and subdirs
    FCname = SearchInPath(FCname, RPvdSpath, 'file');
end
if ~exist(FCname,'file') || isempty(FCname),
    error(['cannot find RCX file ''' Cname ''' in RPvdS path.']);
end


