import os
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(24)

@app.route("/", methods=["GET"])
def login():
    return render_template('login.html', title='login')

app.run(debug=True)
