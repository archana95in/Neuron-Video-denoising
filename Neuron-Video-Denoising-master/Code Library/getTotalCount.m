%% Define Get Total Count
% Inputs:
%       countMatrix: the count matrix
% Return:
%       count: the total number of firings detected


function count = getTotalCount(countMatrix)

    [height, width] = size(countMatrix);
    
    %declare local variables
    visited = uint8(zeros(height, width));
    
    count = 0;
    
    for row = 1:height
        for col = 1:width
            %if unvisited
            if visited(row, col) == 0
                %if there is a count
                if countMatrix(row, col) > 0
                    [visited, tempCount] = getClusterCount(row, col, countMatrix, visited);
                    count = count + tempCount;
                end
            end
        end
    end
end