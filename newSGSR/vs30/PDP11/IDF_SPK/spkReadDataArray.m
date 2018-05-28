function rec = spkReadDataArray(fid)

% function rec = spkReadDataArray(fid);

arr_time_len = 63;

rec.data_rec_kind = 5; % data_array record
% var1, var2: stimreal = array[left..right] of real; 
% rec.data = fread(fid,arr_time_len,'ulong');
dd = freadVAXD(fid, 2*arr_time_len,'uint16');
Nwords = length(dd);
Nlongs = round(Nwords/2);
rec.data=zeros(1,Nlongs);
twoTo16 = 2^16;
rec.data = twoTo16*dd(1:2:end-1) + dd(2:2:end);
