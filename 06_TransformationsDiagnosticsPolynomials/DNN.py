import tensorflow as tf

def NeuralNet3Layers(activation='relu', epochs = 10000) : 
    
    actFun = {'relu':tf.nn.relu, 'sigmoid':tf.nn.sigmoid, 'linear':LinearFunction}[activation]
    
    X = tf.placeholder(tf.float32, [None, 2])
    Y = tf.placeholder(tf.float32, [None, 2])

    W1 = tf.Variable( tf.random_normal([2,128]) )
    b1 = tf.Variable( tf.random_normal([128]))
    L1 = actFun( tf.matmul(X, W1) + b1 )

    W2 = tf.Variable( tf.random_normal([128,64]) )
    b2 = tf.Variable( tf.random_normal([64]))
    L2 = actFun( tf.matmul(L1, W2) + b2 )

    W3 = tf.Variable( tf.random_normal([64,2]) )
    Model = tf.matmul(L2, W3)

    Cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits_v2(logits=Model, labels=Y))
    Adam = tf.train.AdamOptimizer(0.01)

    Trainer = Adam.minimize(Cost)
    
    init = tf.global_variables_initializer()
    sess = tf.Session()
    sess.run(init)

    CostTrace = []
    for epoch in range(epochs):

        _, cost_val = sess.run([ Trainer, Cost ], feed_dict={X: ScaledDF,
                                                             Y: onehotSurvived} )

        CostTrace.append(cost_val)
        if epochs % 1000 == 0 :
            print("1000 additional epochs completed, Cost:{}".format(cost_val))
        
    IsCorrect = tf.equal(tf.argmax(Model, 1), tf.argmax(Y, 1))
    Accuracy = tf.reduce_mean(tf.cast(IsCorrect, tf.float32))
    print ("Learning Completed, Accuracy:{}".format(sess.run(Accuracy, feed_dict = {X: ScaledDF, Y: onehotSurvived }) ) )
    return(CostTrace)