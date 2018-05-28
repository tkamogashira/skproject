function ArgOut = disp(ML)
%DISP   display function for metalng object
%   DISP(<metalng object>) displays metalng object information in the command window.
%   s = DISP(<metalng object>) returns the same information as a character string
%   instead of displaying it on the command window.

%B. Van de Sande 09-10-2003

Indent = blanks(5);

if isempty(ML), 
    s = [Indent 'empty metalng object'];
    s = strvcat(s, [Indent 'only contains sink and source contained in same element.']);
else, 
    s = [Indent 'metalng object with ' int2str(length(ML)) ' vertices.']; 
    s = strvcat(s, [Indent 'elements and connections are :']);
    s = strvcat(s, [Indent ' Nr   | Content      | Connections']);
    s = strvcat(s, [Indent '------|--------------|------------']);
    Vertices = ML.Vertices; Edges = ML.Edges;
    NVertices = length(Vertices);
    for n = 1:NVertices,
        if n == 1, s = strvcat(s, [Indent ' 1    | Source       | ' mat2str(Edges{1})]);
        elseif n == NVertices, s = strvcat(s, [Indent ' ' FixLenStr(int2str(NVertices), 4) ' | Sink         | ']);    
        elseif isempty(Vertices{n}), s = strvcat(s, [Indent ' ' FixLenStr(int2str(n), 4) ' | Empty        | ' mat2str(Edges{n})]);
        else, s = strvcat(s, [Indent ' ' FixLenStr(int2str(n), 4) ' | ' FixLenStr(Vertices{n}, 12) ' | ' mat2str(Edges{n})]); end    
    end    
end

if nargout == 1, ArgOut = s; else, disp(s); end