    function [ret_visited, isNeuron] = processNeuron(row_val,col_val,NeuronNum,im,visited, threshold)
    %% Define queue
    q = java.util.LinkedList;
    [height, width] = size(im);
    clusterArea = 1;
    
    q.add([row_val; col_val]);          % add input pixel to queue
    cluster = zeros(height, width); % initialize all values as unvisited
    cluster(row_val, col_val) = 1;      % marking input pixel as visited
    
    %as long as there are pixels in the cluster to be processed
    while ~q.isEmpty()
        targetPixel = q.remove();    %remove next value from queue
        clusterArea = clusterArea+1; %increment cluster area
        %% call function to return indices of neighboring pixels
        validNeighbors = getValidNeighbors(targetPixel(1), targetPixel(2), im);
        [~, neighbors_width] = size(validNeighbors);
        for i = 1:neighbors_width
            %% For unvisited neighboring pixels (in bounds), check if intensity is greater than threshold and assign 1 if true
            neighbor_row = validNeighbors(1, i);
            neighbor_col = validNeighbors(2, i);
            
            if cluster(neighbor_row,neighbor_col) == 0 %if unvisited
                %if unvisited and bright
                if im(neighbor_row, neighbor_col)> threshold 
                    q.add([neighbor_row; neighbor_col]);     %add to queue
                    cluster(neighbor_row, neighbor_col) = 1; %mark as visited
                
                %if visited, assign -1(visited & dark) in visited matrix 
                else
                    visited(neighbor_row, neighbor_col) = -1;
                end
            end
        end
    end
    
    %if the cluster is of proper area, it is a neuron
    if (8 <= clusterArea) && (clusterArea <= 1256)
    	isNeuron = true;
        
    %otherwise, it is noise
    else
    	isNeuron = false;
    end
    
    %% For every pixel in the cluster matrix
    for r = 1:height
        for c = 1:width
            %if the cluster is of proper area
            if isNeuron
                %assign pixels of valid cluster values to value NeuronNum
                if cluster(r,c) == 1
                    visited(r,c) = NeuronNum;
                end
            
            %if invalid, assign -1(visited & dark) in visited matrix
            %this filters out noise of high intensity
            else
                visited(r,c) = -1;
            end
        end
    end    
    ret_visited = visited;
end