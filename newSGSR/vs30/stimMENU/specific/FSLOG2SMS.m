function SMS=FSLOG2SMS(idfSeq,calib);

% FSLOG2SMS - convert FSLOG menu parameters to SMS XXX

% apart from log spacing, fslog is idenctical to fs, so delegate
SMS = FS2SMS(idfSeq, calib);