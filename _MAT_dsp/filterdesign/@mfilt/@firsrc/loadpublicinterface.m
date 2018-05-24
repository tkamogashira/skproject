function loadpublicinterface(this, s)
%LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if s.version.number == 1
    
    Scir = s.HiddenStates;
    
    % Circular -> Linear
    tapIndex = s.TapIndex+1; %1-based indexing
    s.States = [Scir(tapIndex+1:end,:); Scir(1:tapIndex-1,:)];
end

src_loadpublicinterface(this, s);


% [EOF]
