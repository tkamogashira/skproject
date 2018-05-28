function newPos = IDFFillToNextBlock(fid, NbytesInBlock)

% function IDFFillToNextBlock(fid);
% writes zero to file (opened with fid=fopen(name,'w','ieee-le'))
% to fill block with size NbytesInBlock (default 256)

if nargin<2
    NbytesInBlock=256;
end

where = ftell(fid);
offset = rem(where, NbytesInBlock);
if offset>0
   bytesToFill = NbytesInBlock - offset;
   fwriteVAXD(fid, zeros(1,bytesToFill),'uint8');
end
newPos = ftell(fid);
