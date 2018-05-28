function ignoreUD = convertUD()

if mym(10, 'status')
    mym(10, 'open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
    mym(10, 'use ExpData');
end


S = serverdir;
D = dir([servername S.UsrData '\*_usr.m']);

disp([num2str(length(D)) ' user data files found...']);

ignoreUD = {};

% Get all userdata structures
errNo = 0;
for cUD = 1:length(D)
    err = 0;
    try
        fileName = D(cUD).name(1:end-6);
        convertUDEntry(fileName);
    catch
        disp(['Ignoring ' D(cUD).name(1:end-6) '...']);
        ignoreUD = [ignoreUD; D(cUD).name(1:end-6) ' - ' str2line(lasterr, ' <> ')];
        errNo = errNo+1;
        err = 1;
    end
    if ~err
        disp(['Processed ' D(cUD).name(1:end-6) '...']);
    end  
end
disp([num2str(errNo) ' files were ignored.']);

