# Summer Camp 2022 in Diffusion Map
## Outline
|#|Topic|Demo|Contents|TODO|
|-|-|-|-|-|
|0|Eigen Decomposition & SVD|[Link](demo/ED_SVD.mlx)|<ul><li>eigen-decomposition</li><li>SVD</li><li>sparse matrix</li><li>low rank approximation</li></ul>|Arnoldi iteration|
|1|Transition Matrix & Difffusion Map|[Link](demo/Affinity_Transition.mlx)|<ul><li>Transition matrix</li><li>Spectral of transition matrix</li><li>Kernel bandwidth and outlier</li></ul>|<ul><li>ev of all ones matrix</li><li>ev of all identity matrix</li></ul>|
|2|Difffusion Map on Simulation Data|[Link](demo/Diffu_Simul.mlx)|<ul><li>Bandwidth</li><li>Diffusion distance</li><li>Mobius strip</li><li>Klein bottle</li></ul>|bandwidth and recover manifold|
|3|Difffusion Map on Real Data|[Link](demo/Diffu_Simul.mlx)|<ul><li>Fisheriris dataset</li><li>MNIST dataset</li><li>ECG dataset</li><li>EEG dataset</li></ul>|<ul><li>Roseland (SVD)</li><li>self-tune bandwidth</li><li>EEG signal</li><li>wavelet transform & scattering transform</li></ul>|
|4|Clustering & Classification|[Link](demo/Clustering_Classification.mlx)|<ul><li>Clustering</li><li>Classification (SVM)</li><li>metric</li><li>K-fold</li></ul>|<ul><li>Leave one subject out</li><li>metric</li></ul>|

## Eigen Decomposition & SVD
- How to apply eigen-decomposition in MATLAB. 
- Reduce time complexicity.
- Know `eigs` and `svd`.
- the costs of eigen-decomposition and SVD are as
  - <img src="https://render.githubusercontent.com/render/math?math=9n^3"> if matrix is with size <img src="https://render.githubusercontent.com/render/math?math=n\times n">
  - <img src="https://render.githubusercontent.com/render/math?math=14mn^2%2B8n^3"> if matrix is with size <img src="https://render.githubusercontent.com/render/math?math=m\times n"> where <img src="https://render.githubusercontent.com/render/math?math=m\geq n">.
  - Please refer to Nicholas J. Higham, Functions of Matrices: Theory and Computation for more detail.
![](https://i.imgur.com/L0TXL2G.png)
