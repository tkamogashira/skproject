function zcir = thissetstates(this,zi)
%THISSETSTATES Overloaded set for the States property.

%   This should be a private method.

% The States of a CIC filter is a matrix whose size is (M+1)xN and is broken 
% down as follows:
%
%  Integrator portion --> [1 ... N] (where N is the number of stages)
%  Comb portion       --> [1 ... N] (where M is the Differential delay)
%                     --> [. ... N]
%                     --> [M ... N]

%   Author: P. Costa
%   Copyright 1999-2011 The MathWorks, Inc.

if ~isempty(zi), 
    M = this.DifferentialDelay;
    N = this.NumberOfSections;
    
    if isnumeric(zi)

        [rows, cols] = size(zi);

        % cols/N is the number of channels which must be an integer
        if rem(cols, N)
            error(message('dsp:mfilt:abstractcic:thissetstates:invalidState'));
        end

        % Loop over the channels and create a state object for each.
        nchannels = cols/N;
        
        intg = reshape(zi(1, :), N, nchannels);
        comb = reshape(zi(2:end, :), M*N, nchannels);
        
        zi = filtstates.cic(intg, comb);
        
    elseif isa(zi, 'filtstates.cic')
        % Check that we have the correct # of states.
        % Call validate.
        % Check that the integrator has N states.
        % Check that the comb has rows equal to M.
        validate(zi, N, M);
        
    end
    if ~strcmpi(class(this.filterquantizer), 'dfilt.filterquantizer')
        zi = validatestates(this.filterquantizer, zi);
    end
    
else
    % Default states object based on factory values for NumberOfSections
    % and DifferentialDelay
    factNofSections = 2;
    factDiffDelay = 1;
    zi = filtstates.cic(zeros(factNofSections,1),zeros(factNofSections,factDiffDelay));
end
set(this, 'HiddenStates', zi);


% [EOF]
