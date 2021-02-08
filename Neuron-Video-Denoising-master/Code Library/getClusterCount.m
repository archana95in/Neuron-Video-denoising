%% Define Get Cluster Count
% Inputs:
%       start_row: the starting row
%       start_col: the starting column
%       countMatrix: the countMatrix
%       visited_in: the input visited matrix
% Return:
%       visited_out: the output visited matrix
%       clusterCount: the number of firing events for this cluster


function [visited_out, clusterCount] = getClusterCount(start_row, start_col, countMatrix, visited_in)    
    %declare local variables
    q = java.util.LinkedList;
    visited_out = visited_in;
    clusterCount = 0;
    
    %add start pixel to queue
    q.add([start_row; start_col]);
    
    %as long as there are pixels in the cluster to be processed
    while ~q.isEmpty()
        targetPixel = q.remove();    %remove next value from queue
        if countMatrix(targetPixel(1), targetPixel(2)) > clusterCount
            clusterCount = countMatrix(targetPixel(1), targetPixel(2));
        end
        
        % call function to return indices of neighboring pixels
        validNeighbors = getValidNeighbors(targetPixel(1), targetPixel(2), countMatrix);
        
        [~, neighbors_width] = size(validNeighbors);
        for i = 1:neighbors_width
            % For unvisited neighboring pixels (in bounds), 
            % check if pixel is white (intensity > 0)
            neighbor_row = validNeighbors(1, i);
            neighbor_col = validNeighbors(2, i);
            
            if visited_out(neighbor_row,neighbor_col) == 0 %if unvisited
                %if unvisited and bright
                if countMatrix(neighbor_row, neighbor_col) > 0
                    q.add([neighbor_row; neighbor_col]);     %add to queue
                    visited_out(neighbor_row, neighbor_col) = 1;
                end
            end
        end
    end
end