%
% 	Calculation of SAI using Strobe point information
% 	30 May 2002
% 	18 Feb 2002
%       9 Oct 2002
%	Toshio Irino
%
%       Frame Base (ex. SAIparam.FrstepAID == 10)
%       Event Base (SAIparam.FrstepAID == 0)
%
function [SAI3d, RAI3d, SAIparam, StrobeInfo] ...
        = CalSAIstinfo(NAPPhsCmp,NAPparam,StrobeInfo,STBparam,SAIparam);

%%%%% Parameter setting %%%%
if nargin < 5, SAIparam = []; end;

if isfield(SAIparam,'Nwidth') == 0,  SAIparam.Nwidth = [];   end;
if length(SAIparam.Nwidth) == 0, 
	SAIparam.Nwidth     = 0;   % Negative width of auditory image (ms).
end;
if isfield(SAIparam,'Pwidth') == 0,  SAIparam.Pwidth = [];   end;
if length(SAIparam.Pwidth) == 0, 
	SAIparam.Pwidth     = 35;   % Positive width of auditory image (ms).
end;
if isfield(SAIparam,'NAPdecay') == 0,  SAIparam.NAPdecay = [];   end;
if length(SAIparam.NAPdecay) == 0, 
	SAIparam.NAPdecay   = -2.5; % NAP (input) decay rate (%/ms)
end;
if isfield(SAIparam,'ImageDecay') == 0,  SAIparam.ImageDecay = [];   end;
if length(SAIparam.ImageDecay) == 0, 
	SAIparam.ImageDecay = 30;   % Auditory image decay half-life (ms).
				    %   NG for 10 ?
end;
if isfield(SAIparam,'FrstepAID') == 0,  SAIparam.FrstepAID = [];   end;
if length(SAIparam.FrstepAID) == 0, 
	SAIparam.FrstepAID  = 0;    % default : Event base 
	% SAIparam.FrstepAID  = 10; % frame shift 10 ms
end;

if isfield(SAIparam,'SwSmthWin') == 0,  SAIparam.SwSmthWin = [];   end;
if length(SAIparam.SwSmthWin) == 0, 
        SAIparam.SwSmthWin = 1;  % Switch of Smoothing Window
end;

if SAIparam.SwSmthWin == 0, SAIparam.CoefSmthWin = 1; end; % no smoothing
if SAIparam.SwSmthWin == 1, SAIparam.CoefSmthWin = hanning(5); end; %hanning window
if SAIparam.SwSmthWin == 2, SAIparam.CoefSmthWin = [1 2 3 4 0 0 0]; end;
SAIparam.CoefSmthWin  = SAIparam.CoefSmthWin/sum(SAIparam.CoefSmthWin);

fs = NAPparam.fs;
nExtDur = [];
if length(StrobeInfo.NAPpoint) == 0, 
  nExtDur = fix(STBparam.ExtDur(1)*fs/1000):fix(STBparam.ExtDur(2)*fs/1000);
end;
% if StrobeInfo.NAPpoint is missing, then Reproduce NAPpoint.
% Max Loc Error is about 100 sample point. Error in MI3d is about 1.5%
% check on 16 Oct 2002
%

disp('*** SAI Calculation ***');
disp(SAIparam)

%%%%% Initialize %%%%
[NumCh, LenNAP]	= size(NAPPhsCmp);
LenNwid       	= abs(SAIparam.Nwidth)*fs/1000;
LenPwid       	= abs(SAIparam.Pwidth)*fs/1000;
LenSAI        	= LenPwid +LenNwid +1;
NAPdecayWin   	= 1 + (SAIparam.NAPdecay/100/fs*1000)*(-LenNwid:LenPwid);
NAPdecayWin   	= ones(NumCh,1)*NAPdecayWin;
if SAIparam.ImageDecay > 0,
 SAIdecayConst 	= 1 - log(2)/(SAIparam.ImageDecay*fs/1000); % ^ (sample point)
end;
RawAI 		= zeros(NumCh,LenSAI);
SAI   		= zeros(NumCh,LenSAI);

LenStrb = length(StrobeInfo.EventLoc);
if SAIparam.FrstepAID > 0, LenFrame = fix(LenNAP/(SAIparam.FrstepAID*fs/1000));
else                       LenFrame = LenStrb; % event base
end;
FrameTiming 	= (1:LenFrame)*SAIparam.FrstepAID*fs/1000;
SAI3d 		= zeros(NumCh,LenSAI,LenFrame);
RAI3d 		= zeros(NumCh,LenSAI,LenFrame);
IntgrPoint	= zeros(1,LenStrb);
dIntgrPoint	= zeros(1,LenStrb); 
MeandIP0	= 8*fs/1000; % setting to 8 ms period 

if SAIparam.FrstepAID == 0, %%%%%  Event Base %%%%

   for nst = 1:LenStrb
	for nch = 1:NumCh
           if length(nExtDur) > 0 
	      nrng = StrobeInfo.EventLoc(nst) + nExtDur;
              nrng = min( LenNAP, max(1,nrng));
              [val Npeak] = max(NAPPhsCmp(nch,nrng));
              nstp =  min(nrng)+Npeak-1;
              StrobeInfo.NAPpoint(nch,nst) = nstp;
           end;
     	   npt = StrobeInfo.NAPpoint(nch,nst) +(-LenNwid:LenPwid);
	   npt = min(LenNAP,max(1,npt));
     	   RawAI(nch,:) = NAPPhsCmp(nch,npt); % Raw SAI
	end;

  	IntgrPoint(nst) = max(StrobeInfo.NAPpoint(:,nst))+1; % in sample point
	dIntgrPoint(nst) =  IntgrPoint(nst) - IntgrPoint(max(1,nst-1));
	MeandIP = mean(dIntgrPoint(max(1,nst-10):nst)); % last 10 strobe
	% MeandIP = MeandIP0; % fixed --> NG level difference. 13 Jun 2002

	RAI3d(:,:,nst) = RawAI;

        if SAIparam.ImageDecay > 0
	AmpDecay = SAIdecayConst^dIntgrPoint(nst);	
	AmpIntgr = min(MeandIP/MeandIP0,3)*NAPdecayWin;
	SAI = AmpDecay * SAI  + AmpIntgr .*  RawAI; % 12 June 2002
	SAI3d(:,:,nst) = SAI;
        end;

	if rem(nst, 50) == 0 | nst == LenFrame
         disp(['SAI-STI Event-Base Frame #' ...
		int2str(nst) '/#' int2str(LenFrame) ':  ' ...
		'elapsed_time = ' num2str(toc,3) ' (sec)']);
   	end;
   end;

    % size(StrobeInfo.NAPpoint)

   if SAIparam.ImageDecay == 0 & SAIparam.SwSmthWin == 0
     disp('Set SAI3d == RAI3d');
     SAI3d = RAI3d;
     return;
   end;

   %%% Smoothing with window %%%
   if SAIparam.ImageDecay == 0
     for nst = 1:LenStrb
       SAI = zeros(NumCh,LenSAI);
       LenCSW = length(SAIparam.CoefSmthWin);
       for nwin = -fix(LenCSW/2):fix(LenCSW/2)
          ncf = nwin+fix(LenCSW/2)+1;
	  SAI = SAI + SAIparam.CoefSmthWin(ncf) ...
                    * RAI3d(:,:,min(max(nst+nwin,1), LenStrb));
       end;
       SAI3d(:,:,nst) = SAI;
     end;
   end;

else   %%%%%%%%%%% if SAIparam.FrstepAID > 0, %%%%%  Constant Frame Base %%%%

%appears to be no point in the following code 
error('Constant Frame Base. I am not sure it is maintained. 12 Jun 2002');
    IntgrPoint(1) = 1;
    nfr = 0;

    for nst = 2:LenStrb
	for nch = 1:NumCh
     	   npt = StrobeInfo.NAPpoint(nch,nst) +(-LenNwid:LenPwid);
	   npt = min(LenNAP,max(1,npt));
	   RawAI(nch,:) = NAPPhsCmp(nch,npt);
   	end;

        IntgrPoint(nst) = max(StrobeInfo.NAPpoint(:,nst))+1;

	nkk = find( FrameTiming >= IntgrPoint(nst-1) & ...
		    FrameTiming <  IntgrPoint(nst));
	if nst == LenStrb, nkk2 = find(FrameTiming >= IntgrPoint(LenStrb)); 
   	else		   nkk2 = [];
   	end;

   	for nn = [nkk nkk2],
	   nfr = nfr+1;
	   dTim  =  FrameTiming(nn) - IntgrPoint(nst-1);
	   SAI3d(:,:,nfr) = SAI * ( SAIdecayConst^dTim);
	   RAI3d(:,:,nfr) = RawAI;
	   SwOn(nfr) = nfr;

	   if rem(nfr, 50) == 0 | nfr == LenFrame
            disp(['SAI-STI ' int2str(SAIparam.FrstepAID) ...
	 '-ms Uniform Frame #' int2str(nfr) '/#' int2str(LenFrame) ':  ' ...
		 'elapsed_time = ' num2str(toc,3) ' (sec)']);
   	   end;
   	end;

    	%%% Add in here %%%
    	dIntgrPoint = IntgrPoint(nst)-IntgrPoint(nst-1);
    	SAI = SAI*( SAIdecayConst^dIntgrPoint) + RawAI.*NAPdecayWin;
    end;

end;   %%%%%%%%%%% if SAIparam.FrstepAID > 0, %%%%%  


return;

