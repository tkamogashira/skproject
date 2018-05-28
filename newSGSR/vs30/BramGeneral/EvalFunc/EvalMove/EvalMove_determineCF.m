function CF = EvalMove_determineCF(ParamCF, ThrCF, DifDF, SacDF)

if isnumeric(ParamCF)
    if ~isnan(ParamCF)
        CF = ParamCF;
    elseif ~isnan(ThrCF)
        CF = ThrCF;
    elseif ~isnan(DifDF)
        CF = DifDF;
    else
        CF = SacDF;
    end
elseif strcmpi(ParamCF, 'cf')
    CF = ThrCF;
elseif strcmpi(ParamCF, 'df')
    if ~isnan(DifDF)
        CF = DifDF;
    else
        CF = SacDF;
    end
else
    CF = NaN;
end
