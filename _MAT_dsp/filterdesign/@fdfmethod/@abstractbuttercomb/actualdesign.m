function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Copyright 2008 The MathWorks, Inc.

%Get BW, shelving filter order, number of peaks/notches from specs in hs
specs = getdesignspecs(this,hs);

%shelving filter parameters
%upsampling of this filter will yield the desired comb response
ShelvingF0 = 0;

%increase shelving filter BW so that it matches desired peak/notch BW after
%upsampling
ShelvingBw = (specs.BW/2)*specs.L; 

%Set parametric equalizer gains to obtain a peak or notch filter
if isequal(hs.CombType, 'Notch')
    G0 = 0;
    G  = -3000; 
else
    G0 = -Inf;
    G  = 0; 
end

% Although there is no ripple, the notused value must be finite and between
% G and G0 
if isinf(G0),    
    notused = G-10;
else
    notused = (G0+G)/2;
end

%The comb filter does not return SOS sections so the abstractbuttercomb
%class does not inherit from fmethod.abstractclassiciir in order to avoid
%all the SOS-related properties. For this reason, we need to instantiate an
%fdfmethod.butterparameq object to be able to use the designbwparameq
%algorithm available in fmethod.abstractclassiciir.
this2 = fdfmethod.butterparameq;

%Design parametric equalizer shelving filter
[s,g] = designbwparameq(this2,specs.ShelvingFilterOrder,G0,G,notused, ...
    specs.GBW,ShelvingF0*pi,ShelvingBw*pi,0);

coeffs = shelving2comb(this,specs.L,s,g);

end

% [EOF]
