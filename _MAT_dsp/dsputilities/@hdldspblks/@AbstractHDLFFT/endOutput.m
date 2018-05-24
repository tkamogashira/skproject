function [endOutS] = endOutput(useMemData)

persistent useMemData_1dly endDetect_dly1 endDetect_dly2 endDetect_dly3 endDetect_dly4 endDetect_dly5 endDetect_dly6 endDetect_dly7
if isempty(useMemData_1dly)
    useMemData_1dly = false;
    endDetect_dly1  = false;
    endDetect_dly2  = false;
    endDetect_dly3  = false;
    endDetect_dly4  = false;
    endDetect_dly5  = false;
    endDetect_dly6  = false;
    endDetect_dly7  = false;
end

endDetect = useMemData_1dly && ( ~ useMemData);
useMemData_1dly  = useMemData;

endOutS = endDetect_dly7;
endDetect_dly7 = endDetect_dly6;
endDetect_dly6 = endDetect_dly5;
endDetect_dly5 = endDetect_dly4;
endDetect_dly4 = endDetect_dly3;
endDetect_dly3 = endDetect_dly2;
endDetect_dly2 = endDetect_dly1;
endDetect_dly1 = endDetect;
