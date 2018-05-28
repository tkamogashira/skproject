function argout = MLVersion()

try
    V = ver; 
    argout = str2double(V(1).Version);
catch
    error('Could not determine Matlab version.');
end