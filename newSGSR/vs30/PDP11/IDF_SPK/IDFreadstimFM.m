function indiv = IDFreadstimFM(fid)

% function indiv = IDFreadstimFMs(fid);

% stim{1..2}
for k=1:2
    indiv.stim{k}.spl = freadVAXD(fid, 1, 'int16');
    indiv.stim{k}.fmcarrlo = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fmcarrhi = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.sweepup = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.sweepdown = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.sweephold = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.delay = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.rise = freadVAXD(fid, 1, 'single');
    indiv.stim{k}.fall = freadVAXD(fid, 1, 'single');
end
