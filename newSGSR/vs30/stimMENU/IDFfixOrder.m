function idfSeq = IDFfixOrder(idfSeq, startVar, stepVar, endVar);
% IDFfixOrder - fix subseq order and sign of stepsize according to Farmington rituals
% 
% The manipulations are based on the following comment of Ranjan's:
%
%   Storage of parameters in IDF file: (i) The "high frequency" parameter in
%   the file should reflect the true starting frequency after taking into
%   account the FWD/REV toggle. (ii) The "low frequency" parameter should
%   reflect the end frequency after taking into account the toggle. (iii) For a
%   descending series, the step size should be positive, and for an ascending
%   series it should be negative, again after taking into account the FWD/REV
%   toggle. I know the last is ass backwards, but historically all series were
%   descending and the step size was stored as a positive value. Following
%   these conventions should (hopefully) allow ascending series to work
%   smoothly with the analysis programs as well as descending series. At
%   present, none of the menus appear to follow this arrangement. For CFS, even
%   the parameters for the descending series are not stored properly. The only
%   menu I didn't test was BMS.
%   [CFS: misunderstanding - log steps are possible with SGSR, but not with PDP11]

TheOrder = idfSeq.order;
if TheOrder==2, return; end; % random order, nothing we can do
if isfield(idfSeq.indiv.stim{1}, startVar),
   for ichan=1:2,
      startVal = getfield(idfSeq.indiv.stim{ichan}, startVar);
      stepVal = getfield(idfSeq.indiv.stim{ichan}, stepVar);
      endVal = getfield(idfSeq.indiv.stim{ichan}, endVar);
      if TheOrder==1, % forward: swap
         [startVal, endVal] = swap(startVal, endVal);
         idfSeq.order = 0; % reverse
      end
      % now the order is always reverse. Check the sign of step
      stepVal = abs(stepVal).*sign(endVal - startVal);
      % store in place
      idfSeq.indiv.stim{ichan} = ...
         setfield(idfSeq.indiv.stim{ichan}, startVar, startVal);
      idfSeq.indiv.stim{ichan} = ...
         setfield(idfSeq.indiv.stim{ichan}, stepVar, stepVal);
      idfSeq.indiv.stim{ichan} = ...
         setfield(idfSeq.indiv.stim{ichan}, endVar, endVal);
   end % for ichan
elseif isfield(idfSeq.indiv.stimcmn, startVar), % same story but in stmcmn field
   startVal = getfield(idfSeq.indiv.stimcmn, startVar);
   stepVal = getfield(idfSeq.indiv.stimcmn, stepVar);
   endVal = getfield(idfSeq.indiv.stimcmn, endVar);
   if TheOrder==1, % forward: swap
      [startVal, endVal] = swap(startVal, endVal);
      idfSeq.order = 0; % reverse
   end
   % now the order is always reverse. Check the sign of step
   stepVal = abs(stepVal).*sign(endVal - startVal);
   % store in place
   idfSeq.indiv.stimcmn = ...
      setfield(idfSeq.indiv.stimcmn, startVar, startVal);
   idfSeq.indiv.stimcmn = ...
      setfield(idfSeq.indiv.stimcmn, stepVar, stepVal);
   idfSeq.indiv.stimcmn = ...
      setfield(idfSeq.indiv.stimcmn, endVar, endVal);
else, error(['Param ''' startVar ''' not found in idfSeq.']);
end








