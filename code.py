import nltk
import SocketServer
import sys
import datetime
import os
#from bluetooth import *
import serial
import time
import get_data
import name

try:
    PORT = int(sys.argv[1])
except (IndexError, NameError):
    PORT = 8083

def extract_features(phrase):
    """
    This function will extract features from the phrase being used.
    Currently, the feature we are extracting are unigrams of the text 	corpus.
    """
    words = nltk.word_tokenize(phrase)
    features = {}
    for word in words:
        features['contains(%s)' % word] = (word in words)
    return features

file_data_p = get_data.get_data(p1)	#p1 and p2 stand for the name of the two folders and 
file_data_b = get_data.get_data(p2)	#get_data function fetches the data from each training data file

def extract_feature_set(file_data):
    training_data = []
    for file_index in range(len(file_data)-1):
    	for line in file_data[file_index]:
	    if file_index < 10:
       	        training_data.append((line, str(file_index)))
	    elif file_index == 10:
		training_data.append((line, 'a'))
            else:
		training_data.append((line, 'b'))
    training_feature_set = [(extract_features(line), label) for (line, label) in training_data]
    return training_feature_set

pclassifier = nltk.NaiveBayesClassifier.train(extract_feature_set(file_data_p))
bclassifier = nltk.NaiveBayesClassifier.train(extract_feature_set(file_data_b))

#last_line = file(PATH_TO_FILE, "r").readlines()[-1]
pcode = pclassifier.classify(extract_features("Hey, how you doing?"))
bcode = bclassifier.classify(extract_features("I am on cloud nine"))
print pcode
print bcode
ser = serial.Serial('/dev/ttyUSB0',9600,timeout=2)
ser.write(pcode)
ser.write(bcode)
print ser.readline()

print ser.readline()
print ser.readline()

