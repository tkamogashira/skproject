function Data = LoadMadisonSchemeType(fid, SchemeType)

Data = struct([]);

if nargin ~= 2
    error('Wrong number of input arguments');
end

SchemeType = upper(deblank(SchemeType));
SchemesDir = [fileparts(which(mfilename)) '\SCHEMES'];
if exist([SchemesDir '\' SchemeType '.m'], 'file'), 
    curdir = pwd;
    cd(SchemesDir);    
    Data = eval(sprintf('%s(fid)', SchemeType));
    cd(curdir);
end
