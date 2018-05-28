function init_dbase(FN, keyfield, flag);
% init_dbase - add a struct as entry to a database file
%   init_dbase(FN, keyfield)
%     FN is filename holding struct array 
%     KeyField is the fieldname in S identifying the entry
%
%   init_dbase(FN, keyfield, 'overwrite') overwrites any earlier version of
%   database in FN.
%
%   init_dbase(FN, keyfield, 'onlyifnew') does not do anything when th
%   database already exists (the default behavior is to throw an error).
%
%
%   See also add2dbase, retrieve_dbase.

[flag] = arginDefaults('flag', '');

if ~isvarname(keyfield),
    error('Key field must be valid MATLAB identifier.');
end
if exist(FN, 'file') && isequal('onlyifnew', flag),
    return;
elseif exist(FN, 'file') && ~isequal('overwrite', flag),
    error(['Database in file ''' FN ''' already exists. Choose new name or use ''overwrite'' or ''onlyifnow'' flag.']);
end
DB.keyfield = keyfield;
DB.content = [];
structsave(FN ,DB);

