% env1_fts2cell={};
% for s=1:4
% 
% [env1_fts2, Fs]=make_band_chimeras2('s67S_ga.wav','noise',[4],1,1,s);
% 
% env1_fts2cell{s,1}=env1_fts2;
% clear env1_fts2
% 
% end;

figure;
%for s=1:4
    
    subplot(4,1,1)
    spectrogram( env1_fts2cell{1,1}, 512/2,[],8192*2,Fs,'yaxis');colorbar;
    %spectrogram(abs(zfilt1cell{s,:}), 128,[],'yaxis');colorbar;
    %%%set(gca,'YScale','log'); 
     ylim([100 Fs/2]);
    ylim([0 6000]);
    %hold on;
    
     subplot(4,1,2)
    spectrogram( env1_fts2cell{2,1}, 512/2,[],8192*2,Fs,'yaxis');colorbar;
    %spectrogram(abs(zfilt1cell{s,:}), 128,[],'yaxis');colorbar;
    %%%set(gca,'YScale','log'); 
     ylim([100 Fs/2]);
    ylim([0 6000]);
    %hold on;
    
        subplot(4,1,3)
    spectrogram( env1_fts2cell{3,1}, 512/2,[],8192*2,Fs,'yaxis');colorbar;
    %spectrogram(abs(zfilt1cell{s,:}), 128,[],'yaxis');colorbar;
    %%%set(gca,'YScale','log'); 
     ylim([100 Fs/2]);
    ylim([0 6000]);
    %hold on;
    
        subplot(4,1,4)
    spectrogram( env1_fts2cell{4,1}, 512/2,[],8192*2,Fs,'yaxis');colorbar;
    %spectrogram(abs(zfilt1cell{s,:}), 128,[],'yaxis');colorbar;
    %%%set(gca,'YScale','log'); 
     ylim([100 Fs/2]);
    ylim([0 6000]);
    %hold on;
    
    
%end;