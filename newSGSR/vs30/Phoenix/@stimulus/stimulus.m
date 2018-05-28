function ST = stimulus(name, createdBy);
% Stimulus - constructor for Stimulus objects
%   Stimulus(name, CreatedBy) creates a named and signed 
%   stimulus object. To fill it with chunks, waveforms,
%   and DAshots, see the following stimulus methods:
%     addChunk, defineWaveform, defineDAshot.
%
%   Note: a new, "empty", stimulus object contains four standard
%   chunks with zero-filled buffers of lengths 1,10,100 and 1000.
%   These are used by defineWaveform to create silent intervals.
%
%   See also StimDefinitionFS, paramset.

if nargin<1, name = ''; 
elseif ~isvarname(name),
   error('Name of stimulus object must be valid MatLab variable name. See ISVARNAME.');
end
if nargin<2, createdBy = ''; end


chunk = emptyStruct('Nsam', 'samples', 'name', 'storage', 'address'); % array with chunks of samples
waveform = emptyStruct('Nsam', 'Fsam', 'ifilt', 'DAchannel', 'chunkList', 'maxSPL');
DAshot = emptyStruct('HardwareSettings', 'waveform', 'weight', 'Param');
presentation = emptyStruct('DAshotList', 'presParam');
globalInfo = struct('storage', 'none');

ST = collectInStruct(name, chunk, waveform, DAshot, presentation, globalInfo, createdBy);
ST = class(ST, 'stimulus');

if isvoid(ST), return; end;
% standard zero buffers - DO NOT CHANGE without also adapting defineWaveform!!
ST = AddChunk(ST, zeros(1,1), 'zero1');
ST = AddChunk(ST, zeros(1,10), 'zero10');
ST = AddChunk(ST, zeros(1,100), 'zero100');
ST = AddChunk(ST, zeros(1,1000), 'zero1000');
% standard buffer for sync pulse
ST = AddChunk(ST, [TTLamplitude, zeros(1,10)], 'sync');


% lowest level: single-channel sound bits, e.g. rising part of tone 
% here is where the samples really are - the rest is bookkeeping.
%chunk[]: Nsam, samples

% one level up: single-channel waveform, in fact a chain of chunks
% note that a single chunk may participate in multiple DAshots
% (see below) - attenuator settings may differ across DAshots.
% The maxSPL field indicates the SPL when attenuators are wide-open.
% Silences (e.g. for obtaining an ITD or a pause between reps) are 
% included in the definition of the waveform.
%    waveform[]: Fsam, ifilt, ichan, chunkList, maxSPL
% chunklist contains chunk indexes, repcounts, and sampleCounts

% one more up: prescription for a repeated dual-channel presentation with silence in between reps
% this thing is played in one shot, i.e., the computer says Go and the hardware takes
% care of the D/A conversion. Thus, within a DA shot, hardware settings 
% like attenuators and sample rates have a fixed set of settings.
% Multiple waveforms are mixed with weight factors (sys3 only).
% All waveforms must have the same #samples, sample rate etc.
%DAshot[]: HardwareSettings, waveformLeft[], waveformRight[], weightFactors[], depVar
%   where HardwareSettings: Nplay, Fsam, ifilt, routing/circuit, attenuator settings

% highest level: complete collection of DAshots, that is, a list of subsequent
% DAshots. Simply a list of DAshots, but one that is associated with some parameter
% like "index of subsequence" or something else, depending on the organization
% of stimuli in the experimental run. This allows one to play directly the 
% stimuli associated with one or more given values of the "presentation parameter"
%presentation: DAshotList, presParameter







