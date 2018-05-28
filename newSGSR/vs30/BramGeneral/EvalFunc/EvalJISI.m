function EvalJISI(ds)
% EvalJISI evaluate the joint interspiketime interval histogram
% 
% E.g.  ds=dataset('A0242','86-8-SPL');
%       EvalJISI(ds)

% Created by: Ramses de Norre

if ~isa(ds, 'dataset')
    error('The first argument must be a dataset.');
end

%% Calculating
nsubs = ds.nsub;
nreps = ds.nrep;

lengths = zeros(nsubs,1);
for sub = 1:nsubs
    for rep = 1:nreps
        lengths(sub) = lengths(sub) + length(ds.SpikeTimes{sub, rep}) - 1;
    end
end

X = cell(2, nsubs);
for n = 1:nsubs
    [ X{1,n} X{2,n} ] = deal(zeros(1,lengths(n)));
end
for sub = 1:nsubs
    begin = 1;
    for rep = 1:nreps
        spt = ds.SpikeTimes{sub, rep};
        diffs = diff(spt);
        End = begin + length(diffs)-2;
        
        x = X{1,sub};
        x(begin:End) = diffs(2:end);
        X{1,sub} = x;
        
        x = X{2,sub};
        x(begin:End) = diffs(1:end-1);
        X{2,sub} = x;
        
        begin=End+1;
    end
end

%% Plotting

GridPlot(X(1,:), X(2,:), ds, 'xlabel', {'(n+1)'}, 'ylabel', {'n'}, ...
    'mfileName', mfilename, 'plotTypeHdl', @XYPlotObject, ...
    'plotParams', {'Marker', '.', 'LineStyle', 'none'}, 'subsequences', true);
