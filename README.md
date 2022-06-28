# Summer Camp 2022 in Diffusion Map
## Convention
There are $n$ data, which is $p$-dimensional. The data is stored in $p\times n$ matrix. After apply diffusion map, we will reduce the dimension from $p$ to $m$. Hence, the data is compressed in $p\times m$ matrix.

## Outline
|#|Topic|Demo|Contents|TODO|
|-|-|-|-|-|
|<a href="#eigen-decomposition--svd">0</a>|Eigen Decomposition & SVD|[Link](demo/ED_SVD.mlx)|<ul><li>eigen-decomposition</li><li>SVD</li><li>sparse matrix</li><li>low rank approximation</li></ul>|Arnoldi iteration|
|<a href="#transition-matrix--difffusion-map">1</a>|Transition Matrix & Difffusion Map|[Link](demo/Affinity_Transition.mlx)|<ul><li>Transition matrix</li><li>Spectral of transition matrix</li><li>Kernel bandwidth and outlier</li></ul>|<ul><li>ev of all ones matrix</li><li>ev of all identity matrix</li><li>Mahalanobis distance</li></ul>|
|<a href="#difffusion-map-on-simulation-data">2</a>|Difffusion Map on Simulation Data|[Link](demo/Diffu_Simul.mlx)|<ul><li>Bandwidth</li><li>Diffusion distance</li><li>Mobius strip</li><li>Klein bottle</li></ul>|<ul><li>bandwidth and recover manifold</li><li>ambient/geodesic distance</li></ul>|
|<a href="#difffusion-map-on-real-data">3</a>|Difffusion Map on Real Data|[Link](demo/Diffu_Real.mlx)|<ul><li>Fisheriris dataset</li><li>MNIST dataset</li><li>ECG dataset</li><li>EEG dataset</li></ul>|<ul><li>Roseland (SVD)</li><li>self-tune bandwidth</li><li>EEG signal</li><li>wavelet transform & scattering transform</li></ul>|
|4|Clustering & Classification|[Link](demo/Clustering_Classification.mlx)|<ul><li>Clustering</li><li>Classification (SVM)</li><li>metric</li><li>K-fold</li></ul>|<ul><li>Leave one subject out</li><li>metric</li></ul>|

## Eigen Decomposition & SVD
- How to apply eigen-decomposition in MATLAB. 
- Reduce time complexicity.
- Know `eigs` and `svd`.
- the costs of eigen-decomposition and SVD are as
  - eigen-decomposition: $9n^3$ if matrix is with size $n\times n$
  - SVD: $14mn^2+8n^3$ if matrix is with size $m\times n$ where $m\geq n$.
  - Please refer to [Nicholas J. Higham, (2008)](https://books.google.com.tw/books/about/Functions_of_Matrices.html?id=S6gpNn1JmbgC&redir_esc=y) for more detail.
![](https://i.imgur.com/L0TXL2G.png)

## Transition Matrix & Difffusion Map
- Apply diffusion map step by step: distance matrix -> affinity matrix -> transition matrix -> eigen-decomposition.
- Tune bandwidth to know when the outliers occur.
- What happen to transition matrix if the bandwidth is too small. What is eigenvalue and eigenvector of identity matrix.
- What happen to transition matrix if the bandwidth is too large. What is eigenvalue and eigenvector of all ones matrix.
- Know different type of distance, e.g. mahalanobis distance. Please refer to [Malik, Shen, Wu & Wu, (2018)](https://arxiv.org/abs/1804.02811).
![](https://i.imgur.com/ZK67jTJ.png)

## Difffusion Map on Simulation Data
- In practice, since $K=D^{-1}W$ is not symmetric, we will use symmetric matrix $D^{-1/2}WD^{-1/2}$ which is similar to $K$. Please refer to [J. Banks, J. Garza-Vargas, A. Kulkarni, N. Srivastava, (2019)](https://arxiv.org/abs/1912.08805) for more detail of time complixity of eigen-decomposition of symetric matrix.
- In practice, we use `knnsearch` to construct affinity instead of `pdist` because `knnsearch` is based on KD algorithm which time complexity is $O(n\log(n))$. Moreover, time complexity of `pdist` is $O(n^2)$.
- Suppose a dataset belongs to a $d$-dimensional manifold $M$, which is in ambient space $R^p$. Diffusion map reduce the dimension $p$ to dimension $m$ but preserve the topological property of the manifold.
![](https://i.imgur.com/HzzK9wk.png)
- Different type of torus, different type of embedding figure.
![](https://i.imgur.com/oB79jjB.png)
- Preserve topological properties, e.g. geodesic distance and diffusion distance. Please refer to [A. Singer, H.-T. Wu, (2011)](https://arxiv.org/abs/1102.0075) for more detail.
![](https://i.imgur.com/tCtVJbq.png)

## Difffusion Map on Real Data
### Two useful techniques
- **Roeseland**:
  - In order to accelerate the algorithm, this algorithm is based on SVD.
  - The default number landmark is chosen $\sqrt{n}$.
  - In my code, I apply few steps `k-means` to choose landmark.
  - Please refer to [Shen and Wu, (2019)](https://arxiv.org/abs/2001.00801) for more detail.
![](https://i.imgur.com/3oqs0uw.png)


- **Self-tune**:
  - The affinity matrix is created by $k(x_i,x_j)=\exp\left(\frac{\|x_i-x_j\|^2}{\epsilon_i\epsilon_j}\right)$.
  - Please refer to [Zelnik-Manor & Perona, (2005)](https://proceedings.neurips.cc/paper/2004/file/40173ea48d9567f1f393b20c855bb40b-Paper.pdf) for more detail.

### EEG siganls
- The channel of this EEG is Fpz-Cz, which sampled at 100 Hz.
- The sleep stages are reduced to 5 stages, Awake, REM, N1, N2, N3.

## Code reference

## Material
[Hackmd version](https://hackmd.io/@singyuan/SJ5xrFwq9)

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

## Reference