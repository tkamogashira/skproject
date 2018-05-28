function anExampleVAXDG
% This tests reading vaxd and vaxg files with the ieee-le file
% format. The functions freadVAXD and freadVAXG work in R2008b.
% This function works in R2008a and earlier because it requires
% fopen(...,'vaxd') and fopen(...,'vaxg') to write the files.
%
% See also freadVAXD, freadVAXG

% Copyright 2009 The MathWorks, Inc.

%% Create test data
%testData.x = [rand(1000,1);rand(1000,1)*1e100];
testData = load('testData.mat');

%% Create VAXD File
% fid = fopen('test_vaxd','w','vaxd');
% fwrite(fid, testData.x, 'single');
% fwrite(fid, testData.x, 'double');
% fclose(fid);
% 
% %% Create VAXG File
% fid = fopen('test_vaxg','w','vaxg');
% fwrite(fid, testData.x, 'single');
% fwrite(fid, testData.x, 'double');
% fclose(fid);

%% Read VAXD files with ieee-le format (available in R2008b)
fid = fopen('test_vaxd','r','ieee-le');
vaxdSingle = freadVAXD(fid, length(testData.x), 'single');
vaxdDouble = freadVAXD(fid, length(testData.x), 'double');
fclose(fid);

%% Read VAXG files with ieee-le format (available in R2008b)
fid = fopen('test_vaxg','r','ieee-le');
vaxgSingle = freadVAXG(fid, length(testData.x), 'single');
vaxgDouble = freadVAXG(fid, length(testData.x), 'double');
fclose(fid);

%% Display results
disp(['Number of elements: ' num2str(length(testData.x))])
disp('Maximum Error --> VAXF:Single(in VAXD file) vs MATLAB:Single')
disp(max(vaxdSingle-single(testData.x)))
disp('Maximum Error --> VAXD:Double vs MATLAB:Double')
disp(max(vaxdDouble-testData.x))
disp('Maximum Error --> VAXF:Single(in VAXG file) vs MATLAB:Single')
disp(max(vaxgSingle-single(testData.x)))
disp('Maximum Error --> VAXG:Double vs MATLAB:Double')
disp(max(vaxgDouble-testData.x))

end
