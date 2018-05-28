function rec = spkReadStimInfo(fid)

stim_info_len = 10;

rec.data_rec_kind = 3; % stim_info_record
% var1, var2: stimreal = array[left..right] of real; 
for ii=1:stim_info_len
   rec.stimrec{ii}.var1 = freadVAXD(fid,2,'single').'; 
   rec.stimrec{ii}.var2 = freadVAXD(fid,2,'single').';
   rec.stimrec{ii}.uet_status = freadVAXD(fid,4,'int16').';
end
