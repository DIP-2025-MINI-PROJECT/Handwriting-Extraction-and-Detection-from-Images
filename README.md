# Handwriting-Extraction-and-Detection-from-Images
**PROJECT DESCRIPTION**

This project focuses on extracting handwritten text from images using a step-by-step image-processing pipeline in MATLAB. The system uses grayscale conversion, filtering, thresholding, and morphological operations to isolate and segment handwritten characters, even when the image has noise, poor lighting, or uneven handwriting. The extracted characters are currently sent to Tesseract for basic text recognition. In the next stage, we will integrate a trained deep-learning model to improve accuracy and make the handwriting recognition more reliable.

**SUMMARY**

Handwriting detection and recognition play a vital role in Digital Image Processing, enabling the automated extraction of handwritten content from documents, notes, and real-world images. This project implements a hybrid system that combines classical MATLAB-based image processing techniques—such as grayscale conversion, noise filtering, adaptive thresholding, morphological refinement, and connected-component analysis—to accurately segment handwritten characters and group them into words. Alongside this, a CNN trained on the EMNIST ByClass dataset (62 alphanumeric classes) with a validation accuracy of ~87–89% is prepared to act as the recognition module. While the current MATLAB pipeline reliably detects and segments handwritten text, integrating the trained CNN for complete end-to-end OCR functionality remains the next step.

**COURCE CONCEPT USED:**

1.Grayscale Conversion & Intensity Normalization

2.Noise Reduction (Median Filter) and contrast enhancement

3.Adaptive Thresholding

4.Morphological Operations

5.Connected Component Analysis

6.Character Filtering

7.Line and Word Segmentation Using Spatial Clustering

**ADDITIONAL CONCEPTS USED:**

MODEL TRAINING 

1.EMNIST-Based Character Recognition

2.Convolutional Neural Networks for Feature Extraction

3.Data Normalization & Preprocessing for Model Compatibility

**DATASET:**

https://www.tensorflow.org/datasets/catalog/emnist

**NOVELITY:**

1.Advanced Morphological Operations for Stroke Reconstruction:
The system uses morphology (gap closing, hole filling, noise removal) to repair broken handwriting strokes and strengthen thin characters, achieving clearer segmentation without training any neural networks.

2.Geometry-Based Character Selection Instead of ML Classification:
Characters are identified using simple geometric rules (area, aspect ratio), showing that accurate handwritten segmentation can be achieved.

**CONTRIBUTORS:**

1.  Vibha Gopinath (PES1UG23EC343)

2.  Vijayasree Rajesh(PES1UG23EC346)

3.  Spoorthi K Gaddi (PES1UG23EC305)

**OUTPUT:**

The project produces five key outputs - a grayscale image showing the cleaned version of the original input, a binary image where thresholding and morphological operations isolate the handwriting, a visualization of individual characters marked with red bounding boxes, a view of grouped word regions highlighted in green, and finally a display of extracted word crops aligned horizontally to show the segmented text.
Input image :

**REFERENCES:**

1. https://github.com/GMarzinotto/MATLAB-Handwriting
   
2. https://github.com/AbhishekRS4/Handwriting_Recognition

3. https://github.com/anandhkishan/Handwritten-Character-Recognition-using-CNN

**LIMITATIONS AND FUTURE WORK:**

- **Character Segmentation Sensitivity:** The area/aspect-ratio filtering and spacing-based grouping may incorrectly remove or merge characters when handwriting is irregular.

- **Incomplete OCR Pipeline:** The system currently performs only detection and segmentation; deep learning–based recognition is not yet integrated.

- **Integrate CNN Recognition Module:** Connect the MATLAB segmentation pipeline with the trained EMNIST CNN to achieve full end-to-end OCR.

- **Enhanced Text Segmentation:** Implement advanced deep-learning–based detectors (EAST/CTPN/YOLO) for more robust word and line detection in noisy or complex handwritten images.

