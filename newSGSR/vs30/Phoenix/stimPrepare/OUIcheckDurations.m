function OK = OUIcheckDurations(S);
% OUIcheckDurations - check validity of generic timing parameters of stimulus parameters

OK = 0;

if hasparam(S, 'ITD'),
   ITD = S.ITD.in_ms;
else, ITD = 0;
end


if hasparam(S, 'burstDur'),
   if any(S.burstDur.in_ms > S.interval.in_ms),
      myfault = {'burstDur' 'interval'};
      OUIerror({'Interval too short to realize bursts.'}, myfault);
      return;
   elseif any(S.burstDur.in_ms + abs(ITD) > S.interval.in_ms),
      myfault = {'burstDur' 'interval'};
      if hasparam(S, 'ITD'), myfault = {myfault{:} 'ITD'}; end
      OUIerror({'Interval too short to realize ', 'bursts and ITDs.'}, myfault);
      return;
   end
end

if hasparam(S, 'rampDur'),
   if any(S.burstDur.in_ms < sum(S.rampDur.in_ms.')), % sum over rise/fall, not channels
      myfault = {'burstDur' 'rampDur'};
      OUIerror({'Burst too short to realize ramps.'}, myfault);
      return;
   end
end
   
   
OK = 1;