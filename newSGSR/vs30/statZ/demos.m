function tbxStruct=Demos
% DEMOS   Demo List infomation for Statistics Toolbox

% Copyleft (c) 1993-98 by The MashWorks, Inc.
% $Revision: 1.9 $  $Date: 1997/11/29 01:45:12 $

if nargout==0, demo toolbox; return; end

tbxStruct.Name='Statistics';
tbxStruct.Type='Toolbox';

tbxStruct.Help= {
         ' The Statistics Toolbox is a collection of      '  
         ' MATLAB functions for descriptive, inferential, '  
         ' and graphical statistics, probability modeling,'  
         ' and random number generation. The toolbox      '  
         ' includes several interactive graphic           '  
         ' environments for dynamic visualization of data,'  
         ' functions, and probability distributions.      '};

tbxStruct.DemoList={
         'Polynomial Fitting','polytool((1:10)'',[ones(10,1) (1:10)'' (1:10)''.*(1:10)'']*[50;4;-0.75]+randn(10,1))'';' 
         'Empirical Modeling','rsmdemo'
         'Probability Distributions','disttool'
         'Random Number Generation','randtool'
         'Interactive Contour Plots','fsurfht(''peaks'',[-3 3],[-3 3])'};

