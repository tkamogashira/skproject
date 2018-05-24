function [hTar,domapcoeffstoports] = parse_coeffstoexport(Hd,hTar)
%PARSE_COEFFSTOEXPORT Store coefficient names and values into hTar for
%export.

%   Copyright 2009 The MathWorks, Inc.

userdefinedflag = false;
state = hTar.MapCoeffsToPorts;

if ~isempty(hTar.CoeffNames)
    userdefinedflag = true;
end

if strcmpi(state,'on')
    [mapstate coeffnames var] = mapcoeffstoports(Hd,'MapCoeffsToPorts','on',...
                                        'CoeffNames',hTar.CoeffNames);
    hTar.CoeffNames = coeffnames;
    setprivcoefficients(hTar,var);
end

domapcoeffstoports = strcmpi(state,'on');

% Append stage index to coefficient names if the coefficient names are not
% user-defined to prevent repeated names.
if ~userdefinedflag && domapcoeffstoports
    coeffnames = hTar.CoeffNames;
    fd = fields(coeffnames);
    for stage = 1:length(fd)
        stagecoeff = coeffnames.(sprintf('Phase%d',stage));
        coeffname_temp = appendcoeffstageindex(Hd,stagecoeff,num2str(stage));    % add stage number
        coeffnames.(sprintf('Phase%d',stage)) = coeffname_temp;
    end
    hTar.CoeffNames = coeffnames;
end

% [EOF]
