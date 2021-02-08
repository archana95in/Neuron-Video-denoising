%% Define Write 3 Grayscale Videos Function
% Inputs:
%   videos: an array of videos 
%       each video is an array of grayscale images(intensities: [0-255])
%   filename: name of file(should end in ".avi")
%   frame_rate: desired frame rate (in frames per second)
%
% NOTE: all videos should be of the same dimensions and have the 
% same number of frames

function writeMultipleGrayscaleVideos(videos, filename, frame_rate)
    v = VideoWriter(filename, 'Grayscale AVI');
    v.FrameRate = frame_rate; %match frameRate of original video
    open(v);
    
    [num_frames,frame_height,frame_width, num_videos] = size(videos);
    
    %initialize blank video with borders
    border_color = 255; %set border color to white
    border_thickness = 10;
    combinedHeight = frame_height+(2*border_thickness);
    combinedWidth = (num_videos*frame_width)+(1+num_videos)*(border_thickness);
    combinedVideo = uint8(zeros(num_frames, combinedHeight, combinedWidth));
    combinedVideo(:,1:border_thickness,:) = border_color; %add top border
    combinedVideo(:,frame_height+border_thickness+1:combinedHeight,:) = border_color; %add bottom border
    
    
    for frame = 1:num_frames
        combinedVideo(frame,border_thickness + 1:frame_height+10,1:border_thickness) = border_color; %add left border
        
        %add videos and inner frames
        for vidNum = 1:num_videos
            %add frame of video
            combinedVideo(frame,border_thickness + 1:border_thickness+frame_height,border_thickness+(vidNum-1)*(border_thickness+frame_width) + 1:border_thickness+(vidNum-1)*(border_thickness+frame_width) + frame_width) = squeeze(videos(frame,:,:,vidNum));
            
            %add border to the right of the frame
            combinedVideo(frame,border_thickness + 1:border_thickness+frame_height,border_thickness+(vidNum-1)*(border_thickness+frame_width) + frame_width + 1:border_thickness+(vidNum-1)*(border_thickness+frame_width) + frame_width + border_thickness) = border_color;
        end
        %combinedVideo(frame,border_width + 1:frame_height+10,combinedWidth-border_width:combinedWidth) = border_color; %add right border
        writeVideo(v, mat2gray(squeeze(combinedVideo(frame,:,:))));
        fprintf("Rendered Frame: %i of %s\t%d%% complete\n", frame, filename, uint8((frame/num_frames) * 100));
    end
    
    clc; %clear terminal

    %close video
    close(v);
end