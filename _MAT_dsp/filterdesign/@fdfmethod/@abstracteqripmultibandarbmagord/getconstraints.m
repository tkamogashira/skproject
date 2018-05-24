function [bandEdgeProps,constraints,FEdges,AEdges,A,F,WBands,W] = getconstraints(this,FEdges,AEdges,A,F,W,constraints,NBands,Fs)
%GETCONSTRAINTS Get constraints for the filter design.

% This method sets up all the inputs needed by multibandFIRGR.
% multibandFIRGR is a function called by firgr to obtain the desired
% frequency response of the filter. Note that the number of bands at the
% output can be larger than the number of bands specified at the input when
% there are forced frequency points or adjacent bands without a don't care
% region in between.
%
% The outputs of GETCONSTRAINTS are:
%
% bandEdgeProps - cell array containing band edge specifications. The
%                 specification values can be 'n' (normal edge point), 'f'
%                 (forced edge point), 'i' (indeterminate edge point), 's'
%                 (single band point).
%
% constraints   - cell array containing one constraint specification per
%                 band. The values can be 'w' (unconstrained band), or 'c'
%                 (constrained band)
%
% FEdges        - Vector containing the frequency edges per band. 
%
% AEdges        - Vector containing the amplitude edges per band. 
%
% A             - Cell array containing the amplitude points per band in each
%                 element.
%
% F             - Cell array containing the frequency points per band in each
%                 element.
%
% WBands        - Vector containing a weight or ripple per band. If the i-th
%                 band is a constrained band then the i-th element of WBands
%                 is the corresponding ripple value. If the i-th band is
%                 unconstrained then the i-th element of WBands contains a 1.
%                 In this case, the relevant weight values are contained in
%                 output W.
%
% W             - Cell array containing weight points values per band. If the
%                 i-th band is constrained then the i-th element of W is an
%                 empty vector, otherwise, the element is a vector of weight
%                 values, one per each frequency point specified in that
%                 band.
%

%   Copyright 2011 The MathWorks, Inc.

if Fs == 1
  FsNormFactor = 1;
else
  FsNormFactor = Fs/2;
end

finalFreqEdges = {};
finalFreqPoints = {};
finalAmpEdges = {};
finalAmpPoints = {};
finalWeightPoints= {};
finalWBands = [];
finalConstraints = {};
bandEdgeProps = {};

% Cache constrained bands for the info method.
this.privConstrainedBands = [];

for idxBands = 1:NBands
  
  la = length(A{idxBands});
  
  freqPoints = F{idxBands};
  freqEdges = FEdges{idxBands};
  ampPoints = A{idxBands};
  ampEdges = AEdges{idxBands};
 
  freqEdgesNew = {freqEdges};
  freqPointsNew = {freqPoints};
  ampEdgesNew = {ampEdges};
  ampPointsNew = {ampPoints};
  
  constraintsNew = constraints(idxBands);
    
  % Check if current band is constrained or not
  if strcmp(constraints{idxBands},'w')
    isconstrainedband = false;
    % WBandsNew holds weight value for the unconstrained band which must be
    % 1. The relevant weight vector used by multibandFIRGR is in
    % W{idxBands}.
    weightPoints = W{idxBands};
    weightPointsNew = {weightPoints};
    WBandsNew = 1;
  else
    isconstrainedband = true;
    this.privConstrainedBands = [this.privConstrainedBands idxBands];
    % multibandFIRGR will use the value in W{idxBands} as ripple for
    % constrained band. In this case the weight points are not relevant and
    % the ripple value for the band is specified in WBands.
    WBandsNew = W{idxBands};
    weightPointsNew = {[]};
    constraintRipple = W{idxBands};
  end
  
  % If this is a single point, then we do nothing if the point has been
  % forced. Single points are always forced in firgr. If not a single
  % point, we need to break the band in parts. This will cause the number
  % of bands to increase when compared with the number of bands specified
  % by the user.
  forcedFreqPts = this.(sprintf('%s%d%s','B',idxBands,'ForcedFrequencyPoints'))/FsNormFactor;
  if ~isempty(forcedFreqPts) && la > 1        
    bandEdgePropsNew = {};
    for idxForced = 1:length(forcedFreqPts)
      
      forcedF = forcedFreqPts(idxForced);
      forcedA = ampPoints(freqPoints == forcedF);
      if ~isconstrainedband
        forcedW = weightPoints(freqPoints == forcedF);
      end
      
      if forcedF == freqPoints(1)
        % CASE 1: Left band edge forced value
        
        % Add a single band value to the left of the band edge. Replace the
        % original left band edge value with the same value plus a small
        % delta.
        
        delta = findDelta(forcedF,freqPoints(2),1);
        
        freqEdgesNew = {forcedF, [forcedF+delta freqEdges(end)]};
        freqPointsNew = {forcedF,[forcedF+delta freqPoints(2:end)]};
        
        ampEdgesNew = {forcedA, [forcedA ampEdges(end)]};
        ampPointsNew = {forcedA,[forcedA ampPoints(2:end)]};
        
        if isconstrainedband
          weightPointsNew = [{[]} weightPointsNew];
          WBandsNew = [constraintRipple WBandsNew];
        else
          weightPointsNew = {forcedW,[forcedW weightPoints(2:end)]};
          WBandsNew = [1 WBandsNew];
        end
        
        constraintsNew = [constraints{idxBands} constraintsNew];
        
        bandEdgePropsNew = {'s','n','n'};
                        
      elseif forcedF ~= freqPoints(end)
        % CASE 2: Intermediate frequency forced value
        
        % Break the band in two and repeat the same forced frequency point
        % at the right and left of the new bands. Set the right edge
        % property of the first band to 'i' and the left edge property of
        % the second band to 'f' to force the value. 
        
        ampEdgesNew(end:end+1) = {[ampEdgesNew{end}(1) forcedA],[forcedA ampEdgesNew{end}(end)]};
        ampPointsNew(end:end+1) = {ampPointsNew{end}(freqPointsNew{end}<=forcedF),ampPointsNew{end}(freqPointsNew{end}>=forcedF)};
        
        if isconstrainedband
          weightPointsNew = [weightPointsNew {[]}];
          WBandsNew = [WBandsNew constraintRipple];
        else
          weightPointsNew(end:end+1) = {weightPointsNew{end}(freqPointsNew{end}<=forcedF),weightPointsNew{end}(freqPointsNew{end}>=forcedF)};
          WBandsNew = [WBandsNew 1];
        end
        
        freqEdgesNew(end:end+1) = {[freqEdgesNew{end}(1) forcedF],[forcedF freqEdgesNew{end}(end)]};
        freqPointsNew(end:end+1) = {freqPointsNew{end}(freqPointsNew{end}<=forcedF),freqPointsNew{end}(freqPointsNew{end}>=forcedF)};
        
        if isempty(bandEdgePropsNew)
          bandEdgePropsNew = {'n','i','f','n'};
        else
          bandEdgePropsNew = [bandEdgePropsNew(1:end-1) {'i','f','n'}];
        end
        constraintsNew = [constraintsNew constraints{idxBands}];
      else
        % CASE 3: Right band edge force value
        
        % Add a single band value to the right of the band edge. Replace
        % the original right band edge value with the same value plus a
        % small delta.

        delta = findDelta(forcedF,freqPointsNew{end}(end-1),0);
        
        freqEdgesNew{end}(end) = forcedF-delta;
        freqEdgesNew{end+1} =  forcedF;
        
        freqPointsNew{end}(end) = forcedF-delta;
        freqPointsNew{end+1} = forcedF;
        
        ampEdgesNew{end}(end) = forcedA;
        ampEdgesNew{end+1} =  forcedA;
        
        ampPointsNew{end}(end) = forcedA;
        ampPointsNew{end+1} = forcedA;
        
        if isconstrainedband
          weightPointsNew = [weightPointsNew {[]}];
          WBandsNew = [WBandsNew constraintRipple];
        else
          weightPointsNew{end}(end) = forcedW;
          weightPointsNew{end+1} = forcedW;
          WBandsNew = [WBandsNew 1];
        end
        
        if isempty(bandEdgePropsNew)
          bandEdgePropsNew = {'n','n','s'};
        else
          bandEdgePropsNew = [bandEdgePropsNew {'s'}];
        end
        constraintsNew = [constraintsNew constraints{idxBands}];
      end
    end    
    % Check if new leftmost band edge has same frequency value as the
    % rightmost edge of previous band. If it does, add an indeterminate
    % edge.
    if idxBands > 1 && (finalFreqEdges{end}(end) == freqEdgesNew{1}(1))      
      if length(freqEdgesNew{1}) == 1
        if ~strcmp(bandEdgeProps{end},'s');
          % Change property of previous band only if it is not a single
          % point band.
          bandEdgeProps{end} = 'i';
        end
      else
        bandEdgePropsNew{1} = 'i';
      end
    end    
    bandEdgeProps = [bandEdgeProps bandEdgePropsNew];
  else
    % No forced frequency points
    if la == 1
      if idxBands>1 && finalFreqEdges{end}(end) == freqEdgesNew{1}(1)
        % If two bands don't have a don't care region in between and the
        % second band is a single point band, specify the right band edge
        % of the first band as indeterminate ('i'), and the single point
        % band as single ('s').
        if ~strcmp(bandEdgeProps{end},'s');
          % Don't change the property to 'i' if previous band is a single
          % point band. You cannot set a single point band to 'i'.
          bandEdgeProps{end} = 'i';
        end
        bandEdgeProps = [bandEdgeProps {'s'}]; %#ok<*AGROW>
      else
        % Specify a single point band as a single point band ('s').
        bandEdgeProps = [bandEdgeProps {'s'}];
      end
    else      
      if idxBands>1 && finalFreqEdges{end}(end) == freqEdgesNew{1}(1)
        % If two bands don't have a don't care region in between. Specify
        % the right edge of the second band as indeterminate ('i') and the
        % left edge of the second band as normal ('n').
        bandEdgeProps = [bandEdgeProps {'i','n'}];
      else
        bandEdgeProps = [bandEdgeProps {'n','n'}];
      end
    end
  end
  
  finalFreqEdges = [finalFreqEdges freqEdgesNew];
  finalFreqPoints = [finalFreqPoints freqPointsNew];
  finalAmpEdges = [finalAmpEdges ampEdgesNew];
  finalAmpPoints = [finalAmpPoints ampPointsNew];
  finalWeightPoints = [finalWeightPoints weightPointsNew];
  finalWBands = [finalWBands WBandsNew];
  finalConstraints = [finalConstraints constraintsNew];
end

% Convert cells with band edges to vectors so that they can be used by the
% multibandFIRGR function.
FEdges = cell2mat(finalFreqEdges);
AEdges = cell2mat(finalAmpEdges);
F = finalFreqPoints;
A = finalAmpPoints;
W = finalWeightPoints;
WBands = finalWBands;
constraints = finalConstraints;

%---------------------------------------------------------------------------
function delta = findDelta(forcedF,adjFreqPoint,type)
deltaFactor = 1000;
isDone = false;
cnt = 0;
while ~isDone && cnt < 10
  if forcedF == 0
    delta = 1/deltaFactor;
  else
    delta = forcedF/deltaFactor;
  end
  
  if type ==1 && forcedF+delta < adjFreqPoint
    % Ensure that adjacent frequency point to the right is larger
    % than the frequency point+delta
    isDone = true;
  elseif type==0 && forcedF-delta > adjFreqPoint
    % Ensure that adjacent frequency point to the left is smaller
    % than the frequency point-delta
    isDone = true;
  else
    deltaFactor = deltaFactor*10;
  end
  cnt = cnt+1;
end

if cnt == 10
  delta = 0;
end
