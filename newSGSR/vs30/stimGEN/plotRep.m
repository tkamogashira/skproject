function plotRep(isub);

if nargin<1, isub=1; end;

% plotRep - quick & dirty plot of single rep from PRP storage
% SYNTAX: plotRep(isub);

global PRPinstr;

playlist = PRPinstr.PLAY(isub).playList;
DBNs = playlist(:,1:2:end);
DBNreps = playlist(:,2:2:end);

trivialSizes =[];
for ii=1:5,
   trivialSizes = [trivialSizes length(dama2ml(ii))];
end

Nchan = size(DBNs,1);
if Nchan==2,
   if DBNs(2,1)==0, Nchan=1; end;
end

% find first occurrence of nontrivial DBN in both channels
NonTriv = find((DBNs(1,:)>5) |(DBNs(1,:)<0) ); NonTriv = NonTriv(1);
trivIndex = 1:NonTriv-1;
Nhead(1) = sum(trivialSizes(DBNs(1,trivIndex)).*DBNreps(1,trivIndex));
if Nchan>1, 
   NonTriv2 = find(DBNs(2,:)>5 |(DBNs(1,:)<0)); NonTriv2 = NonTriv2(1);
   trivIndex = 1:NonTriv2-1;
   Nhead(2) = sum(trivialSizes(DBNs(2,trivIndex)).*DBNreps(2,trivIndex));
   NonTriv = [NonTriv NonTriv2]; 
end;
% find all occurrence of that DBN, if any
for ichan = 1:Nchan,
   DBNstart = DBNs(ichan,NonTriv(ichan));
   reoc = find(DBNs(ichan,:)==DBNstart);
   if length(reoc)>1, % stop just before reoc(2)
      stopAt(ichan) = reoc(2)-1;
   else, % stop just before end-of-list indicated by trailing zero(s)
      stopAt(ichan) = min(find(DBNs(ichan,:)==0)) -1 ; 
   end
end

if Nchan>1,
   % compute corrections due to differences in offset
   LeftLag = Nhead(1) - Nhead(2);
   if LeftLag>0, 
      Head = [LeftLag 0];
      Tail = [0 LeftLag];
   else, 
      Head = [0 -LeftLag];
      Tail = [-LeftLag 0];
   end
else,
   Head = [0 0];
   Tail = [0 0];
end

% now collect samples
samples = cell(1,Nchan);
for ichan=1:Nchan,
   samples{ichan} = zeros(1, Head(ichan));
   for ii=NonTriv(ichan):stopAt(ichan),
      dbn = DBNs(ichan,ii);
      reps = DBNreps(ichan,ii);
      if dbn>0, news = dama2ml(dbn);
      else, news = fromSampleLib(-dbn);
      end
   samples{ichan} = [samples{ichan} kron(ones(1,reps),news(:)')];
   end
   samples{ichan} = [samples{ichan} zeros(1, Tail(ichan))];
end

if length(samples{1}) ~= length(samples{end}),
   disp(['Left: ' num2str(length(samples{1}))]);
   disp(['Right: ' num2str(length(samples{end}))]);
   error('unequal # samples in the two channels?!');
end
N = length(samples{1});

time = ((1:N)-1)*PRPinstr.PLAY(isub).SamP * 1e-3; % time axis in ms

figure;
if Nchan==1,
   plot(time, samples{1});
else,
   plot(time, samples{1}, time, samples{2});
end

xlabel('time (ms)');





