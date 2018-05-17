function play_chimera(name1, name2, Nbands, shuffle)
% Chimera demo - Play auditory chimera from sound files
% Usage: play_chimera(name1, name2, Nbands, shuffle)
%  	name1, name2 	file names of original sounds 
%	Nbands			number(s) of frequency bands (scalar or vector)	
%	shuffle			Set flag to randomize order of stimuli
%
%	Copyright Bertrand Delgutte, 1999-2000
%
if nargin < 2, error('Specify original sounds'); end
if nargin < 3, Nbands = [1 8 32]; end
if nargin < 4, shuffle = 0; end

[orig1,Fs] = wavread(name1);
if ~strcmp(name2, 'noise'), 
	orig2 = wavread(name2);
else
	orig2 = psd_matched_noise(orig1);
    orig2 = orig2/max(abs(orig2(:)));
end

if shuffle, Nbands = Nbands(randperm(length(Nbands))); end

ndel = round(.2*Fs);	% add 200-ms delay between signals
nchan = size(orig1,2);

tmp = [orig1; zeros(ndel, nchan); orig2];
disp('Original sounds')
repeat = 1;
while repeat,
   if strcmp(computer,'SUN4'), sunsound(tmp, Fs); 
	else soundsc(tmp, Fs); end
	pause(ceil(length(tmp)/Fs))
    r=input('Repeat ("r") or next? ', 's');
    if isempty(r) | r ~= 'r', repeat = 0; end
end

for n = Nbands,
	file1 = sprintf('%s_env+%s_fts-nb%d', name1, name2, n);
	file2 = sprintf('%s_env+%s_fts-nb%d', name2, name1, n);
	disp
	env1_fts2 = wavread(file1);
	env2_fts1 = wavread(file2);

	disp(sprintf('%d-band chimera', n))
   tmp = [env1_fts2; zeros(ndel, nchan); env2_fts1];
   repeat = 1;
   while repeat,
      if strcmp(computer,'SUN4'), sunsound(tmp, Fs); 
      else soundsc(tmp, Fs); end
      pause(ceil(length(tmp)/Fs))
      r=input('Repeat ("r") or next? ', 's');
      if isempty(r) | r ~= 'r', repeat = 0; end
   end
end
