function Add2dbase(FN, S);
% Add2dbase - add a struct as entry to a database file
%   Add2dbase(FN, S);
%     FN is filename holding struct array 
%     S is the struct representing the entry, or struct array for multiple 
%     entries.
%
%   See also init_dbase, retrieve_dbase.

DB = load(FN, '-mat');
for ii=1:numel(S), % add or replace single entry
    s = S(ii);
    if isempty(DB.content),
        imatch = [];
    else,
        imatch = find([DB.content.(DB.keyfield)]==s.(DB.keyfield));
    end
    if isempty(imatch),
        DB.content = [DB.content s];
    else,
        DB.content(imatch) = s;
    end
end
structsave(FN, DB);






