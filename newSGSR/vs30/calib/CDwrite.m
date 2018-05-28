function FN = CDwrite(CD, fname, Type);
% CDwrite - write calibration data
if nargin<3,
   Type = CD.CalType;
end
FN = '';
ext = upper(Type);
switch ext,
case {'CAV', 'PRB', 'PRL'}, defdir = calibdir;
case {'ERC'}, defdir = datadir;
otherwise, error(['Unknown caldata type ''' Type ''''])
end

if nargin<2,
   [fn fp] = uiputfile([defdir '\*.' ext], 'Select calibration filename to write');
   if fn==0, return; end; % user cancelled
   FN = [fp fn];
   % impose correct extension
   [pp nn ee] = fileparts(FN);
   FN = fullfile(pp, [nn '.' ext]);
else, FN = fullFilename(fname, defdir, ext);
end
if isequal(ext, 'ERC'), % both channels in same file
   app = {};
   CalType = ext;
   if exist(FN, 'file'), app={'-append'}; end;
   if isequal(1,CD.DAchan),
      L = CD; save(FN, 'L', 'CalType', app{:});
   else,
      R = CD; save(FN, 'R', 'CalType', app{:});
   end
else,
   dummyvarname = CD;
   dummyvarname.CalType = Type;
   save(FN, 'dummyvarname');
end




