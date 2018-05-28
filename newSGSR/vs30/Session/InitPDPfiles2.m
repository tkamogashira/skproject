function succeed = InitDPDfiles2(fName, NoMenu);

global DEFDIRS;
datadir = DEFDIRS.IdfSpk;
fullName = [datadir '\' fName];

succeed = 0;
while 1,
	IDFname = [fullName '.IDF'];
   SPKname = [fullName '.SPK'];
   if exist(IDFname) & exist(SPKname),
      if NoMenu, succeed=1; return; end;
      question = ['@IDF & SPK files named ''''' fName ''''' already exist.' ...
            '@in directory ' datadir ...
         '@What to do with them?'];
	   answer = warnchoice1(...
   	   'existing IDF/SPK files specified',...
	      'WARNING' , question, 'Append', 'Cancel');
      if isequal(answer,'Cancel'), 
         return; % failure
      elseif isequal(answer,'Append'), 
         succeed = 1;
         return;
      end
	elseif exist(IDFname) & ~exist(SPKname),
	   mess = strvcat([fullName '.IDF exists but SPK file does not!'], ...
	      'Choose different name for new idf/spk files,',...
	      'or delete or rename existing file.');
      h = errordlg(mess, 'ERROR initializing IDF/SPK files');
      waitfor(h);
      return; % failure
	elseif ~exist(IDFname) & exist(SPKname),
	   mess = strvcat([fullName '.SPK exists but IDF file does not!'], ...
	      'Choose different name for new idf/spk files,',...
	      'or delete or rename existing file.');
      h = errordlg(mess, 'ERROR initializing IDF/SPK files');
      waitfor(h); % failure
      return;
   else, break; end;
end

% create IDF/SPK files
try
   IDFinitFile(fullName);
   SPKinitFile(fullName);
   succeed = 1;
catch
   h = errordlg(strvcat(...
      'Unable to create IDF/SPK files named ',...
       ['''''' fullName  ''''''],...
      'Check filename, write permission, disk space.',...
      '(MatLab error message: ', [lasterr ')']),...
      'ERROR creating IDF/SPK files');
   uiwait(h); 
   return; % failure
end


