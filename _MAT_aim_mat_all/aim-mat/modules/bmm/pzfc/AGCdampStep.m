function  [pdampsmod, agcstate] = AGCdampStep(detect, pdamps, ...
					      agcepsilons, agcgains, agcstate, agcfactor);
  % 
  
% function [pdampsmod, agcstate] = AGCdampStep(detect, pdamps,
%                                  agcepsilons, agcgains, agcstate);
% 
%  update the dampings and agcstates based on present outputs
%  including 50% stereo coupling if two channels based on size of
%  agcstate is twice the number of channels

if nargin < 6
    agcfactor=12;
end

Nch = length(pdamps);
Ntracks = size(detect,2); % two columns for stereo
Nstages = length(agcepsilons);


if length(detect)==0,
  Ntracks = 1; % mono default
  if size(agcstate,2)>Nstages
    Ntracks = round(size(agcstate,2)/Nstages); % pass in agcstate big
                                                % enough to do stereo
  end
  detect = DetectFun(0.0)*ones(Nch,1);
  %agcstate = 1.2*detect*ones(1,Ntracks*Nstages); % a detect-dependent
  %hack to initialize damping
  rep = 1+rem((1:Ntracks*Nstages)-1,Nstages);
  agcstate = 1.2*detect*agcgains(rep); % rep is like [1 2 3 4 1 2 3 4]
  detect = DetectFun(0.0)*ones(Nch,Ntracks);
end

agcepsleft = 0.3; % 0.15;
agcepsright = 0.3; % 0.15;
spacecoeffs = [agcepsleft, 1.0-agcepsleft-agcepsright, agcepsright];

for k = 1:Ntracks % track number (1 for mono, 2 for second channel)
  for j = 1:Nstages % stage number
    jj = j + (k-1)*Nstages; % index into state columns
    %spatial smoothing:
    agcavg = filter(spacecoeffs, 1, [agcstate(1,jj); agcstate(:,jj); ...
		    agcstate(Nch,jj)]);
    agcavg = agcavg(3:(Nch+2));
    %time smoothing:
    epsilon = agcepsilons(j);
    agcstate(:,jj) = agcavg*(1-epsilon) + epsilon*detect(:,k)*agcgains(j);
  end
end

%agcstate can't exceed 0.25, usually , with max detect being 0.5
% only INCREASE the damping over pdamp
%agcfactor = 12; % 6.0; % 12.0;
% now set above or as an argument

offset = 1-agcfactor*DetectFun(0.0);  % 0.7422 for DetectFun(0)=0.0215
% this makes the minimum damping (with 0 signal into AGC and agcstate being 
% equal to the DetectFun value at zero, which may be zero) equal the nominal

for k = 1:Ntracks % track number (1 for mono, 2 for second channel)
%   pdampsmod(:,k) = pdamps.*min(1.5,(offset+agcfactor*...
%           (mean(agcstate')' + mean(agcstate(:,((k-1)*Nstages+1):k*Nstages)')')/2));
  pdampsmod(:,k) = pdamps.*(offset+agcfactor*...
          (mean(agcstate')' + mean(agcstate(:,((k-1)*Nstages+1):k*Nstages)')')/2);
  % the above hack weights the track AGC and the average equally
  % for mono is same as just ...ofset+agcfactor*sum(agcstates')'
end

%plot([detect, pdamps, pdampsmod, agcstate, sum(agcstate')'])
%drawnow
