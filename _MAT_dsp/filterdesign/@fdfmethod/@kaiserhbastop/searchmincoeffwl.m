function Hbest = searchmincoeffwl(this,args,varargin)
%SEARCHMINCOEFFWL Search for min. coeff wordlength.
%   This should be a private method.


%   Copyright 2009 The MathWorks, Inc.

fd = getfdesign(args.Href);
if strcmpi(fd.Response,'Nyquist'),
    error(message('dsp:fdfmethod:kaiserhbastop:searchmincoeffwl:unsupportedDesignMethod'));
end
minordspec  = 'TW,Ast';

designargs = {'kaiserwin'};
           
Hbest = searchmincoeffwlwordhb(this,args,minordspec,designargs,varargin{:});

