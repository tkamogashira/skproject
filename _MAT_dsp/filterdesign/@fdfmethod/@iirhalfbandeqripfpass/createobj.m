function Hd = createobj(this,den)
%CREATEOBJ

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

filtstruct = get(this, 'FilterStructure');
desmode = this.DesignMode;

[filtstruct,mfiltstruct] = ...
    determineiirhalfbandfiltstruct(this,desmode,filtstruct);

m = length(den) - 1;
coeffs = Hbliphasos(this,den,filtstruct,mfiltstruct);

if isempty(mfiltstruct),
    Hd = cascade(parallel(dfilt.delay(m),...
        cascade(dfilt.delay(1),feval(['dfilt.',filtstruct],coeffs{:}))),dfilt.scalar(0.5));
else
    Hd = feval(['mfilt.',mfiltstruct],{[zeros(1,m/2),1]},coeffs);
end

%--------------------------------------------------------------------------

function coeffs = Hbliphasos(this,den,filtstruct,mfiltstruct)


% Determine the roots of polynomial in terms of z^2
ra = roots(den(1:2:end));

% Sort complex pairs
sra = cplxpair(ra);

nr = length(sra);

indxr = find(imag(sra)==0,1,'first');
if isempty(indxr),
    % No real roots
    indxr = nr + 1;
end

for k = 1:2:indxr-1,
    if isempty(mfiltstruct),
        a0 = [0 -2*real(sra(k)) 0 abs(sra(k))^2];
    else
        a0 = [-2*real(sra(k)) abs(sra(k))^2];
    end
    coeffs{1+(k-1)/2} = a0;
end

for l = indxr:nr
    % Second-order section
    if isempty(mfiltstruct),
        a1 = [0 -sra(l)];
    else
        a1 = [-sra(l)];
    end
    if indxr == 1,
        % Handle case when there are no complex conjugate pairs
        coeffs{l} = a1;
    else
        coeffs{1+(k-1)/2+l+1-indxr} = a1;
    end
end





% [EOF]
