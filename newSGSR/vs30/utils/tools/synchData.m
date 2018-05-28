function synchData
% synchData - synchronize data from Bigscreen -> SGSRserver

KiwiRoot = 'C:\SGSRserver\ExpData';

if ~atkiwi, error('Data synchronization only from KIWI'); end

% list of local data files
KiwiList = filetree(KiwiRoot);
BulanList = filetree([KiwiRoot '\Bulan']);
% remove files in BULAN folder
Nstr = num2str(length(KiwiList));
KiwiList = structfilter(KiwiList,['~ismember(1:' Nstr ', strfindcell($folder$, ''bulan''))']);
KiwiNames = lower({KiwiList.name});

% list of remote data files
B_is_bigscreen(1); % throw error if bigscreen is not accesible

BigscreenList = filetree('B:\Data\SGSRbackup');
Nb = length(BigscreenList);

% now look for zip files on bigscreen that are not present on kiwi
icopy = 0;
for ii=1:Nb,
   bd = BigscreenList(ii);
   if ~ismember(lower(bd.name), KiwiNames),
      [pp fn ext] = fileparts(bd.name);
      if ~isequal('.zip', lower(ext)), 
         warning(['Non-zip file ''' bd.folder '\' bd.name  ''' ignored.']);
         continue
      end
      bd
      [dummy subfolder] = fileparts(bd.folder)
      destFolder = [KiwiRoot '\'  subfolder];
      if ~exist(destFolder, 'dir'),
         [stat, msg] = mkdir(KiwiRoot, subfolder);
         error(msg);
      end
      SourcePath = [bd.folder '\' bd.name];
      [stat, msg] = copyfile(SourcePath, destFolder);
      error(msg);
      icopy = icopy+1;
   else, % bd exist @ kiwi. But it might be an obsolete version
      ikiwi = strmatch(lower(bd.name), KiwiNames, 'exact');
      if length(ikiwi)>1, error(['Kiwi has multiple versions of zip file ''' bd.name '''.']); end
      kd = KiwiList(ikiwi);
      dnBigScreen = datenum(bd.date);
      dnKiwi = datenum(kd.date);
      doCopy = 0;
      if (dnBigScreen>dnKiwi),
         upper(bd.name);
         doCopy = 1;
      elseif (dnBigScreen<dnKiwi),
         if abs((dnKiwi-dnBigScreen)-1/24)<1e-6, % exactly 1-hour difference. Ignore this Microsoft bullshit.
         else,
            DiffHour = 24*(dnKiwi-dnBigScreen)
            error(['Date of zipfile ''' bd.name ''' is more recent on Kiwi than on Bigscreen?!?.']);
         end
      end
      if doCopy, 
         [stat, msg] = copyfile(SourcePath, destFolder);
         error(msg);
         icopy = icopy+1;
      end
   end
end

disp(['Datafolders synchronized. ' num2str(icopy) ' zip files copied Bigscreen->Kiwi']);

