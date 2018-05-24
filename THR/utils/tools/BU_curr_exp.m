function BU_curr_exp(varargin);
% BU_curr_exp - backup current experiment folder
%   Usage: BU_curr_exp(FC, OR)
%   Inputs:
%     FC = Force creation of parent folder (experimenter's folder), 
%          if doesn't exist. False by default.
%     OR = Override destination folder, if already exists. False by default.
%
%    See also BU_exp.

NAM = name(current(experiment));
if isempty(NAM),
    error('No current experiment found.');
end
% delegate to BU_exp
BU_exp(NAM, varargin{:});

