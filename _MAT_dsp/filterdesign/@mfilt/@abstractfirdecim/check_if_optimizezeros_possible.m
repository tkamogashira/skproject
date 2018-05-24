function check_if_optimizezeros_possible(this, hTar)
%CHECK _IF_OPTIMIZEZEROS_POSSIBLE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

coefs = polyphase(this);
for m = 1:size(coefs,1)
    if sum(coefs(m,:)~=0)==0
        hTar.OptimizeZeros = 'off';
        break;
    end
end


% [EOF]
