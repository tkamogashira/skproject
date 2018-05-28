function SetgrapeFile(DF);
% SetgrapeFile - set grape file for suppression-processing functions
evalin('caller', ['TT = ''' DF ''';']);
grape('filename', DF);
supplist('fn', DF);
grape('mc', 2);
evalin('caller', ['O1 = ''grtoss(7:12)'';']);
evalin('caller', ['O2 = ''grtoss(1:6)'';']);
clear global TOSScmp
if atbigscreen,
    datadir B:\SGSRwork\ExpData
end
