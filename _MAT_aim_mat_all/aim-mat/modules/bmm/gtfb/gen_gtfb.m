% generating function for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function fr=gen_gtfb(sig,options)

NumCh=options.nr_channels;
fre1=options.lowest_frequency;
fre2=options.highest_frequency;
FRange = [fre1 fre2];


samplerate=getsr(sig);
Snd=getvalues(sig);
Snd=Snd'; %- do we need this transpose?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = samplerate;
NAPparam.cf_afb  = [fre1 fre2];
cf_afb=NAPparam.cf_afb;
NAPparam.SubBase  = 0.5;

%%%%% Outer-Mid Ear Compensation %%%%
%CmpnOutMid = OutMidCrctFilt('ELC',fs,0);
%Snd_om = filter(CmpnOutMid,1,Snd);

%we are already applying filter in PCP module
Snd_om = Snd; % if unnecessary


%%%%% BMM  %%%
% disp('*** BMM & NAP Calculation ***');
% disp(NAPparam)
% tic;
Frs = FcNch2EqERB(min(cf_afb),max(cf_afb),NumCh);
NAPparam.Frs = Frs;
NAPparam.b = options.b; % maah: 1.019; % default gammatone

% IIR implementation
% disp('BMM : Start calculation, Wait a minute');
% fcoefs = MakeERBFilters98B(fs,Frs,[],b);   % new version
% BMM = ERBFilterBank(Snd_om, fcoefs);
% disp(['BMM : elapsed_time = ' num2str(toc,3) ' (sec)']);

% %%%% Lowpass filter for representing Phase-lock property %%%
% flpcut = 1200;
% [bzLP apLP] = butter(1,flpcut/(fs/2));
% bzLP2 = [bzLP(1)^2,  2*bzLP(1)*bzLP(2), bzLP(2)^2]; 
% apLP2 = [apLP(1)^2,  2*apLP(1)*apLP(2), apLP(2)^2]; 


LenSnd = length(Snd_om);
bias = 0.1;
waithand=waitbar(0,'generating basilar membrane motion');

for nch = 1:NumCh
	if mod(nch,10)==0
		waitbar(nch/NumCh);
	end
	gt = GammaChirp(Frs(nch),fs,4,NAPparam.b,0,0,[],'peak');
	BMM(nch,:) = fftfilt(gt,Snd_om);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now we convert all the stuff into the form that aim mat wants it
fr=frame(BMM);
fr=setsr(fr,samplerate);
fr=setstarttime(fr,getminimumtime(sig));

fr=setcf(fr,Frs);


if ~strcmp(options.do_phase_alignment,'off')
	fr=phasealign(fr,options);
end


close(waithand);



