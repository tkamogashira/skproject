function isHigh = highVersion()

isHigh = (char2num(version('-release')) > 13);