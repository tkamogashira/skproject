function [constraints,FEdges,AEdges] = getconstraints(~,FEdges,A,AEdges,NBands)
%GETCONSTRAINTS Get constraints for the filter design.

%   Copyright 2011 The MathWorks, Inc.

constraints = {};

for idxBands = 1:NBands
  la = length(A{idxBands});  
  
    % Previous band right edge equals value of current left band edge. Make
    % the value to the left indeterminate to avoid convergence problems.
    if la == 1      
      if idxBands>1 && FEdges{idxBands-1}(end) == FEdges{idxBands}(1)
        constraints{end} = 'i';
        constraints = [constraints {'s'}]; %#ok<*AGROW>  
      else
        constraints = [constraints {'s'}]; 
      end        
    else
      if idxBands>1 && FEdges{idxBands-1}(end) == FEdges{idxBands}(1)
        constraints = [constraints {'i','n'}];                  
      else
        constraints = [constraints {'n','n'}];                  
      end        
    end                  
end  

% Convert cells with band edges to vectors so that they can be used by the
% multibandFIRGR function.
FEdges = cell2mat(FEdges);
AEdges = cell2mat(AEdges);

