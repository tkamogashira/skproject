function freqAxis = ExpandFreqAxis(FreqSpacing);

% recovers full frequency axis from spacing info

if isfield(FreqSpacing,'Ncomp'), % old style data
   freqAxis = zeros(1, sum(FreqSpacing.Ncomp));
   offset = 0; Nsp = length(FreqSpacing.Ncomp);
   for iSpc = 1:Nsp, 
      nc = FreqSpacing.Ncomp(iSpc); % # components with current spacing
      f0 = FreqSpacing.Flow(iSpc); % freq of first component 
      df = FreqSpacing.DF(iSpc); % freq spacing
      freqAxis(offset+(1:nc)) = f0 -df + (1:nc)*df;
      offset = offset + nc;
   end
else, % new style
   DF = FreqSpacing.DF;
   Nlow = FreqSpacing.Nlow;
   Nsam = length(FreqSpacing.ampl.dy);
   freqAxis = DF*(Nlow-2+(1:Nsam));
end

