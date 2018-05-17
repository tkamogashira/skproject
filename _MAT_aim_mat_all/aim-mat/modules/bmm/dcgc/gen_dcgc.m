% generating function for 'aim-mat'
% 
% 
% Toshio Irino and Roy Patterson (2005). "A dynamic, compressive gammachirp auditory filterbank" Revision submitted to IEEE SAP.. 
% Implementation in aim-mat by Ralph van Dinther
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function fr=gen_dcgc(sig,options)

% Generating the dcgc 

NumCh = options.nr_channels;
fre1 = options.lowest_frequency;
fre2 = options.highest_frequency;
FRange = [fre1 fre2];
Frs = FcNch2EqERB(min(FRange),max(FRange),NumCh);

sr = getsr(sig);
GCparam.fs=sr;%     Sampling rate          (48000)
GCparam.NumCh=NumCh;%  Number of Channels     (75)
GCparam.FRange=FRange;
GCparam.Ctrl = 'tim';

% TCW AIM 2006 - Now defaults to 70 dB, not 40 as before
if isfield(options, 'gain_ref')
    GCparam.GainRefdB=options.gain_ref;
else
    GCparam.GainRefdB=70;
end

%% Anticipating the noise pre-excitation stuff I'm going to write...
% if ~isfield(options, 'pre_excite_with_noise')
%     do_pre_excite=0;
% else
%     do_pre_excite=options.pre_excite_with_noise;
% end
% 
% if ~isfield(options, 'pre_excite_time')
%     pre_excite_time=0.2; % 200ms
% else
%     pre_excite_time=options.pre_excite_time;
% end
% 
% if ~isfield(options, 'pre_excite_level_dB')
%     pre_excite_level_dB=-10;
% else
%     pre_excite_level_dB=options.pre_excite_level_dB;
% end

NAPparam.cf_afb  = [fre1 fre2];
cf_afb=NAPparam.cf_afb;
NAPparam.SubBase  = 0.5;


sr = getsr(sig);
Snd = getvalues(sig);
LenSnd = length(Snd);

if (fre2>(0.4.*sr))
    warning('Top filter centre frequency is > 0.4 times the signal samplerate - aliasing effects possible');
end

%%%%% BMM  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cGCout, pGCout, GCparam, GCresp] = GCFBv205(Snd',GCparam);
BMM=cGCout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fr = frame(BMM);
fr = setsr(fr,sr);
fr = setstarttime(fr,getminimumtime(sig));
fr = setcf(fr,Frs);

if ~strcmp(options.do_phase_alignment,'off')
 	fr=phasealign(fr,options);
end



