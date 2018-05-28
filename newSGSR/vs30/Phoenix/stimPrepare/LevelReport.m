function OK = LevelReport(maxSPL, SPL, activeDA, IDP, precision);
% LevelReport - report maximum SPLs and complain about excessive SPL requests
%    usage: LevelReport(LevelReport(maxSPL, SPL, activeDA, indepParam, precision);
%      maxSPL is Ncond x 2 matrix
%      SPL is length-2 row vector or Ncond x 2 matrix
%      activeDA is specification of active DA channels
%      indepParam is parameter object containing the succesive
%          values of the independent parameters
%      precision=M rounds the IDP values to =multiples of 10^M.
%          default precision is -1 (one decimal).
%
%
%    See also LevelAdjustment, Calibrate.

if nargin<5, precision = -1; end;

if size(maxSPL,2)~=2, error('maxSPL must be Nx2 matrix');
elseif size(maxSPL,2)~=2, error('SPL must be length-2 vector or Ncondx2 matrix');
end

% restrict checks to active channels
ichans = allChanNums(activeDA);
[maxSPL, SPL] = stereovar(maxSPL, SPL);

Ival = stereovar(IDP.value);
Iunit = IDP.unit;
Ncond = size(Ival,1);

% find most critical (lowest) max SPL value and corresponding indep-par val
tooHigh = 0;
for ichan=ichans,
   [minmaxSPL, icrit(ichan)] = min(maxSPL(:,ichan)); % max per column
   tooHigh = tooHigh | any(SPL(:,ichan)>maxSPL(:,ichan));
end

indepVal = []; SPLval = [];
for ichan=ichans,
   indepVal = [indepVal Ival(icrit(ichan),ichan)];
   SPLval = [SPLval floor(maxSPL(icrit(ichan),ichan))];
end
quant = 10^precision;
indepVal = quant*round(indepVal/quant);
pvar = parameter('tmp', indepVal, Iunit);
splvar = parameter('tmp', SPLval, 'dB SPL');

mess = {['max: ' splvar.valueStr ' ' splvar.Unit] , ['@ ' pvar.valueStr ' ' pvar.Unit]};
if ~isempty(paramOUI), % don't bother if no OUI is active
   OUIhandle('maxSPL', mess);
end 
OK = 1;

if tooHigh,
   OUIerror('Level(s) too high.', 'SPL');
   OK = 0;
end







