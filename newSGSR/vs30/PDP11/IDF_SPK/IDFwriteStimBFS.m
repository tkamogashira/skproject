function Pos = IDFwriteStimBFS(fid, Seq)

% function Pos = IDFwriteStimFS(fid);
% writes FS stimulus info to IDF file

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'bfs'),
   error('not an ''BFS'' stimtype');
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);
% indiv.stimcmn field
fwriteVAXD(fid, Seq.indiv.stimcmn.lofreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.hifreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.deltafreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.beatfreq, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.duration, 'single');

% indiv.stim fields 
for k=1:2,
   fwriteVAXD(fid, Seq.indiv.stim{k}.spl, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end;
Pos = ftell(fid);
