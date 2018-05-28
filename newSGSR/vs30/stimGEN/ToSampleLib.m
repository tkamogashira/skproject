function index = ToSampleLib(varargin);

% ToSampleLib - put variables in global SampleLib struct

global SampleLib;

if isempty(SampleLib), % create it
   SampleLib.cell = cell(1,256);
   SampleLib.free = 1:256;
end

% find non-empty cells
index = find(SampleLib.free~=0);
while length(index)<nargin, % insufficient empty cells - create some more
   Ncell = size(SampleLib.cell, 2);
   newcells = cell(1,256);
   newIndex = (Ncell+1):(Ncell+256);
   [SampleLib.Cell{newIndex}] = deal(newcells{:});
   SampleLib.free = [SampleLib.free newIndex];
   index = [index newIndex];
end

index = index(1:nargin);
[SampleLib.cell{index}] = deal(varargin{:});
SampleLib.free(index) = 0;






