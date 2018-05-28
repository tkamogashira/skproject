function [CF SR minTHR dummy Q10] =  getTHRforSeq(fileName, seq)
    [CF SR minTHR dummy Q10] = EvalTHR(dataset(fileName, seq), 'plot', 'no');
    