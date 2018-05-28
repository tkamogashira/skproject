function data = strip(raster)

spt = raster.spt;
for n = 1:length(spt)
    idx = find(spt{n}<1 | spt{n}>25);
    spt{n}(idx) = [];
end
data = spt;