function [XFit, YFit, Env, Param] = gaborfit(X, Y, NewRange, SampleRate)

%B. Van de Sande 25-03-2003

CEstimate   = [100,     0,  750,   1/1000, 0];
LowerBounds = [25,  -1000,  100, 0.5/1000, -pi];
UpperBounds = [200, +1000, 5000,  50/1000, +pi];
    
%Least Square Fit toepassen ...
Options = optimset('Display', 'off', 'LevenbergMarquardt', 'on'); %'MaxFunEvals', realmax
[c, Residual, Dummy, Converged] = lsqcurvefit(@gaborfunc, CEstimate, X, Y, LowerBounds, UpperBounds, Options);

if Converged,
    XFit = NewRange(1):(1/SampleRate):NewRange(2);
    YFit = gaborfunc(c, XFit);
    
    %Parameters samenstellen ...
    A  = c(1); %Amplitude ...
    DC = 0;    %DC-value ...
    
    EnvMax   = c(2); %Position of enveloppe-maximum ...
    EnvWidth = c(3); %Width of enveloppe ...
    EnvShape = 2;    %Shape of enveloppe (small values give accentuation of the central peak, large values give a box-like shape)...
    
    Freq = c(4); %Frequency ...
    Ph   = c(5); %Phase-shift ...
    
    %Fractie van variantie die fit in rekening brengt ...
    AccFraction = getaccfrac(@gaborfunc, c, X, Y);
    
    Param = CollectInStruct(A, DC, EnvMax, EnvWidth, EnvShape, Freq, Ph, AccFraction);
    
    %Enveloppe bepalen ...
    Env = A * exp(-((abs(XFit-EnvMax)/EnvWidth).^EnvShape));
else
    NElem = (NewRange(2) - NewRange(1)) * SampleRate;
    [XFit, YFit, Env] = deal(repmat(NaN, 1, NElem));
    [A, DC, EnvMax, EnvWidth, EnvShape, Freq, Ph, AccFraction] = deal(NaN);
    
    Param = CollectInStruct(A, DC, EnvMax, EnvWidth, EnvShape, Freq, Ph, AccFraction);
end