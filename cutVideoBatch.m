function [CUTms] =  cutVideoBatch() 

    aviFiles = dir(fullfile(pwd, '**', 'msCam*.avi'));
    % creating a structure for all the videos, this will hold the
    % number of frames per video
        ms_NONconcatenated = get_videoData(pwd,'msCam'); 
        load('ms.mat');
         
    % extracting the number of frames per video into VidFrameCount
    NumOfVids = unique(ms_NONconcatenated.vidNum) ;     
    for VidNum = 1 : length(NumOfVids)  
      VidFrameCount(VidNum) = length(find(ms_NONconcatenated.vidNum == NumOfVids(VidNum)));
    end 
   
    % Taking the overall ms file from the concatenated video, and saving
    % variables into separate ms structure files for each video
    
    load('ms.mat'); 
    startCount = 1;    
    stopCount = VidFrameCount(1);
    startCount1 = 1;
    stopCount1 = ms_NONconcatenated.timestamps(1,1);
    
    for VidNum1 = 1: length(ms_NONconcatenated.timestamps)% VidNum = 1 : length(NumOfVids)
        if startCount1 == 1  
            start1(VidNum1) = startCount1;
            stop1(VidNum1) =  stopCount1;
            startCount1 = ms_NONconcatenated.timestamps(1,1) + startCount1;
            stopCount1 = ms_NONconcatenated.timestamps(1,1)  + ms_NONconcatenated.timestamps(2,1);
            
        else 
            if  VidNum1 == (length(ms_NONconcatenated.timestamps))
                stop1(VidNum1) = sum(ms_NONconcatenated.timestamps);
                start1(VidNum1) =  startCount1; 
            else 
                 start1(VidNum1) = startCount1;
                 stop1(VidNum1) = stopCount1; 
                 startCount1 = startCount1 +  ms_NONconcatenated.timestamps(VidNum1,1);
                 stopCount1 = stopCount1 + ms_NONconcatenated.timestamps(VidNum1+1,1);
            end             
        end                
    end 
    
    
    for VidNum =1: length(ms_NONconcatenated.timestamps) %VidNum = 1 : length(NumOfVids) %length(ms_NONconcatenated.timestamps)
        CUTms(VidNum).frameNum = ms.frameNum(1,[start1(VidNum) : stop1(VidNum)]);
        CUTms(VidNum).FiltTraces = ms.FiltTraces([start1(VidNum) : stop1(VidNum)],:); 
        CUTms(VidNum).RawTraces = ms.RawTraces([start1(VidNum) : stop1(VidNum)],:);
        CUTms(VidNum).time = ms.time([start1(VidNum) : stop1(VidNum)],:);         
        CUTms(VidNum).numFiles = ms.numFiles; 
        CUTms(VidNum).maxFramesPerFiles = ms.maxFramesPerFile; 
        CUTms(VidNum).height = ms.height; 
        CUTms(VidNum).width = ms.width; 
        CUTms(VidNum).maxBufferUsed = ms.maxBufferUsed; 
        CUTms(VidNum).dateNum = ms.dateNum; 
        CUTms(VidNum).analysis_time = ms.analysis_time; 
        CUTms(VidNum).ds = ms.ds; 
        CUTms(VidNum).camNumber = ms.camNumber; 
        CUTms(VidNum).vidObj = ms.vidObj; 
    end 
    
    count = ms_NONconcatenated.sessionCount(1)+1; 
    begin =1; 
    
      for i = 1: length(ms_NONconcatenated.timestamps) 
            CUTms(i).vidObj(count:end) = []; 
          if i>1
            CUTms(i).vidObj(begin: count-ms_NONconcatenated.sessionCount(i)-1) = [];    
          end
          
          if i~=length(ms_NONconcatenated.timestamps) 
             count = count +  ms_NONconcatenated.sessionCount(i+1); 
          end 
      end 
    
        
current_path = cd; 
folderNames = dir; 
folderNames(1) = []; 
folderNames(1) = []; 
count =1; 
 for nameNum=1: length(folderNames)
    if folderNames(count).bytes > 0
        folderNames(count) = [];
        count = count-1;
    end 
    count = count+1;
 end  
 maxTime = 0;
 count =1;   
  %saving each ms file into the origional folders. 
    for msNum = 1: length(ms_NONconcatenated.FolderNames)       
       cd(ms_NONconcatenated.datFiles(msNum).folder); 
       if ~isempty(dir(['msCam*']))
           clear ms  %clearing ms from the workspace for everyloop  
           ms.numNeurons = length(CUTms(count).FiltTraces(1,:)); 
           ms.numFrames = length(CUTms(count).frameNum); 
           ms.frameNum = CUTms(count).frameNum;
           ms.FiltTraces = CUTms(count).FiltTraces;
           ms.RawTraces = CUTms(count).RawTraces;
           ms.numFiles = CUTms.numFiles; 
           ms.maxFramesPerFiles = CUTms.maxFramesPerFiles;
           ms.height = CUTms.height; 
           ms.width = CUTms.width;
           ms.maxBufferUsed = CUTms.maxBufferUsed;
           ms.dateNum = CUTms.dateNum; 
           ms.analysis_time = CUTms.analysis_time; 
           ms.ds = CUTms.ds; 
           ms.camNumber = CUTms.camNumber; 
           ms.vidObj = CUTms(msNum).vidObj;  

           
           ms.time = ms_NONconcatenated.timePerTimestamp{1,count};
           if ms.time(1,1) < 0 || ms.time(1,1) > 1000
               ms.time(1,1) = 0; 
           end 
       save('ms');
       count = count +1; 
       end 
       cd(current_path)
    end 
    
end
