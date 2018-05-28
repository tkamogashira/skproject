function [x, BC, NC] = SPTCORRnum(spt1, spt2, maxlag, binwidth);
% SPTCORRnum - spike time correlogram vectors only
%    SPTCORRnum used to do the essential work for SPTcorr before Mex implementation.
%    Kept as backup & debug function.
%    Syntax:
%      [x, BC, NC] = SPTCORRnum(spt1, spt2, maxlag, binwidth);
%    spt1 and spt2 must be sorted vectors.
% 
%    See SPTCORR, SPTCORRMEX.

Lchunk = 75; % length of a chunk
Nlarge = 1e3; % 

% compute bin centers
N = ceil(maxlag/binwidth);
BC = (-N:N)*binwidth;
EdgeLag = (N+0.5)*binwidth; % edge of extreme bin
x = zeros(size(BC));

% make sure aa  whole # chunks fit in the trains. Append infs if necessary
N1 = length(spt1); N2 = length(spt2);
Lchunk = min([Lchunk,N1,N2]);
r1 = rem(N1,Lchunk); r2 = rem(N2,Lchunk);
if r1>0, spt1=[spt1 inf*ones(1,Lchunk-r1)]; end
if r2>0, spt2=[spt2 inf*ones(1,Lchunk-r2)]; end
N1 = length(spt1); N2 = length(spt2);

% normalize spike times and EdgeLag
spt1 = spt1/binwidth;
spt2 = spt2/binwidth;
EdgeLag = EdgeLag/binwidth;

% start and end indices of chunks
istart1 = 1:Lchunk:N1;
istart2 = 1:Lchunk:N2;
iend1 = istart1+Lchunk-1; 
iend2 = istart2+Lchunk-1;
% start and end times of chunks
tstart1 = spt1(istart1);
tstart2 = spt2(istart2);
tend1 = spt1(iend1);
tend2 = spt2(iend2);

Nch1 = length(tstart1);

itau = [];
Ncomp = 0;
for ichunk1=1:Nch1,
   ch1 = repmat(spt1(istart1(ichunk1):iend1(ichunk1)).',1,Lchunk);
   % find out which chunks of spt2 need to be compared
   tst1 = tstart1(ichunk1);  tnd1 = tend1(ichunk1);
   icompare = find( ((tst1-tend2)<EdgeLag) & ((tstart2-tnd1)<EdgeLag));
   % do the comparison
   for ichunk2=icompare,
      ch2 = repmat(spt2(istart2(ichunk2):iend2(ichunk2)),Lchunk,1);
      tau = ch1-ch2; % inter-spike intervals in normalized units 
      tau = round(tau(:)); % convert to bin indices -N:N
      iok = find(~isnan(tau) & abs(tau)<=N); % reject inf-inf=nan and out-of range stuff
      itau = [itau; tau(iok)]; % convert to bin indices and store them in vector itau
      if length(itau)>Nlarge, % process the time differences found so far
         [itau, x] =localProcess_itau(itau, x, N);
      end
      Ncomp = Ncomp + 1;
   end
end
[itau, x] =localProcess_itau(itau, x, N);
Ncomp;
%===============================
function [itau, x] =localProcess_itau(itau, x, N)
% itau contains indices whose histogram build the correlogram
if isempty(itau), return; end
% now do a manual histogram
itau = N+1+sort(itau'); % the (N+1) shift is to project -N:N onto the bincenter indices 1:2N+1
ijump = 1+[0 find(diff(itau))]; % a new index occurs here in itau
ibin = itau(ijump); % these bins need to be increased
Nfreq = diff([ijump 1+length(itau)]); % this is their frequency (repetition count)
x(ibin) = x(ibin) + Nfreq;
itau = [];













