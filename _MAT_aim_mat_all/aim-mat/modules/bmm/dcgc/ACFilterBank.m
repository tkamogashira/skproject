%
%	ACFilterBank	: IIR ACF time-slice filtering for time-varing filter
%	Toshio IRINO
%       Created: 19 May 2004
%       Modifed: 11 Jun 2004
%       Modifed:  9 Sept 2004 (NO global variable for multiple filters)
%       Modifed:  8 Jan  2005 (Controlling filtering order for inversion)
%
%   function [SigOut,ACFstatus] = ACFilterBank(ACFcoef,ACFstatus,SigIn,SwOrdr);
%	INPUT : ACFcoef: structured value
%                  ACFcoef.bz : MA coefficents   (zero) NumCh*Lbz*NumFilt
%		   ACFcoef.ap : AR coefficents   (pole) NumCh*Lap*NumFilt
%	        ACFstatus: structured value  if length==0, then initialization
%		   ACFstatus.NumCh : Number of channels (Set by initialization)
%		   ACFstatus.Lbz : size of MA
%		   ACFstatus.Lap : size of AR
%		   ACFstatus.NumFilt: Length of Filters
%		   ACFstatus.SigInPrev : Previous status of SigIn
%		   ACFstatus.SigOutrev : Previous status of SigOut
%		SigIn  : Input signal     (NumCh*1, vector)
%               SwOrdr : Switch Filtering Order  0) default, 1) inverse
% 
%	OUTPUT: SigOut	  : Filtered signal  (NumCh*1,   vector)
%               ACFstatus : Current status
%
%       Basics (as shown by "help filter"):
%       a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                             - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
%			      
%
function [SigOut,ACFstatus] = ACFilterBank(ACFcoef,ACFstatus,SigIn,SwOrdr);

if nargin < 2, help ACFilterBank;  end;
if nargin < 3 & length(ACFstatus) ~= 0,  help ACFilterBank;  end;
if nargin < 4, SwOrdr = 0; end;

if length(ACFstatus) == 0,
   [NumCh, Lbz, NumFilt] = size(ACFcoef.bz);
   [NumCh, Lap, NumFilt] = size(ACFcoef.ap);
   if Lbz ~= 3 | Lap ~= 3
     disp('No gaurantee for usual IIR filters except for AsymCmpFilter.');
     error('Please check MakeAsymCmpFiltersV2.m');
   end;

   ACFstatus.NumCh = NumCh;
   ACFstatus.NumFilt = NumFilt;
   ACFstatus.Lbz = Lbz; % size of MA
   ACFstatus.Lap = Lap; % size of AR
   ACFstatus.SigInPrev  = zeros(NumCh,Lbz);
   ACFstatus.SigOutPrev = zeros(NumCh,Lap,NumFilt);
   ACFstatus.Count = 0;
%    disp('ACFilterBank: Initialization of ACFcoef');
   SigOut = [];
   return;
end;

[NumChSig, Lx] = size(SigIn);
if Lx ~= 1 | ACFstatus.NumCh ~= NumChSig
   error('Input Signal should be NumCh*1 vector (1 sample time-slice)'); 
end;

%%%%%%%%%%% time stamp %%%
if 1

Tdisp = 50; % ms
Tcnt = ACFstatus.Count/(fix(ACFcoef.fs/1000)); % ms  
if ACFstatus.Count == 0 
%    disp('ACFilterBank: Start processing');
   tic;
elseif rem(Tcnt, Tdisp) == 0,
%    disp(['ACFilterBank: Processed ' int2str(Tcnt) ...
%      ' (ms).  elapsed Time = ' num2str(toc,3) ' (sec)']);
end;

end;

ACFstatus.Count = ACFstatus.Count+1;

%%%%%%%%%%% processing %%%

ACFstatus.SigInPrev = [ACFstatus.SigInPrev(:,2:ACFstatus.Lbz), SigIn];

x = ACFstatus.SigInPrev;
NfiltList = 1:ACFstatus.NumFilt;
if SwOrdr == 1, NfiltList = fliplr(NfiltList); end;
for Nfilt = NfiltList

  forward  = ACFcoef.bz(:,1:ACFstatus.Lbz,Nfilt) .* fliplr(x);
  feedback = ACFcoef.ap(:,2:ACFstatus.Lap,Nfilt) .* ...
               fliplr(ACFstatus.SigOutPrev(:,2:ACFstatus.Lap,Nfilt));
  fwdSum  = sum(forward')' ; 
  fbkSum  = sum(feedback')'; 

  y = (fwdSum - fbkSum)./ACFcoef.ap(:,1,Nfilt);
  ACFstatus.SigOutPrev(:,:,Nfilt) = ...
		[ACFstatus.SigOutPrev(:,2:ACFstatus.Lap,Nfilt), y];
  x = ACFstatus.SigOutPrev(:,:,Nfilt);
end;

SigOut = y;

