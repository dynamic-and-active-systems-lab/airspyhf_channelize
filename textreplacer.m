%This script recreates the 'airspyhfchannelizeTEMPLATE.m' functions for all
%the different decimation factors. It first copies the template with a new
%file name that includes the decimation factor. It then opens that file and
%replaces all of the **NUMBEROFCHANNELS** string with the decimation
%factor. It then saves the file. 

templateFile = 'airspyhfchannelizeTEMPLATE.m';
%decimationFactors = [2; 3; 4; 5; 6; 8; 10; 12; 15; 16; 19; 20; 24; 25; 30; 32; 38; 40; 48; 50; 57; 60; 64; 75; 76; 80; 95; 96; 100; 114; 120; 125; 128; 150; 152; 160; 190; 192; 200; 228; 240; 250; 256];
decimationFactors = [2; 4; 10; 12; 16; 24; 32; 48; 64; 80; 96; 100; 120; 128; 192; 256]



for i = 1:numel(decimationFactors)
    currDecFact = decimationFactors(i);
    newFileName = [templateFile(1:18),num2str(currDecFact),'.m']
    copyfile(templateFile,newFileName)
        
    strToFind = '**NUMBEROFCHANNELS**';
    strToReplace = num2str(currDecFact);
    
    text         = fileread(newFileName);
    textModified = strrep(text, strToFind, strToReplace);

    fid  = fopen(newFileName,'w');
    fprintf(fid,'%s', textModified);
    fclose(fid);

end