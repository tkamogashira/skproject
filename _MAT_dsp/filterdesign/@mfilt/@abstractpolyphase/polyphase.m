function varargout = polyphase(this, str)
%POLYPHASE Polyphase decomposition of FIR filters.
%   P=POLYPHASE(Hd) returns the polyphase matrix. The ith row P(i,:)
%   represents the ith subfilter.

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if nargout

    if nargin < 2, str = 'matrix'; end

    % Convert the matrix to objects if they are requested.  If we do not
    % recognize the option string error out.
    switch strmatch(str, {'matrix', 'objects'})
        case 1
            P = double(thispolyphase(this));
        case 2
            P = double(thispolyphase(reffilter(this)));
            L = size(P,1);
            for i=1:L,
                Hp(i) = dfilt.dffir(P(i,:));
            end
            if isquantized(this)
                set(Hp, 'Arithmetic', this.Arithmetic);
                if strcmpi(this.Arithmetic, 'fixed')
                    set(Hp, 'CoeffWordLength', this.CoeffWordLength, ...
                        'CoeffAutoScale', this.CoeffAutoScale);
                    if ~this.CoeffAutoScale
                        set(Hp, 'NumFracLength', this.NumFracLength);
                    end
                end
            end
            P = Hp;
        otherwise
            error(message('dsp:mfilt:abstractpolyphase:polyphase:InvalidInput', str));
    end
    varargout = {P};
    
else
    h = fvtool(this, 'PolyphaseView', 'On', 'Analysis', 'coefficients');
end

% [EOF]
