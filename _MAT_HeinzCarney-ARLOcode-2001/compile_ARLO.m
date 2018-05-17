% This file compiles the matlab version of the ARLO auditory nerve model:
% Auditory nerve model for predicting performance limits of normal and impaired listeners
% Heinz, Zhang, Bruce, and Carney  ARLO (2001) 2:91-96.
%
% This creates the matlab function: an_arlo, which creates the sypnapse output
%    in response to an arbitrary input stimulus, scaled in pascals.
mex an_arlo.c runmodel.c cmpa.c hc.c complex.c filters.c synapse.c

% This creates the matlab function sgmodel, which is a spike generation model.
mex sgmodel.c spikes.c
