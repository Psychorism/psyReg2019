import os
os.chdir("../Dataset/MPV/")

import pandas as pd
import numpy  as np
import tensorflow as tf
import matplotlib.pyplot as plt

from sklearn import linear_model
from sklearn import metrics

import statsmodels.api as sm
from scipy import stats


Delivery = pd.read_csv("delivery.csv")

Regressor = Delivery.iloc[:,1:3]
Response  = Delivery.iloc[:,3]

LinRegression = linear_model.LinearRegression()
LinRegression.fit(Regressor, Response)

X = tf.placeholder(tf.float32, [None, 2])
Y = tf.placeholder(tf.float32, [None, 1])

W = tf.Variable(tf.constant([[30.],[-25.]])) # initial value close to MLE
b = tf.Variable(tf.constant([[-30.]]))       # initial value close to MLE
Model = tf.matmul(X, W) + b

Cost = tf.reduce_mean(tf.square( Y - Model ))

Grad = tf.train.GradientDescentOptimizer(0.01)
Adam = tf.train.AdamOptimizer(0.01)

Trainer = Adam.minimize(Cost)


if __name__ == "__main__":

	init = tf.global_variables_initializer()
	sess = tf.Session()
	sess.run(init)

	costs = []
	for epoch in range(1000):
	    
	    _, cost_val = sess.run([ Trainer, Cost ], feed_dict={X: Delivery.loc[:,['time', 'cases']],
	                                                         Y: Delivery.loc[:,['distance']]} )
	    
	    costs.append(cost_val)
	    if epoch % 100 == 0:
	        print('Epoch: {}'.format(epoch + 1),
	              'Avg. cost= {:.3f}'.format(cost_val))

	MSE = tf.reduce_mean(tf.square( Y - Model ))
	Wtrained = sess.run(W)
	bTrained = sess.run(b)

	print(Wtrained)
	print(bTrained)

	ANNpredict = np.matmul( Regressor, Wtrained ) + bTrained
	print(metrics.mean_squared_error(Response, ANNpredict))

	print('MSE:', sess.run(MSE, feed_dict={X: Delivery.loc[:,['time', 'cases']],
	                                       Y: Delivery.loc[:,['distance']]})   )

	print(LinRegression.coef_)
	print(LinRegression.intercept_)
	print(metrics.mean_squared_error( Response, LinRegression.predict(Regressor) ))