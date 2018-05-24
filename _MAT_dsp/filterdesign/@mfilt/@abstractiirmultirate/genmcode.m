function hcode = genmcode(this, varname, place) %#ok
%GENMCODE   Generate an MATLAB code object for this object.

%   Author(s): R. Losada
%   Copyright 2005-2009 The MathWorks, Inc.

if nargin < 2
    varname = 'Hm';
end

hcode = sigcodegen.mcodebuffer;

c = struct2cell(this.Polyphase);
argstr = '';
for k = 1:prod(getratechangefactors(this)),
    
    params{k} = sprintf('phase%d',k);
    values{k} = struct2cell(c{k});
    valstr = '';
    for n = 1:length(values{k}),
        valstr = [valstr,',',genmcodeutils('array2str', values{k}{n}, 16)];        
    end
    values{k} = ['{',valstr(2:end),'}']; % Remove leading comma
    descs{k}  = sprintf('Phase%d',k);
    argstr = [argstr,',',params{k}];
end
argstr = argstr(2:end); % Remove leading comma

hcode.addcr(hcode.formatparams(params, values, descs));
hcode.cr;
hcode.add('%s = %s(%s);', varname, class(this),argstr);


% [EOF]
