# Summer Camp 2022 in Diffusion Map
## Convention
There are $n$ data, which is $p$-dimensional. The data is stored in $n\times p$ matrix. After apply diffusion map, we will reduce the dimension from $p$ to $m$. Hence, the data is compressed in $n\times m$ matrix.

## Outline
|#|Topic|Demo|Contents|TODO|exp|
|-|-|-|-|-|-|
|<a href="#eigen-decomposition--svd">0</a>|Eigen Decomposition & SVD|[Link](demo/ED_SVD.mlx)|<ul><li>eigen-decomposition</li><li>SVD</li><li>sparse matrix</li><li>low rank approximation</li></ul>|||
|<a href="#transition-matrix--difffusion-map">1</a>|Transition Matrix & Difffusion Map|[Link](demo/Affinity_Transition.mlx)|<ul><li>Transition matrix</li><li>Spectral of transition matrix</li><li>Kernel bandwidth and outlier</li></ul>|<ul><li>ev of all ones matrix</li><li>ev of all identity matrix</li><li>Mahalanobis distance</li></ul>||
|<a href="#diffusion-map-on-simulation-data">2</a>|Diffusion Map on Simulation Data|[Link](demo/Diffu_Simul.mlx)|<ul><li>Bandwidth</li><li>Diffusion distance</li><li>Mobius strip</li><li>Klein bottle</li></ul>|<ul><li>bandwidth and recover manifold</li><li>ambient/geodesic distance</li></ul>|<ul><li>[Circle](exp/CircleMain.m)</li><li>[Distance](exp/Spring_Distance.m)</li><li>[Torus](exp/TorusMain.m)</li></ul>|
|<a href="#diffusion-map-on-real-data">3</a>|Diffusion Map on Real Data|[Link](demo/Diffu_Real.mlx)|<ul><li>Fisheriris dataset</li><li>MNIST dataset</li><li>ECG dataset</li><li>EEG dataset</li></ul>|<ul><li>Roseland (SVD)</li><li>self-tune bandwidth</li><li>EEG signal</li><li>wavelet transform & scattering transform</li></ul>|<ul><li>[ECG](exp/ECG_Visualization.m)</li><li>[MNIST](exp/MNIST_Visulization.m)</li></ul>|
|<a href="#clustering--classification">4</a>|Clustering & Classification|[Link](demo/clustering_classification.mlx)|<ul><li>Clustering (k-means)</li><li>Classification (SVM)</li><li>metric</li><li>K-fold</li></ul>|<ul><li>Leave one subject out</li><li>metric</li></ul>|<ul><li>[EEG](exp/EEG_classification.m)</li><li>[K-Fold](exp/Iris_KFold.m)</li></ul>|

## Eigen Decomposition & SVD
- How to apply eigen-decomposition in MATLAB. 
- Reduce time complexicity.
- Know `eigs` and `svd`.
- the costs of eigen-decomposition and SVD are as
  - eigen-decomposition: $9n^3$ if matrix is with size $n\times n$
  - SVD: $14nk^2+8k^3$ if matrix is with size $n\times k$ where $n\geq k$.
  - Please refer to Nicholas J. Higham, *Functions of Matrices: Theory and Computation*, (2008) for more detail.
![](https://i.imgur.com/L0TXL2G.png)

## Transition Matrix & Difffusion Map
- Apply diffusion map step by step:
  1. distance matrix
  2. affinity matrix $W_{ij}=\exp\left(-\frac{\|x_i-x_j\|^2}{\epsilon^2}\right)$
  3. transition matrix $K=D^{-1}W$ where diagonal matrix $D_{ii}=\sum_jW_{ij}$
  4. Eigen-decomposition of $K$ is $U$, _i.e._ $KU=US$ where $S_{ii}=\lambda_i$
  5. dimension reduction by largest $m$ eigenvector $U'=\left[u_2, u_2, \cdots,u_{m+1}\right]$
- Tune bandwidth to know when the outliers occur.
- What happen to transition matrix if the bandwidth is too small. What is eigenvalue and eigenvector of identity matrix.
- What happen to transition matrix if the bandwidth is too large. What is eigenvalue and eigenvector of all ones matrix.
- Know different type of distance, e.g. mahalanobis distance. Please refer to [Malik, Shen, Wu & Wu, (2018)](https://arxiv.org/abs/1804.02811).
![](https://i.imgur.com/ZK67jTJ.png)

<details>
<summary><b>Click me to see something scary</b></summary>
Let $\{x_i\}_{i=1}^n\subset \mathcal{M}$. Let the kernel matrix $W_{ij}=k_\epsilon(x_i,x_j)$. The degree matrix is defined as $D_{ii}=\sum_{j=1}^nW_{ij}$. Then, the **(negative)** graph Laplacian operator is defined as
$$L=\frac{D^{-1}W-I}{\epsilon^2}$$
In [Coifman and Lafon (2006)](https://www.sciencedirect.com/science/article/pii/S1063520306000546?ref=pdf_download&fr=RR-2&rr=723831845a7b6a96) and In [Singer (2006)](https://www.sciencedirect.com/science/article/pii/S1063520306000510), they showed the bias term and variance term, respectively.  Given "normalized" kernel, $m_0=1$, the graph Laplacian operator is approximated as follows,
$$\sum_{j=1}^{n} L_{i j} f\left(x_{j}\right)=\frac{m_2}{2d}\Delta f\left(x_{i}\right)+O\left(\frac{\sqrt{\log(n)}}{n^{1 / 2} \epsilon^{d/2+1}}\right)+O(\epsilon).$$
> This paper give the lower bound of $\epsilon$. That is, if the dataset is finite, the bandwidth cannot be approach to zero. The relation between $n$ and $\epsilon$ can be seem that $n^{1/2}\epsilon^{d/2+1}$ is constant. Actually, it is because there must be enough number of data points in the kernel bandwidth.
</details>

## Diffusion Map on Simulation Data
- In practice, since $K=D^{-1}W$ is not symmetric, we will use symmetric matrix $D^{-1/2}WD^{-1/2}$ which is similar to $K$. Please refer to [J. Banks, J. Garza-Vargas, A. Kulkarni, N. Srivastava, (2019)](https://arxiv.org/abs/1912.08805) for more detail of time complixity of eigen-decomposition of symetric matrix.
- In practice, we use `knnsearch` to construct affinity instead of `pdist` because `knnsearch` is based on KD algorithm which time complexity is $O(n\log(n))$. Moreover, time complexity of `pdist` is $O(n^2)$.
- Suppose a dataset belongs to a $d$-dimensional manifold $M$, which is in ambient space $R^p$. Diffusion map reduce the dimension $p$ to dimension $m$ but preserve the topological property of the manifold.
![](https://i.imgur.com/HzzK9wk.png)
- Different type of torus, different type of embedding figure.
![](https://i.imgur.com/oB79jjB.png)
- Preserve topological properties, e.g. geodesic distance and diffusion distance. Please refer to [A. Singer, H.-T. Wu, (2011)](https://arxiv.org/abs/1102.0075) for more detail.
![](https://i.imgur.com/JFEHoPU.png)

<details>
  <summary><b>Click me to see comparison with PCA</b></summary>
  <ol>
  PCA is linear dimension reduction method, so it could not straighten the spring. Hence, PCA could recover the geodesic distance.
  
  ![](https://i.imgur.com/K9Lm2ng.png)
  </ol>
</details>

## Diffusion Map on Real Data
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

## Clustering & Classification
### Classifier
- Clustering: k-means is unsupervised learning.
- Classification: SVM is supervised learning.
  - There are two parameters, box constraint and kernel scale. Note that kernel scale is $\gamma$ in this equation $k(x,y)=\exp\left(-\gamma\|x-y\|^2\right)$.
![](https://i.imgur.com/4GBbAUs.png)
  - Usually, we use $\log$-scale to fine tune these two parameters.
![](https://i.imgur.com/h2YJj0Y.png)



### Evaluation
  - Metric: recall, precision, F1 score
![](https://i.imgur.com/IB8IzOU.png)

  - Evaluation on k-folds cross validation.
![](https://i.imgur.com/BUxLuNr.png)

## Appendix for methodology
There are many method to dimension reduction. Diffusion map is just one of them. Hence, you could compare diffusion map and other methods. Feel free to use the data in my folder `data`.
- Diffusion map
- PCA (kernel PCA)
- Locally linear embedding (LLE)
- t-SNE
![](https://i.imgur.com/c6TY1Tp.png)

## Material
[Hackmd version](https://hackmd.io/@singyuan/SJ5xrFwq9)

## Data
The data source in folder `data` is introduced as following.
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

## Code references
1. `src/Lazykmeans.m` is modified from Kai (2021), Improved Nystrom Kernel Low-rank Approximation ( https://www.mathworks.com/matlabcentral/fileexchange/38422-improved-nystrom-kernel-low-rank-approximation ), MATLAB Central File Exchange.
2. `src/cluster_acc.m` is from Dong Dong (2022). clustering accuracy ( https://www.mathworks.com/matlabcentral/fileexchange/77452-clustering-accuracy ), MATLAB Central File Exchange.

## References 
_Random Arrangement_
1. J. de la Porte, B. M. Herbst, W. Hereman and S. J. van der Walt, _An introduction to diffusion maps_, **(2008)**.
2. J. Wang, _Geometric Structure of High-Dimensional Data and Dimensionality Reduction_.
3. L. Zelnik-Manor and P. Perona, _Self-Tuning Spectral Clustering_, **(2005)**.
4. C. Shen and H.-T. Wu, _Scalability and robustness of spectral embedding: landmark diffusion is all you need_, **(2019)**.
5. J. Malik, C. Shen, H.-T. Wu and N. Wu, _Connecting Dots -- from Local Covariance to Empirical Intrinsic Geometry and Locally Linear Embedding_, **(2018)**.
6. A. Singer and H.-T. Wu, _Orientability and diffusion maps_, **(2011)**.
7. R. R. Lederman, R Talmon, H.-T. Wu, Y.-L. Lo and R. R. Coifman, _Alternating diffusion for common manifold learning with application to sleep stage assessment_, **(2015)**.
8. R. R. Coifman and S. Lafon, _Diffusion Map_, **(2006)**.
9. A. Singer, _From graph to manifold Laplacian: The convergence rate_, **(2006)**.
10. A. Singer and H.-T. Wu, _Vector Diffusion Maps and the Connection Laplacian_, **(2011)**.
11. Y.-T. Lin, J. Malik and H.-T. Wu, _Wave-shape oscillatory model for nonstationary periodic time series analysis_, **(2021)**.