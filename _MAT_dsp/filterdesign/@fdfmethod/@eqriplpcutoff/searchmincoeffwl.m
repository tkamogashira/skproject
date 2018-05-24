function Hbest = searchmincoeffwl(this,args,varargin)
%SEARCHMINCOEFFWL Search for min. coeff wordlength.
%   This should be a private method.


%   Copyright 2009 The MathWorks, Inc.

minordspec  = 'Fp,Fst,Ap,Ast';

designargs = {'equiripple',...                
                'MinPhase',this.MinPhase,...
                'StopbandShape',this.StopbandShape,...
                'StopbandDecay',this.StopbandDecay};
           
Hbest = searchmincoeffwlword(this,args,minordspec,designargs,varargin{:});

