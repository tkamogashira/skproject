function OK = ReportPlayTime(pp, Ncond);
% ReportPlayTime - display estimated total stimulus duration

global StimMenuStatus
hh = StimMenuStatus.handles;
DoStutter = isequal(1, uiintfromtoggle(hh.StutterButton));
iextra = double(DoStutter);

if nargin<2, Ncond=nan; end
%dp pp, return
totDur = nan;

if isfield(pp, 'stimcntrl'),
   interval = pp.stimcntrl.interval;
   nrep = pp.stimcntrl.repcount;
   Ncond;
else,
   %pp
   interval = pp.interval;
   nrep = pp.reps;
   Ncond;
end

totDur = 1e-3*interval*nrep*(Ncond+iextra); % ms -> s
Nminute = floor(totDur/60);
Nsec = round(rem(totDur,60));
dStr = [num2str(Nminute) ' min. ' num2str(Nsec) ' sec.'];
UIinfo(strvcat('estimated stimulus duration',dStr),1);
if DoStutter,
   UIinfo('(stutter = on)', 1)
end




