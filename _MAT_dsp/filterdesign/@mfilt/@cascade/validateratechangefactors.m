function validateratechangefactors(this)
%VALIDATERATECHANGEFACTORS   Validate the rate change factors for analysis.
%   VALIDATERATECHANGEFACTORS   Errors out if the rate change factors are
%   invalid.  

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.

rcf = getratechangefactors(this);

prestr = 'Analysis of multistage-multirate filters in which';


% Remove all single rate filters.
indx = 1;
while indx <= size(rcf, 1)
    if rcf(indx, 1) == rcf(indx, 2)
        rcf(indx, :) = [];
    else
        indx = indx + 1;
    end
end

% We can handle any single stage.
if size(rcf, 1) < 2
    return;
end

if rcf(1,1) == 1
    % If the first section is a decimator, make sure that we go all the way
    % down and then back up.
    
    int_indx = min(find(rcf(:,1) ~= 1));

    % If there are no interpolators, then we can just return.
    if isempty(int_indx)
        return;
    end
    
    if ~all(rcf(1:int_indx-1,1) == 1) || ~all(rcf(int_indx:end,2) == 1)
        error(message('dsp:mfilt:cascade:validateratechangefactors:invalidStages1'));
    else
        p = get(this, 'privRateChangeFactor');
        if p(1) ~= p(2)
            error(message('dsp:mfilt:cascade:validateratechangefactors:invalidStages2'));
        end
    end

elseif rcf(1,2) == 1
    % If the first section is an interpolator
    
    dec_indx = min(find(rcf(:,2) ~= 1));
    
    % If there are no decimators then we can just return.
    if isempty(dec_indx)
        return;
    end
    
    if ~all(rcf(dec_indx+1:end,1) == 1)

        if any(xor(rcf(dec_indx+1:end,2) > 1, rcf(dec_indx+1:end,1) == 1))
            error(message('dsp:mfilt:cascade:validateratechangefactors:invalidStages3'));
        else
            error(message('dsp:mfilt:cascade:validateratechangefactors:invalidStages4'));
        end
    end
else
    % If the first section is an src, then we only support following it
    % with decimators.
    if prod(rcf(2:end,1)) ~= 1
        error(message('dsp:mfilt:cascade:validateratechangefactors:invalidStages5'));
    end
end



% [EOF]
