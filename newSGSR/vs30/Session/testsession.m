function y=testsession(varargin);

% TESTSESSION - developer function; start session without uicontrols

DataFileName = 'test';
ERCdir = [datadir '\'];
CalibParams = struct(...
   'DAchannel','Both',...
   'CalibMode','FLAT',...
   'ERCfile','',...
   'maxLevel', 130, ...
   'ERCdir',ERCdir...
   );
RecSide = 1;
IDreq = 1;
Experimenter = 'test';
% (DFN, CalibParams, RecSide, requestID, Experimenter, NoMenu);
NewSession('nomenu',DataFileName, CalibParams, RecSide, IDreq ,Experimenter);

global SESSION
SESSION.KeepPen = 0;


