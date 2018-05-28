function corrs = rasterSac(spt, referenceBlockIdx, blocks)

referenceBlock = spt(referenceBlockIdx(1):referenceBlockIdx(2));
[ dummy numBlocks ] = size(blocks);

% corrs is a 3x(numBlocks+1) matrix containing the output of sptcorr for the
% reference block and all the other blocks.

[h bc] = sptcorr(referenceBlock, 'nodiag', 15, 0.05, NaN, '');
corrs = zeros(2, numBlocks+1, length(h));
corrs(1,1,:) = h;
corrs(2,1,:) = bc;
for n = 1:numBlocks
    block = spt(blocks(1,n):blocks(2,n));
    for m = 1:length(referenceBlock)
        [h bc] = sptcorr(block(:), referenceBlock(m), 15, 0.05, NaN, '');
        corrs = addColumnToMatrix(corrs, h, [1 n+1]);
        corrs = addColumnToMatrix(corrs, bc, [2 n+1]);
    end
    figure;
    bc = squeeze(corrs(2,n+1,:));
    h = squeeze(corrs(1,n+1,:));
    plot(bc,h);
end

%% Local functions
function matrix = addColumnToMatrix(matrix, vector, coord)

for n = 1:length(matrix)
    matrix(coord(1), coord(2), n) = matrix(coord(1), coord(2), n) + vector(n);
end
