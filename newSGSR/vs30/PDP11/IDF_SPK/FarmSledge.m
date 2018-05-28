function S = FarmSledge(S)
% FarmSledge - convert stimulus parameter struct of Farmington datasets
%   FarmSledge(DS.SPAR), where DS is a Farminon-style dataset
%   unpacks the stimcntrl and indiv fields of the stimulus-parameter
%   struct and delas its (sub)fields to a non-branched struct.

if isfield(S, 'stimcntrl')
   stimcntrl = S.stimcntrl;
   S = rmfield(S, 'stimcntrl');
else
    return % obviously not a Farmington dataset
end

if isfield(S, 'indiv')
   indiv = S.indiv;
   S = rmfield(S, 'indiv');
   %try,
      stim = [];
      stim1 = indiv.stim{1};
      stim2 = indiv.stim{2};
      FNS = fieldnames(stim1);
      for ii=1:length(FNS)
         fn = FNS{ii};
         eval(['fv1 = stim1.' fn ';']);
         eval(['fv2 = stim2.' fn ';']);
         if isnumeric(fv1)
             fv = [fv1, fv2]; %#ok
         else
             fv = {fv1, fv2}; %#ok
         end
         eval(['stim.' fn ' = fv;']);
      end
      indiv = rmfield(indiv, {'stim'});
      stimcmn = getfieldOrDef(indiv, 'stimcmn', []);
      try
          indiv = rmfield(indiv, 'stimcmn');
      catch
          
      end
      restante = indiv;
      %end % try
end

%stimcntrl, stim, stimcmn, restante
S = combinestruct(S, stimcmn, stim, restante, stimcntrl, S);
