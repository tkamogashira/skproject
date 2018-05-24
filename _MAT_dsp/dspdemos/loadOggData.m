function loadOggData(songName)
%LOADOGGDATA Load input data for Vorbis Decoder demos.

% Copyright 2011 The MathWorks, Inc.

fid = fopen(songName);
hws = get_param(bdroot,'modelworkspace');
hws.assignin('oggData',uint8(fread(fid)));
fclose(fid);
clear hws ans fid;