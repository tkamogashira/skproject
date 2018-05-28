function nc = NoiseCharOfIDFseq(idfSeq);
% NoiseCharOfIDFseq - returns noise character specified in idfSeq variable; frozen|running ~ 0|1
% SYNTAX
%   nc = NoiseCharOfIDFseq(idfSeq);
% idfSeq is idf-sequence variable (see idfread)
% nc = 0|1 = frozen|running

nc = 0; % default: frozen noise
try % no compulsive checking of field existence, etc
   if isfield(idfSeq.indiv, 'noise_character'),
      nc = idfSeq.indiv.noise_character(1);
   elseif isequal(23, idfSeq.stimcntrl.stimtype), % NTD; see NTDcreateIDF
      nc = ~isempty(findstr('NTD_RHO*', idfSeq.indiv.stim{2}.noise_data_set));
   end
end % try



