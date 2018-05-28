function Pos = IDFwriteStimNTD(fid, Seq)

% function Pos = IDFwriteStimNTD(fid, Seq);

if ~isequal(idfStimName(Seq.stimcntrl.stimtype),'ntd')
   warning('not an ''NTD'' stimtype');
   return
end

% stimcntrl record
idfWriteStimControl(fid, Seq.stimcntrl);

% stimcmn
fwriteVAXD(fid, Seq.indiv.stimcmn.start_itd, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.end_itd, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.delta_itd, 'single');
fwriteVAXD(fid, Seq.indiv.stimcmn.duration, 'single');
% stim{1..2}
for k=1:2
   fwriteVAXD(fid, Seq.indiv.stim{k}.attn, 'int16');
   fwriteVAXD(fid, Seq.indiv.stim{k}.cutoff_freq, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.noise_data_set, 'uchar');
   fwriteVAXD(fid, Seq.indiv.stim{k}.file_name, 'uchar');
   fwriteVAXD(fid, Seq.indiv.stim{k}.total_pts, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.sample_rate, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.rise, 'single');
   fwriteVAXD(fid, Seq.indiv.stim{k}.fall, 'single');
end

Pos = ftell(fid);

% source: IDFreadstimNTD