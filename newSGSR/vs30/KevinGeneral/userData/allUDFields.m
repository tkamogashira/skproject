function outFields = allUDFields()

S = serverdir;
D = dir([servername S.UsrData '\*_usr.m']);

disp([num2str(length(D)) ' user data files found...']);

UD = [];

% Get all userdata structures
errNo = 0;
for cUD = 1:length(D)
    err = 0;
    try
        UD = [UD; getuserdata_old(D(cUD).name(1:end-6))];
    catch
        disp(['Ignoring ' D(cUD).name(1:end-6) '...']);
        errNo = errNo+1;
        err = 1;
    end
    if ~err
        disp(['Processed ' D(cUD).name(1:end-6) '...']);
    end    
end
disp([num2str(errNo) ' files were ignored.']);

% what fields are there?
expFields = {};
cellFields = {};
DSFields = {};

for cUD = 1:length(UD)
    if ~isempty(UD(cUD).Experiment)
        expFields   = [expFields; fieldNamesDeep(UD(cUD).Experiment)];
    end
    if ~isempty(UD(cUD).CellInfo)
        cellFields  = [cellFields; fieldNamesDeep(UD(cUD).CellInfo)];
    end
    if ~isempty(UD(cUD).DSInfo)
        DSFields    = [DSFields; fieldNamesDeep(UD(cUD).DSInfo)];
    end
end

outFields.expFields = unique(expFields);
outFields.cellFields = unique(cellFields);
outFields.DSFields = unique(DSFields);