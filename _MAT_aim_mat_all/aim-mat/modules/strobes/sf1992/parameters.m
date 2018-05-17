% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

%%%%%%%%%%%%%
% old strobe finding
% hidden parameters
sf1992.generatingfunction='gen_sf1992';
sf1992.displayname='strobe finding old ams version';
sf1992.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module

% can be 'peak','temporal_shadow','local_maximum','delta_gamma'
sf1992.strobe_criterion='local_maximum'; 
% parameter for temporal_shadow
sf1992.strobe_decay_time=0.02;


% which unit is applied to the time measurements below
% can be sec,ms,cycles:
sf1992.unit='sec';
% parameter for local_maximum
sf1992.strobe_lag=0.005;
sf1992.timeout=0.01;