function curGroupCluster = syncCountMatrix(countMatrix, curGroupCluster, currentGroupNumber, prevGroupCluster)

 [height, width] = size(curGroupCluster);
 
 start_row = -1;
 start_col = -1;
 
 first_count = -1;
 
     %find count number in corresponding cluster of count matrix
    for row = 1:height
        for col = 1:width
            %if pixel is in the current group
            if curGroupCluster(row, col) == currentGroupNumber
                %if corresponding pixel in CountMatrix is greater than
                %count
                if countMatrix(row, col) > 0 
                    %detect multiple count values and revert to previous
                    %frame for these clusters
                    if first_count ~= -1
                        if countMatrix(row, col) ~= first_count
                            for row2 = 1:height
                                for col2 = 1:width
                                    if curGroupCluster(row2, col2) == currentGroupNumber
                                        if prevGroupCluster(row2, col2) > 0
                                            curGroupCluster(row2, col2) = currentGroupNumber;
                                        else
                                            curGroupCluster(row2, col2) = 0;
                                        end
                                    end
                                end
                            end
                            return;
                        end
                    end
                    %get one pixel in the count group
                    start_row = row;
                    start_col = col;
                    first_count = countMatrix(row, col);
                end
            end
        end
    end
    
    if(start_row ~= -1 && start_col ~= -1)
    
        %declare local variables
        q = java.util.LinkedList;
        visited = uint8(zeros(height, width));

        %add start pixel to queue
        q.add([start_row; start_col]);

        %as long as there are pixels in the cluster to be processed
        while ~q.isEmpty()
            targetPixel = q.remove();    %remove next value from queue

            % call function to return indices of neighboring pixels
            validNeighbors = getValidNeighbors(targetPixel(1), targetPixel(2), countMatrix);

            [~, neighbors_width] = size(validNeighbors);
            for i = 1:neighbors_width
                % For unvisited neighboring pixels (in bounds), 
                % check if pixel is white (intensity > 0)
                neighbor_row = validNeighbors(1, i);
                neighbor_col = validNeighbors(2, i);

                if visited(neighbor_row,neighbor_col) == 0 %if unvisited
                    %if unvisited and a count exists
                    if countMatrix(neighbor_row, neighbor_col) > 0
                        q.add([neighbor_row; neighbor_col]);     %add to queue
                        visited(neighbor_row, neighbor_col) = 1; %mark as visited

                        %mark pixel as being in the current group
                        curGroupCluster(neighbor_row, neighbor_col) = currentGroupNumber;
                    end
                end
            end
        end 
    end
end

                
    
   
 