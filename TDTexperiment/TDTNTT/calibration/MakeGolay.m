function [ACode, BCode]=MakeGolay(N)
%MakeGolay -- Generate Golay codes A and B with order N
%By SF, 07/19/2001
%Usage: [ACode, BCode]=MakeGolay(N)

myA=[1 1];
myB=[1 -1];

ACode=myA;
BCode=myB;
for i=2:N
   ACode=[myA myB];
   BCode=[myA -myB];
   myA=ACode;
   myB=BCode;
end
