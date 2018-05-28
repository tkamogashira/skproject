function [DAdata, GENdata] = stimeval(wf);

% STIMEVAL - evaluates computational details of stimuli
% STIMEVAL uses the waveform filed of the stimdef record 
% as stimulus definition
% (see files stimdefXXX in stimdef directory)
% STIMEVAL computes the sample frequency, number of
% samples to be stored in MatLab and the AP2, the number
% samples to be played, the warping factors, etc.
% These computations are delegated to specialized
% files that know about the stimtypes, e.g., for
% a waveform of type 'tone,' a call is made
% to the function 'stimevaltone'. If this function
% does not exist, an error results.
% Results are put in a STIMEVAL structure,which
% is a cell array, the elements of which correspond
% one-by-one to the pool elements of sd.
% The type and format of this STIMEVAL structure is
% independent of the stimtype! It can be handled by
% memory-allocating functions, etc., who do not care
% nor know about stimtypes - they just see samples,
% buffers, sample rates, etc.

% check input arg
if nargin~=1, error('incorrect # input args'); end;

if ~isfield(wf,'stimCat'),
   error('absent stimCat field in stimdef');
end
sc = wf.stimCat;
% check if stimtype is known, i.e., if a stimeval file exists
if strcmp(sc,''), error('empty stimCat field in stimdef'); end;
stimevalfile = ['stimeval' sc];
if (exist(stimevalfile)~=2),
   error(['do not know how to evaluate ''' sc ''' stimCat']);
end

% Surviving all checks, we delegate according to stimtype
evalstr = ['[DAdata GENdata] = ' stimevalfile '(wf);'];
eval(evalstr);

