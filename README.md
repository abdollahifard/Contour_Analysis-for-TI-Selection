# Training-Image-Selection-for-MPS-via-Contours-Analysis
Computer Code for “Efficient Training Image Selection for Multiple-Point Geostatistics via Analysis of Contours”
This code is written by Mohammad Javad Abdollahiafard, Tafresh University,
mj.abdollahi@tafreshu.ac.ir 
Programming Language: MATLAB,
The code is freely available for academic purposes. 
To Run The Code:
Set the folder containing these files as current directory of MATLAB. Then, run either of the following codes:
>>use_TISelection_Binary
>>use_TISelection_Categorical
>>use_TISelection_Continuous
You can set the parameters in the aforementioned m-files. 
The core of these codes is a function named TISelection, which takes the sampling grid Is (with nans at unknown locations), a cell containing TIs, the categories (cats=[0,1] for binary images, cats=[0,1,2, …,nC] for categorical images, and cats=[] for continuous images), parameters structure params.
Paramters:
params.N= number of triangles to be considered in a data-event,
params.R= radius of the circle delimiting each data-event,
params.Npad= the number of rows/columns added to the beginning and end of the Is symmetrically. Set this to 20.
Params.tolerance= acceptable error for match finding, for binary and categorical variables set this to 0.001 (instead of zero), for continuous images higher values can also be used. 
Other functions:
The functions TISelection_DS, TISelection_exhaustive, TISelection_partial can also be used in the same way.

