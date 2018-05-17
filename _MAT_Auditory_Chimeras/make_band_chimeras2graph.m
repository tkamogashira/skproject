function [env1_fts2, Fs]=make_band_chimeras2graph(name1, name2, Nbands, do_play, do_plot, border)
% Synthesize and store single or multi-band auditory chimeras from pair of original signals.
% Usage: make_band_chimeras(name1, name2, Nbands, do_play, do_plot)
%	name1, name2	Original signals (WAV files), Mono or Stereo.
%				If the second signal is 'noise' or is not specified,
%				random noise with same power spectrum as NAME1 is used
%	Nbands		Number of frequency bands used for synthesis.
%				Can be scalar or vector, in which case one pair of
%				chimeras is synthesized for each element of Nbands.
%				By default Nbands = [1 8 32];
%	do_play		Set flag to play chimeras (default no play)
%	do_plot		Set flag to plot stimulus waveforms (default no plot)
%
%	The function creates two WAV files to store the chimeras
%	for each value of Nbands.  Files are named
%		'name1_env+name2_fts-nb#' and 'name2_env+name1_fts-nb#', 
%	where # is the number if bands.  
%	The files are stored in a folder specified by the Matlab global variable
%	'ChimeraFolder'.  By default, this is set to the current folder '.'
%
%	Copyright Bertrand Delgutte, 1999-2000
%
if nargin == 0, error('Give names of two WAV files'); end
if nargin < 3, Nbands = [1 8 32]; end
if nargin < 4, do_play = 0; end
if nargin < 5, do_plot = 0; end

refilter = 0;
if refilter, refilt_code = '_f2'; else refilt_code = ''; end

global ChimeraFolder;
if isempty(ChimeraFolder), ChimeraFolder = '.'; end

% read original waveforms
[orig1, Fs] = wavread(name1);
nchan = size(orig1,2);
if nargin >= 2 & ~strcmp(name2, 'noise'),
	[orig2, Fs2] = wavread(name2);
   if Fs ~= Fs2, error('Incompatible sampling rates'); end
   if size(orig2,2) ~= nchan, error('Inconsistent numbers of channels'); end
	if length(orig2) < length(orig1),
	    orig2 = [orig2; zeros(length(orig1)-length(orig2),nchan)];
	elseif length(orig2) > length(orig1),
	    orig1 = [orig1; zeros(length(orig2)-length(orig1),nchan)];
	end
else	% synthesize noise with same power spectrum as original
	name2 = 'noise';
	orig2 = psd_matched_noise(orig1);
   orig2 = orig2/max(abs(orig2(:)));
end

if do_play,	% play original sounds
	disp('Playing original sounds')
	tmp = [orig1; orig2];
	if strcmp(computer, 'SUN4'), sunsound(tmp, Fs); 
    %else sound(tmp, Fs); end
    else sound(orig1, Fs); end
    pause(ceil(length(tmp)/Fs))
end

if do_plot,	% plot waveforms of original signals

	t=[0:length(orig1)-1]*1000/Fs;

% 	figure(1)
% 	clf
    figure;
	subplot(2,2,1)
	plot(t, orig1);
	title(sprintf('Original "%s" Sound', name1))
	subplot(2,2,3)
	plot(t, orig2)
	title(sprintf('Original "%s" Sound', name2))
	xlabel('Time (ms)')
    
    subplot(2,2,2)
    spectrogram(orig1,512/2,[],8192*2,Fs,'yaxis');colorbar;ylim([0 4000]);%%%%% xlim([0 0.2]);
    %spectrogram(orig1,128,[],'yaxis');colorbar;
    subplot(2,2,4)
    spectrogram(orig2,128,[],100,Fs,'yaxis');colorbar;
    %spectrogram(orig2,128,[],'yaxis');colorbar;
	drawnow
    [s1,f1,t1]=spectrogram(orig1,512/2,[],8192*2,Fs,'yaxis');
    assignin('base','s1',s1);assignin('base','f1',f1);assignin('base','t1',t1);
%     [s2,f2,t2]=spectrogram(orig1,128,[],200,Fs,'yaxis');
%     assignin('base','s2',s2);assignin('base','f2',f2);assignin('base','t2',t2);
end



%pause;%Shotaro
Fmin = 80;	% lower frequency of filterbank in Hz
Fmax = .4*Fs;	% upper frequency of filterbank (.8 * Nyquist)
figure;f1=gcf;
figure;f2=gcf;
for nb = Nbands,

    % determine band cutoffs equally spaced on basilar membrane
    Fco = equal_xbm_bands(Fmin, Fmax, nb);	
    assignin('base',['Fco_' num2str(nb)],Fco);
        % compute multi-band chimeras
        [env1_fts2, env2_fts1, b, zfilt1cell, zfilt2cell, zfilt1wave, zfilt2wave, chim12cell, chim21cell] = multi_band_chimera2(orig1, orig2, Fco, Fs, refilter, border);
        assignin('base',['zfilt1cell_' num2str(nb)],zfilt1cell);
        % normalize and save
        env1_fts2 = env1_fts2./max(abs(env1_fts2(:)));
        env2_fts1 = env2_fts1./max(abs(env2_fts1(:)));

        chimfileA = sprintf('%s_env+%s_fts-nb%d_border%d%s.wav', name1, name2, nb, border, refilt_code);
        chimfileB = sprintf('%s_env+%s_fts-nb%d_border%d%s.wav', name2, name1, nb, border, refilt_code);
        wavwrite(env1_fts2, Fs, 16, [ChimeraFolder '\' chimfileA]);
        wavwrite(env2_fts1, Fs, 16, [ChimeraFolder '\' chimfileB]);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%         % compute multi-band chimeras URA
%         [env1_fts2URA, env2_fts1URA, bURA, zfilt1cellURA, zfilt2cellURA, zfilt1waveURA, zfilt2waveURA] = multi_band_chimera2(orig1, orig2*(-1), Fco, Fs, refilter, border);
%         assignin('base',['zfilt1cellURA_' num2str(nb)],zfilt1cellURA);
%         % normalize and save
%         env1_fts2URA = env1_fts2URA./max(abs(env1_fts2URA(:)));display(size(env1_fts2URA))
%         env2_fts1URA = env2_fts1URA./max(abs(env2_fts1URA(:)));
% 
%         chimfileAURA = sprintf('URA%s_env+%s_fts-nb%d_border%d%s.wav', name1, name2, nb, border, refilt_code);
%         chimfileBURA = sprintf('URA%s_env+%s_fts-nb%d_border%d%s.wav', name2, name1, nb, border, refilt_code);
%         wavwrite(env1_fts2URA, Fs, 16, [ChimeraFolder '\' chimfileAURA]);
%         wavwrite(env2_fts1URA, Fs, 16, [ChimeraFolder '\' chimfileBURA]);
%         
%         audiowrite(['plumi' chimfileAURA],[env1_fts2 env1_fts2URA], Fs);
%         audiowrite(['plumi' chimfileBURA],[env2_fts1 env2_fts1URA], Fs);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        
    if do_play,		% play band chimeras
	   	disp(sprintf('Playing %d-band chimeras', nb))
    	tmp = [env1_fts2; env2_fts1];
    	if strcmp(computer, 'SUN4'), sunsound(tmp, Fs); 
      	else sound(tmp, Fs); end
      	pause(ceil(length(tmp)/Fs))
    end

    if do_plot,		% plot waveforms of band chimeras

%        figure(2)
%        clf
       figure;
       subplot(2,2,1)
       plot(t, env1_fts2)
       xlabel('Time (ms)')
       title(sprintf('%d-band Chimera ("%s" envelope, "%s" fine structure)', ...
          nb, name1, name2))
       
       subplot(2,2,3)
       plot(t, env2_fts1)
%        xlabel('Time (ms)')
       xlabel(['border=' num2str(border)]);
       title(sprintf('%d-band Chimera ("%s" envelope, "%s" fine structure)', ...
          nb, name2, name1))
       
       subplot(2,2,2)
       spectrogram(env1_fts2,512/2,[],8192*2,Fs,'yaxis');colorbar;ylim([0 3000]);%%%%% xlim([0 0.2]);
       subplot(2,2,4)
       spectrogram(env2_fts1,512/2,[],8192*2,Fs,'yaxis');colorbar;ylim([0 3000]);%%%%% xlim([0 0.2]);
       drawnow
    end	% if do_plot
    display(nb);
    assignin('base',['b_' num2str(nb)],b);

    
    for s=1:nb
    %freqz(b(:,s),1,512,Fs);hold on;
    [h,f]=freqz(b(:,s),1,512,Fs);
    figure(f1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s-3) %1—ñ–Ú
%     plot(f,20*log10(abs(h)));hold on;
%     plot([Fco(s) Fco(s+1)],[0 0],'r*');hold off;
%     xlabel('Frequency(Hz)');ylabel('Magnitude(dB)');
    t=[0:length(zfilt1wave{s,:})-1]*1000/Fs;
    plot(t, zfilt1wave{s,:} );grid on;
    xlabel('Time(ms)');title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'wave']);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s-2) %2—ñ–Ú
    t=[0:length(zfilt2wave{s,:})-1]*1000/Fs;
    plot(t, zfilt2wave{s,:} );grid on;
    xlabel('Time(ms)');title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'noise']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s-1) %3—ñ–Ú
    t=[0:length(zfilt1cell{s,:})-1]*1000/Fs;
    plot(t, abs(zfilt1cell{s,:}) );grid on;
    xlabel('Time(ms)');title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'env']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s) %4—ñ–Ú
    t=[0:length(zfilt2cell{s,:})-1]*1000/Fs;
    plot(t, abs(zfilt2cell{s,:}) );grid on;
    xlabel('Time(ms)');title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'tfs']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(f2);
    subplot(nb,4,4*s-3) %1—ñ–Ú
    t=[0:length(chim12cell{s,:})-1]*1000/Fs;
    plot(t, chim12cell{s,:} );grid on;
    xlabel('Time(ms)');title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'E1T2']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s-2) %2—ñ–Ú
    spectrogram( chim12cell{s,:}, 128,[],100,Fs,'yaxis');colorbar;
    %spectrogram(abs(zfilt1cell{s,:}), 128,[],'yaxis');colorbar;
    %%%set(gca,'YScale','log'); 
%     ylim([100 Fs/2]);
    ylim([0 3000]);title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'E1T2']);ylabel([]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s-1) %3—ñ–Ú
    t=[0:length(chim21cell{s,:})-1]*1000/Fs;
    plot(t, chim21cell{s,:} );grid on;
    xlabel('Time(ms)');title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'E2T1']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(nb,4,4*s) %4—ñ–Ú
    spectrogram( chim21cell{s,:}, 128,[],100,Fs,'yaxis');colorbar;
    %spectrogram( cos(angle(zfilt1cell{s,:})), 128,[],'yaxis');colorbar;
    %%%set(gca,'YScale','log'); 
%     ylim([100 Fs/2]);
    ylim([0 3000]);title([num2str(Fco(s),'%.0f') 'to' num2str(Fco(s+1),'%.0f') 'E2T1']);ylabel([]);
    
%     subplot(nb,5,5*s)
%     t=[0:length(orig1)-1]*1000/Fs;
%     plot(t, cos(angle(zfilt1cell{s,:})) );grid on;
%     xlabel('Time(ms)'); 
    
    
    end;
    %pause;%Shotaro
end	% loop over Nbands
