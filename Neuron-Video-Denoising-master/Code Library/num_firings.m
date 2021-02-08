
%% Function to count the number of firings for each neuron

function [countMatrix] = num_firings(binary_video)
%% Initialize Okay to Merge to 0
[num_frames,height,width] = size(binary_video);

countMatrix = uint8(zeros(height, width));
prevGroupCluster = uint8(zeros(height, width));
ok_to_merge = uint8(zeros(height, width));
curGroupCluster = uint8(zeros(height, width));
for frame = 1: num_frames    
    groupNumber = 1; %start counting each frame with group #1
    visited = uint8(zeros(height, width));
    for row = 1: height 
        for col = 1:width
            if visited(row,col) == 0 %% if unvisted
                if binary_video(frame,row,col) > 0 %% if in a group
                    
                    
                    %update curGroupCluster for this group number
                    [curGroupCluster, visited] = ...
                        getGroupCluster(binary_video, frame, row, col, visited, curGroupCluster, groupNumber);
                    
                    [allDark, oneGroup] = analyzeCluster(prevGroupCluster, ...
                    curGroupCluster, row, col, frame);
                
                    %grow the size of the neuron in countMatrix
                    if oneGroup == 1 && ok_to_merge(row,col) > 0
                        curGroupCluster = syncCountMatrix(countMatrix, curGroupCluster, groupNumber, prevGroupCluster);
                    end
                
                
                    if allDark
                        countMatrix = increment(countMatrix, curGroupCluster, groupNumber);
                    end
                    
                    %update ok_to_merge            
                    for i = 1:height
                        for j = 1:width
                        	if curGroupCluster(i, j) == groupNumber
                                %if not one group, NOT ok to merge
                                if oneGroup == 0 && allDark == false
                                    ok_to_merge(i, j) = 0;
                                %if allDark and oneGroup is true
                                elseif allDark == true
                                    ok_to_merge(i, j) = 1;
                                end
                            end
                        end
                    end
                    
                    %increment group number
                    groupNumber = groupNumber + 1;
                    
                end
            end
        end  
    end
    %set current cluster to previous
    prevGroupCluster = curGroupCluster ;
    
    %reset current group cluster
    curGroupCluster = uint8(zeros(height, width));
    
    %print progress
    fprintf("Counted Neurons up to frame %i\n", frame);
end
                
     
 
    

                
     
 
    
