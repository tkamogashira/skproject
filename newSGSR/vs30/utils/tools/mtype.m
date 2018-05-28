function mtype(filename978352);

% lists variable contents of mat file

try
   load(filename978352, '-mat');
   disp(['Contents of ' filename978352 ':']);
   clear filename978352;
   whos;
catch
   error(['unable to load ' filename]);
end
