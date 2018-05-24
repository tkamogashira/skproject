function Hbest = searchmincoeffwl(this,args,varargin)
%SEARCHMINCOEFFWL Search for min. coeff wordlength.
%   This should be a private method.


%   Copyright 2009 The MathWorks, Inc.

minordspec  = 'TW,Ast';

designargs = {'equiripple',...                
                'MinPhase',this.MinPhase};
           
Hbest = searchmincoeffwlwordhb(this,args,minordspec,designargs,varargin{:});

