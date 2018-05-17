%
% 	Calculation of NAP 
%	(gammatone, halfwave rectification, lowpass, log compression)
% 	7 Jan 2002
%	Toshio Irino
%
function  [NAP, NAPparam, BMM] = CalNAPghll(Snd, NAPparam)

fs = NAPparam.fs;
if isfield(NAPparam,'NumCh') == 0,  NAPparam.NumCh = [];   end;
if length(NAPparam.NumCh) == 0, 
	NAPparam.NumCh  = 75;
end;
if isfield(NAPparam,'cf_afb') == 0,  NAPparam.cf_afb = [];   end;
if length(NAPparam.cf_afb) == 0, 
	NAPparam.cf_afb  = [100 6000]; %4500 in aim-mat 6000 used by irino
end;
if isfield(NAPparam,'SubBase') == 0,  NAPparam.SubBase = [];   end;
if length(NAPparam.SubBase) == 0, 
	NAPparam.SubBase  = 0;
end;

fs = NAPparam.fs;
NumCh = NAPparam.NumCh;
cf_afb = NAPparam.cf_afb;

%%%%% Outer-Mid Ear Compensation %%%%
%CmpnOutMid = OutMidCrctFilt('ELC',fs,0);
%Snd_om = filter(CmpnOutMid,1,Snd); TAKEN OUT THE PCP %%%%%%%%%%%%%
Snd_om = Snd; % if unnecessary

   save Snd.mat Snd;

%%%%% BMM  %%%
disp('*** BMM & NAP Calculation ***');
disp(NAPparam)
tic;
%% dERB = (Freq2ERB(max(cf_afb))-Freq2ERB(min(cf_afb)))/(NumCh-1);
%% Frs =  ERB2Freq( Freq2ERB(min(cf_afb)):dERB:Freq2ERB(max(cf_afb)) );
Frs = FcNch2EqERB(min(cf_afb),max(cf_afb),NumCh);
NAPparam.Frs = Frs;
NAPparam.b = 1.019; % default gammatone

% IIR implementation
% disp('BMM : Start calculation, Wait a minute');
% fcoefs = MakeERBFilters98B(fs,Frs,[],b);   % new version
% BMM = ERBFilterBank(Snd_om, fcoefs);
% disp(['BMM : elapsed_time = ' num2str(toc,3) ' (sec)']);

%%%%% Lowpass filter for representing Phase-lock property %%% - do we want
%%%%% to remove this?
flpcut = 1200;
% [bzLP apLP] = butter(1,flpcut/(fs/2));
% bzLP2 = [bzLP(1)^2,  2*bzLP(1)*bzLP(2), bzLP(2)^2]; 
% apLP2 = [apLP(1)^2,  2*apLP(1)*apLP(2), apLP(2)^2]; 

%%%%% NAP %%%%
tic;
LenSnd = length(Snd_om);
bias = 0.1;
for nch = 1:NumCh
     if rem(nch, 20) == 0 | nch == 1 |  nch == NumCh 
	 disp(['BMM-NAP #' int2str(nch) '/#' int2str(NumCh) ':  ' ...
		 'elapsed_time = ' num2str(toc,3) ' (sec)']);
     end;

     gt = GammaChirp(Frs(nch),fs,4,NAPparam.b,0,0,[],'peak');
     %  BMM(nch,:) = filter(gt,1,Snd_om);
     BMM(nch,:) = fftfilt(gt,Snd_om);
    
    % save BMM.mat BMM;
     
     NAPraw = log10(max(BMM(nch,:),bias)) - log10(bias);
     %NAP(nch,1:LenSnd) = filter(bzLP2,apLP2,NAPraw); % LP filtered -
     %REMOVED BY RICH
     NAP(nch,1:LenSnd) = NAPraw;

	% [Frs(nch) max(max(NAPraw)) max(max(NAP(nch,:)))]
end;

     savefile = 'bmm_irino.mat';
     save(savefile,'BMM');


if NAPparam.SubBase ~= 0,
disp([ '=== Baseline subtraction :  Max NAP = ' num2str( max(max(NAP))) ... 
	', NAPparam.SubBase = ' num2str(NAPparam.SubBase) ' ===']);
end;

NAP0 = NAP;
NAP = max((NAP0 - NAPparam.SubBase),0);

NAPparam.height = max(max(NAP));
NAPparam.tms    = (0:LenSnd-1)/fs*1000;

return

%%%%%%%%%%%%

if 1
     ProfNAP0 = mean(NAP0')';
     ProfNAP = mean(NAP')';
     plot(NAPparam.Frs,ProfNAP0,NAPparam.Frs,ProfNAP0)
     subplot(2,1,1)
     image(flipud(NAP0(:,1:100:LenSnd))*15)
     subplot(2,1,2)
     image(flipud(NAP(:,1:100:LenSnd))*20)
end;     


return

%%%%%%%%%%%%%%%%%%%%

% [bzGT, apGT, Frs, ERBw] = MakeERBFiltersB(fs,NumCh,Frs,b); % NG for low freq

%%Simple pre-emphasis
%%CoefPreEmph = [1, -0.97];
%%Snd = filter(CoefPreEmph,1,Snd);

% [frsp, freq] = freqz(bzLP,apLP,1024,fs);
% [frsp2, freq] = freqz(bzLP2,apLP2,1024,fs);
% plot(freq,20*log10(abs(frsp)),freq,20*log10(abs(frsp2)))
% axis([0 2000 -10 2]);
% grid;
