function SPKwriteDataArray(fid, spikeData, offset)

% function SPKwriteDataArray(fid, spikeArray, offset);
% writes spike arrival times to SPK file
% Should only be called via SPKaddSeqToFile

if rem(ftell(fid), 256)
   error('not at begin of 256-byte block');
end

fwriteVAXD(fid, 4, 'uint8'); % data_array record ID
fwriteVAXD(fid, 0, 'uint8'); % alignment

arr_time_len = 63;
N = min(arr_time_len, length(spikeData)-offset);

% strange 'long' format of PDP11 is not identical to
% 'vaxd' 'long' format known to MatLab; convert by hand

twoTo16 = 2^16;

lowords = round(rem(spikeData(offset+(1:N)), twoTo16));
hiwords = round((spikeData(offset+(1:N))-lowords)/twoTo16);

% now zip high words and low words
zipped = [hiwords' lowords']';
zipped = zipped(:)'; % order is: hi1 lo1 hi2 lo2 ...

fwriteVAXD(fid, zipped, 'uint16');
IDFfillToNextBlock(fid);
