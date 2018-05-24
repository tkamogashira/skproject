function zi = formatstates(this, zi)
%FORMATSTATES   Format the states for filtering.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.DifferentialDelay;
N = this.NumberOfSections;

if isa(zi, 'filtstates.cic')

    % Convert the object to a matrix.
    zi = int(zi);

    nchannels = size(zi, 2)/N;
    
    % Zero pad for the algorithm.
    for indx = 1:nchannels
        colindx = 1+(indx-1)*N:indx*N;
        ztemp{indx} = zi(:, colindx)';
        ztemp{indx} = [ztemp{indx}; zeros(N, size(ztemp{indx}, 2))];
        ztemp{indx} = ztemp{indx}(:);
    end
    zi = [ztemp{:}];
else

    nchannels = size(zi,2);

    % The comb portion of the filter is expecting a vector of states of length
    % N*(M+1); Need to extract all zeros which were added to pad for the
    % circular states
    for idx = 1:M+1,
        start = (idx*N)+1;
        zi(start:(start+N-1),:) = [];
    end
    
    % Create a new states object and quantize it.
    znew = filtstates.cic(zi(1:N,:),zi(N+1:end,:));
    zi = quantizestates(this.filterquantizer, znew);
end

% [EOF]
