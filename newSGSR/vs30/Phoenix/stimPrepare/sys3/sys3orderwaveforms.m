function sys3orderwaveforms(order, wavOffset, zOffset);  
  
% sys3orderwaveforms - given a vector order, the function calculates a vector with the correct offsets   
%                      to the waveforms in a RAMbuf of the RP2_1. Used in conjunction with sys3loadwaveforms.  
%  
%       sys3xxxx.m files should be in      somedir/mfiles    
%       rp_play_waveforms.rco should be in somedir/rpvds        
%         
%       Order can be anything like [1 3 4 5 1 1 2 3 3 3] where 1 - 5 are the numbers of the waveforms  
%       wavOffset and zOffset are returned by sys3loadwaveforms, these contain the offsets per waveform,  
%       needed to calculate the new offset vector, which is loaded into the appropriate memeory space on the RP2_1.  
%  
%   see also SYS3ORDERWAVEFORMS, SYS3PLAYWAVEFORMS  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% calculate offsets for given order         %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
offset = [];  
%for i = 1:length(order),  
%   offset = [offset wavOffset(:, order(i))];  
%end  
  
%offset          %%this loop is for aesthetic purposes only  
  
offset = [];  
for i = 1:length(order),  
    offset = [offset wavOffset(:, order(i))'];  
end  
  
safe_offset = [offset zOffset]                                       %%to make sure there arent' played any sounds after conditions  
  
sys3write(safe_offset, 'offset', 'RP2_1');  
sys3setpar(length(offset) + 1, 'nCond', 'RP2_1');                      %%playing should stop after conds are played (using FeatureSearch)  
  
  
