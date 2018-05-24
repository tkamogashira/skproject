function [startOutS] = startOutput(useDlyData_1)

persistent useDlyData_1dly startDetect_dly1 startDetect_dly2 startDetect_dly3 startDetect_dly4

if isempty(useDlyData_1dly)
    useDlyData_1dly = false;
    startDetect_dly1= false;
    startDetect_dly2= false;
    startDetect_dly3= false;
    startDetect_dly4= false;
end

startDetect = useDlyData_1dly && ( ~ useDlyData_1);
useDlyData_1dly  = useDlyData_1;

startOutS = startDetect_dly4;
startDetect_dly4 = startDetect_dly3;
startDetect_dly3 = startDetect_dly2;
startDetect_dly2 = startDetect_dly1;
startDetect_dly1 = startDetect;
