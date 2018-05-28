function viewEDFDSSpkTimes(ds)

%B. Van de Sande 07-08-2003
%This is a debugging tool ...

if nargin ~= 1, error('Wrong number of input arguments.'); end
if ~isa(ds, 'edfdataset'), error('First and only argument should be a EDF dataset object.'); end
if isempty(ds.spt), error('Dataset should contain spiketimes.'); end

nDim  = ndims(ds.spt3d);
SptSz = size(ds.spt3d);

Data  = cellfun('length', ds.spt3d);

FigHdl = figure('Name', sprintf('viewEDFDSSpkTimes: %s <%s>', ds.ID.FileName, ds.ID.SeqID), ...
                'NumberTitle','off', ...
                'Units', 'normalized');
AxHdl  = axes('Position', [0.10 0.10 0.60 0.80]);
LegHdl = axes('Position', [0.80 0.10 0.10 0.20]); 
            
switch nDim
case 2,
    [NX, NRep] = deal(SptSz(1), SptSz(2));
    Xval = unique(ds.xval);
    
    Ncolor = max(Data(:))+1;
    ColorMap = hot(Ncolor+1); ColorMap(end, :) = []; 
    ColorMap = ColorMap(Ncolor:-1:1, :);

    axes(AxHdl);
    
    set(AxHdl, 'Box', 'on', ...
        'XTick', Xval, ...  
        'YTick', 1:NRep, ...
        'XLim', [min(Xval), max(Xval)], ...
        'YLim', [1 NRep]);
    
    for x = 1:NX,
        for r = 1:NRep, line(Xval(x), r, 'LineStyle', 'none', 'Marker', '.', 'Color', ColorMap(Data(x, r)+1, :), 'MarkerSize', 20); end
    end
    
    title(sprintf('Nr of Spikes for all stimulus conditions, %s <%s>.', ds.ID.FileName, ds.ID.SeqID), 'fontsize', 12);
    xlabel(ds.xlabel); 
    ylabel('Nrep (#)');
    
    axes(LegHdl);
    
    [X, Y] = meshgrid(0:Ncolor-1, [0 1]);
    C = [1:Ncolor;1:Ncolor];
    colormap(ColorMap);
    pcolor(X, Y, C);
    
    set(LegHdl, 'Box', 'on', ...
        'XTick', 1:2:Ncolor, ...  
        'YTick', [], 'YTickLabel', '', ...
        'XLim', [0, Ncolor-1]);

    title('Legend', 'fontsize', 12);
    xlabel('Nr of spikes');
case 3,
    [NX, NY, NRep] = deal(SptSz(1), SptSz(2), SptSz(3));
    Xval = unique(ds.indepval(1));
    Yval = unique(ds.indepval(2));
    
    Ncolor = max(Data(:))+1;
    ColorMap = hot(Ncolor+1); ColorMap(end, :) = []; 
    ColorMap = ColorMap(Ncolor:-1:1, :);

    axes(AxHdl);
    
    set(AxHdl, 'Box', 'on', ...
        'XTick', Xval, ...  
        'YTick', Yval, ...
        'ZTick', 1:NRep, ...
        'XLim', [min(Xval), max(Xval)], ...
        'YLim', [min(Yval), max(Yval)], ...
        'ZLim', [1 NRep]);
    
    for x = 1:NX,
        for y = 1:NY,
            for r = 1:NRep, line(Xval(x), Yval(y), r, 'LineStyle', 'none', 'Marker', '.', 'Color', ColorMap(Data(x, y, r)+1, :), 'MarkerSize', 20); end
        end
    end
    
    title(sprintf('Nr of Spikes for all stimulus conditions, %s <%s>.', ds.ID.FileName, ds.ID.SeqID), 'fontsize', 12);
    xlabel(ds.indeplabel(1)); 
    ylabel(ds.indeplabel(2));
    zlabel('Nrep (#)');
    
    axes(LegHdl);
    
    [X, Y] = meshgrid(0:Ncolor-1, [0 1]);
    C = [1:Ncolor;1:Ncolor];
    colormap(ColorMap);
    pcolor(X, Y, C);
    
    set(LegHdl, 'Box', 'on', ...
        'XTick', 1:2:Ncolor, ...  
        'YTick', [], 'YTickLabel', '', ...
        'XLim', [0, Ncolor-1]);

    title('Legend', 'fontsize', 12);
    xlabel('Nr of spikes');
end