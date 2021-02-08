function countMatrix = increment(countMatrix, curGroupCluster, currentGroupNumber)

 [height, width] = size(curGroupCluster);
 onlyOneCount = 1;
 first_count_val = 0;
    
    %find group number in corresponding cluster of previous frame
    for row = 1:height
        for col = 1:width
            %if pixel is in the current group
            if curGroupCluster(row, col) == currentGroupNumber
                %if corresponding pixel in CountMatrix is greater than
                %count
                if countMatrix(row, col) > 0
                    
                    %if no count val has been detected yet
                    if first_count_val == 0
                        first_count_val = countMatrix(row, col);
                    %otherwise, check if there are more than one count vals
                    %present
                    elseif curGroupCluster(row, col) ~= first_count_val
                        onlyOneCount = 0;
                    end
                end
            end
        end
    end
    
    %increment
    for row = 1:height
        for col = 1:width
            if curGroupCluster (row,col) == currentGroupNumber
                if onlyOneCount == 1 || first_count_val == 0
                    countMatrix(row,col)= first_count_val +1;
                else
                    countMatrix(row, col) = countMatrix(row, col) + 1;
                end
            end
        end
    end
end

                
    
   
 