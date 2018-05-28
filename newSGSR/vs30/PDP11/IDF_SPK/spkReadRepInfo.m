function rec = spkReadRepInfo(fid)

rep_info_len = 42;

rec.data_rec_kind = 4; % rep_info_record
% var1, var2: stimreal = array[left..right] of real; 
for ii=1:rep_info_len,
   rec.reprec{ii}.loc = SPKreadlocation(fid);
   rec.reprec{ii}.spkcount = freadVAXD(fid,1,'uint16');
end
