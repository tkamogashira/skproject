function name = PDPtestSetName(N)

% name = PDPtestSetName(N);

if ~isnumeric(N)
   name=N;
   return
end

names = {'94A42U' , '95A10K' ,'96B73A', '97A58O', ...
      '95C58G', '99C03H', '98d05d', '99A35P', '95E58M' };
if nargin<1
    N=1;
end
NN = length(names);
if ismember(N,1:NN)
   name = names{N};
else
    error(['I have only ' num2str(NN) ...
         ' sample files, you asked for N=' ...
         num2str(N)]);
end

