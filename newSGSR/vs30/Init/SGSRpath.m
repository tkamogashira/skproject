function SGSRpath

% Sets SGSR MatLab path.
% The AddToPath function must be in the path at the time of calling
% SGSRpath, the global variables SGSRDIR and VERSIONDIR must have their
% correct values in order for AddToPath to work.

global SGSRDIR;

if exist('pathdeforig')
    % MatLab path unpolluted by pathtool
    pathdeforig;
end

[initDir] = fileparts(which(mfilename)); % SGSRpath itself resides ...
  % ... in init dir store this dir before resetting path to factory settings

if isempty(strfind(pathdef, initDir))
    path([initDir ';' pathdef]); % restore factory settings but include initDir
else
    path(pathdef);
end

% dirs relative to sgsr 'root' dir in global VERSIONDIR
addToPath('TDT');
addToPath('TDT\APOS');
addToPath('TDT\XBDRV');
addToPath('TDT\S232');
 
addToPath('PRP');
addToPath('PDP11\IDF_SPK');

addToPath('STIMDEF');
addToPath('STIMEVAL');
addToPath('STIMGEN');
addToPath('STIMDA');

addToPath('INIT');
addToPath('Session');
addToPath('CALIB');
addToPath('TCURVE');
addToPath('SPIKEREC');

addToPath('STIMMENU');
addToPath('STIMMENU\SPECIFIC');
addToPath('STIMMENU\CONSTRUCTION');

addToPath('UTILS\TOOLS');
addToPath('UTILS\STRFUN');
addToPath('UTILS\CONVERSION');
addToPath('UTILS\UI');
addToPath('UTILS\MISC');
addToPath('UTILS\KMAIL');

addToPath('DataStruct');
addToPath('Phoenix');
addToPath('Phoenix\Utilities');
addToPath('statZ',  'append');

addToPath('KQuest\startup', true);

%if inLeuven || inUtrecht || inRotterdam,
   % addToPath('RAP');
   addToPath('EREV');
   addToPath('Phoenix\EyeTrack');
   addToPath('Phoenix\stimPrepare');
   addToPath('Phoenix\stimPrepare\theStimuli');
   addToPath('Phoenix\Sys3\sys3basics');
   addToPath('Phoenix\Sys3\SeqPlay');
   addToPath('Phoenix\Sys3\RX6timing');
   addToPath('Phoenix\OUI');
   AddKevinBramPaths;
%end

addToPath('LOOK');
addToPath('SpikeAna');

addToPath('DataView');
addToPath('DataView\HistPlot');
addToPath('DataView\IndepPlot');

% add Java stuff to Classpath
%if inLeuven || inUtrecht,
   AddJavaClassPath exampleGUI
%end

% if this system belongs to a "developer", add developer dirs to path
if isdeveloper,
   DevDir = updir(SGSRDIR);
   path(path, [DevDir '\developOnly\planning']);
   path(path, [DevDir '\developOnly\buzz']);
   path(path, [DevDir '\developOnly\local']);
end
clear SGSRDIR

AddToLog('SGSR path defined');
