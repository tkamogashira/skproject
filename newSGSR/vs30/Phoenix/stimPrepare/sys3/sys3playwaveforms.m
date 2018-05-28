function sys3playwaveforms(wait_flag);  
  
% sys3playwaveforms - gives the RP2_1 the command to play waveforms   
%                       the waveforms have to be loaded first, as well as the order in which they should be played.  
%                       Thus other sys3xxxxwaveforms have to be used first.  
%                         
%       sys3xxxx.m files should be in      somedir/mfiles    
%       rp_play_waveforms.rco should be in somedir/rpvds        
%         
%       With wait_flag one can specify in what manner is waited for all conditions to be played (default = 1)  
%       -1 => wait until all played, then reset index to first waveform, then play again  
%       0  => do not wait, immedeately reset index and play first waveform  
%       1  => reset index to first waveform, wait for all waveforms to play and stop playing  
%  
%       If -1 or 0 is used, nothing stops the RP2_1 from playing: it will always start playing   
%       the first waveform again, followed by all the others. Thereafter the RP2_1 will count to the end of the offset memory,  
%       while nothing is heard (all conditions played <=> silence). However, when the counter reaches the end of offset memory,   
%       it rolls over so the conditions are played again. The rolling over occurs after something like 10000 times the waveform length.  
%       So flag 1 should be used to stop annoying noises from time to time ;-  
%  
%   see also SYS3ORDERWAVEFORMS, SYS3PLAYWAVEFORMS  
  
if nargin < 1, wait_flag = 1; end  
  
if wait_flag == -1,                                         % wait for D/A to finish previous play  
    while sys3getpar('done', 'RP2_1') ~= 0; end;  
end  
  
sys3trig(1, 'RP2_1');                                         %%reset index of serialbuf containing offsets  
  
sys3setpar(1, 'Start', 'RP2_1');   
  
if wait_flag == 1,                                          % wait for D/A to finish previous play  
    while sys3getpar('done', 'RP2_1') ~= 0; end;  
    sys3setpar(0, 'Start', 'RP2_1');  
end  
  
  
  
  
  
  
