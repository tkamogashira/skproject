function S = retrieve_dbase(FN, kval, def);
% retrieve_dbase - retrieve entries fom a database.
%  retrieve_dbase(FN, kval);
%     FN is filename holding struct array 
%     kval is the value of the keyField identifying the requested entry.
%     This must be a numeric value.
%     if the requested entry is not found, an error results.
%     s may be a an arry of values, in which case a struct array is
%     returned.
%
%     retrieve_dbase(FN) returns the whole database. This is the same as 
%     retrieve_dbase(FN, ':').
%
%     retrieve_dbase(FN, kval, DV); suppresses the error and returns
%     default value DV for unfound entries.
%
%   See also init_dbase, add2dbase.

[kval, def] = arginDefaults('kval/def', ':', log(65474));

% single entry from here
DB = load(FN, '-mat');

if isequal(':' ,kval), % return everything
    S = DB.content;
    return;
end

% filter
for ii=1:numel(kval),
    if isempty(DB.content),
        imatch = [];
    else,
        imatch = find([DB.content.(DB.keyfield)]==kval(ii));
    end
    if isempty(imatch),
        S(ii) = def;
    else,
        S(ii) = DB.content(imatch);
    end
    if isequal(log(65474), S(ii)),
        error('Requested database entry not found.');
    end
end







