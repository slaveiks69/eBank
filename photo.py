from flask import Blueprint, json, render_template, request, redirect, url_for
from utils import *

photo = Blueprint('photo', __name__)

@photo.get('/')
def get_photo():
    return render_template('photo.html')