function N = length(ML)
%LENGTH  number of elements in metalng object
%   N = LENGTH(<metalng object>) returns the total number of elements in a
%   metalng object, including sink, source and empty elements.

%B. Van de Sande 09-10-2003

N = length(ML.Vertices);