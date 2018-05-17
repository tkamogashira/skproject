% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function spectal_profile=calculate_spectral_profile(wave_file)
% function for Tim Griffith to plot the spectral profile from an simple
% model

% define the model:
model_file='simple_model.m';  % this can be exchanged against any model produced with aim-mat by selecting "save standalone parameter file"

% evaluate the model, so that it can passed to aimmat:
% ( you have to be in the same directory as the model file!)
[a,b,c]=fileparts(model_file);
eval(b);

% now there is a variable with the name all_parameters. Tell aimmat to
% use the given soundfile
all_options.signal.signal_name=wave_file;
% tell it to use the full length and the given samplerate (this could be
% changed here)
sig=loadwavefile(signal,wave_file);
all_options.signal.start_time=0;
all_options.signal.duration=getlength(sig);
all_options.signal.samplerate=getsr(sig);

% call aimmat with the appropriate model:
retdata=aim_ng(all_options);

% the nap is now caluclated and available in the returning data structure:
nap=retdata.data.nap;

% we need the data:
nap_values=getvalues(nap);

% and calculate the profile:
spectal_profile=sum(nap_values');

% figure
% % and plot it
% plot(spectal_profile);

% an easier (?) way to plot:
options.frequency_profile_scale=0.7/max(spectal_profile);
options.maximum_time_interval=getlength(sig);
options.turn_axis_vertically=0;
figure
plotfrequencyprofile(nap,options);

