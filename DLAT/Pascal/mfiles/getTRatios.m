function tr = getTRatios(DM)
% getTRatios(list DM)
% Calculates trading ratio's in microsec/dB from the delay-values in the field DM.yval and
% the spl-values in the field DM.xval from the struct array DM created by psML_SX and returns 
% them as a column vector (in microsec/dB).
%
% TF 24/08/2005

tr = zeros(1,numel(DM));

for i=1:numel(DM)
    x = DM(i).xval;
    y = DM(i).yval;
    p = polyfit(x,y,1);
    tr(i)=p(1);
end

% rescale from ms/dB to microsec/dB
tr = tr *1000;