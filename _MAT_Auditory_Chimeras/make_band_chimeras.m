function make_band_chimeras(name1, name2, Nbands, do_play, do_plot)
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
    else sound(tmp, Fs); end
    pause(ceil(length(tmp)/Fs))
end

if do_plot,	% plot waveforms of original signals

	t=[0:length(orig1)-1]*1000/Fs;

	figure(1)
	clf
	subplot(2,1,1)
	plot(t, orig1);
	title(sprintf('Original "%s" Sound', name1))
	subplot(2,1,2)
	plot(t, orig2)
	title(sprintf('Original "%s" Sound', name2))
	xlabel('Time (ms)')
	drawnow
end

Fmin = 80;	% lower frequency of filterbank in Hz
Fmax = .4*Fs;	% upper frequency of filterbank (.8 * Nyquist)

for nb = Nbands,

    % determine band cutoffs equally spaced on basilar membrane
    Fco = equal_xbm_bands(Fmin, Fmax, nb);	

    % compute multi-band chimeras
    [env1_fts2, env2_fts1] = multi_band_chimera(orig1, orig2, Fco, Fs, refilter);

    % normalize and save
    env1_fts2 = env1_fts2./max(abs(env1_fts2(:)));
    env2_fts1 = env2_fts1./max(abs(env2_fts1(:)));

    chimfileA = sprintf('%s_env+%s_fts-nb%d%s.wav', name1, name2, nb, refilt_code);
    chimfileB = sprintf('%s_env+%s_fts-nb%d%s.wav', name2, name1, nb, refilt_code);
    wavwrite(env1_fts2, Fs, 16, [ChimeraFolder '\' chimfileA]);
    wavwrite(env2_fts1, Fs, 16, [ChimeraFolder '\' chimfileB]);

    if do_play,		% play band chimeras
	   	disp(sprintf('Playing %d-band chimeras', nb))
    	tmp = [env1_fts2; env2_fts1];
    	if strcmp(computer, 'SUN4'), sunsound(tmp, Fs); 
      	else sound(tmp, Fs); end
      	pause(ceil(length(tmp)/Fs))
    end

    if do_plot,		% plot waveforms of band chimeras

       figure(2)
       clf
       
       subplot(2,1,1)
       plot(t, env1_fts2)
       xlabel('Time (ms)')
       title(sprintf('%d-band Chimera ("%s" envelope, "%s" fine structure)', ...
          nb, name1, name2))
       
       subplot(2,1,2)
       plot(t, env2_fts1)
       xlabel('Time (ms)')
       title(sprintf('%d-band Chimera ("%s" envelope, "%s" fine structure)', ...
          nb, name2, name1))
       
       drawnow
    end	% if do_plot

end	% loop over Nbands
