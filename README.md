# Summer Camp 2022 in Diffusion Map
## Outline
|#|Topic|Demo|Contents|TODO|
|-|-|-|-|-|
|0|Eigen Decomposition & SVD|[Link](demo/ED_SVD.mlx)|<ul><li>eigen-decomposition</li><li>SVD</li><li>sparse matrix</li><li>low rank approximation</li></ul>|Arnoldi iteration|
|1|Transition Matrix & Difffusion Map|[Link](demo/Affinity_Transition.mlx)|<ul><li>Transition matrix</li><li>Spectral of transition matrix</li><li>Kernel bandwidth and outlier</li></ul>|<ul><li>ev of all ones matrix</li><li>ev of all identity matrix</li><li>Mahalanobis distance</li></ul>|
|2|Difffusion Map on Simulation Data|[Link](demo/Diffu_Simul.mlx)|<ul><li>Bandwidth</li><li>Diffusion distance</li><li>Mobius strip</li><li>Klein bottle</li></ul>|bandwidth and recover manifold|
|3|Difffusion Map on Real Data|[Link](demo/Diffu_Real.mlx)|<ul><li>Fisheriris dataset</li><li>MNIST dataset</li><li>ECG dataset</li><li>EEG dataset</li></ul>|<ul><li>Roseland (SVD)</li><li>self-tune bandwidth</li><li>EEG signal</li><li>wavelet transform & scattering transform</li></ul>|
|4|Clustering & Classification|[Link](demo/Clustering_Classification.mlx)|<ul><li>Clustering</li><li>Classification (SVM)</li><li>metric</li><li>K-fold</li></ul>|<ul><li>Leave one subject out</li><li>metric</li></ul>|

## Eigen Decomposition & SVD
- How to apply eigen-decomposition in MATLAB. 
- Reduce time complexicity.
- Know `eigs` and `svd`.
- the costs of eigen-decomposition and SVD are as
  - $9n^3$ if matrix is with size $n\times n$
  - $14mn^2+8n^3$ if matrix is with size $m\times n$ where $m\geq n$.
  - Please refer to [Nicholas J. Higham, (2008)](https://books.google.com.tw/books/about/Functions_of_Matrices.html?id=S6gpNn1JmbgC&redir_esc=y) for more detail.
![](https://i.imgur.com/L0TXL2G.png)

## Transition Matrix & Difffusion Map
- Apply diffusion map step by step: distance matrix -> affinity matrix -> transition matrix -> eigen-decomposition.
- Tune bandwidth to know when the outliers occur.
- What happen to transition matrix if the bandwidth is too small. What is eigenvalue and eigenvector of identity matrix.
- What happen to transition matrix if the bandwidth is too large. What is eigenvalue and eigenvector of all ones matrix.
- Know different type of distance, e.g. mahalanobis distance. Please refer to [Malik, Shen, Wu & Wu, (2018)](https://arxiv.org/abs/1804.02811).
![](https://i.imgur.com/ZK67jTJ.png)


## Data
In the folder `data`, there are three data: `UniSphere.mat`, `irismat.mat` and `FakeECG.mat`.
1. Sphere data `UniSphere.mat`: There are 998 sphere points in (x, y, z)-coordinate.
> This is generated from Brian Z Bentz (2021), ( https://www.mathworks.com/matlabcentral/fileexchange/57877-mysphere-n ), MATLAB Central File Exchange.
2. Iris data `irismat.mat`: There are 3 categories of flowers and each categories contains 50 data. Each flower data has 4 features.
> From MATLAB database `load('fisheriris')`
3. Fake ECG data: There are 1229 pulse and each pulse is approximated by 141 points. This original data is about 15 minutes.
> This is generated from [McSharry PE, Clifford GD, Tarassenko L, Smith L. (2003)](https://physionet.org/content/ecgsyn/1.0.0/#files).
4. Real ECG data: The database contains 14552 heartbeat pulses from 290 people. There are two categories: normal and abnormal, where there are 10506 abnormal pulses and 4046 normal pulses.
> This dataset is from [kaggle](), called the [PTB Diagnostic ECG Database](https://www.physionet.org/content/ptbdb/1.0.0/).
5. EEG spectrum: The database contains 4462 EEG  epochs from 5 people. The channel of this EEG is Fpz-Cz, which sampled at 100 Hz. The sleep stages are reduced to 5 stages, Awake, REM, N1, N2, N3.
> This dataset is from Physionet, which is called [Sleep-EDF Database](https://physionet.org/content/sleep-edf/1.0.0/).
6. Klein bottle dataset
> This dataset is generated and modified from David Smith (2022). Klein Bottle ( https://www.mathworks.com/matlabcentral/fileexchange/5880-klein-bottle ), MATLAB Central File Exchange.
7. MNIST dataset: The database contains 5000 digital images with size 28x28. Each class contains 400-600 images.
> This dataset is randomly chosen from [here](https://github.com/sunsided/mnist-matlab).
