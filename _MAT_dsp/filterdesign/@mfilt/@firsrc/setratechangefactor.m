function R = setratechangefactor(Hm,R)
%SETRATE Overloaded set for the RateChangeFactor property.

% This should be a private method

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Call super method
R = supersetratechangefactor(Hm,R);

% Super method updates private rate change factors. Get them from this
% property. Note R has been made empty at this point, more over, if L and M
% are not relatively prime, they have been simplified, so we shouldn't just
% try to use R.
Rsimp = Hm.privRateChangeFactor;
Li = Rsimp(1);
Mi = Rsimp(2);

% Update the polyphase selector
Hm.PolyphaseSelector = mod((0:Li-1)*Mi,Li);

% Reset the States and "internal memory"
reset(Hm);

% Reset polyphase matrix.
num = formnum(Hm,Hm.refpolym); % Don't use Hm.Numerator because we would
                               % loose the reference coefficients since the
                               % numerator is formed form the quantized
                               % (privpolym) rather than the reference
                               % (refpolym). See g226901 for more info.
resetpolym(Hm,num);


