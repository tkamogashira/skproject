function y=testSS1switching(instructions)

for icomm=instructions.', % column-wise assignment (see help for)
   s232('SS1select', icomm(1), icomm(2), icomm(3));
end;