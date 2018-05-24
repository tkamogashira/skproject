function b = actualdesign(this, hspecs)
%ACTUALDESIGN   

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

if hspecs.TransitionWidth/2>=1/hspecs.Band,
    error(message('dsp:fdfmethod:kaisernyqmin:actualdesign:InvalidSpec'));
end
args = designargs(this, hspecs);

b = {firnyquist(args{:})};



f = fdesign.nyquist(hspecs.Band,hspecs.TransitionWidth,hspecs.Astop);
h = dfilt.dffir(b{1});
m = measure(h,f);

if m.Astop < hspecs.Astop,
    % Kaiser designs often miss the Astop, we create a temporary fdesign in
    % order to measure and ensure we meet the specs.
    TW = hspecs.TransitionWidth;
    L  = hspecs.Band;
    fp = 1./L - TW./2;
    fs = 1./L + TW./2;
    Dev = convertmagunits(hspecs.Astop,'db','linear','stop');
    N = kaiserord([fp,fs],[1 0],[Dev,Dev]);
    if rem(N,2),
        N = N + 1;
    end

    % Design until we meet the spec, increase stopband attenuation
    count = 0;
    while m.Astop < hspecs.Astop && count < 10,
        N = N + 2;
        f2 = fdesign.nyquist(L,'n,tw',N,TW);
        h2 = kaiserwin(f2);
        b = {h2.Numerator};
        m = measure(h2);
        count = count + 1;
    end
end

% [EOF]
