function IDFinitFile(fname)

% function IDFinitFile(fname);

ffname = [fname '.IDF'];
if exist(ffname, 'file')
    error([ffname ' is existing file']);
end
% header
header = IDFcreateHeader(0); % zero sequences
fid = fopen(ffname, 'w', 'ieee-le');
IDFheaderWrite(fid, header);
fclose(fid);
