%this takes in an ms file which was origional a bunch of smaller videos,
%and cuts them up back into individual ms files 

function [CUTms] =  cutVideo() 

    aviFiles = dir([pwd '\msCam*.avi']);
    % creating a structure for all the videos, this will hold the
    % number of frames per video
        ms_NONconcatenated = msGenerateVideoObj_Tori(pwd,'msCam');

    % extracting the number of frames per video into VidFrameCount
    NumOfVids = unique(ms_NONconcatenated.vidNum) ;     
    for VidNum = 1 : length(NumOfVids)  
      VidFrameCount(VidNum) = length(find(ms_NONconcatenated.vidNum == NumOfVids(VidNum)));
    end 
   
    % Taking the overall ms file from the concatenated video, and saving
    % variables into separate ms structure files for each video
    
    load('ms.mat'); 
    startCount = 1;    
    stopCount = ms_NONconcatenated.timestamp(1);
    
    
    for VidNum = 1 : length(ms_NONconcatenated.timestamp)
        if startCount == 1 
            start(VidNum) = startCount;
            stop(VidNum) = stopCount;   
            startCount = ms_NONconcatenated.timestamp(1)+startCount;
            stopCount = ms_NONconcatenated.timestamp(1)  + ms_NONconcatenated.timestamp(2);
            
        else 
            if VidNum == (length(ms_NONconcatenated.timestamp))
                stop(VidNum) = sum(ms_NONconcatenated.timestamp);   
                start(VidNum) = startCount;
            else 
                start(VidNum) = startCount;
                stop(VidNum) = stopCount ;         
                startCount = startCount +  ms_NONconcatenated.timestamp(VidNum);
                stopCount = stopCount + ms_NONconcatenated.timestamp(VidNum+1);  
            end             
        end                
    end 
    
    
    for VidNum = 1 : length(ms_NONconcatenated.timestamp)
        CUTms(VidNum).numFrames = VidFrameCount(VidNum);        
        CUTms(VidNum).frameNum = ms.frameNum(1,[start(VidNum) : stop(VidNum)]);
        CUTms(VidNum).FiltTraces = ms.FiltTraces([start(VidNum) : stop(VidNum)],:); 
        CUTms(VidNum).RawTraces = ms.RawTraces([start(VidNum) : stop(VidNum)],:);
        CUTms(VidNum).time = ms.time([start(VidNum) : stop(VidNum)],:);  
    end 
    
    
  %saving each ms file into the origional folders. 
    for msNum = 1: length(CUTms)       
       
       clear ms  %clearing ms from the workspace for everyloop 
       destdirectory = sprintf('%s\\Session%d',pwd,msNum);
       mkdir(destdirectory);   %create the directory for the new ms files         
       ms.numFrames = CUTms(msNum).numFrames; 
       ms.frameNum = CUTms(msNum).frameNum;
       ms.FiltTraces = CUTms(msNum).FiltTraces;
       ms.RawTraces = CUTms(msNum).RawTraces;
       ms.time = CUTms(msNum).time;   
       Folder = sprintf('%s\\ms.mat', destdirectory);       
       save(Folder,'ms');
    end 
    
end
