function [IS, NB, IR] = IsubAndNbinCheck(hh, Nsub, Nrep);
% IsubAndNbinCheck - read & check Nbin, subseq & rep specification in edit control

if nargin<2, Nsub=NaN; end; % -> no isub edit
if nargin<3, Nrep=NaN; end; % -> no irep edit
[IS, NB, IR] = deal([]); [iRep, iSub, Nbin] = deal([]);
%---------iSub---------
if ~isnan(Nsub),
   iSub = getstring(hh.IsubEdit);
   updown = isequal('up',lower(iSub)) | isequal('down',lower(iSub));
   if ~updown,
      iSub = UIdoubleFromStr(hh.IsubEdit,inf,1); % last arg: interpret "1:8" etc
   end
   doReturn = 1;
   if updown, doReturn = 0;
   elseif ~CheckNaNandInf(iSub),
   elseif any(iSub<0) | any(round(iSub)~=iSub) | any(iSub>Nsub),
      UIerror('invalid subseq values', hh.IsubEdit);
   elseif any(iSub>Nsub),
      UIerror('subseq value exceeds #subseqs', hh.IsubEdit);
   elseif ~isequal(0,iSub) & any(iSub<1),
      UIerror(strvcat('Subsequence specification must be',...
         ' either a single zero ', ...
         'or a row of positive numbers.'), hh.IsubEdit);
   else, doReturn = 0;
   end
   if doReturn, return; end;
end

%---------iRep---------

if ~isnan(Nrep),
   iRep = UIdoubleFromStr(hh.RepSelectEdit,inf,1); % last arg: interpret "1:8" etc
   doReturn = 1;
   if ~CheckNaNandInf(iRep),
   elseif any(iRep<0) | any(round(iRep)~=iRep) | any(iRep>Nrep),
      UIerror('invalid rep values', hh.RepSelectEdit);
   elseif any(iRep>Nrep),
      UIerror('rep value exceeds #reps', hh.RepSelectEdit);
   elseif ~isequal(0,iRep) & any(iRep<1),
      UIerror(strvcat('Repetition specification must be',...
         ' either a single zero ', ...
         'or a row of positive numbers.'), hh.RepSelectEdit);
   else, doReturn = 0;
   end
   if doReturn, return; end;
end

% ----Nbin-------
if isfield(hh, 'NbinEdit'),
   doReturn = 1;
   Nbin = UIdoubleFromStr(hh.NbinEdit,1);
   if ~CheckNaNandInf(Nbin),
   elseif ~isequal(Nbin, round(Nbin)) | (Nbin<2),
      UIerror('# bins must be integer > 1');
   else, doReturn = 0;
   end
   if doReturn, return; end;
end

% only assign non-empty values once everything is okay
IR = iRep; IS = iSub; NB = Nbin;

