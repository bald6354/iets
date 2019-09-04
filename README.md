# Inceptive Event Time-Surfaces for Object Classification using Neuromorphic Cameras (IETS)

![Missing Image](https://github.com/bald6354/iets/blob/master/images/rotDisk_IETS.png "IETS Denoised Dataset")

## Summary
This is the implemtation code for the following paper.
  
Cite as:

Baldwin R.W., Almatrafi M., Kaufman J.R., Asari V., Hirakawa K. (2019) Inceptive Event Time-Surfaces for Object Classification Using Neuromorphic Cameras. In: Karray F., Campilho A., Yu A. (eds) Image Analysis and Recognition. ICIAR 2019. Lecture Notes in Computer Science, vol 11663. Springer, Cham

BibTex:

    @InProceedings{10.1007/978-3-030-27272-2_35,
    author="Baldwin, R. Wes
    and Almatrafi, Mohammed
    and Kaufman, Jason R.
    and Asari, Vijayan
    and Hirakawa, Keigo",
    editor="Karray, Fakhri
    and Campilho, Aur{\'e}lio
    and Yu, Alfred",
    title="Inceptive Event Time-Surfaces for Object Classification Using Neuromorphic Cameras",
    booktitle="Image Analysis and Recognition",
    year="2019",
    publisher="Springer International Publishing",
    address="Cham",
    pages="395--403",
    abstract="This paper presents a novel fusion of low-level approaches for dimensionality reduction into an effective approach for    high-level objects in neuromorphic camera data called Inceptive Event Time-Surfaces (IETS). IETSs overcome several limitations of conventional time-surfaces by increasing robustness to noise, promoting spatial consistency, and improving the temporal localization of (moving) edges. Combining IETS with transfer learning improves state-of-the-art performance on the challenging problem of object classification utilizing event camera data.",
    isbn="978-3-030-27272-2"
    }

## Inceptive Event Time Surfaces 

*Springer Best Paper Award - ICIAR 2019* 
[Link to Paper](https://rdcu.be/bQcGk)

This  paper  presents  a  novel  fusion  of  low-level  approaches for dimensionality reduction into an effective approach for high-level objects in neuromorphic camera data called Inceptive Event Time-Surfaces(IETS). IETSs overcome several limitations of conventional time-surfaces by  increasing  robustness  to  noise,  promoting  spatial  consistency,  and improving the temporal localization of (moving) edges. Combining IETS with transfer learning improves state-of-the-art performance on the challenging problem of object classification utilizing event camera data.

ICIAR 2019 presentation available in [Google Slides](https://docs.google.com/presentation/d/1xXY7GWQ0IKP8-hhdGIIOJRE7IwZfoV0jTsZWWTzpYwA/edit?usp=sharing).

## Dataset: N-CARS 
The dataset used for development and evaluation was N-CARS. It can be found [here](https://www.prophesee.ai/dataset-n-cars/).

## Code Implementation
### Requirements:
     Matlab
     Pretrained GoogLenet
     
### Preparations:
1. Download N-CARS dataset to NCARS folder
2. Open Matlab and type 'googlenet' at the command window to ensure pretrained GoogLenet is installed. Follow additional directions if needed. If GoogLenet is not found at runtime, the script will load the included .mat file as a replacement.

### Running examples:
1. Change the Matlab directory to the code folder and execute the Matlab script *makeImages.m*. This script runs IETS and generates a single RGB image for each 100ms sample of data. The results are stored in the 'time_surfaces' folder.
2. Once all images are generated execute the the Matlab script *transferLearn.m*. This will load the pretrained network and preform transfer learning and evaluation.

## Contact 
For any questions or bug reports, please contact R. Wes Baldwin baldwinr2@udayton.edu .
