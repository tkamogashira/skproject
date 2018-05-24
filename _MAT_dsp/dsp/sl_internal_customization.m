function sl_internal_customization( cm )

% Copyright 2010-2012 The MathWorks, Inc.

    if  loc_TestInstallation
        
        cm.addSigScopeMgrViewerLibrary('dspviewers');
        cm.addSigScopeMgrGeneratorLibrary( 'dspgenerators' );
    end

end

function res = loc_TestInstallation
    res = ~isempty( ver( 'dsp' ) ) && loc_TestLicense;
end

function res = loc_TestLicense
    res = license( 'test', 'Signal_Blocks' );
end
