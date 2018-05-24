function [out, coeffnames] = super_mapcoeffstoports(this,varargin)
%SUPER_MAPCOEFFSTOPORTS 

%   Copyright 2009-2011 The MathWorks, Inc.

coeffnames = [];
out = parse_mapcoeffstoports(this,varargin{:});

nphases = length(this.privphase);

if strcmpi(out,'on')
    % User-specified coefficient names
    idx = find(strcmpi(varargin,'CoeffNames'));
    if ~isempty(idx)&&~isempty(varargin{idx+1})
        coeffnames = varargin{idx+1};
        
        % check if the specified coefficient name is a structure and the number
        % of coefficient names' stages match with filter stages.
        errorflag = false;
        if ~isstruct(coeffnames);
            errorflag = true;
        else
            fd = fields(coeffnames);
            if length(fd)~=nphases, errorflag=true; end;
        end
        
        if errorflag
            error(message('dsp:mfilt:abstractiirmultirate:super_mapcoeffstoports:InvalidValue1', this.FilterStructure, nphases));
        end
        
        % check if the field name is in the format: Name.Phase1, Name.Phase2, etc.
        errorflag = false;
        for phase = 1:length(fd)
            phasename = fd{phase};
            idx = findstr(phasename,'Phase');   % Find 'Phase' string
            if ~isempty(idx)
                % check that the phase number is appended after the string
                % 'Phase' i.e. Phase1, Phase2.
                phasenum = str2double(phasename(idx+5));
                if ~isfinite(phasenum)||(phasenum<1)||(phasenum>length(fd))
                    errorflag = true;
                end
            else
                errorflag = true;
            end
        end
        
        % provide error message when the name is not Phase1, Phase2, etc.
        if errorflag
            error(message('dsp:mfilt:abstractiirmultirate:super_mapcoeffstoports:InvalidValue'));
        end
    end
    
    % Get default coefficient names and coefficient variables.
    for k=1:nphases
        coef = coefficients(this.privPhase(k));
        nsections = length(coef);
        for n = 1:nsections
            sectionname{n} = sprintf('%s%d','C',n);
        end
        coeffs.(sprintf('Phase%d',k)) = sectionname;
        sectionname = [];
    end
    
    % If no user-specified coefficient names, use default.
    if isempty(coeffnames)
        coeffnames = coeffs;
    end
    
end

% [EOF]
