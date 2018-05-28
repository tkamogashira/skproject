function PRP = CreatePRPinfo(plotInfo, playOrder, varargin);

% CreatePRPinfo - create PRP field for SMS struct


PRP = [];
PRP.plotInfo = plotInfo; % info for spike-rate plots
PRP.playOrder = playOrder; % order of playing the subsequences
for ii=1:nargin-2,
   PRP = setfield(PRP,inputname(ii+2),varargin{ii});
end

