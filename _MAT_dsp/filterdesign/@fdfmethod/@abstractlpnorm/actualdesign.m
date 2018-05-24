function varargout = actualdesign(this,hspecs,varargin)
%ACTUALDESIGN   Perform the actual design.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

args = designargs(this, hspecs);
args = [args,{this.MaxPoleRadius, ...           % Radius
        [this.InitNorm this.Norm], ...          % Norm
        this.DensityFactor, ...                 % Density
        }];             
args = parseic(this,args,args{1},args{2});

if this.MaxPoleRadius<1,
    % Call iirlpnormc
    [b,a,err,sos,g] = iirlpnormc(args{:},varargin{:});
else
    % Call iirlpnorm
    args(7) = []; % Remove radius
    [b,a,err,sos,g] = iirlpnorm(args{:},varargin{:});
end

varargout = {{sos, g}, err};

% [EOF]
