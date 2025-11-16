clc; clear; close all;
img = imread('handwriting_detect.jpg');
if size(img,3) == 3
    gray = rgb2gray(img);
else
    gray = img;
end
figure; imshow(gray); title('1. Grayscale Image');
filtered = medfilt2(gray, [3 3]);
enhanced = imadjust(filtered, stretchlim(filtered, [0.01 0.99]), []);
bw = imbinarize(enhanced, 'adaptive', ...
                'ForegroundPolarity', 'dark', ...
                'Sensitivity', 0.3);
bw = ~bw;
bw_clean = bwareaopen(bw, 60);
se = strel('rectangle', [2 2]);
bw_clean = imclose(bw_clean, se);
bw_clean = imfill(bw_clean, 'holes');
figure; imshow(bw_clean); title('2. Cleaned Binary Image');
stats = regionprops(bw_clean, 'BoundingBox', 'Area', 'Centroid');
valid_idx = [];
for k = 1:length(stats)
    bbox = stats(k).BoundingBox;
    aspect_ratio = bbox(3) / bbox(4);
    A = stats(k).Area;
    if (A > 50 && A < 2000) && (aspect_ratio > 0.1 && aspect_ratio < 1.5)
        valid_idx = [valid_idx k];
    end
end
filtered_stats = stats(valid_idx);
num_chars = length(filtered_stats);
disp(['Detected characters after filtering: ' num2str(num_chars)]);
figure; imshow(img); hold on;
title('3. Detected Individual Characters (For Debug)');
for k = 1:num_chars
    rectangle('Position', filtered_stats(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 1.5);
end
hold off;
if isempty(filtered_stats)
    disp('No characters detected. Skipping word segmentation.');
    return;
end
bboxes = vertcat(filtered_stats.BoundingBox);
bboxes = sortrows(bboxes,[2 1]);
yCenters = bboxes(:,2) + bboxes(:,4)/2;
lineGap = median(bboxes(:,4)) * 1.5;
lines = {};
currentLine = bboxes(1,:);
for i = 2:size(bboxes,1)
    if abs(yCenters(i) - yCenters(i-1)) > lineGap
        lines{end+1} = currentLine;
        currentLine = bboxes(i,:);
    else
        currentLine = [currentLine; bboxes(i,:)];
    end
end
lines{end+1} = currentLine;
figure; imshow(img); title('4. Output 1: Detected Word Regions'); hold on;
wordCount = 0;
extractedWordCrops = {};
for l = 1:length(lines)
    lineBoxes = sortrows(lines{l},1);
    avgWidth = mean(lineBoxes(:,3));
    wordGap = avgWidth * 0.5
    currentWord = lineBoxes(1,:);
    for i = 2:size(lineBoxes,1)
        prevBox = currentWord(end,:);
        gap = lineBoxes(i,1) - (prevBox(1) + prevBox(3));
        if gap > wordGap
            wordCount = wordCount + 1;
            minX = min(currentWord(:,1));
            minY = min(currentWord(:,2));
            maxX = max(currentWord(:,1)+currentWord(:,3));
            maxY = max(currentWord(:,2)+currentWord(:,4));
            rectangle('Position',[minX,minY,maxX-minX,maxY-minY],'EdgeColor','g','LineWidth',2);
            wordCrop = imcrop(gray,[minX, minY, maxX-minX, maxY-minX]);
            extractedWordCrops{end+1} = wordCrop;
            currentWord = lineBoxes(i,:);
        else
            currentWord = [currentWord; lineBoxes(i,:)];
        end
    end
    wordCount = wordCount + 1;
    minX = min(currentWord(:,1));
    minY = min(currentWord(:,2));
    maxX = max(currentWord(:,1)+currentWord(:,3));
    maxY = max(currentWord(:,2)+currentWord(:,4));
    rectangle('Position',[minX,minY,maxX-minX,maxY-minY],'EdgeColor','g','LineWidth',2);
    wordCrop = imcrop(gray,[minX, minY, maxX-minX, maxY-minY]);
    extractedWordCrops{end+1} = wordCrop;
end
hold off;
disp(['Word detection complete. Total words found: ', num2str(wordCount)]);
if isempty(extractedWordCrops)
    disp('No word crops were generated in Step 7. Cannot create Output 2.');
    return;
end
targetHeight = 100;
wordImagesPadded = {};
for w = 1:length(extractedWordCrops)
    wc = extractedWordCrops{w};
    if size(wc,3) == 3
        wc = rgb2gray(wc);
    end
    scale = targetHeight / size(wc,1);
    wc_resized = imresize(wc, scale);
    current_h = size(wc_resized, 1);
    if current_h > targetHeight
        wc_resized = wc_resized(1:targetHeight, :);
    elseif current_h < targetHeight
        wc_resized = padarray(wc_resized, [targetHeight - current_h, 0], 255, 'post');
    end
    paddingWidth = 10;
    [h, w_r] = size(wc_resized);
    paddedWord = 255 * ones(h, w_r + paddingWidth, 'uint8');
    paddedWord(:, 1:w_r) = wc_resized;
    wordImagesPadded{end+1} = paddedWord;
end
finalExtractedText = horzcat(wordImagesPadded{:});
figure;
imshow(finalExtractedText);
title('5. Output 2: Extracted Words Lined Up');
