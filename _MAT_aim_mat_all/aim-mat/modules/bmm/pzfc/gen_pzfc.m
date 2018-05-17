% Generating function for AIM-MAT
% Based on Dick Lyon's code for the Pole-Zero filter cascade
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function fr=gen_pzfc(sig,options)

% Unpack the options and get the raw signal from the signal class
CFMin=options.lowest_frequency;
CFMax=options.highest_frequency;


% Default parameters (these defaults should be the same as in the parameter
% file)
if ~isfield(options,'segment_length')
    segLength=200;
else
    segLength=options.segment_length;
end

if ~isfield(options,'stepfactor')
    stepfactor=1/3;
else
    stepfactor=options.stepfactor;
end

if ~isfield(options,'pdamp')
    pdamp=0.12;
else
    pdamp=options.pdamp;
end

if ~isfield(options,'zdamp')
    zdamp=0.2;
else
    zdamp=options.zdamp;
end

if ~isfield(options,'zfactor')
    zfactor=1.4;
else
    zfactor=options.zfactor;
end

if ~isfield(options, 'bw_over_cf')
    bwOverCF = 0.11;
else
    bwOverCF = options.bw_over_cf;
end

if ~isfield(options, 'bw_min_hz');
    bwMinHz = 27; 
else
    bwMinHz=options.bw_min_hz;
end

if ~isfield(options, 'use_fitted_params')
    useFit=0;
else
    useFit=options.use_fitted_params;
end

if ~isfield(options, 'agcfactor')
    agcfactor=12;
else
    agcfactor=options.agcfactor;
end

if ~isfield(options, 'do_agc')
    doagcstep=1;
else
    doagcstep=options.do_agc;
end

if ~isfield(options, 'pre_excite_with_noise')
    do_pre_excite=0;
else
    do_pre_excite=options.pre_excite_with_noise;
end

if ~isfield(options, 'pre_excite_time')
    pre_excite_time=0.2; % 200ms
else
    pre_excite_time=options.pre_excite_time;
end

if ~isfield(options, 'pre_excite_level_dB')
    pre_excite_level_dB=-10;
else
    pre_excite_level_dB=options.pre_excite_level_dB;
end

if ~isfield(options, 'doplot')
    doplot=0;
else
    doplot=options.doplot;
end

if useFit~=0 
   if isfield(options, 'fitted_params')
        eval(options.fitted_params); % sets the varaible ValParam
        if ~isvector('ValParam')
            error('PZFC param file specified is not in the right format. Should set variable ValParam.');
        end
   else
        error('If use_fitted_params is nonzero (i.e. true) then fitted_params must be a real filename');
   end
end



fs=getsr(sig);
inputColumn=getvalues(sig);
Nt = length(inputColumn);

if useFit==0
    if options.erb_scale == 0
        [Coeffs Nch, freqs] = PZBankCoeffsHiLow(fs, CFMax, CFMin, pdamp, zdamp, zfactor, stepfactor, bwOverCF, bwMinHz);
    else
        [Coeffs Nch, freqs] = PZBankCoeffsERB(fs, CFMax, CFMin, pdamp, zdamp, zfactor, stepfactor);
    end
else
    % Use the parameters from the fit to set up the filterbank (using ERB scale)
    [Coeffs,  Nch, freqs] = PZBankCoeffsERBFitted(fs, CFMax, CFMin, ValParam);
end

deskewDelay = 0;
doStereo = 0; % no stereo option for AIM-MAT version
Ntracks=1; % ditto - don't try and make this any more than 1!

pfreqs = Coeffs(:,1);
pdamps = Coeffs(:,2);
za0 = Coeffs(:,3);
za1 = Coeffs(:,4);
za2 = Coeffs(:,5);
Nch = length(pfreqs);

mindamp = .18; % (Q = 3 max end of interp)
maxdamp = .4; % (Q = 1.25 min end of interp)
% min and max refer to the damping, not the x and r coordinates
rmin = exp(-mindamp*pfreqs);
rmax = exp(-maxdamp*pfreqs);
xmin = rmin.*cos(pfreqs.*(1-mindamp^2).^0.5);
xmax = rmax.*cos(pfreqs.*(1-maxdamp^2).^0.5);


agcepsilons = [0.0064, 0.0016, 0.0004, 0.0001]; % roughly 3 ms, 12 ms, 48 ms, 200 ms
agcgains = [1, 1.4, 2, 2.8];
agcgains = agcgains/mean(agcgains);
Nstages = length(agcepsilons);

outarray = []; %zeros(Nch*Ntracks,Nt);
for j = 1:Ntracks
    inputColumn(:,j) = filter([0.5 0.5], 1, inputColumn(:,j)); % puts a zero in the TF
end

state1 = zeros(Nch,Ntracks);
state2 = zeros(Nch,Ntracks);
prevout = zeros(Nch,Ntracks);
agcstate = zeros(Nch, Nstages*Ntracks);
% initialize with double dampling:
[pdampsmod agcstate] = AGCdampStep([ ], pdamps, agcepsilons, agcgains, agcstate); % initialize pdampsmod, agcstate
% make safer place to start than full gain, in case input is abruptly loud:
pdampsmod = pdampsmod + 0.05;
agcstate = agcstate + 0.05;

% Noise pre-excitation
if do_pre_excite == 1
    wbh=waitbar(0, 'Pre-calculating noise excitaiton for Pole-Zero filter cascade'); 
    Nt_noise=pre_excite_time.*fs;
    doagcstep_noise=1; % we want to run the AGC in this section, even if not in the main section.
    
    nsegs = floor(Nt_noise/segLength);
    %wbh=waitbar(0, 'Calculating Pole-Zero filter cascade');
    for segno = 1:nsegs
        inputSegment = rand(segLength,1);
        inputSegment = inputSegment.*10.^(pre_excite_level_dB./20);

        [outsegment, prevout, agcstate, state1, state2, pdampsmod] = ...
            RunPZBankSegment(inputSegment, prevout, agcstate, state1, state2, pfreqs, pdamps, pdampsmod, ...
            mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, agcepsilons, agcgains, agcfactor, doagcstep_noise, doplot);

        waitbar(segno/nsegs, wbh);


    end
    close(wbh); 
end

% Reset the previous output of the filterbank
state1 = zeros(Nch,Ntracks);
state2 = zeros(Nch,Ntracks);
prevout = zeros(Nch,Ntracks);

nsegs = floor(Nt/segLength);
wbh=waitbar(0, 'Calculating Pole-Zero filter cascade');
for segno = 1:nsegs
    inputSegment = inputColumn((segno-1)*segLength + (1:segLength), :);


    [outsegment, prevout, agcstate, state1, state2, pdampsmod] = ...
        RunPZBankSegment(inputSegment, prevout, agcstate, state1, state2, pfreqs, pdamps, pdampsmod, ...
        mindamp, maxdamp, xmin, xmax, rmin, rmax, za0, za1, za2, agcepsilons, agcgains, agcfactor, doagcstep, doplot);

    if isempty(outarray)
        outarray=outsegment;
    else
        outarray = [outarray, outsegment]; % gather up the segments
    end

    waitbar(segno/nsegs, wbh);


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert all the stuff into the form that AIM-MAT wants it
outarray=flipdim(outarray, 1);
freqs=flipdim(freqs, 1);

fr=frame(outarray);
fr=setsr(fr,fs);
fr=setstarttime(fr,getminimumtime(sig));
fr=setcf(fr,freqs);
close(wbh);

return;

