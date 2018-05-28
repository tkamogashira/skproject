function [zOffset, wavOffset] = sys3loadwaveforms(Wav, nPlay, reqSrate);  
  
% sys3loadwaveforms - loads waveforms into a RAMbuf on the RP2_1 and split into a number of intervals to save storage space  
%  
%       sys3xxxx.m files should be in      somedir/mfiles    
%       rp_play_waveforms.rco should be in somedir/rpvds        
%         
%       all waveforms should have the same length, and sorted in columns of the matrix Wav.  
%       nPlay specifies the total length (in samples) to be played (=condition). When nPlay > length(Wav), zeros are added.  
%       reqSrate is 25, 50 or 100 kHz. 48828 samples @ 50kHz equals 1 second since Srate isn't 50kHz exactly  
%  
%       Since the rp_play_waveforms circuit is loaded by this function, any data in any buffer on the RP2_1 is lost.  
%  
%       When Nplay > 2*length(Wav), the function divides the whole waveforn into intervals, where the first interval contains   
%                                   the waveform itself and the other intervals contain zeros only. Hence, we save RAM memory   
%                                   by only storing the waveforms and 1 block of zeros. Offsets are used to play the correct   
%                                   conditions after all.  
%  
%       sys3loadwaveforms returns zOffset = offset of block of zeros in the RAMbuf (eg 150)  
%                           and wavOffset = a matrix with nWav columns containing the offsets per waveform  
%                                             eg   0    50   100    for 3 waveforms of 40 samples with nPlay set to 50.  
%                                                  150  150  150  
%  
%   see also SYS3ORDERWAVEFORMS, SYS3PLAYWAVEFORMS  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% initialise                              %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if nargin < 3, reqSrate = 50; end  
if nargin < 2, reqSrate = 50; nPlay = 0; end                         %%no zeros have to be added.  
  
sys3loadCOF('rp_play_waveforms', 'RP2_1', reqSrate);                   %%load circuit  
[n, nWav] = size(Wav);  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% split up waveforms                        %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
k = floor(nPlay/n)                                                     
  
if k == 0,   
    realNplay = n  
    nIntv = realNplay                                               %%no zeros added, just play waveforms  
else  
    realNplay = k * ceil(nPlay/k)                                   %%this is new condition length  
    nIntv = realNplay/k                                             %%this is new waveform length  
end  
  
for i = 1:nWav,  
    sys3write(vectorzip(Wav(:,i)', Wav(:,i)'), 'waveform', 'RP2_1', 2 + 2*(i-1)*nIntv, 'I16');        
end                                                                  %%+2 xtra offset since TDT's device skips 1 sample  
  
zOffset = nWav*nIntv;                                                %%offset of block containing zeros only  
  
sys3setpar(nIntv, 'nIntv', 'RP2_1');                                   %%this sets pulsetrain period  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% calculate offsets for every waveform      %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
for i = 1:nWav,                                                      %%nWav columns, k rows  
    if k == 0,  
        wavOffset(1,i) = (i - 1) * n;  
    else  
        for j = 1:k,                                         
            if j == 1,  
                wavOffset(j,i) = (i + j - 2) * nIntv;                %%first row = offsets of waveforms  
            else  
                wavOffset(j,i) = zOffset;                            %%other rows = offset of zero interval  
            end  
        end  
    end  
end  
  
sys3run('RP2_1');  
