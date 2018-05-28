function s=sizeof(x);
% sizeOf returns size of variable in bytes
w = whos('x');
s = w.bytes;