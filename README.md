BASIC STEPS TO REPRODUCE THE COMPARATIVE STUDY OF BAYESIAN NETWORKS
-------------------------------------------------------------------

DOWNLOAD THIS TOOLBOX AND UNZIP IT INTO ANY FOLDER (CALLED *$MATLAB_CODE HERE*)

DOWNLOAD THE PART A - PATH 1 OF FREIBURG, LJUBLJANA AND SAARBRUCKEN SEQUENCES FROM COLD DATASET (http://www.cas.kth.se/COLD/downloads.php), INTO *$MATLAB_CODE/dataset/COLD/* WITH THE NEXT STRUCTURE

      $MATLAB_CODE/datasets/COLD/Freiburg/seq1_cloudy1.tar
      ...
      $MATLAB_CODE/datasets/COLD/Freiburg/seq1_sunny4.tar
      $MATLAB_CODE/datasets/COLD/Ljubljana/seq1_cloudy1.tar
      ...
      $MATLAB_CODE/datasets/COLD/Ljubljana/seq1_sunny3.tar
      $MATLAB_CODE/datasets/COLD/Saarbrucken/seq1_cloudy1.tar
      ...
      $MATLAB_CODE/datasets/COLD/Saarbrucken/seq1_night3.tar

ALSO DOWNLOAD THE DUMBO AND MINNIE SEQUENCES FROM KTH-IDOL2 DATASET(http://www.cas.kth.se/IDOL/#Download) INTO *$MATLAB_CODE/datasets/KTH-IDOL* WITH THE NEXT STRUCTURE

      $MATLAB_CODE/datasets/KTH-IDOL/dum_cloudy1.tar
      ...
      $MATLAB_CODE/datasets/KTH-IDOL/dum_sunny4.tar
      $MATLAB_CODE/datasets/KTH-IDOL/min_cloudy1.tar
      ...
      $MATLAB_CODE/datasets/KTH-IDOL/min_sunny4.tar

TO CREATE THE FOLDER STRUCTURE THAT OUR FUNCTIONS NEED, TWO SHELL SCRIPT MUST BE LAUNCH FROM THE TERMINAL

      $MATLAB_CODE/COLDFolders.sh
      $MATLAB_CODE/IDOLFolders.sh

DOWNLOAD THE LAST VERSION OF *BNT* FOR MATLAB (https://code.google.com/p/bnt/) AND UNZIP IT IN *$MATLAB_CODE* FOLDER WITH THE NEXT STRUCTURE

      $MATLAB_CODE/bnt-master
	
DOWNLOAD THE LAST VERSION OF *libsvm* FOR MATLAB (http://www.csie.ntu.edu.tw/~cjlin/libsvm/) AND UNZIP IT IN *$MATLAB_CODE* FOLDER WITH THE NEXT STRUCTURE

      $MATLAB_CODE/libsvm

IF $LIBSVM_FOLDER IS DIFFERENT TO *libsvm*, RENAME IT.

BEFORE USING *libsvm*, IT MUST BE COMPILED. LAUNCH MATLAB AND ESTABLISH *$MATLAB_CODE/libsvm/matlab* AS CURRENT FOLDER, THEN TYPE

      >> make

IF THIS DOESN'T WORK READ THE README.TXT IN *$MATLAB_CODE/$LIBSVM_FOLDER/matlab* FOLDER FOR MORE INFORMATION.

DOWNLOAD THE PHOG CODE FOR MATLAB (http://www.robots.ox.ac.uk/~vgg/research/caltech/phog.html) AND UNZIP IT IN THE FOLDER

    $MATLAB_CODE/Descriptors
	
OPEN MATLAB AND SET $MATLAB_CODE AS CURRENT FOLDER

LEARN DIFFERENTS TRAINING MODELS AND TEST THEM

    + The experiments can be reproduced with completeProcessCV function:
        completeProcessCV(0,0,1,360,5,5) learns and tests a Naive Bayes network with 
        continuous data from DUMBO dataset and store the accuracy and the confusion 
        matrix in an output folder. The first call to this function takes a long time,
        in order to extract all the features and store them in the correct directory 
        structure.

    + Prove different combinations for completeProcessCV. The variables and their 
      options are detailed in the comments.
	

THIS CODE INCLUDES FUNCTIONS TO EXTRACT PHOG DESCRIPTORS OF DIFFERENT IMAGES AND TO LEARN BAYESIAN NETWORKS WITH DIFFERENT ALGORITHMS.
THE PREVIOUS STEPS SERVE TO REPRODUCE A SERIES OF EXPERIMENTS, BUT THE FUNCTIONS CAN BE TESTED EASILY BY FOLLOWING THE CODE FROM 
*completeProcessCV.m* IN THE CASE OF USING DIFFERENT DATA.
