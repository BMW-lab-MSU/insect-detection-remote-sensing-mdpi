from sklearn.feature_selection import mutual_info_classif
from scipy.io import loadmat
import numpy as np

DATA_DIR = "../../data/training/"
RESULTS_DIR = "../../results/feature-analysis/"

matfile = loadmat(DATA_DIR + "featuresAndLabelsForPythonMutualInfo.mat")

mi = mutual_info_classif(matfile['features'],matfile['labels'].ravel())

np.savetxt(RESULTS_DIR + "mi.csv", mi, delimiter=",")


