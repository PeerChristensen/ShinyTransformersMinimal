
import torch
from transformers import pipeline
#import numpy as np


def get_model():
  model = pipeline("text-classification",model='bhadresh-savani/distilbert-base-uncased-emotion', top_k=-1)
  return model

def get_predictions(input_text,classifier):
  predictions = classifier(input_text)
  return predictions
  

