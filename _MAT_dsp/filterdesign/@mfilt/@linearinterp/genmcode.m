function hcode = genmcode(this, varname, place)
%GENMCODE   Generate an MATLAB code object for this object.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

if nargin < 2
    varname = 'Hd';
end

hcode = sigcodegen.mcodebuffer;

hcode.addcr(hcode.formatparams({'intf'}, {sprintf('%d', this.InterpolationFactor)}, ...
    {'Interpolation Factor'}));
hcode.cr;

hcode.add('%s = %s(intf);', varname, class(this));

% Add the quantizer mcode.
% Add the quantizer mcode.
switch lower(this.Arithmetic)
    case 'double'
        % NO OP
    case 'single'
        hcode.cr;
        hcode.cradd('set(%s, ''Arithmetic'', ''single'');', varname);
    otherwise
        hqcode = genmcode(this.filterquantizer);
        if ~isempty(hqcode)
            hcode.cr;
            hcode.craddcr('set(%s, ''Arithmetic'', ''%s'', ...', varname, this.Arithmetic);
            firstLine = hqcode.getline(1);
            firstLine = firstLine{1};
            firstLine = firstLine(~isspace(firstLine));            
            if strcmpi(firstLine(1),',')
              firstLine = firstLine(2:end);
              hqcode.replace(1,firstLine);
            end            
            lastLine = hqcode.getline(length(hqcode.buffer));
            lastLine = lastLine{1};
            lastLine = lastLine(~isspace(lastLine));            
            if ~(strcmpi(lastLine(end-1),')') && strcmpi(lastLine(end),';'))
              lastLine(end+1:end+2) = ');';
              hqcode.replace(length(hqcode.buffer),lastLine);
            end                                    
            hcode.add(hqcode);            
        end
end

% [EOF]
