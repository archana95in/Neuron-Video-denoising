%% Define Read AVI File Function
% Inputs:
%   filename: name of file(should end in ".avi")
%   num_frames: total number of frames in the video file
%   height: height of the video (in pixels)
%   width: width of the video (in pixels)

function video = readAVIFile(filename, num_frames, height, width)
    v = VideoReader(filename);

    video = uint8(zeros(num_frames,height,width));
    i = 1;

    while hasFrame(v)
        frame = readFrame(v); 
        frame = frame(:,:,1);
        video(i,:,:) = uint8(frame);
        i = i+1;
    end
end