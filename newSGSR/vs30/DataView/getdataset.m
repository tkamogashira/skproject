function DS = getdataset(DS);
% getdataset - get dataset variable from string specification
%   Getdataset returns the dataset variable that matches the specification
%   in the input argument.
%
%   Examples
%     DS = getdataset(DS) % returns dataset DS as is.
%     DS = getdataset('C0604/8-20') % specified by sequence identifier
%     DS = getdataset('C0604/-23') % specified by sequence index
%     DS = getdataset({'C0604' '8-20'}) % filename and seq as cells of cell array
%     DS = getdataset({C0604 -23}) % idem, seq index used
%
%   See also dataset.

if isa(DS, 'dataset'),
   return; % DS in, DS out
end

if ischar(DS),
   ww = words2cell(DS,'/');
   DF = ww{1}; % datafile
   seq = ww{2}; % sequence specification
   iseq = sscanf(seq, '%f'); % try to read as single number
   if length(iseq)==1, % single number that can be passed to dataset
      seqSpec = iseq;
   else, % seq is a string like '8-20' or '4-56-ARMIN'; pass string to dataset
      seqSpec = seq;
   end
elseif iscell(DS),
   [DF, seqSpec] = deal(DS{:});
else,
   error('Dataset specification must be dataset, char string or cell array.');
end

DS = dataset(DF, seqSpec);
