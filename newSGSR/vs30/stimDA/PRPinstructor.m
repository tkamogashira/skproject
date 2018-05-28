function ins=PRPinstructor(SD);
if isfield(SD.PRP, 'Instructor'),
   ins = SD.PRP.Instructor;
else, % default instr
   ins = 'defPRPinstructor';
end
