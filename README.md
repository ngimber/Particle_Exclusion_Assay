# Particle Exclusion Assay

This repository contains ImageJ macros and a Python script for automating the generation and quantification of z-profiles on the endothelial glycocalyx layer in spinning disc confocal image stacks. For full study details, refer to:
S.G. Twamley et al., International Journal of Nanomedicine. DOI: [10.2147/ijn.s437714](https://doi.org/10.2147/ijn.s437714)

[![Video Title](https://img.youtube.com/vi/oHuG9-NGpjo/0.jpg)](https://youtu.be/oHuG9-NGpjo)


## Background
The quantitative particle exclusion assay measures the endothelial glycocalyx response to shear stress. By analyzing how particles are excluded from the cell surface under shear stress, the assay offers insights into glycocalyx behavior and its interaction with mechanical forces, critical for understanding vascular health and endothelial function. This automated workflow generates and quantifies z-profiles to capture the spatial distribution of fluorescence intensities across the endothelial layer, revealing cellular organization and tissue architecture.

## Overview
The workflow automates confocal z-profile processing using the following tools:

- **Correct Illumination (ImageJ Macro)**: Adjusts for uneven illumination in 3D spinning disk confocal stacks.
- **Segmentation (ImageJ Macro)**: Segments nuclei from the Hoechst channel using:
  - Gaussian blur (sigma = 3.4 µm)
  - Otsu binarization for thresholding
  - Watershed segmentation to separate nuclei
- **Z Alignment (Python Script)**: Aligns z-profiles based on Hoechst intensity peaks for consistent spatial referencing.

All parameters used in the original study are available in the log file: `log.txt`

## Installation

1. Clone the repository.
2. Install the following software:
   - ImageJ/Fiji
   - Python 3.x with the following libraries:
     - NumPy
     - SciPy
     - Matplotlib

## Usage

### Correct Illumination

1. Open `correctIllumination3D.ijm` in ImageJ/Fiji.
2. Apply the script to correct uneven illumination in spinning disk confocal stacks.

### Segmentation

1. Open `segmentation.ijm` in ImageJ/Fiji.
2. Run the script to segment nuclei using the Hoechst channel and generate z-profiles.

### GUI Parameters for Segmentation

- **File Type**: Specifies the image file type.
- **Cell Segmentation**: Ensure DAPI is in channel 1 (ch1); modify the code if necessary.
- **Enlarge DAPI**: Adjust the DAPI segmented area (negative values shrink, positive values expand).
- **Minimal and Maximal DAPI Area**: Set the minimum and maximum sizes for the DAPI area to be considered valid nuclei.
- **DAPI Blur**: Adjust the blur applied to the DAPI signal to balance edge accuracy and smoothness.
- **Binarize Channel x (Lower Threshold)**: Apply a threshold to binarize other channels based on area size.
- **Autothreshold**: Enable automatic thresholding for segmentation.
- **Threshold Method**: Select the thresholding method.

- ![GUI Screenshot](https://raw.githubusercontent.com/ngimber/Particle_Exclusion_Assay/main/GUI.png)

### Z Alignment

Run `z_alignment.py` to align z-profiles based on the segmented images.

## Citation
If you use this code, please cite:

- S.G. Twamley et al., International Journal of Nanomedicine. DOI: 10.2147/ijn.s437714
- This GitHub repository: https://github.com/ngimber/Particle_Exclusion_Assay

## License
This repository is licensed under the MIT License.
