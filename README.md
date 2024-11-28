# Particle Exclusion Assay

This repository contains the ImageJ macros and Python script used for automated quantification of z-profiles in confocal image stacks, as detailed in our study:

**S.G. Twamley et al., International Journal of Nanomedicine. DOI: 10.2147/ijn.s437714**

## Overview

The workflow automates the processing of confocal z-profiles using the following tools:

- **Correct Illumination (ImageJ Macro)**: Adjusts for uneven illumination in 3D confocal stacks.
- **Segmentation (ImageJ Macro)**: Segments nuclei from the Hoechst channel using:
  - Gaussian blur (sigma = 3.4 µm)
  - Otsu binarization for thresholding
  - Watershed segmentation for separating nuclei
- **Z Alignment (Python Script)**: Aligns z-profiles based on the Hoechst intensity peak to ensure consistent spatial referencing.

All parameters used in the study are provided in the log file.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/ngimber/Particle_Exclusion_Assay.git
    ```

2. Install the required software:
    - ImageJ/Fiji
    - Python 3.x with the following libraries:
      - NumPy
      - SciPy
      - Matplotlib (optional, for visualization)

## Usage

### Correct Illumination

1. Open `correctIllumination3D.ijm` in ImageJ/Fiji.
2. Apply to confocal stacks to adjust for uneven illumination.

### Segmentation

1. Open `segmentation.ijm` in ImageJ/Fiji.
2. Run on confocal stacks to segment nuclei based on the Hoechst channel.

### Z Alignment

1. Run `z_alignment.py` to align z-profiles using the segmented images.
    ```bash
    python z_alignment.py --input <input_path> --output <output_path>
    ```

## GUI

The tools are accompanied by a graphical user interface (GUI) to simplify their usage. A preview of the GUI can be seen below:

- **Correct Illumination**: Provides input options for stack correction.
- **Segmentation**: Allows adjustments for segmentation parameters like blur and thresholding.
- **Alignment**: Enables selection of input/output paths for z-profile registration.

## Citation

If you use this code, please cite both the following:

- **S.G. Twamley et al., International Journal of Nanomedicine. DOI: 10.2147/ijn.s437714**
- **This GitHub repository: https://github.com/ngimber/Particle_Exclusion_Assay**

## License

This repository is licensed under the MIT License.
Feel free to copy and paste this into your README.md file! If you need any more adjustments, just let me know.


In Pages bearbeiten


1 von 30 Antworten
KI-generierte Inhalte können fehlerhaft sein


