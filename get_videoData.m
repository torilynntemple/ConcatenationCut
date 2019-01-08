function ms = get_videoData(dirName, filePrefix)
%Organizes and spits out info and video files corresponding to "filePrefix" for further processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   This function will read through all files inside the folder/directory
%   marked as "dirName". It will find all wanted .avi videofiles with a
%   specific name defined as "filePrefix", organize them via time stamp,
%   create a list of video objects of each .avi file and record frame
%   number, frame index and file # index. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modified by Émmanuel Wilson and Tori

%     MAXFRAMESPERFILE = 1000; %This is set in the miniscope control software
%     ms.dirName = dirName;
%     % find avi and dat files
%     
%     aviFiles = dir(fullfile(dirName, '**', 'msCam*.avi')); %looks at whats inside this directory to see files
%     datFiles = dir(fullfile(dirName, '**', 'timestamp*.dat'));    
%     
%     % need to make folder save the locations of the avi files
%     %now we need to rename these so that these files are access correctly: 
    current_path = cd; 
    folderName = dir; 
    count = 1; 
%     [~,index] = sort([aviFiles.datenum],'ascend');
    %gets the names of all the folder names in the directory       
            folderName(1) = []; 
            folderName(1) = [];
    
%     for i =1: (length(aviFiles) + length(datFiles))           
%         if i > length(aviFiles)
%             folder(i) = datFiles(i-length(aviFiles)); 
%         else
%             folder(i) = aviFiles(index(count)); 
%             count = count+1;
%         end
%     end 

    MAXFRAMESPERFILE = 1000; %This is set in the miniscope control software
    ms.dirName = dirName;
    % find avi and dat files    
    if ~isempty(strfind(filePrefix,'msCam'))
        aviFiles = dir(fullfile(dirName, '**', 'msCam*.avi')); %looks at whats inside this directory to see files
    elseif ~isempty(strfind(filePrefix,'behavCam'))
        aviFiles = dir(fullfile(dirName, '**', 'behavCam*.avi')); %looks at whats inside this directory to see files
    end 
    
    datFiles = dir(fullfile(dirName, '**', 'timestamp*.dat'));    
    
    %we need to sort the aviFiles and the datFiles such that they are in
    %the order that matches the current folder: 
    timeLocation = strfind(datFiles(1).folder,'\H');
    s = strings(length(datFiles),1);
    folderNames = strings(length(datFiles),1);
    for folderNum = 1 : length(datFiles)        
        folderNames(folderNum,1)  = datFiles(folderNum).folder ; 
        m =folderNames{folderNum}(timeLocation+1:end); 
        s(folderNum,1) = m; 
    end 
    
    for num =1: length(datFiles)
        order{1,num} = sscanf(s(num,1),'H%d_M%d_S%d*');
    end 
    
      %this next chunck takes the order variable which has the hours,
      %minutes, and seconds saved, and create a new array with the format
      %of hours, minutes, seconds saved in a single array, in a format the
      %computer can properly read and sort. 
      orderTime = strings(length(datFiles),1);
      for num = 1: length(orderTime)
          %001
          if nnz(isstrprop(num2str(order{1,num}(1)),'digit')) > 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) > 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit'))== 1 
              orderTime(num,1) = sprintf('%d:%d:0%d',order{1,num}(1),order{1,num}(2),order{1,num}(3));
         %010    
          elseif nnz(isstrprop(num2str(order{1,num}(1)),'digit')) > 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) == 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit')) > 1 
              orderTime(num,1) = sprintf('%d:0%d:%d',order{1,num}(1),order{1,num}(2),order{1,num}(3)); 
          %011    
          elseif nnz(isstrprop(num2str(order{1,num}(1)),'digit')) > 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) == 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit')) == 1 
              orderTime(num,1) = sprintf('%d:0%d:0%d',order{1,num}(1),order{1,num}(2),order{1,num}(3));              
          %100    
          elseif nnz(isstrprop(num2str(order{1,num}(1)),'digit')) == 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) > 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit')) > 1 
              orderTime(num,1) = sprintf('0%d:%d:%d',order{1,num}(1),order{1,num}(2),order{1,num}(3));
           %101    
          elseif nnz(isstrprop(num2str(order{1,num}(1)),'digit')) == 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) > 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit'))== 1 
              orderTime(num,1) = sprintf('0%d:%d:0%d',order{1,num}(1),order{1,num}(2),order{1,num}(3)); 
          %110    
          elseif nnz(isstrprop(num2str(order{1,num}(1)),'digit')) == 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) == 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit')) > 1  
              orderTime(num,1) = sprintf('0%d:0%d:%d',order{1,num}(1),order{1,num}(2),order{1,num}(3));              
          %111   
          elseif nnz(isstrprop(num2str(order{1,num}(1)),'digit')) == 1 && nnz(isstrprop(num2str(order{1,num}(2)),'digit')) == 1  && nnz(isstrprop(num2str(order{1,num}(3)),'digit')) == 1 
              orderTime(num,1) = sprintf('0%d:0%d:0%d',order{1,num}(1),order{1,num}(2),order{1,num}(3));
          %000    
          else 
              orderTime(num,1) = sprintf('%d:%d:%d',order{1,num}(1),order{1,num}(2),order{1,num}(3)); 
      end 
      end      
     
     % now rearranging the original datFiles and aviFiles: 
     [~,idxFolder] = sort(orderTime);
     for num =1: length(datFiles)
         new_datFiles(num) =  datFiles(idxFolder(num)); 
         new_folderNames(num) = folderNames(idxFolder(num)); 
         new_s(num) = s(idxFolder(num)); 
     end 
     datFiles = new_datFiles; 
     folderNames = new_folderNames'; 
     s = new_s; 
     
     aviFolders = strings(length(aviFiles),1);
     for num =1 : length(aviFiles)
         aviFolders(num) = aviFiles(num).folder; %we can index easier this way 
     end 
     
     
     for num =1: length(folderNames)
        idx_aviFiles = find(aviFolders == folderNames(num)); 
        if num == 1 
            new_aviFiles = aviFiles(idx_aviFiles); 
        else
            new_aviFiles = [new_aviFiles; aviFiles(idx_aviFiles)];
        end 
     end 
       aviFiles = new_aviFiles; 
    
       
       %if the one before it is more than 1 away and not a 1, then move. 
       for videoNum =1: length(aviFiles)
        if ~isempty(strfind(filePrefix,'msCam'))
            videoOrder(videoNum) = sscanf(aviFiles(videoNum).name,'msCam%d.avi');
        elseif ~isempty(strfind(filePrefix,'behavCam'))
            videoOrder(videoNum) = sscanf(aviFiles(videoNum).name,'behavCam%d.avi');
        end           
       end
       videoOrder = videoOrder'; 
       
        for num =1 : length(aviFiles)
         aviFolders(num) = aviFiles(num).folder; %we can index easier this way 
        end 
     
       for num = 1: length(folderNames)
              location = strfind(aviFolders, folderNames(num)); %find the folder we are looking at 
              idx_location = find(~cellfun(@isempty,location)); %the index of the videos in that folder              
              videos = aviFiles(idx_location);  %save them in a separate array to sort and put back into aviFiles
              videos_idx = videoOrder(idx_location);
              
              [~,idxmatr] = sort(videos_idx); %sort the videos with their saved index
              videos = videos(idxmatr); %with their saved index reorder "videos"
              
              %Now placing them back into aviFiles:              
              aviFiles = [aviFiles(1:idx_location(1)-1);    videos;    aviFiles(idx_location(end)+1:end)];              
       end    
       
% need to make folder save the locations of the avi files
    %now we need to rename these so that these files are access correctly: 
    for i =1: (length(aviFiles) +length(datFiles))  
        if i > length(aviFiles)
            folder(i) = datFiles(i-length(aviFiles)); 
        else
            folder(i) = aviFiles(i); 
        end 
    end 

    ms.FolderNames = folderNames; 
    ms.s=s;
    ms.datFiles = datFiles; 
    %------------------------------------------
    Scount = 1; 
    session = 1; 
    for i = 2: length(folder)-1
        s1 = folder(i).folder; 
        s2 = folder(i-1).folder; 
       if strcmp(s1,s2) == 0
           Scount = 1;
           session = session +1; 
       else
           Scount = Scount +1; 
       end 
       
       if strfind(folder(i).name,'avi') >0
          ms.sessionCount(session) = Scount;  
       end       
    end 
    
    count = 1; 
    numFolderstemp = length(folderName); 
        for folderNum = 1: numFolderstemp
           if folderName(count).bytes> 0 
               folderName(count) = []; 
               count = count - 1; 
           end
            count = count+1; 
        end 
    %rename the names of the timestamps: 
    count = 1; 
    for i =1:length(datFiles)
        cd(folderName(i).name);
        if i<10
            tempNames(i).name = sprintf('timestamp0%d.dat', count);
        else
            tempNames(i).name = sprintf('timestamp%d.dat', count);
        end
        if strcmp(dir, 'timestamp*') 
                movefile(datFiles(i).name,tempNames(count).name); 
                count = count+1; 
        end 
        cd (current_path);
    end 
    
    
    ms.numFiles = 0;        %Number of relevant .avi files in the folder
    ms.numFrames = 0;       %Number of frames within said videos
    ms.vidNum = [];         %Video index
    ms.frameNum = [];       %Frame number index
    ms.maxFramesPerFile = MAXFRAMESPERFILE; %finds the maximum number of frames contained in a single throughout all videos
    ms.dffframe = [];
    
    %find the total number of relevant video files
    ms.numFiles = length(aviFiles); 

    
    Timestampmin = 1000000;     %Arbitrary VERY large number for min value storage, must be larger than datenum stamp in folder
    Timestamp = 0;              %Total number of frames observed (including previous video itterations)
    o = NaN(1,ms.numFiles);     %index movie file order
    anomilynames = NaN(1,4);
    count = 0;
    

    o = nan(1,length(folder));
    stamps = zeros(1,length(folder));
    j = 1;
    k =1;
    for i = 1:length(folder)
        if ~folder(i).isdir && ~isempty(strfind(folder(i).name,filePrefix))
            o(i) = k;
            k = k+1;
        elseif ~folder(i).isdir && ~isempty(strfind(folder(i).name,'timestamp'))
            stamps(i) = j;
            j=j+1;
        end
    end
    [a b] = sort(o);
    folder = folder(b);
    o = o(b);
    [a b] = sort(stamps);
    folder = folder(b);
    stamps = stamps(b);
    
    %generate a vidObj for each video file. Also calculate total frames
    for i=1:ms.numFiles
        j = o(1,i);                                                     %call on .avi files chronologically   
        ms.vidObj{i} = VideoReader([folder(j).folder filesep folder(j).name]);                     %Read .avi video file
        ms.vidNum = [ms.vidNum i*ones(1,ms.vidObj{i}.NumberOfFrames)];  %Store video index into ms for future use outside this fn
        ms.frameNum = [ms.frameNum 1:ms.vidObj{i}.NumberOfFrames];      %Current frame # in total
        ms.numFrames = ms.numFrames + ms.vidObj{i}.NumberOfFrames;      %Total number of frames
    end
    ms.height = ms.vidObj{1}.Height;        %video dimentions
    ms.width = ms.vidObj{1}.Width;
    
    camNum = [];
    frameNum = [];
    sysClock = [];
    buffer1 = [];
    frameTot1 = 0;
    frameTot0 = 0;
    %read timestamp information
    for i=1:length(datFiles)
        if strfind(datFiles(i).name,'timestamp')
            fileID = fopen(sprintf('%s\\%s',datFiles(i).folder,datFiles(i).name)); %looks for timestamp, but will not iterate through because it'll only accept the first timestamp           
            dataArray = textscan(fileID, '%f%f%f%f%[^\n\r]', 'Delimiter', '\t', 'EmptyValue' ,NaN,'HeaderLines' ,1, 'ReturnOnError', false);    %read file and make sure it is not empty
            camNumtemp = dataArray{:, 1};       %camera number
            A = unique(camNumtemp); 
            frameNumtemp = dataArray{:, 2}; 
            ms.timestamps(i,1) = max(frameNumtemp); 
            if i ==1
                frameTot = 0; 
                frameTot1 = 0;
                frameTot0 = 0; 
                sysClock = [];
                sysClock1 =[];
                sysClock0 =[];
                sysClocktemp1 =[];
                sysClocktemp0 =[];                
            end 
            
            if length(A) == 1
                idx = find(camNumtemp == A(1)); 
                frameNumtemp = dataArray{:, 2};     %frame number 
                camNum1 = frameNumtemp(idx);                          
                ms.timestamps(i,1) = max(dataArray{:, 2}); 
                ms.timestamps1(i,1) = max(frameNumtemp(idx, 1));
                ms.timestamps0(i,1) = max(frameNumtemp(idx, 1));
                sysClocktemp = dataArray{:, 3};     %system clock
                buffer1temp = dataArray{:, 4};      %buffer
                clearvars dataArray;  %clear variables from dataArray 
                cam1 = max(idx); 
                fclose(fileID);
                    if i == 1
                        camNum = camNumtemp ;
                        buffer1 = buffer1temp;
                        sysClock1 = sysClocktemp(idx);
                        sysClock0 = sysClocktemp(idx); 
                        sysClocktemp1 = sysClocktemp(cam1);
                        sysClocktemp0 = sysClocktemp(cam1);
                        time1{i} =  sysClocktemp(idx);
                        frameTot1 = frameTot1; 
                        frameTot0 = frameTot0;
                         time0{i} =  sysClocktemp(idx);
                         time1{i} =  sysClocktemp(idx);
                        
                    else
                        camNum = [camNum; camNumtemp] ;
                        frameNum = [frameNum; frameNumtemp];                       
                        buffer1 = [buffer1; buffer1temp];
                        sysClock1 = [sysClock1; (sysClocktemp(idx) + sysClocktemp1)]; %we dont yet add times together to get the end ms.time result. 
                        sysClock0 = [sysClock0; (sysClocktemp(idx) + sysClocktemp0)]; 
                        sysClocktemp1 = sysClocktemp(cam1) + sysClocktemp1;
                        sysClocktemp0 = sysClocktemp(cam1) + sysClocktemp0;
                        time1{i} =  sysClocktemp(idx);
                        time0{i} =  sysClocktemp(idx);
               
                    end
                       frameTot1 = frameTot1 + camNum1(length(camNum1));
                       frameTot0 = frameTot0 + camNum1(length(camNum1));
                
            else
                idx0 = find(camNumtemp == min(A));     
                idx1 = find(camNumtemp == max(A));  
                frameNumtemp = dataArray{:, 2};     %frame number                 
                camNum1 = frameNumtemp(idx1);
                camNum0 = frameNumtemp(idx0);            
                ms.timestamps1(i,1) = max(frameNumtemp(idx1, 1));
                ms.timestamps0(i,1) = max(frameNumtemp(idx0, 1));
                cam1 = max(idx1);                              
                cam0 = max(idx0);  
                
                sysClocktemp = dataArray{:, 3};     %system clock
                k = 1;
                 ms.timeMin1(i) = min(sysClocktemp(idx1));                 
                 ms.timeMin0(i) = min(sysClocktemp(idx0));
                 if ms.timeMin1(i) < -1000
                     out1 = sort(sysClocktemp(idx1));
                     ms.timeMin1(i) = out1(2); 
                 end 
                 if ms.timeMin0(i) < -1000
                     out0 = sort(sysClocktemp(idx0));
                     ms.timeMin0(i) = out0(2);
                 end 
                 
                 
                buffer1temp = dataArray{:, 4};      %buffer
                clearvars dataArray;            %clear variables from dataArray
                fclose(fileID);
                    if i == 1
                        camNum = camNumtemp ;                                
                        sysClock1 = sysClocktemp(idx1);                        
                        time1{i} =  sysClocktemp(idx1);                        
                        sysClock0 = sysClocktemp(idx0);
                        time0{i} =  sysClocktemp(idx0);                         
                        buffer1 = buffer1temp;
                        sysClocktemp1 = sysClocktemp(cam1);
                        sysClocktemp0 = sysClocktemp(cam0);
                        frameTot1 = frameTot;
                        frameTot0 = frameTot;
                    else
                        camNum = [camNum; camNumtemp] ;
                        frameNum = [frameNum; frameNumtemp];
                        buffer1 = [buffer1; buffer1temp];
                        sysClock1 = [sysClock1; (sysClocktemp(idx1)+ sysClocktemp1)];
                        sysClock0 = [sysClock0; (sysClocktemp(idx0)+ sysClocktemp0)];
                        sysClocktemp1 = sysClocktemp(cam1) + sysClocktemp1;
                        sysClocktemp0 = sysClocktemp(cam0) + sysClocktemp0;
                       
                        time1{i} =  sysClocktemp(idx1); 
                        time0{i} =  sysClocktemp(idx0);
                        
                       
                    end
                    frameTot1 = frameTot1 + camNum1(length(camNum1));
                    frameTot0 = frameTot0 + camNum0(length(camNum0)); 
            end              
        end
    end
    for j=max(camNum):-1:0   
        if (sum(camNum==j)~=0)
            if (frameTot1 == ms.numFrames) && (sum(camNum==j) == ms.numFrames)
                ms.camNumber = j;
                %ms.time = sysClock1(camNum == j);
                ms.time = sysClock1; 
                ms.time(1) = 0;
                ms.maxBufferUsed = max(buffer1(camNum==j));
                ms.timestamps = ms.timestamps1; 
                ms.timePerTimestamp = time1;
            elseif (frameTot0 == ms.numFrames) && (sum(camNum==j) == ms.numFrames)
                ms.camNumber = j;
                %ms.time = sysClock0(camNum == j);
                ms.time = sysClock0; 
                ms.time(1) = 0;
                ms.maxBufferUsed = max(buffer1(camNum==j));
                ms.timestamps = ms.timestamps0;
                ms.timePerTimestamp = time0;
            else
                display(['Problem matching up timestamps for ' dirName]);
            end
        end
    end

    idx = strfind(dirName, '_');
    idx2 = strfind(dirName,'\');
    if (length(idx) >= 4)
        ms.dateNum = datenum(str2double(dirName((idx(end-2)+1):(idx2(end)-1))), ... %year
            str2double(dirName((idx2(end-1)+1):(idx(end-3)-1))), ... %month
            str2double(dirName((idx(end-3)+1):(idx(end-2)-1))), ... %day
            str2double(dirName((idx2(end)+2):(idx(end-1)-1))), ...%hour
            str2double(dirName((idx(end-1)+2):(idx(end)-1))), ...%minute
            str2double(dirName((idx(end)+2):end)));%second
    end
end