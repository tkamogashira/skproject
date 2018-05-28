function Hdl = rasplot(ds, iSubSeqs, AxHdl)
%RASPLOT  creates raster plot
%   RASPLOT(ds) creates raster plot of dataset ds. The plot is created in the current axis.
%   If no current axis object exists, one is created.
%   Hdl = RASPLOT(ds, iSub, AxHdl) only plots the requested subsequences and uses the handle
%   of the axis object suppied in AxHdl. Optionally, the handle of the axis object is returned.

%B. Van de Sande 24-05-2004

Colors  = {'r', 'g', 'b', 'c', 'm', 'y', 'k'}; 
NColors = length(Colors);

%Checking parameters ...
if (nargin < 1) || ~isa(ds, 'dataset')
    error('Wrong input parameters.');
end
switch nargin,
case 1,
    iSubSeqs = 1:ds.nrec;
    AxHdl    = gca;
case 2,
    AxHdl = gca;
end    

%Plotting raster ...
SptCell = ds.spt;
NRep    = ds.nrep;
ColIdx  = 0; %Color index ...
Hdl     = [];
for nSubSeq = iSubSeqs(:)'
    X = [];
    Y = [];
    ColIdx = mod(ColIdx, NColors) + 1;
    yy = linspace(nSubSeq-0.4, nSubSeq+0.4, NRep+1);
    for n = 1:NRep
        Spks = SptCell{nSubSeq, n}; 
        NSpk = length(Spks);
        if (NSpk > 0)
            X  = [X VectorZip(Spks, Spks , Spks+NaN)];
            y1 = yy(n)+0*Spks;   %same size as x
            y2 = yy(n+1)+0*Spks; %same size as x
            Y  = [Y, VectorZip(y1, y2, y2)];
        end
    end
    LnHdl = line(X, Y, 'LineStyle', '-', 'Color', Colors{ColIdx}, 'Marker', 'none');
    if ~isempty(LnHdl)
        Hdl = [Hdl, LnHdl];
    end
end

%Setting axis properties ...
%Indepval vector is invalid for incomplete BFS-dataset collected before August 2002 ...
if strcmpi(ds.FileFormat, 'IDF/SPK') && any(strcmpi(ds.StimType, {'BFS', 'FS'}))...
    && (ds.nrec ~= ds.nsub) && (datenum(ds.Time([3, 2, 1, 4, 5, 6])) < datenum(2002, 8, 1))
    warning('Incomlete FS-dataset collected before August 2002.');
    Freqs = SPKuetvar(ds); Indepval = Freqs(:, 1);
else
    Indepval = ds.indepval;
end
set(AxHdl, 'YTick', iSubSeqs, 'YTicklabel', eval(['{' num2sstr(Indepval(iSubSeqs))  '}']), ...
    'ylim', [min(iSubSeqs)-0.5 max(iSubSeqs)+0.5]);
title('Raster Plot', 'fontsize', 12);
xlabel('Time (ms)');
ylabel(sprintf('%s (%s)', ds.indepname, ds.indepunit));
