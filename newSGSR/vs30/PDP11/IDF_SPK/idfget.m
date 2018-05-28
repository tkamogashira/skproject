function [idfSeq, FN] = idfget(nnn, iii)

[IDF, FN] = IDFread(nnn);
idfSeq = IDF.sequence{abs(iii)};

try % correct special cases
   if isequal(upper(nnn),'A0216') && iii==9,
      idfSeq.indiv.stim{1}.deltaspl = 2.5;
      idfSeq.indiv.stim{2}.deltaspl = 2.5;
   end
catch
    return
end

